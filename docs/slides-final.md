---
marp: true
theme: default
paginate: true
size: 16:9
backgroundColor: "#ffffff"
header: "Delay Detective — 최종 발표"
footer: "혜지 | 2026.06"
style: |
  /* ───── Base ───── */
  section {
    font-family: 'Apple SD Gothic Neo', '맑은 고딕', 'Noto Sans KR', sans-serif;
    font-size: 24px;
    padding: 44px 52px;
    color: #1a1a2e;
  }

  /* ───── Cover ───── */
  section.cover {
    background: linear-gradient(135deg, #0f2044 0%, #1F3864 45%, #2E75B6 100%);
    color: white;
    text-align: center;
    justify-content: center;
    padding: 48px;
  }
  section.cover .app-icon {
    font-size: 72px;
    margin-bottom: 8px;
    display: block;
  }
  section.cover h1 {
    font-size: 58px;
    font-weight: 800;
    margin: 0 0 8px 0;
    letter-spacing: -1px;
  }
  section.cover .subtitle {
    font-size: 22px;
    opacity: 0.9;
    margin-bottom: 28px;
    font-weight: 300;
  }
  section.cover .tagline {
    font-size: 18px;
    opacity: 0.75;
    background: rgba(255,255,255,0.12);
    padding: 10px 28px;
    border-radius: 30px;
    display: inline-block;
  }
  section.cover .meta {
    position: absolute;
    bottom: 32px;
    left: 0; right: 0;
    font-size: 15px;
    opacity: 0.6;
  }

  /* ───── Headings ───── */
  h2 {
    color: #1F3864;
    border-bottom: 3px solid #2E75B6;
    padding-bottom: 8px;
    margin-bottom: 20px;
    font-size: 30px;
  }
  h3 { color: #2E75B6; font-size: 20px; margin: 12px 0 8px 0; }

  /* ───── Tables ───── */
  table { font-size: 19px; width: 100%; border-collapse: collapse; }
  th { background: #1F3864; color: white; padding: 7px 10px; }
  td { padding: 5px 10px; border: 1px solid #dde4f0; }
  tr:nth-child(even) td { background: #f5f8ff; }

  /* ───── Code ───── */
  code {
    background: #f0f4ff;
    padding: 2px 8px;
    border-radius: 4px;
    font-size: 19px;
    color: #1F3864;
  }
  pre {
    background: #1a1a2e;
    color: #e0e8ff;
    padding: 16px 20px;
    border-radius: 10px;
    font-size: 17px;
    line-height: 1.6;
    border-left: 4px solid #2E75B6;
  }
  pre code { background: transparent; color: inherit; font-size: inherit; padding: 0; }

  /* ───── Blockquote ───── */
  blockquote {
    border-left: 4px solid #2E75B6;
    background: #eef4ff;
    padding: 10px 18px;
    margin: 14px 0;
    border-radius: 0 8px 8px 0;
    font-size: 20px;
    color: #1F3864;
  }

  /* ───── Utility ───── */
  .two-col { display: grid; grid-template-columns: 1fr 1fr; gap: 24px; }
  .box {
    background: #f5f8ff;
    border: 2px solid #c5d8f5;
    border-radius: 10px;
    padding: 14px 18px;
  }
  .box-green {
    background: #f0faf0;
    border: 2px solid #86c77a;
    border-radius: 10px;
    padding: 14px 18px;
  }
  .box-orange {
    background: #fff8f0;
    border: 2px solid #ffaa55;
    border-radius: 10px;
    padding: 14px 18px;
  }
  .chip {
    display: inline-block;
    padding: 2px 10px;
    border-radius: 20px;
    font-size: 14px;
    font-weight: 600;
  }
  .done  { background: #70AD47; color: white; }
  .ms    { background: #C00000; color: white; }
  .warn  { background: #FF6B35; color: white; }

  /* ───── WBS table overrides ───── */
  .wbs-table { font-size: 11px !important; }
  .wbs-table th { padding: 3px 5px; font-size: 11px; }
  .wbs-table td { padding: 2px 4px; border: 1px solid #ccc; font-size: 11px; }
  .wbs-table tr.sec td { background: #dce8ff; font-weight: 700; }
  .wbs-table tr.ms  td { background: #fff3cc; font-weight: 700; }

  /* ───── Demo slide ───── */
  section.demo {
    background: linear-gradient(135deg, #0f2044, #1F3864);
    color: white;
  }
  section.demo h2 { color: white; border-color: #5599dd; }
  section.demo .step {
    background: rgba(255,255,255,0.1);
    border: 1px solid rgba(255,255,255,0.25);
    border-radius: 10px;
    padding: 8px 16px;
    margin: 6px 0;
    font-size: 20px;
  }
  section.demo .step .num {
    background: #2E75B6;
    color: white;
    border-radius: 50%;
    width: 26px; height: 26px;
    display: inline-flex;
    align-items: center; justify-content: center;
    font-weight: 700; font-size: 14px;
    margin-right: 10px;
  }

  /* ───── Thank-you slide ───── */
  section.thankyou {
    background: linear-gradient(135deg, #1F3864, #2E75B6);
    color: white;
    text-align: center;
    justify-content: center;
  }
  section.thankyou h2 { color: white; border: none; font-size: 42px; }
  section.thankyou .gh { font-size: 20px; opacity: 0.9; }

  /* ───── Script comments hidden ───── */
  /* script blocks are HTML comments — rendered as speaker notes */
---

<!-- _class: cover -->

<span class="app-icon">🕵️</span>

# Delay Detective

<p class="subtitle">AI-Powered Procrastination Analyzer</p>

<span class="tagline">📋 미루는 태스크를 감지 → AI 인터뷰 → 소태스크 재구성</span>

<p class="meta">혜지 | 2026.06 | Flutter + Firebase + Anthropic API</p>

<!--
[대사 — 20초]
안녕하세요. 저는 AI 기반 할 일 미루기 분석 앱 'Delay Detective'를 개발한 혜지입니다.
오늘 발표는 비전 제시부터 시연 데모, 기술 구조, 테스트까지 5분 안에 압축해서 말씀드리겠습니다.
-->

---

## 🎯 비전 & 문제 정의

<div class="two-col">

<div class="box-orange">

### 🔴 기존 할 일 앱의 한계

- 할 일 **추가** → 마감 알림 → **또 미룸** 🔄
- "왜 미루는지" 물어주는 앱 없음
- 태스크가 너무 크면 막막해서 회피

</div>

<div class="box-green">

### 🟢 Delay Detective 해결책

- 마감 초과 자동 감지 🔥
- **AI 인터뷰** (Claude) → 원인 파악
- 15분 단위 **소태스크 자동 재구성**
- 오프라인에서도 완전 동작

</div>

</div>

> **비전**: 미루는 사람이 스스로 원인을 파악하고, 다시 시작할 수 있도록 돕는다

**핵심 사용자 시나리오**
> "발표 준비를 계속 미루는데, AI가 '왜 미루고 있어요?'라고 물어본 뒤 '슬라이드 1장만 쓰기' 같은 소태스크로 나눠줬더니 시작할 수 있었다"

<!--
[대사 — 20초]
할 일을 미루는 건 의지력 문제가 아니라, 태스크가 너무 크거나 막막해서입니다.
기존 앱은 마감 알림만 줄 뿐, 왜 미루는지 알려주지 않습니다.
Delay Detective는 AI가 그 이유를 직접 물어보고, 해결 가능한 크기로 잘라줍니다.
저도 이 발표 준비를 계속 미루다가 이 앱을 만들게 됐습니다.
-->

---

<!-- _class: demo -->

## 🎬 시연 데모 — 사용자 시나리오 (30초)

<div style="display:grid; grid-template-columns:1fr 1fr; gap:20px; margin-top:10px;">
<div>

**[데모 영상 재생 — 30초]**

<div class="step"><span class="num">1</span> Google 로그인 → 메인 화면 진입</div>
<div class="step"><span class="num">2</span> 할일 추가 (발표 준비, 마감 오늘)</div>
<div class="step"><span class="num">3</span> 마감 초과 태스크 🔥 강조 확인</div>
<div class="step"><span class="num">4</span> AI 분석 시작 → Claude 인터뷰 3턴</div>
<div class="step"><span class="num">5</span> 소태스크 3개 자동 생성 결과</div>
<div class="step"><span class="num">6</span> 통계 탭 → 완료율 시각화</div>

</div>
<div style="text-align:center; padding:20px;">

📱 **바텀 네비게이션 4탭**

```
🏠 홈 캘린더
   날짜별 할일 칩 표시
   
📋 할일 목록
   진행중 / 완료 탭
   
🤖 AI 분석
   인터뷰 → 결과
   
📊 통계
   완료율 · 지연 현황
```

</div>
</div>

<!--
[대사 — 데모 중 해설]
보시는 것처럼 Google 로그인 후 할일을 추가하면 캘린더에 바로 표시됩니다.
마감이 지난 태스크는 불꽃 아이콘으로 강조되고, AI 분석을 시작하면 Claude가 왜 미루는지 질문합니다.
2~3턴의 대화 후 소태스크 3개가 자동 생성되고, 통계 탭에서 진행률을 확인할 수 있습니다.
-->

---

## 📅 프로젝트 계획 — WBS & 진행 현황

<style scoped>
table { font-size: 11px; border-collapse: collapse; width: 100%; margin-top:8px; }
th { background:#1F3864; color:white; text-align:center; padding:3px 5px; }
td { padding:2px 5px; border:1px solid #ccc; }
tr.sec td { background:#dce8ff; font-weight:700; }
tr.ms  td { background:#fff3cc; font-weight:700; }
.done { background:#70AD47; color:white; border-radius:8px; padding:1px 6px; font-size:10px; }
.mstag { background:#C00000; color:white; border-radius:8px; padding:1px 6px; font-size:10px; }
</style>

| WBS | 태스크 | 상태 | W10 05/11 | W11 05/18 | W12 06/01 | W13 06/08 | W14 06/15~21 |
|:---:|:---|:---:|:---:|:---:|:---:|:---:|:---:|
| **1** | **기획 & 설계** | <span class="done">완료</span> | ██ | · | · | · | · |
| 1.1 | 기획 문서 (비전·요구사항·WBS·ADR) | <span class="done">완료</span> | █ | · | · | · | · |
| 1.2 | 설계: AI·Firestore·Hive 흐름 정의 | <span class="done">완료</span> | █ | · | · | · | · |
| **M1** | **★ 기획·설계 완료** | <span class="mstag">마일스톤</span> | ◆ | · | · | · | · |
| **2** | **백엔드 레이어** | <span class="done">완료</span> | · | ███ | · | · | · |
| 2.1 | 데이터 모델 (Task·SubTask·DelayAnalysis) | <span class="done">완료</span> | · | █ | · | · | · |
| 2.2 | HiveService CRUD + FirestoreService | <span class="done">완료</span> | · | █ | · | · | · |
| 2.3 | SyncService — Last-Write-Wins 동기화 | <span class="done">완료</span> | · | █ | · | · | · |
| **3** | **AI 인터뷰 시스템** | <span class="done">완료</span> | · | · | ██ | · | · |
| 3.1 | Anthropic API + 프롬프트 템플릿 | <span class="done">완료</span> | · | · | █ | · | · |
| 3.2 | 인터뷰 3턴 플로우 → 소태스크 생성 | <span class="done">완료</span> | · | · | █ | · | · |
| **M3** | **★ AI 인터뷰 완료** | <span class="mstag">마일스톤</span> | · | · | ◆ | · | · |
| **4** | **UI + 통합** | <span class="done">완료</span> | · | · | · | ██ | · |
| 4.1 | 4탭 바텀 네비 · 캘린더 · 통계 화면 | <span class="done">완료</span> | · | · | · | █ | · |
| 4.2 | Google 로그인 · 로그아웃 · Auth 분기 | <span class="done">완료</span> | · | · | · | █ | · |
| **M4** | **★ UI 완료** | <span class="mstag">마일스톤</span> | · | · | · | ◆ | · |
| **5** | **배포 & 마무리** | <span class="done">완료</span> | · | · | · | · | ███ |
| 5.1 | APK·AAB·Web 빌드 + 릴리즈 서명 | <span class="done">완료</span> | · | · | · | · | █ |
| 5.2 | 테스트 (단위 11개 · Playwright E2E) | <span class="done">완료</span> | · | · | · | · | █ |
| 5.3 | 문서 완성 (README · docs · LLM Wiki) | <span class="done">완료</span> | · | · | · | · | █ |
| **M6** | **★ 최종 발표** | <span class="mstag">마일스톤</span> | · | · | · | · | ◆ |

<!--
[대사 — 20초]
6주 동안 기획·백엔드·AI·UI·배포 5단계를 모두 완료했습니다.
Must 기능 100%, Should 기능도 주요 항목은 구현했습니다.
-->

---

## 🛠️ 기술 스택

<div class="two-col">

<div>

| 계층 | 기술 | 선택 이유 |
|---|---|---|
| UI | **Flutter** (Dart) | 웹·Android 동시, 단일 코드 |
| 상태 관리 | **Provider** | 공식 권장, 낮은 학습곡선 |
| 로컬 DB | **Hive** | 오프라인 우선, 고속 I/O |
| 클라우드 | **Firestore** | 실시간 동기화, 서버리스 |
| 인증 | **Firebase Auth** | Google OAuth2, uid 격리 |
| AI | **Anthropic API** | 자연어 인터뷰·분석 |
| 테스트 | **Flutter Test + Playwright** | 단위·E2E |

</div>

<div>

**AI 에이전트 팀 구성**

| 에이전트 | 역할 |
|---|---|
| product-manager-prd | PRD·WBS·일정 |
| backend-architect | Firebase·Hive·동기화 |
| frontend-developer | Flutter UI |
| qa-engineer | Playwright E2E |
| ai-integration-specialist | 프롬프트 엔지니어링 |

> **MCP 3개**: Notion (분석 저장), GitHub (이슈 연동), Playwright (E2E 자동화)

</div>

</div>

<!--
[대사 — 20초]
기술 선택의 핵심은 '서버 없이 오프라인도 동작하는 앱'이었습니다.
Hive가 로컬, Firestore가 클라우드를 담당해 네트워크 없이도 완전히 동작합니다.
개발은 5개 서브에이전트 팀으로 나눠 각 전문 역할을 분담했습니다.
-->

---

## 🏗️ 앱 구조 — 4-레이어 아키텍처

<div class="two-col">

<div>

```
lib/
├── presentation/       ← 화면 9개 + 위젯
│   screens/
│     HomeScreen        캘린더 + 날짜 바텀시트
│     TaskListScreen    진행중 / 완료 탭
│     InterviewScreen   AI 인터뷰 채팅 UI
│     AnalysisResult    소태스크 결과
│     HistoryScreen     분석 이력
│     StatsScreen       완료율 통계
│     LoginScreen       Google 로그인
│
├── application/        ← Provider 상태 관리
│   TaskProvider / AuthProvider / SyncProvider
│
├── domain/             ← 순수 모델 (외부 의존 없음)
│   Task, SubTask, DelayAnalysis, TaskStatus
│
└── data/
    local/   HiveService   (오프라인 CRUD)
    remote/  FirestoreService, AuthService, AIService
    sync/    SyncService   (sync_queue 패턴)
```

</div>

<div>

**의존성 방향**

```
Presentation
    ↓
Application (Provider)
    ↓
Domain  ←  Data
```

<div class="box" style="margin-top:14px;">

**아키텍처 핵심 원칙**

- Domain은 외부에 의존하지 않음
- 오프라인 우선 (Hive → Firestore)
- `ChangeNotifierProxyProvider`로 uid 변경 시 자동 재생성
- ADR-0001: Flutter 선택 이유 문서화

</div>

</div>

</div>

<!--
[대사 — 25초]
클린 아키텍처의 4-레이어를 적용했습니다.
가장 중요한 원칙은 Domain 레이어가 외부 라이브러리에 전혀 의존하지 않는다는 것입니다.
Presentation은 Provider를 통해 상태를 받고, Data 레이어가 로컬과 클라우드 모두를 처리합니다.
이 결정은 ADR-0001에 기록했습니다.
-->

---

## 🔄 구현 방법 — 오프라인-온라인 동기화

<div class="two-col">

<div>

**동기화 흐름**

```
[오프라인]
사용자 조작
  → Hive 즉시 저장
  → sync_queue에 taskId 추가

[네트워크 복구]
SyncService.flushQueue() 실행
  → Hive.updatedAt vs Firestore.updatedAt
  → Last-Write-Wins (더 최신 선택)
  → 동기화 완료 배너 표시
```

**웹 / 모바일 Google 로그인 분기**

```dart
if (kIsWeb) {
  // 웹: signInWithPopup
  //     (idToken 미지원 이슈 우회)
} else {
  // 모바일: google_sign_in 패키지
  //         네이티브 계정 선택
}
```

</div>

<div>

**Conflict Resolution — ADR-0003**

```dart
if (local.updatedAt > remote.updatedAt) {
  // 로컬이 최신 → Firestore 업로드
  await firestore.set(local.toMap());
} else {
  // 서버가 최신 → Hive 업데이트
  await hive.put(local.id, remote);
}
```

<div class="box-green" style="margin-top:14px;">

**Hive settings 박스**로 offline UID 영속화
→ 앱 재시작 시 UID 재생성 문제 해결

`connectivity_plus`로 온/오프라인 상태 실시간 감지

</div>

</div>

</div>

<!--
[대사 — 25초]
가장 복잡했던 부분이 오프라인-온라인 동기화입니다.
오프라인에서 변경한 내용은 sync_queue에 쌓아두고, 네트워크 복구 시 타임스탬프를 비교해 더 최신 데이터를 선택합니다.
웹과 모바일의 Google 로그인 방식이 달라서 kIsWeb으로 분기해야 했던 것이 가장 배움이 컸습니다.
-->

---

## ⚙️ 개발 환경 설정 & 빌드/배포

<div class="two-col">

<div>

**개발 환경**

| 항목 | 내용 |
|---|---|
| Flutter | 3.x (Dart 3.x) |
| IDE | VS Code + Claude Code |
| Firebase | CLI + flutterfire_cli |
| 테스트 기기 | Galaxy S25 (Android 16) |

**GitHub 설치 가이드** (`docs/setup.md`)

```bash
git clone https://github.com/hyeji203/delay-detective
flutter pub get
flutterfire configure   # Firebase 연결
# 웹 실행 (OAuth 포트 5000 고정)
flutter run -d chrome --web-port 5000
```

</div>

<div>

**빌드 & 배포 3단계**

```bash
# 1. 개발
flutter run --debug

# 2. 릴리즈 빌드
flutter build apk --release        # 49.9 MB
flutter build appbundle --release  # 43 MB (Play Store)
flutter build web --release        # Firebase Hosting

# 3. 웹 배포
firebase deploy --only hosting
```

<div class="box" style="margin-top:12px;">

✅ APK + AAB 빌드 완료 (릴리즈 서명 키 설정)
✅ Firebase Hosting 배포 완료
✅ `keystore`, `.env` → `.gitignore`

</div>

</div>

</div>

<!--
[대사 — 20초]
빌드는 debug, release, profile 세 종류입니다.
릴리즈 빌드는 서명 키를 설정하고 appbundle로 Play Console에 업로드합니다.
웹은 Flutter Web으로 빌드 후 Firebase Hosting에 배포했습니다.
설치 방법은 setup.md에 명령어 그대로 따라할 수 있게 정리했습니다.
-->

---

## 🐛 구현 시행착오 & 성능 최적화

<div class="two-col">

<div>

**시행착오 5가지**

| 문제 | 해결 |
|---|---|
| Firestore 중복 데이터 | Hive settings 박스로 UID 영속화 |
| `400: origin_mismatch` | `--web-port 5000` 고정 + OAuth 등록 |
| 웹 로그인 후 화면 미전환 | `signInWithPopup()` 전환 |
| Android 로그인 실패 | SHA-1 지문 Firebase 등록 |
| 로그아웃 후 Splash 멈춤 | signOut() 전 즉시 `notifyListeners()` |

</div>

<div>

**성능 최적화 노력**

<div class="box-green">

**캘린더 렌더링 최적화**
- `LayoutBuilder`로 rowHeight 동적 계산
- `IndexedStack`으로 탭 전환 시 상태 유지
- 날짜 계산: `DateTime(y,m,d)` 비교 (ms 오차 제거)

</div>

<div class="box" style="margin-top:10px;">

**AI 응답 성능**
- Anthropic API `stream: true`로 실시간 타이핑 효과
- 인터뷰 2~3턴으로 최소화 (UX 최적화)
- JSON 파싱 실패 시 fallback 소태스크 제공

</div>

</div>

</div>

<!--
[대사 — 25초]
5가지 버그를 실제로 겪고 해결했습니다.
가장 어려웠던 건 웹과 Android의 Google 로그인 방식 차이였습니다.
성능 면에서는 캘린더 렌더링에 LayoutBuilder를 써서 화면 크기에 맞게 동적 계산하고,
AI 응답은 스트리밍으로 받아 실시간 타이핑 효과를 구현했습니다.
-->

---

## ✅ 코드 품질 관리 & 테스트 결과

<div class="two-col">

<div>

**단위 테스트 — `flutter test` → 11개 전체 통과**

```
test/unit/
  task_model_test.dart
    ✓ shouldBeDelayed: 마감 초과 시 true
    ✓ shouldBeDelayed: 완료 시 false
    ✓ shouldBeDelayed: 미래 마감 false
    ✓ shouldBeDelayed: 당일 마감 true
    ✓ Task.toMap / fromMap 직렬화 왕복
    ✓ Conflict Resolution — local newer
    ✓ Conflict Resolution — remote newer
    ... (11개 전체)
```

**E2E 테스트 — Playwright MCP**

```typescript
e2e/
  login.spec.ts        로그인 화면·버튼 렌더링
  navigation.spec.ts   비인증 리다이렉트 확인
  task.spec.ts         할일 CRUD 플로우
```

</div>

<div>

**코드 품질 관리**

<div class="box-green">

**4-레이어 아키텍처로 관심사 분리**
→ 각 레이어 독립 테스트 가능

</div>

<div class="box" style="margin-top:10px;">

**보안 체크리스트**
- `google-services.json` → `.gitignore` ✅
- `keystore.jks` + `key.properties` → `.gitignore` ✅
- Anthropic API 키 → `.env` (미커밋) ✅
- Firestore Security Rules: uid 기반 격리 ✅

</div>

<div class="box" style="margin-top:10px;">

**ADR 문서화 (결정 이유 기록)**
- ADR-0001: Flutter 선택 (vs Native)
- ADR-0002: Provider (vs Redux)
- ADR-0003: Firebase+Hive (vs 자체 서버)

</div>

</div>

</div>

<!--
[대사 — 20초]
단위 테스트 11개를 모두 통과했습니다.
특히 Conflict Resolution, 직렬화 왕복, 마감 계산 4케이스를 꼼꼼히 커버했습니다.
E2E 테스트는 Playwright MCP로 로그인·네비게이션·태스크 CRUD 흐름을 자동화했습니다.
모든 보안 키는 .gitignore로 커밋을 차단했습니다.
-->

---

## 📋 ADR 요약 — Q&A 준비

| ADR | 결정 | 핵심 이유 | 기록 |
|---|---|---|---|
| **ADR-0001** | Flutter 선택 | 웹+Android 동시 지원, 단일 코드베이스 | `.planning/adr/` |
| **ADR-0002** | Provider 선택 | Flutter 공식 권장, 낮은 학습곡선 | `.planning/adr/` |
| **ADR-0003** | Firebase+Hive | 서버 없이 오프라인-온라인 동기화 구현 | `.planning/adr/` |

**예상 Q&A**

> **Q: 왜 Supabase 대신 Firebase를 선택했나요?**  
> A: Flutter 공식 패키지 성숙도, 무료 플랜, 국내 레퍼런스 다양함 — ADR-0003에 기록

> **Q: Redux 대신 Provider를 쓴 이유는?**  
> A: 이 앱 규모에서 Redux는 과도한 보일러플레이트. Provider가 Flutter 공식 권장 — ADR-0002

> **Q: 오프라인과 온라인 충돌이 나면?**  
> A: updatedAt 타임스탬프 비교 → Last-Write-Wins. 동일 시각이면 서버 우선 — ADR-0003

<!--
[대사 — 15초]
기술 결정은 모두 ADR 문서로 남겼습니다.
왜 이 기술을 선택했는지 Q&A 질문이 오면 ADR 번호로 바로 답변할 수 있습니다.
-->

---

## 🚀 활용 방안 & 향후 발전 방향

<div class="two-col">

<div>

**현재 활용 가능**

<div class="box-green">

- ✅ 개인 할일 관리 + AI 미루기 분석
- ✅ 오프라인에서도 완전 동작
- ✅ 웹(Chrome) + Android 멀티플랫폼
- ✅ Google 계정 로그인, 멀티 디바이스 동기화

</div>

**GitHub 설치 가이드**

```
github.com/hyeji203/delay-detective
→ README.md → docs/setup.md
  flutter pub get
  flutter run -d chrome --web-port 5000
```

잔디 GitHub: **https://num.slogs.dev**

</div>

<div>

**향후 발전 방향**

<div class="box">

| 우선순위 | 기능 |
|---|---|
| 🔴 높음 | FCM 푸시 알림 (마감 D-1) |
| 🔴 높음 | iOS TestFlight 배포 |
| 🟡 중간 | 미루기 패턴 장기 통계 |
| 🟡 중간 | Notion·GitHub 소태스크 자동 연동 |
| 🟢 낮음 | AI 인사이트 대시보드 |

</div>

<div class="box-orange" style="margin-top:12px;">

**기술 자산화**
AUTHORING.hyeji.md 한 파일로 5개 에이전트 부트스트랩
→ 다음 프로젝트에 템플릿 재사용 가능

LLM Wiki `notes/` 5개 파일 → 협업·동기화 경험 축적

</div>

</div>

</div>

<!--
[대사 — 20초]
이 앱은 지금 당장 웹과 Android에서 사용할 수 있습니다.
향후에는 FCM 푸시 알림과 iOS 지원을 가장 먼저 추가하고 싶습니다.
그리고 이 프로젝트에서 만든 AUTHORING.hyeji.md 템플릿과 LLM Wiki는 다음 프로젝트에서도 그대로 활용할 수 있는 자산이 됐습니다.
-->

---

<!-- _class: thankyou -->

## 감사합니다 🙏

<br>

**Delay Detective**
> "AI가 물어봐주면, 미루기가 시작된다"

<br>

<p class="gh">📦 GitHub: <strong>https://github.com/hyeji203/delay-detective</strong></p>
<p class="gh">🌿 잔디 확인: <strong>https://num.slogs.dev</strong></p>
<p class="gh">📄 발표자료: <code>docs/slides-final.md</code> · 설계서: <code>AUTHORING.hyeji.md</code></p>

<br>

**Q & A**

<!--
[대사 — 10초]
이상으로 Delay Detective 발표를 마칩니다. 감사합니다.
Q&A는 ADR 3개와 백업 슬라이드를 참고해서 답변하겠습니다.
-->

---

# 백업 슬라이드

---

## B1. Firestore 데이터 구조

```
users/{uid}/tasks/{taskId}
  - id, title, description
  - dueDate (ISO 8601), isCompleted, isDelayed
  - delayReason, delayCategory (복잡함/두려움/우선순위/환경)
  - createdAt, updatedAt   ← 동기화 타임스탬프 (Last-Write-Wins 기준)
  - subTasks: [{id, title, isCompleted}]

users/{uid}/sync_queue/{taskId}
  - taskId, action (upsert | delete), timestamp
```

---

## B2. AI 인터뷰 흐름 (Anthropic API)

```
System Prompt:
  "당신은 공감적인 미루기 코치입니다. 2~3 턴 내에:
   1) 왜 미루는지 원인을 파악하고
   2) 15분 안에 할 수 있는 소태스크 3개를 JSON으로 제시하세요."

1턴: "이 태스크를 미룬 이유가 뭔가요?" (개방형)
2턴: 원인 유형 확인 (복잡함/두려움/우선순위/환경 분류)
3턴: "15분 안에 할 수 있는 첫 번째 단계는?" → SubTask 추출

→ API stream=true 로 실시간 타이핑 효과
→ JSON 파싱 실패 시 fallback 소태스크 3개 자동 제공
```

---

## B3. 가산점 신청 요약

| 항목 | 증빙 | 점수 |
|---|---|---|
| ✅ AI Agent 워크플로우 | `.claude/agents/` 5개 파일 + MCP 3개 | +1 |
| ✅ 나만의 기법 | `AUTHORING.hyeji.md` 단일파일 부트스트랩 | +2 |
| ✅ LLM Wiki | `notes/` 5개 파일 (실제 경험 기반) | +1 |
| ✅ AI Agent 리포트 발표 | 이 슬라이드 전체 | +2 |
| **합계** | | **+6** |

---

## B4. 보안 & 테스트 체크리스트

```bash
# 단위 테스트 (11개)
flutter test test/unit/

# E2E (Playwright MCP)
npx playwright test e2e/login.spec.ts
npx playwright test e2e/navigation.spec.ts
npx playwright test e2e/task.spec.ts

# 보안
.gitignore: google-services.json, GoogleService-Info.plist,
            keystore.jks, key.properties, .env
Firestore Rules: uid 기반 사용자 격리
HTTPS 강제 (Firebase Hosting 기본)
```
