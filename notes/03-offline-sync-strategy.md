# 오프라인 우선 동기화 전략

> LLM Wiki — Hive ↔ Firestore 동기화 설계 기록  
> 작성자: 혜지

## 이 파일의 목적
Delay Detective의 핵심 기술 도전인 오프라인-온라인 동기화를 설계하면서 배운 전략, 트레이드오프, 실제 구현 결정을 기록한다.

---

## 핵심 원칙: Hive Primary, Firestore Secondary

**결정**: 모든 쓰기는 Hive(로컬)에 먼저 저장하고, Firestore는 백그라운드에서 나중에 동기화한다.

**이유**:
- 사용자는 네트워크 상태와 무관하게 즉각적인 UI 응답을 원함
- Firestore 쓰기는 평균 200~500ms 지연이 있음
- 오프라인 환경(지하철, 비행기)에서도 완전한 기능 동작 필요

**트레이드오프**:
```
장점: 즉각적인 UI 반응, 오프라인 완전 지원
단점: 동기화 충돌 가능성, 구현 복잡도 상승
```

---

## 동기화 흐름

```
사용자 액션
    ↓
HiveService.addTask()  ← 즉시 저장 (로컬)
    ↓
UI 즉각 반응 ✅
    ↓
sync_queue에 taskId 등록
    ↓ (네트워크 연결 시)
SyncService.upload()
    ↓
FirestoreService.addTask()
    ↓
성공 시 sync_queue에서 제거
실패 시 queue에 유지 → 다음 네트워크 연결 시 재시도
```

---

## Last-Write-Wins Conflict Resolution 전략

**기준**: `updatedAt` 타임스탬프 비교

```dart
if (hiveTask.updatedAt.isAfter(firestoreTask.updatedAt)) {
  // 로컬이 더 최신 → Firestore 업로드
  await firestoreService.updateTask(hiveTask);
} else if (hiveTask.updatedAt.isBefore(firestoreTask.updatedAt)) {
  // 서버가 더 최신 → Hive 업데이트
  await hiveService.updateTask(firestoreTask);
} else {
  // 동일 타임스탬프 → 사용자 선택 다이얼로그 표시
  showConflictDialog(hiveTask, firestoreTask);
}
```

**이 전략을 선택한 이유**:  
개인 앱이라 멀티 디바이스 동시 편집 빈도가 낮음. 구현 단순성 우선.

---

## 네트워크 상태 감지

**패키지**: `connectivity_plus`

**상태 3가지**:
```dart
enum SyncStatus {
  offline,        // 네트워크 없음 → Hive만 사용
  syncing,        // 동기화 중 → 배너 표시
  synced,         // 동기화 완료 → 정상 상태
}
```

**UI 표시 규칙**:
- `offline`: 노란색 배너 "오프라인 모드 — 데이터는 로컬에 저장됩니다"
- `syncing`: 파란색 배너 + 스피너 "동기화 중..."
- `synced`: 배너 숨김 (3초 딜레이 후)

---

## 오프라인 큐 설계

**방식**: Hive 별도 Box에 미전송 작업 저장

```dart
// sync_queue Box 구조
{
  'taskId_1': { 'operation': 'create', 'timestamp': ... },
  'taskId_2': { 'operation': 'update', 'timestamp': ... },
  'taskId_3': { 'operation': 'delete', 'timestamp': ... },
}
```

**처리 순서**: timestamp 오름차순 (먼저 발생한 작업부터 처리)

---

## 배운 점 & 주의사항

| 항목 | 내용 |
|---|---|
| 타임스탬프 신뢰성 | 기기 시간이 틀릴 수 있음 → Firestore 서버 타임스탬프(`FieldValue.serverTimestamp()`) 병행 사용 권장 |
| 오프라인 큐 크기 | 장기 오프라인 시 큐가 커짐 → 큐 최대 크기 제한 필요 |
| 동기화 중복 방지 | 앱 재시작 시 큐가 두 번 처리될 수 있음 → idempotent 작업 설계 필수 |
| 삭제 동기화 | 로컬 삭제 후 서버 삭제 전에 앱이 꺼지면 서버에 고아 데이터 남을 수 있음 |
| 오프라인 배너 타이밍 | 배너가 너무 자주 나타나면 사용자 불안 → 3초 딜레이 후 표시 |
