---
marp: true
theme: default
paginate: true
size: 16:9
header: "Delay Detective — 최종 발표"
footer: "혜지 | 2026"
---

# Delay Detective
### AI-Powered Procrastination Analyzer

> "당신은 왜 오늘도 그 일을 미뤘나요?"

<!-- 대사: "안녕하세요. 저는 미루는 습관을 AI가 분석해주는 앱, Delay Detective를 개발한 혜지입니다." -->

---

## 비전 & 문제 정의

**비전**: 미루는 사람이 스스로 원인을 파악하고, 다시 시작할 수 있도록 돕는다.

**문제**: 할 일 앱은 많지만, "왜 미루는지" 알려주는 앱은 없다.

```
기존 앱: 할일 추가 → 마감 알림 → 또 미룸 🔄

Delay Detective:
  마감 초과 감지 → AI 인터뷰 → 원인 분석
  → 15분 단위 소태스크 재구성 → 실행
```

> "저도 발표 준비를 자꾸 미루다가 이 앱을 만들었습니다."

<!-- 대사: "할 일을 미루는 건 의지력 문제가 아니라, 태스크가 너무 크거나 막막해서입니다. AI가 그 이유를 물어보고, 해결 가능한 크기로 잘라줍니다." -->

---

## 시연 데모 (30초)

**[데모 영상 재생]**

시연 순서:
1. 앱 실행 → Google 로그인
2. 할일 추가 (마감일 설정)
3. 마감 초과 태스크 🔥 강조 확인
4. AI 분석 시작 → 인터뷰 3턴
5. 소태스크 생성 결과 확인
6. 통계 화면 (완료율 시각화)

<!-- 대사: "보시는 것처럼 Google 로그인 후 바로 할일을 추가할 수 있고, 마감이 지난 태스크는 불꽃 표시로 강조됩니다. AI 인터뷰를 시작하면 Claude가 왜 미루는지 물어보고, 소태스크로 분해해줍니다." -->

---

## 프로젝트 계획 — WBS & 진행 현황

| 단계 | 주요 산출물 | 상태 |
|---|---|---|
| 1. 기획 | 비전, 요구사항, WBS, ADR 3개 | ✅ 완료 |
| 2. 설계 | 4-레이어 아키텍처, Firestore/Hive 스키마 | ✅ 완료 |
| 3. 구현 | 화면 9개, Firebase, AI 인터뷰, Google 로그인 | ✅ 완료 |
| 4. 테스트 | Flutter 단위 11개, Playwright E2E | ✅ 완료 |
| 5. 배포 | 웹 빌드, APK 49.9MB, AAB 43MB | ✅ 완료 |

**총 6주 개발 (세션 2~6)**

<!-- 대사: "6주 동안 기획부터 배포까지 모든 단계를 완료했습니다. 계획한 Must 기능은 100%, Should 기능도 주요 항목은 구현했습니다." -->

---

## 기술 스택

| 계층 | 기술 | 선택 이유 |
|---|---|---|
| UI | Flutter (Dart) | 웹·Android 동시 지원, 단일 코드베이스 |
| 상태 관리 | Provider | Flutter 공식 권장, 단순하고 확장성 있음 |
| 로컬 DB | Hive | 오프라인 우선, 빠른 읽기/쓰기 |
| 클라우드 | Firebase Firestore | 실시간 동기화, 서버 없이 운영 가능 |
| 인증 | Firebase Auth (Google) | 안전한 OAuth2, uid 기반 데이터 분리 |
| AI | Anthropic API (Claude) | 자연어 인터뷰 & 원인 분석 |
| 테스트 | Flutter Test + Playwright | 단위·E2E 커버리지 |

<!-- 대사: "기술 선택의 핵심은 '서버 없이 오프라인도 동작하는 앱'이었습니다. Hive가 로컬, Firestore가 클라우드를 담당해서 네트워크 없이도 완전히 동작합니다." -->

---

## 아키텍처 — 4-레이어 구조

```
lib/
├── presentation/   ← UI 화면 9개, 위젯
│     screens/: Home, AddTask, Interview, AnalysisResult,
│               History, Stats, Login, Splash, TaskList
├── application/    ← Provider (TaskProvider, AuthProvider, SyncProvider)
├── domain/         ← Task, SubTask, DelayAnalysis 모델, Enum
└── data/
      local/    → HiveService (오프라인 CRUD)
      remote/   → FirestoreService, AuthService, AIService
      sync/     → SyncService (sync_queue 패턴)
```

**의존성 방향**: Presentation → Application → Domain ← Data

<!-- 대사: "클린 아키텍처의 4-레이어를 적용했습니다. 각 레이어는 한 방향으로만 의존하고, Domain 레이어는 외부에 의존하지 않습니다. ADR-0001에서 이 결정을 기록했습니다." -->

---

## 구현 방법 — 오프라인-온라인 동기화

```
[오프라인]  사용자 조작 → Hive 저장 → sync_queue에 taskId 추가
[네트워크 복구]  SyncService.flushQueue() 실행
                → Hive.updatedAt vs Firestore.updatedAt 비교
                → 더 최신 데이터 선택 (Last-Write-Wins)
```

**Google 로그인 분기 처리** (`kIsWeb` 체크):
```dart
if (kIsWeb) {
  // 웹: signInWithPopup (idToken 이슈 우회)
} else {
  // 모바일: google_sign_in 패키지 (네이티브 계정 선택)
}
```

<!-- 대사: "가장 복잡한 부분이 동기화 로직입니다. 오프라인에서 변경한 내용은 sync_queue에 쌓아두고, 네트워크 복구 시 타임스탬프를 비교해서 더 최신 데이터를 선택합니다. ADR-0003에 이 결정을 기록했습니다." -->

---

## 구현 시행착오 (개발자 관점)

| 문제 | 원인 | 해결 |
|---|---|---|
| Firestore 중복 데이터 | 앱 실행마다 offline UID 재생성 | Hive settings 박스로 UID 영속화 |
| `400: origin_mismatch` | Google OAuth에 localhost:포트 미등록 | `--web-port 5000` 고정, Cloud Console 등록 |
| 웹 로그인 후 화면 안 바뀜 | `signIn()`이 웹에서 idToken 미반환 | `signInWithPopup()`으로 전환 |
| Android 로그인 실패 | Firebase에 SHA-1 지문 미등록 | keytool→openssl로 SHA-1 추출, 등록 |
| 로그아웃 후 Splash에서 멈춤 | authStateChanges 스트림 응답 지연 | signOut() 전 즉시 `notifyListeners()` |

<!-- 대사: "5가지 버그를 실제로 겪고 해결했습니다. 특히 웹과 모바일의 Google 로그인 방식이 달라서 kIsWeb으로 분기해야 했던 것이 가장 배움이 컸습니다." -->

---

## 테스트 & 코드 품질

**단위 테스트** — `flutter test` → **11개 전체 통과**
- `Task.shouldBeDelayed` 4케이스, 직렬화 왕복, Conflict Resolution

**통합 테스트 (E2E)** — Playwright (`e2e/`)
- `login.spec.ts`: 로그인 화면 렌더링, 버튼 반응
- `navigation.spec.ts`: 비인증 리다이렉트 확인

**코드 품질 관리**
- 4-레이어 아키텍처로 관심사 분리
- `ChangeNotifierProxyProvider`로 uid 변경 시 Provider 자동 재생성
- `keystore`, `.env` → `.gitignore` 등록, 보안 키 미커밋

<!-- 대사: "단위 테스트 11개를 작성했고 모두 통과했습니다. E2E 테스트는 Playwright로 로그인·네비게이션 흐름을 자동화했습니다." -->

---

## 개발환경 & 빌드/배포 & GitHub 설치 가이드

**개발환경**: Flutter 3.x · Firebase CLI · VS Code · Claude Code · Android USB 디버깅

**GitHub 설치 가이드** (`docs/setup.md`)
```bash
git clone https://github.com/<repo>/delay-detective
flutter pub get
# Firebase 연결
flutterfire configure
# 웹 실행 (OAuth 포트 5000 고정)
flutter run -d chrome --web-port 5000
```

**빌드/배포 3단계**
```
debug  → flutter run --debug      (개발)
release→ flutter build apk/appbundle/web --release  (배포)
hosting→ firebase deploy --only hosting  (웹 퍼블리시)
```

<!-- 대사: "빌드는 debug, release, profile 세 종류입니다. 릴리즈 빌드는 서명 키를 설정하고 appbundle로 Play Console에 업로드합니다. 설치 방법은 README와 docs/setup.md에 명령어 그대로 따라할 수 있게 정리했습니다." -->

---

## ADR 요약 — 핵심 기술 결정 3가지

| ADR | 결정 | 이유 |
|---|---|---|
| **ADR-0001** Flutter 선택 | Native 대신 Flutter | 웹+Android 동시 지원, 단일 코드베이스 |
| **ADR-0002** Provider 선택 | Redux 대신 Provider | Flutter 공식 권장, 학습 곡선 낮음 |
| **ADR-0003** Firebase+Hive | 자체 서버 대신 Firebase | 서버 개발 없이 오프라인-온라인 동기화 구현 |

> Q: "왜 Supabase 대신 Firebase를 선택했나요?"  
> A: "Flutter 공식 패키지 성숙도, 무료 플랜, 국내 레퍼런스 다양함 — ADR-0003에 기록했습니다."

<!-- 대사: "모든 기술 결정은 ADR 문서로 남겼습니다. 왜 이 기술을 선택했는지 Q&A에서 질문이 오면 ADR 번호로 답변할 수 있습니다." -->

---

## 활용 방안 & 향후 발전 방향

**현재 활용 가능**
- 개인 할일 관리 + AI 미루기 원인 분석
- 오프라인에서도 완전 동작
- 웹(Chrome) + Android 멀티 플랫폼

**향후 발전 방향**
- iOS 지원 (TestFlight 배포)
- 미루기 패턴 장기 통계 분석
- 푸시 알림 (FCM)
- Notion/GitHub 연동으로 소태스크 자동 이슈 생성

**기술 습득 의지**: LLM Wiki 5개 파일(`notes/`)에 동기화 전략·에이전트 협업·MCP 활용 경험 축적 → 다음 프로젝트에 재사용

<!-- 대사: "이 앱의 AUTHORING.hyeji.md 한 파일로 전체 AI 팀을 부트스트랩하는 방식은 다음 프로젝트에도 그대로 적용할 수 있습니다. AI와 협업하는 개발 방식 자체를 자산으로 만들었습니다." -->

---

## AI Agent 활용 워크플로우

**도구 구성**

| 도구 | 역할 |
|---|---|
| Claude Code | 메인 오케스트레이터, 코드 생성·검증 |
| 서브에이전트 5종 | PM·백엔드·프론트·QA·AI통합 역할 분리 |
| MCP 3개 | Notion(기획), GitHub(이슈), Playwright(E2E) |

**나만의 기법 — AUTHORING.hyeji.md 단일 파일 부트스트랩**

```
1개 파일로 5개 에이전트의 컨텍스트를 공유
→ 세션 전환 시 "AUTHORING.hyeji.md 읽어" 한 줄로 재시작
→ PRD·ADR·WBS·스키마가 한 파일 안에 = 에이전트 간 정보 단절 없음
```

**LLM Wiki** (`notes/` 폴더): 세션마다 배운 것 기록 → 5개 파일 축적

<!-- 대사: "서브에이전트를 5개 역할로 나눠 팀처럼 운영했습니다. 가장 중요한 기법은 AUTHORING.hyeji.md 한 파일로 모든 에이전트를 부트스트랩한 것입니다. 세션이 끊겨도 이 파일 하나만 읽으면 바로 이어서 개발할 수 있었습니다." -->

---

## 회고

### 잘된 것
- 6주 안에 기획→구현→배포 전 사이클 완료
- Hive + Firestore Last-Write-Wins 동기화 — 오프라인에서도 완전 동작
- 웹·Android 동시 지원 (Google 로그인 분기 처리까지)
- 서브에이전트 역할 분리로 복잡한 코드도 맥락 없이 인계 가능

### 어려웠던 것
- 웹·모바일 Google 로그인 방식이 달라서 `kIsWeb` 분기 직접 작성
- OAuth `origin_mismatch` — 포트 고정(`--web-port 5000`) 방법 직접 삽질
- Firebase SHA-1 등록을 몰라서 Android 로그인 2일 막힘

### 1주일 더 있다면
- FCM 푸시 알림 (마감 D-1 알림)
- iOS TestFlight 배포
- 미루기 패턴 장기 통계 + AI 인사이트 대시보드

<!-- 대사: "가장 힘들었던 건 웹과 Android의 Google 로그인 차이였습니다. 공식 문서가 분리돼 있어서 직접 코드를 읽고 kIsWeb 분기를 작성했습니다. 이 경험이 플랫폼 차이에 대한 이해를 가장 높여줬습니다." -->

---

## 가산점 신청 요약

| 항목 | 내용 | 증빙 |
|---|---|---|
| ✅ A. AI Agent 워크플로우 | 서브에이전트 5종 + MCP 3개 | `.claude/agents/` 5개 파일 |
| ✅ B. 나만의 기법 | AUTHORING.hyeji.md 단일 파일 부트스트랩 | `AUTHORING.hyeji.md` |
| ✅ C. LLM Wiki | 세션별 학습 기록 5개 파일 | `notes/` 폴더 |

**GitHub 저장소**: https://github.com/hyeji203/delay-detective

- `docs/slides-final.md` — 이 발표자료
- `AUTHORING.hyeji.md` — AI 팀 설계 문서
- `notes/` — LLM Wiki (5개 파일)
- `.claude/agents/` — 서브에이전트 정의 5종

<!-- 대사: "가산점 세 항목 모두 GitHub 저장소에 실제 파일로 증빙됩니다. AUTHORING.hyeji.md는 단순 문서가 아니라, 이걸 읽으면 에이전트가 바로 이어서 개발할 수 있는 '살아있는 설계서'입니다." -->

---

## 감사합니다

### Q&A

> "Delay Detective — AI가 물어봐주면, 미루기가 시작된다"

**GitHub**: https://github.com/hyeji203/delay-detective  
**발표자**: 혜지 | 2026

---

# 백업 슬라이드

---

## B1. Firestore 데이터 구조

```
users/{uid}/tasks/{taskId}
  - id, title, description
  - dueDate, isCompleted, isDelayed
  - delayReason, delayCategory
  - createdAt, updatedAt   ← 동기화 타임스탬프
  - subTasks: [{id, title, isCompleted}]

users/{uid}/sync_queue/{taskId}
  - taskId, action (upsert/delete), timestamp
```

---

## B2. AI 인터뷰 흐름

```
1단계: "이 태스크를 미룬 이유가 뭔가요?" (개방형)
2단계: 원인 유형 파악 (복잡함/두려움/우선순위/환경)
3단계: "15분 안에 할 수 있는 첫 번째 단계는?" (소태스크 추출)

→ Claude API stream으로 실시간 답변
→ 응답 파싱 → SubTask 리스트 자동 생성
```

---

## B3. 보안 처리

- `google-services.json` / `GoogleService-Info.plist` → `.gitignore`
- `keystore.jks` + `key.properties` → `.gitignore`
- Anthropic API 키 → `.env` (`.gitignore`)
- Firebase Security Rules: `uid` 기반 사용자 격리

---

## B4. 테스트 상세

```bash
# 단위 테스트 (11개)
flutter test test/unit/

# E2E (Playwright)
npx playwright test e2e/login.spec.ts
npx playwright test e2e/navigation.spec.ts
```

테스트 항목: Task.shouldBeDelayed 4케이스, 직렬화 왕복,  
Conflict Resolution (Hive vs Firestore 타임스탬프 비교)
