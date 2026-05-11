# unknowns.md — 모르는 영역 질문 목록

**작성일**: 2026-05-11 (10주차)  
**목적**: 구현 전에 모르는 것을 미리 파악해서 에이전트에게 설명 요청하거나 학습  
**사용법**: 각 항목을 이해하면 ✅ 표시. 이해 안 되면 해당 에이전트에게 "왜 이렇게 했어?" 질문

---

## 1. Hive (로컬 DB)

- [ ] **Q**: `@HiveType`, `@HiveField` 어노테이션이 정확히 무슨 역할인가?
- [ ] **Q**: `TypeAdapter`를 직접 만드는 것과 `build_runner`로 자동 생성하는 것의 차이?
- [ ] **Q**: Hive 박스(Box)와 LazyBox의 차이 — 언제 LazyBox를 써야 하나?
- [ ] **Q**: 앱을 재시작해도 데이터가 유지되는 원리 (어디에 파일로 저장되는가)?

**담당 에이전트**: `backend-architect`

---

## 2. Firebase Firestore

- [ ] **Q**: Firestore 보안 규칙(Security Rules)을 어떻게 작성해야 "내 데이터만 내가 읽을 수 있게" 되는가?
- [ ] **Q**: 익명 로그인(Anonymous Auth)과 이메일 로그인을 동시에 지원할 때, 기존 익명 데이터를 어떻게 이전하는가?
- [ ] **Q**: Firestore 실시간 리스너(`snapshots()`)와 단순 조회(`get()`)를 언제 각각 쓰는가?
- [ ] **Q**: Firestore 오프라인 캐시와 Hive를 함께 쓰면 충돌이 생기지 않는가?

**담당 에이전트**: `backend-architect`

---

## 3. Hive ↔ Firestore 동기화

- [ ] **Q**: `Timestamp` 기반 Last-Write-Wins에서 두 기기의 시계가 다르면 어떻게 되는가?
- [ ] **Q**: 오프라인 중에 두 기기에서 같은 태스크를 수정하면 어떤 일이 일어나는가?
- [ ] **Q**: `SyncService`는 앱이 백그라운드일 때도 동기화를 실행하는가?
- [ ] **Q**: 동기화 중에 앱을 강제 종료하면 데이터 손실이 생기는가?

**담당 에이전트**: `backend-architect`

---

## 4. Anthropic API

- [ ] **Q**: 대화 맥락을 넘길 때 `messages` 배열에 이전 대화를 어디까지 포함해야 하는가?
- [ ] **Q**: 인터뷰 2~3턴 후 "분석 결과 생성" 모드로 전환하는 것을 프롬프트로 어떻게 제어하는가?
- [ ] **Q**: API 응답에서 공감/원인/소태스크를 안정적으로 분리하는 파싱 방법은?
- [ ] **Q**: 토큰 비용을 줄이기 위해 시스템 프롬프트를 어떻게 최적화하는가?
- [ ] **Q**: API 호출 실패(네트워크 오류, 429 Too Many Requests) 시 어떻게 처리하는가?

**담당 에이전트**: `ai-integration-specialist`

---

## 5. Flutter Provider 상태 관리

- [ ] **Q**: `ChangeNotifier`와 `notifyListeners()`의 동작 원리 — 언제 화면이 다시 그려지는가?
- [ ] **Q**: `MultiProvider`를 쓸 때 Provider 간 의존성이 있으면 어떻게 순서를 정하는가?
- [ ] **Q**: `Consumer`와 `context.watch()`의 차이 — 성능 면에서 어느 게 나은가?
- [ ] **Q**: `TaskProvider`가 `SyncProvider`를 참조해야 할 때 순환 의존성을 어떻게 피하는가?

**담당 에이전트**: `frontend-developer`

---

## 6. Flutter 로컬 알림

- [ ] **Q**: `flutter_local_notifications`에서 iOS 권한 요청은 언제, 어떻게 해야 하는가?
- [ ] **Q**: 앱이 완전히 종료된 상태에서도 D-3 알림이 오는가?
- [ ] **Q**: 마감일이 변경됐을 때 기존에 예약된 알림을 어떻게 취소하고 다시 예약하는가?

**담당 에이전트**: `frontend-developer`

---

## 7. Playwright MCP 테스트

- [ ] **Q**: Playwright MCP가 Flutter 앱(네이티브 위젯)을 어떻게 자동화하는가?
- [ ] **Q**: AI 인터뷰처럼 서버 응답에 의존하는 비동기 UI를 테스트할 때 어떻게 기다리는가?
- [ ] **Q**: 테스트 실패 시 스크린샷이 자동으로 저장되는가?

**담당 에이전트**: `qa-engineer`

---

## 우선 이해해야 할 Top 5

발표 Q&A에서 가장 많이 나올 질문 기준:

1. Hive + Firestore 동기화 충돌 해결 방식 (섹션 3)
2. Anthropic API 인터뷰 턴 제어 방식 (섹션 4)
3. 익명 → 이메일 로그인 데이터 이전 (섹션 2)
4. Provider 간 의존성 관리 (섹션 5)
5. `@HiveType` 어노테이션 원리 (섹션 1)
