# ADR-0002: 상태 관리 라이브러리 선택

- 상태: Accepted
- 날짜: 2026-05-11
- 결정자: 혜지

## 배경

Flutter 앱은 화면 간 데이터 공유와 비동기 상태(로딩, 오류, 동기화 진행 중 등)를 관리할
상태 관리 솔루션이 필요하다.
이 앱에서 관리해야 할 상태는 크게 세 가지다:
- 태스크 목록 + 지연 상태 (TaskProvider)
- Hive ↔ Firestore 동기화 상태 (SyncProvider)
- AI 인터뷰 진행 상태 + 결과 (AIProvider)

## 고려한 대안

### 대안 A: Provider (ChangeNotifier)
- 장점:
  - Flutter 공식 문서에서 기본 추천하는 패턴
  - `ChangeNotifier` + `notifyListeners()` 구조가 직관적
  - 학습 곡선이 낮아 6주 일정에 적합
  - `MultiProvider`로 여러 Provider 병렬 등록 가능
  - AI 에이전트가 가장 많이 생성해본 코드 패턴
- 단점:
  - 대규모 앱에서는 리빌드 범위 관리가 번거로울 수 있음
  - `ChangeNotifier`는 불변(immutable) 상태를 강제하지 않음

### 대안 B: Riverpod
- 장점:
  - Provider의 단점 보완 (컴파일 타임 안전성, 테스트 용이)
  - `ref.watch()` / `ref.read()` 패턴이 깔끔함
  - 2024년 기준 Flutter 커뮤니티 인기도 1위
- 단점:
  - Provider와 API가 달라서 새로 학습 필요
  - 어노테이션 기반(`@riverpod`)은 `build_runner` 추가로 복잡도 증가

### 대안 C: BLoC (Business Logic Component)
- 장점:
  - 이벤트/상태 분리가 명확해 대형 팀 프로젝트에 적합
  - 테스트 작성이 용이
- 단점:
  - 보일러플레이트 코드가 많아 소규모 프로젝트에 과함
  - `Cubit` + `BlocBuilder` 학습 비용이 6주 일정에 부담

### 대안 D: GetX
- 장점:
  - 상태 관리 + 라우팅 + 의존성 주입을 한 패키지로 해결
  - 코드량이 적음
- 단점:
  - 의견이 분분한 패키지 (Flutter 공식 권장 아님)
  - 내부 동작 원리를 이해하기 어려워 Q&A에서 설명하기 곤란

## 결정

**대안 A — Provider (ChangeNotifier)**를 선택한다.

## 이유

- Flutter 공식 권장 패턴이라 발표 Q&A에서 "왜 썼나?"에 명확히 답할 수 있다
- 이 앱의 상태 복잡도(Provider 3개)는 Provider로 충분히 커버된다
- `TaskProvider`, `SyncProvider`, `AIProvider` 3개를 `MultiProvider`로 등록하는 구조가 단순하고 명확하다
- AI 에이전트(frontend-developer)가 생성하는 코드 품질이 Provider 패턴에서 가장 안정적

## 결과 (예상되는 영향)

긍정:
- `context.watch<TaskProvider>()` 한 줄로 화면에서 상태 구독 가능
- `Consumer` 위젯으로 리빌드 범위를 최소화 가능
- 단위 테스트 시 Provider를 mock으로 쉽게 교체 가능

부정 / 제약:
- 앱이 커질 경우 `notifyListeners()` 호출 시 불필요한 리빌드 발생 가능
  → `Consumer`와 `Selector`를 적절히 사용해 완화

## 후속 작업

- [x] `pubspec.yaml`에 `provider: ^6.x` 추가 (2026-05-18 완료)
- [x] `main.dart`에 `MultiProvider` 설정 (2026-05-18 완료)
- [x] `TaskProvider`, `SyncProvider`, `AIProvider` 클래스 골격 생성 (2026-05-18 완료)

---

## 업데이트 — Provider 3개 역할 확정 (2026-05-18)

| Provider | 책임 | 핵심 메서드 |
|:---|:---|:---|
| `TaskProvider` | 태스크 CRUD + 지연 감지 | `loadTasks()`, `addTask()`, `checkDelayStatus()`, `applySubtasks()` |
| `AIProvider` | 인터뷰 턴 1→2→3 상태 관리 | `startInterview()`, `submitAnswer()`, `reset()` |
| `SyncProvider` | 온라인/오프라인 상태 + queue flush | `onConnectivityChanged()`, `flushQueue()` |

**인터뷰 상태 흐름**: `idle → interviewing → analyzing → done / error`

참고: [docs/architecture.md](../../docs/architecture.md)
