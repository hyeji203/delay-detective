# Conflict Resolution 구현 중 발견한 버그와 해결법

> LLM Wiki — 동기화 충돌 해결 구현 경험 기록  
> 작성자: 혜지

## 이 파일의 목적
Hive ↔ Firestore 동기화 구현 중 발생한 버그, 원인 분석, 해결 방법을 사례별로 기록한다.

---

## 버그 1 — Hive TypeAdapter 등록 순서 오류

**현상**:
```
HiveError: Cannot write, unknown type: Task
```

**원인**:  
Hive는 `TypeAdapter`를 `main.dart`의 `Hive.openBox()` 호출 **전에** 등록해야 한다. 순서가 바뀌면 위 에러 발생.

**해결**:
```dart
// main.dart
void main() async {
  await Hive.initFlutter();
  
  // TypeAdapter 등록이 openBox보다 먼저 와야 함
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(SubTaskAdapter());
  Hive.registerAdapter(DelayAnalysisAdapter());
  
  await Hive.openBox<Task>('tasks');  // 등록 후에 open
  runApp(MyApp());
}
```

**교훈**: Hive 초기화 순서는 init → registerAdapter → openBox. 절대 순서 바뀌면 안 됨.

---

## 버그 2 — Firestore Timestamp와 Dart DateTime 비교 오류

**현상**:  
서버가 더 최신 데이터인데 로컬 데이터가 항상 이기는 현상.

**원인**:  
Firestore의 `Timestamp`를 `DateTime`으로 변환할 때 UTC/로컬 시간 혼용 문제.

```dart
// 버그 있는 코드
final firestoreTime = firestoreData['updatedAt'] as Timestamp;
final firestoreDateTime = firestoreTime.toDate();  // 로컬 타임존으로 변환됨

final hiveDateTime = hiveTask.updatedAt;  // UTC로 저장됨
// 비교 시 timezone 차이로 인해 9시간 오차 발생 (한국 KST)
```

**해결**:
```dart
// 둘 다 UTC로 통일해서 비교
final firestoreDateTime = firestoreTime.toDate().toUtc();
final hiveDateTime = hiveTask.updatedAt.toUtc();

if (hiveDateTime.isAfter(firestoreDateTime)) { ... }
```

**교훈**: 타임스탬프 비교는 반드시 UTC로 통일. 저장할 때도 `DateTime.now().toUtc()` 사용.

---

## 버그 3 — 오프라인 큐 중복 처리

**현상**:  
앱을 재시작하면 같은 태스크가 Firestore에 두 번 올라가는 현상.

**원인**:  
SyncService가 시작될 때 큐를 처리하는데, 앱 종료 전에 이미 업로드됐지만 큐에서 제거되기 전에 앱이 꺼진 경우.

**해결**:
```dart
// Firestore 업로드 시 taskId 기준으로 upsert (생성 또는 업데이트)
await firestore.collection('tasks').doc(task.id).set(
  task.toMap(),
  SetOptions(merge: true),  // 이미 있으면 merge, 없으면 생성
);
// → 중복으로 올라가도 덮어쓰기라 데이터 손상 없음
```

**교훈**: 동기화 작업은 항상 idempotent(멱등성)하게 설계. 같은 작업을 두 번 해도 결과가 같아야 함.

---

## 버그 4 — 동기화 중 UI가 갑자기 깜빡이는 현상

**현상**:  
Firestore에서 데이터를 받아서 Hive를 업데이트할 때 화면의 태스크 목록이 순간 사라졌다가 다시 나타남.

**원인**:  
SyncService가 Hive를 전체 초기화(clear) 후 새 데이터를 넣는 방식으로 구현했기 때문. clear 순간 UI가 빈 상태를 표시.

**해결**:
```dart
// 나쁜 방식: clear 후 전체 재삽입
await box.clear();
for (final task in serverTasks) { await box.put(task.id, task); }

// 좋은 방식: 개별 upsert
for (final task in serverTasks) {
  final existing = box.get(task.id);
  if (existing == null || task.updatedAt.isAfter(existing.updatedAt)) {
    await box.put(task.id, task);  // 없거나 서버가 최신이면 업데이트
  }
}
```

**교훈**: 동기화는 전체 교체가 아니라 변경된 것만 업데이트. UI 깜빡임 = 전체 초기화 신호.

---

## 버그 5 — AI 인터뷰 응답 파싱 실패

**현상**:  
Claude API가 소태스크를 JSON으로 반환해야 하는데, 가끔 마크다운 코드 블록으로 감싸서 반환해서 파싱 오류 발생.

**Claude 응답 예시 (문제 상황)**:
~~~
```json
{"subtasks": ["단계1", "단계2", "단계3"]}
```
~~~

**해결**:
```dart
// 응답에서 코드 블록 마커 제거 후 파싱
String cleanJson(String response) {
  return response
    .replaceAll('```json', '')
    .replaceAll('```', '')
    .trim();
}

final cleaned = cleanJson(apiResponse);
final parsed = jsonDecode(cleaned);
```

**교훈**: LLM 응답 파싱은 항상 방어적으로. 코드 블록, 여분의 텍스트, 줄바꿈 처리를 기본으로 넣어야 함.
