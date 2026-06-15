# ADR-0003: 백엔드 & 데이터 저장 방식 선택

- 상태: Accepted
- 날짜: 2026-05-11
- 결정자: 혜지

## 배경

Delay Detective는 두 가지 데이터 요구사항이 있다:
1. **오프라인 동작**: 네트워크 없이도 태스크를 생성·수정·조회할 수 있어야 함
2. **멀티 디바이스 동기화**: 로그인한 사용자는 기기 간 데이터를 동기화할 수 있어야 함

이 두 요구사항을 동시에 만족하는 백엔드/저장소 조합을 선택해야 한다.

## 고려한 대안

### 대안 A: Firebase Firestore + Hive (로컬 우선)
- 장점:
  - Hive: 오프라인 완전 지원, 빠른 로컬 읽기/쓰기
  - Firestore: 실시간 동기화, Google 인프라, 별도 서버 관리 불필요
  - Flutter 공식 패키지(`cloud_firestore`, `hive_flutter`) 성숙
  - Timestamp 기반 Conflict Resolution으로 충돌 해결 가능
  - 무료 할당량(Spark Plan)이 학생 프로젝트에 충분
- 단점:
  - 동기화 로직(SyncService)을 직접 구현해야 함
  - Hive TypeAdapter 코드 생성(`build_runner`) 설정 필요

### 대안 B: Supabase (PostgreSQL 기반)
- 장점:
  - 오픈소스, Firebase 대비 SQL 쿼리 지원
  - 실시간 구독 기능 내장
- 단점:
  - Flutter 패키지가 Firebase보다 덜 성숙
  - 오프라인 지원을 위한 로컬 DB를 별도로 선택해야 함 (SQLite 등)
  - Firebase처럼 국내 레퍼런스가 많지 않아 문제 발생 시 해결 시간 증가

### 대안 C: 자체 서버 (Node.js + MongoDB)
- 장점:
  - 완전한 커스터마이징 가능
  - 데이터 완전 소유
- 단점:
  - 서버 개발 + 배포(EC2, Railway 등) + 유지보수가 추가됨
  - 6주 일정에서 백엔드 서버까지 구축하면 프론트 개발 시간 없음
  - 오프라인 지원을 위해 어차피 로컬 DB 별도 선택 필요

### 대안 D: 로컬 전용 (Hive만 사용)
- 장점:
  - 가장 단순, 네트워크 불필요
  - 개인정보 이슈 없음
- 단점:
  - 기기 교체 시 데이터 소멸
  - 멀티 디바이스 불가
  - 옵션 C(오프라인-온라인 동기화)의 핵심 요구사항 미충족

## 결정

**대안 A — Firebase Firestore(온라인) + Hive(로컬) 조합**을 선택한다.  
로그인은 선택적으로 제공하며, 비로그인 시에는 Hive 단독으로 동작한다.

## 이유

- 이 프로젝트의 핵심 기술 도전(오프라인-온라인 동기화)을 직접 구현해 볼 수 있는 유일한 구조
- Hive의 `lastModified` Timestamp와 Firestore의 `updatedAt`을 비교하는 Last-Write-Wins 방식으로 충돌 해결이 명확함
- Firebase 무료 플랜(Spark)으로 학생 프로젝트 규모는 충분히 커버됨
- Flutter 공식 패키지 사용으로 발표 Q&A에서 기술 선택 근거를 명확히 설명 가능
- 자체 서버 없이 서비스 런칭 가능 (유지보수 비용 0)

## 결과 (예상되는 영향)

긍정:
- 오프라인 상태에서도 100% 기능 동작
- 로그인 시 자동 멀티 디바이스 동기화
- Firebase Console에서 실시간 데이터 모니터링 가능
- Firestore 보안 규칙으로 "내 데이터만 내가 접근" 구현 가능

부정 / 제약:
- `SyncService` 구현 복잡도 — 동기화 버그가 발생할 경우 디버깅이 까다로움
  → R2 위험 요소로 관리 (`04-schedule.md` 참고)
- Firestore는 관계형 DB가 아니어서 복잡한 쿼리에 한계
  → 이 앱의 데이터 구조(태스크 단순 목록)에는 Firestore가 적합

## 후속 작업

- [ ] Firestore 보안 규칙 초안 작성 (`users/{userId}/tasks/{taskId}` 구조)
- [x] Firebase 프로젝트 생성 및 `firebase_options.dart` 실제 키 연결 완료 (2026-06-15)
- [x] `pubspec.yaml`에 `hive`, `hive_flutter`, `firebase_core`, `cloud_firestore`, `firebase_auth` 추가 (2026-05-18 완료)
- [x] `SyncService` 설계 문서 작성 → `docs/architecture.md`에 포함 (2026-05-18 완료)
- [x] 오프라인 UID 영속화 — HiveService settings 박스로 uid 저장, Firestore 중복 데이터 방지 (2026-06-15)
- [x] Google 로그인 도입 — `google_sign_in` 패키지, AuthService / AuthProvider 구현 (2026-06-15)

---

## 업데이트 — Offline-First 전략 & 세부 결정 확정 (2026-05-18)

추가로 결정된 사항:

| 항목 | 결정 | 이유 |
|:---|:---|:---|
| 로그인 | ~~Firebase 익명 로그인만~~ → **Google 로그인으로 변경** (2026-06-15) | 기능 추가 요구, Firestore uid 중복 문제 해결 |
| 소태스크 저장 | Task 문서 내 배열 필드 | 별도 컬렉션 대비 쿼리 단순화 |
| AI 인터뷰 비용 | 3턴 고정 | 무제한 대화 대비 비용 예측 가능 |
| 알림 | 로컬 알림만 | FCM 대비 구현 복잡도 1/10 |

**Firestore 스키마 확정**:
```
users/{uid}/tasks/{taskId}/
  subtasks  : [{id, title, isDone}]   ← 배열 (컬렉션 X)
  analysis  : {empathyMessage, causeSummary, turns[], analyzedAt} | null
  updatedAt : timestamp               ← Last-Write-Wins 기준
```

**sync_queue 구현**: Hive `Box<String>('sync_queue')`에 taskId를 저장하고,
네트워크 연결 시 `SyncService.flushQueue()`가 Firestore로 업로드한다.

참고: [docs/architecture.md](../../docs/architecture.md)

---

## 업데이트 — Google 로그인 & 인증 구조 변경 (2026-06-15)

### 변경 사항

기존에는 Firebase 익명 로그인만 사용했으나, 다음 문제로 Google 로그인으로 전환:

1. **Firestore 중복 데이터 문제**: 익명 로그인 실패 시 `offline-user-타임스탬프`가 매 실행마다 새로 생성되어 Firestore에 동일 할일이 중복 저장됨
2. **UX 요구**: 로그인 기능이 명시적으로 필요

### 새 인증 구조

| 파일 | 역할 |
|:---|:---|
| `lib/data/remote/auth_service.dart` | Google 로그인/로그아웃 (웹: signInWithPopup, 모바일: google_sign_in) |
| `lib/application/auth_provider.dart` | `authStateChanges` 스트림 구독, uid/isLoggedIn 노출 |
| `lib/presentation/screens/login_screen.dart` | Google 로그인 버튼 화면 |
| `main.dart` — `_AuthGate` | 인증 상태에 따라 SplashScreen / LoginScreen / MainScreen 분기 |

### 웹 특이사항

`google_sign_in` 패키지의 `signIn()` 메서드는 웹에서 `idToken`을 반환하지 않아 Firebase 인증이 불가능. 웹에서는 `FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider())`를 직접 사용하여 해결.

### UID 영속화

Firebase Auth가 성공하면 Firebase SDK가 uid를 자동 영속화. 실패(오프라인) 시에는 HiveService `settings` 박스에 uid를 저장해 재사용 — 더 이상 타임스탬프 기반 임시 uid가 생성되지 않음.
