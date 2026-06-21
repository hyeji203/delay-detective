---
marp: true
theme: default
paginate: true
size: 16:9
header: "Delay Detective — 최종 발표"
footer: "혜지 | 2026.06"
style: |
  /* ── 기본 ── */
  section {
    font-family: 'Apple SD Gothic Neo', '맑은 고딕', 'Noto Sans KR', sans-serif;
    font-size: 23px;
    padding: 40px 52px;
    color: #1a1a2e;
    background: #f4f7fe;
  }
  header {
    color: #7a8fb5;
    font-size: 14px;
    top: 18px;
  }
  footer {
    color: #7a8fb5;
    font-size: 14px;
    bottom: 18px;
  }
  section::after {
    font-size: 14px;
    color: #7a8fb5;
  }

  /* ── 커버 ── */
  section.cover {
    background: linear-gradient(140deg, #0b1d3e 0%, #1a3a6b 50%, #2563b0 100%) !important;
    color: #fff !important;
    text-align: center;
    justify-content: center;
    padding: 0;
  }
  section.cover header,
  section.cover footer,
  section.cover::after { display: none; }
  section.cover h1 {
    font-size: 64px;
    font-weight: 800;
    color: #fff !important;
    margin: 12px 0 6px;
    letter-spacing: -1px;
    text-shadow: 0 2px 12px rgba(0,0,0,0.3);
  }
  section.cover h3 {
    color: rgba(255,255,255,0.75) !important;
    font-size: 22px;
    font-weight: 300;
    margin: 0 0 28px;
  }
  section.cover p {
    color: rgba(255,255,255,0.7) !important;
    font-size: 16px;
    margin: 6px 0;
  }
  section.cover blockquote {
    background: rgba(255,255,255,0.12);
    border-left: none;
    border-radius: 30px;
    padding: 10px 32px;
    font-size: 19px;
    color: rgba(255,255,255,0.9) !important;
    display: inline-block;
    margin: 0 auto 24px;
  }

  /* ── 헤딩 ── */
  h2 {
    color: #1a3a6b;
    font-size: 28px;
    border-bottom: 3px solid #2563b0;
    padding-bottom: 8px;
    margin-bottom: 18px;
  }
  h3 {
    color: #2563b0;
    font-size: 18px;
    margin: 10px 0 6px;
  }

  /* ── 테이블 ── */
  table {
    font-size: 18px;
    width: 100%;
    border-collapse: collapse;
    background: white;
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 1px 6px rgba(0,0,0,0.08);
  }
  th {
    background: #1a3a6b;
    color: white;
    padding: 8px 12px;
    font-weight: 600;
  }
  td {
    padding: 6px 12px;
    border-bottom: 1px solid #e4eaf8;
  }
  tr:last-child td { border-bottom: none; }
  tr:nth-child(even) td { background: #f8faff; }

  /* ── 코드 ── */
  code {
    background: #dde8ff;
    color: #1a3a6b;
    padding: 1px 7px;
    border-radius: 4px;
    font-size: 18px;
  }
  pre {
    background: #0d1b3e;
    color: #c8d8ff;
    padding: 14px 18px;
    border-radius: 10px;
    font-size: 15.5px;
    line-height: 1.65;
    border-left: 4px solid #3b82f6;
    box-shadow: 0 2px 12px rgba(0,0,0,0.18);
  }
  pre code {
    background: transparent;
    color: inherit;
    padding: 0;
    font-size: inherit;
  }

  /* ── 인용 ── */
  blockquote {
    border-left: 4px solid #3b82f6;
    background: #e8f0ff;
    padding: 10px 18px;
    margin: 12px 0;
    border-radius: 0 8px 8px 0;
    font-size: 19px;
    color: #1a3a6b;
  }

  /* ── 카드 박스 ── */
  .card {
    background: white;
    border-radius: 12px;
    padding: 16px 20px;
    box-shadow: 0 2px 10px rgba(37,99,176,0.10);
    border: 1px solid #dde8ff;
  }
  .card-green {
    background: #f0faf4;
    border-radius: 12px;
    padding: 14px 18px;
    border: 1.5px solid #4ade80;
    box-shadow: 0 2px 8px rgba(74,222,128,0.10);
  }
  .card-orange {
    background: #fff8f0;
    border-radius: 12px;
    padding: 14px 18px;
    border: 1.5px solid #fb923c;
    box-shadow: 0 2px 8px rgba(251,146,60,0.10);
  }
  .card-dark {
    background: #0d1b3e;
    color: #c8d8ff;
    border-radius: 12px;
    padding: 14px 18px;
    border: 1.5px solid #2563b0;
  }
  .card-dark h3 { color: #7eb8ff !important; }

  /* ── 2열 레이아웃 ── */
  .cols {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 22px;
    margin-top: 6px;
  }
  .cols3 {
    display: grid;
    grid-template-columns: 1fr 1fr 1fr;
    gap: 16px;
  }

  /* ── 칩 ── */
  .tag {
    display: inline-block;
    padding: 2px 10px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 700;
  }
  .tag-done  { background: #22c55e; color: white; }
  .tag-ms    { background: #ef4444; color: white; }
  .tag-warn  { background: #f97316; color: white; }

  /* ── 데모 슬라이드 ── */
  section.demo {
    background: linear-gradient(140deg, #0b1d3e, #1a3a6b) !important;
    color: #e8f0ff !important;
  }
  section.demo h2 { color: #7eb8ff !important; border-color: #3b82f6; }
  section.demo h3 { color: #a5c8ff !important; }
  section.demo blockquote {
    background: rgba(255,255,255,0.08);
    border-left-color: #3b82f6;
    color: #c8d8ff;
  }
  .step {
    background: rgba(255,255,255,0.08);
    border: 1px solid rgba(255,255,255,0.15);
    border-radius: 8px;
    padding: 7px 16px;
    margin: 5px 0;
    font-size: 19px;
    color: #e8f0ff;
  }
  .step b { color: #7eb8ff; }

  /* ── 마지막 슬라이드 ── */
  section.ending {
    background: linear-gradient(140deg, #0b1d3e 0%, #1a3a6b 50%, #2563b0 100%) !important;
    color: #fff !important;
    text-align: center;
    justify-content: center;
  }
  section.ending header,
  section.ending footer,
  section.ending::after { display: none; }
  section.ending h2 {
    color: #fff !important;
    border: none;
    font-size: 44px;
    margin-bottom: 20px;
  }
  section.ending p { color: rgba(255,255,255,0.85) !important; font-size: 20px; }
  section.ending a { color: #93c5fd; }
  section.ending blockquote {
    background: rgba(255,255,255,0.10);
    border: none;
    border-radius: 16px;
    color: rgba(255,255,255,0.9) !important;
    font-size: 22px;
    padding: 14px 36px;
    display: inline-block;
  }
---

<!-- _class: cover -->

# 🕵️ Delay Detective

### AI-Powered Procrastination Analyzer

> 📋 미루는 태스크 감지 → AI 인터뷰 → 소태스크 재구성

혜지 | 2026.06 | Flutter · Firebase · Anthropic API

<!--
[대사 — 20초]
안녕하세요. 저는 AI 기반 할 일 미루기 분석 앱 'Delay Detective'를 개발한 혜지입니다.
오늘 발표는 비전 제시부터 시연 데모, 기술 구조, 테스트까지 5분 안에 압축해서 말씀드리겠습니다.
-->

---

## 🎯 비전 & 문제 정의

<div class="cols">

<div class="card-orange">

### 🔴 기존 할 일 앱의 한계

- 할일 추가 → 마감 알림 → **또 미룸** 🔄
- **"왜 미루는지"** 물어주는 앱이 없다
- 태스크가 크면 막막해서 회피

</div>

<div class="card-green">

### 🟢 Delay Detective 해결책

- 마감 초과 자동 감지 🔥
- **Claude AI 인터뷰** → 원인 파악
- 15분 단위 **소태스크 자동 재구성**
- 오프라인에서도 완전 동작

</div>

</div>

> **비전**: 미루는 사람이 스스로 원인을 파악하고, 다시 시작할 수 있도록 돕는다

**핵심 사용자 시나리오**

> 발표 준비를 계속 미루던 사용자 → AI가 "왜 미루고 있어요?" 물음  
> → "슬라이드 1장만 쓰기" 소태스크 제시 → **시작할 수 있었다**

<!--
[대사 — 20초]
할 일을 미루는 건 의지력 문제가 아니라, 태스크가 너무 크거나 막막해서입니다.
기존 앱은 마감 알림만 줄 뿐, 왜 미루는지 알려주지 않습니다.
Delay Detective는 AI가 그 이유를 직접 물어보고, 해결 가능한 크기로 잘라줍니다.
-->

---

<!-- _class: demo -->

## 🎬 시연 데모 — 사용자 시나리오 (30초)

<div class="cols">
<div>

**[데모 영상 — 30초]**

<div class="step"><b>1</b> Google 로그인 → 메인 홈 캘린더</div>
<div class="step"><b>2</b> 할일 추가 (발표 준비, 마감 오늘)</div>
<div class="step"><b>3</b> 마감 초과 태스크 🔥 강조 확인</div>
<div class="step"><b>4</b> AI 분석 시작 → Claude 인터뷰 3턴</div>
<div class="step"><b>5</b> 소태스크 3개 자동 생성 결과 확인</div>
<div class="step"><b>6</b> 📊 통계 탭 → 완료율 시각화</div>

</div>
<div>

**바텀 네비게이션 4탭**

<div class="card-dark">

```
🏠  홈 캘린더
    날짜별 할일 칩 · 바텀시트

📋  할일 목록
    진행중 / 완료 탭 분리

🤖  AI 분석
    인터뷰 채팅 → 소태스크 결과

📊  통계
    완료율 · 지연 현황 차트
```

</div>

</div>
</div>

<!--
[대사 — 데모 중]
보시는 것처럼 Google 로그인 후 캘린더에 할일이 바로 표시됩니다.
마감이 지난 태스크는 불꽃 아이콘으로 강조되고, AI 분석을 시작하면 Claude가 왜 미루는지 질문합니다.
2~3턴 대화 후 소태스크 3개가 자동 생성되고, 통계 탭에서 진행률을 확인할 수 있습니다.
-->

---

## 📅 프로젝트 계획 — WBS & 진행 현황

<style scoped>
table { font-size: 11px; border-collapse: collapse; width: 100%; margin-top: 8px; }
th { background: #1a3a6b; color: white; text-align: center; padding: 3px 5px; font-size: 11px; }
td { padding: 2px 5px; border: 1px solid #c8d8f5; font-size: 11px; }
tr.sec td { background: #dce8ff; font-weight: 700; }
tr.ms  td { background: #fff3cc; font-weight: 700; }
.done { background: #22c55e; color: white; border-radius: 8px; padding: 1px 6px; font-size: 10px; }
.mstag { background: #ef4444; color: white; border-radius: 8px; padding: 1px 6px; font-size: 10px; }
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
| 4.1 | 4탭 바텀 네비 · 캘린더 · 통계 | <span class="done">완료</span> | · | · | · | █ | · |
| 4.2 | Google 로그인 · Auth 분기 · 로그아웃 | <span class="done">완료</span> | · | · | · | █ | · |
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

## 🛠️ 기술 스택 & AI 에이전트 팀

<div class="cols">
<div>

| 계층 | 기술 | 선택 이유 |
|---|---|---|
| UI | **Flutter** | 웹+Android, 단일 코드 |
| 상태 관리 | **Provider** | 공식 권장, 낮은 학습곡선 |
| 로컬 DB | **Hive** | 오프라인 우선, 고속 I/O |
| 클라우드 | **Firestore** | 실시간 동기화, 서버리스 |
| 인증 | **Firebase Auth** | Google OAuth2, uid 격리 |
| AI | **Anthropic API** | 자연어 인터뷰 & 분석 |
| 테스트 | **Flutter + Playwright** | 단위·E2E |

</div>
<div>

<div class="card">

**AI 에이전트 팀 (서브에이전트 5종)**

| 에이전트 | 역할 |
|---|---|
| product-manager-prd | PRD · WBS · 일정 |
| backend-architect | Firebase · Hive · 동기화 |
| frontend-developer | Flutter UI |
| qa-engineer | Playwright E2E |
| ai-integration-specialist | 프롬프트 엔지니어링 |

</div>

> **MCP 3개**: Notion (분석 저장) · GitHub (이슈) · Playwright (E2E)

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

<div class="cols">
<div>

```
lib/
├── presentation/        ← 화면 9개 + 위젯
│   ├── HomeScreen       캘린더 + 날짜 바텀시트
│   ├── TaskListScreen   진행중 / 완료 탭
│   ├── InterviewScreen  AI 채팅 UI
│   ├── AnalysisResult   소태스크 결과
│   ├── HistoryScreen    분석 이력
│   ├── StatsScreen      완료율 통계
│   └── LoginScreen      Google 로그인
│
├── application/         ← Provider 상태 관리
│   TaskProvider / AuthProvider / SyncProvider
│
├── domain/              ← 순수 모델 (외부 의존 없음)
│   Task, SubTask, DelayAnalysis, TaskStatus
│
└── data/
    ├── local/   HiveService   (오프라인 CRUD)
    ├── remote/  FirestoreService · AIService
    └── sync/    SyncService   (sync_queue)
```

</div>
<div>

**의존성 방향 (단방향)**

<div class="card" style="text-align:center; font-size:20px; padding:20px;">

🖥️ **Presentation**
↓
⚙️ **Application** (Provider)
↓
📦 **Domain** ← 🗄️ **Data**

</div>

<div class="card" style="margin-top:14px;">

**핵심 원칙**
- Domain은 외부 라이브러리에 의존 없음
- 오프라인 우선 (Hive → Firestore)
- `ChangeNotifierProxyProvider`로 uid 변경 시 자동 재생성
- ADR-0001에 Flutter 선택 이유 기록

</div>

</div>
</div>

<!--
[대사 — 25초]
클린 아키텍처의 4-레이어를 적용했습니다.
Domain 레이어는 외부 라이브러리에 전혀 의존하지 않고,
Presentation은 Provider를 통해 상태를 받습니다.
이 결정은 ADR-0001에 기록됐습니다.
-->

---

## 🔄 구현 방법 — 오프라인-온라인 동기화

<div class="cols">
<div>

**동기화 플로우**

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
  // signInWithPopup  ← idToken 미지원 우회
} else {
  // google_sign_in  ← 네이티브 계정 선택
}
```

</div>
<div>

**Conflict Resolution (ADR-0003)**

```dart
if (local.updatedAt > remote.updatedAt) {
  // 로컬이 최신 → Firestore 업로드
  await firestore.set(local.toMap());
} else {
  // 서버가 최신 → Hive 업데이트
  await hive.put(local.id, remote);
}
```

<div class="card-green" style="margin-top:14px;">

✅ **Hive settings 박스**로 offline UID 영속화
→ 앱 재시작 시 UID 재생성 버그 해결

✅ `connectivity_plus`로 온·오프라인 실시간 감지

</div>

</div>
</div>

<!--
[대사 — 25초]
가장 복잡했던 부분이 오프라인-온라인 동기화입니다.
오프라인 변경 내용은 sync_queue에 쌓아두고, 네트워크 복구 시 타임스탬프를 비교해 더 최신 데이터를 선택합니다.
웹과 모바일의 Google 로그인 방식 차이로 kIsWeb 분기를 직접 작성해야 했습니다.
-->

---

## ⚙️ 개발 환경 & 빌드/배포 & GitHub 설치 가이드

<div class="cols">
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
flutterfire configure     # Firebase 연결
# 웹 실행 (OAuth 포트 고정)
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

<div class="card-green" style="margin-top:12px;">

✅ APK + AAB 빌드 완료 (릴리즈 서명 키)
✅ Firebase Hosting 배포 완료
✅ `keystore`, `.env` → `.gitignore`

</div>

</div>
</div>

<!--
[대사 — 20초]
빌드는 debug, release, profile 세 종류입니다.
릴리즈 빌드는 서명 키 설정 후 appbundle로 Play Console에 업로드합니다.
설치 방법은 setup.md에 명령어 그대로 정리했습니다.
-->

---

## 🐛 구현 시행착오 & 성능 최적화

<div class="cols">
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

**성능 최적화**

<div class="card-green">

**캘린더 렌더링**
- `LayoutBuilder`로 rowHeight 동적 계산
- `IndexedStack`으로 탭 전환 시 상태 유지
- `DateTime(y,m,d)` 비교로 날짜 오차 제거

</div>

<div class="card" style="margin-top:10px;">

**AI 응답 최적화**
- Anthropic API `stream: true` → 실시간 타이핑 효과
- 인터뷰 2~3턴 최소화 (UX 최적화)
- JSON 파싱 실패 시 fallback 소태스크 자동 제공

</div>

</div>
</div>

<!--
[대사 — 25초]
5가지 버그를 직접 겪고 해결했습니다.
가장 어려웠던 건 웹과 Android의 Google 로그인 방식 차이였고,
성능 면에서는 캘린더에 LayoutBuilder를 써서 화면 크기에 맞게 동적 계산했습니다.
AI 응답은 스트리밍으로 받아 실시간 타이핑 효과를 구현했습니다.
-->

---

## ✅ 코드 품질 & 테스트 결과

<div class="cols">
<div>

**단위 테스트 — `flutter test` → 11개 전체 통과**

```
test/unit/task_model_test.dart
  ✅ shouldBeDelayed: 마감 초과 → true
  ✅ shouldBeDelayed: 완료 시 → false
  ✅ shouldBeDelayed: 미래 마감 → false
  ✅ shouldBeDelayed: 당일 마감 → true
  ✅ Task.toMap / fromMap 직렬화 왕복
  ✅ Conflict Resolution — local newer
  ✅ Conflict Resolution — remote newer
  ✅ ... (11개 전체 PASS)
```

**E2E — Playwright MCP**

```
e2e/login.spec.ts       로그인 화면·버튼 렌더링
e2e/navigation.spec.ts  비인증 리다이렉트
e2e/task.spec.ts        할일 CRUD 플로우
```

</div>
<div>

**코드 품질 관리**

<div class="card-green">

**4-레이어 아키텍처**로 관심사 분리
→ 각 레이어 독립 테스트 가능

</div>

<div class="card" style="margin-top:10px;">

**보안 체크리스트**
- `google-services.json` → `.gitignore` ✅
- `keystore.jks` + `key.properties` → `.gitignore` ✅
- Anthropic API 키 → `.env` (미커밋) ✅
- Firestore Security Rules: uid 기반 격리 ✅

</div>

<div class="card" style="margin-top:10px;">

**ADR 문서화** (결정 이유 기록)
- ADR-0001: Flutter 선택 (vs Native)
- ADR-0002: Provider (vs Redux)
- ADR-0003: Firebase+Hive (vs 자체 서버)

</div>

</div>
</div>

<!--
[대사 — 20초]
단위 테스트 11개 모두 통과했습니다.
Conflict Resolution, 직렬화 왕복, 마감 계산 4케이스를 커버했고,
E2E는 Playwright MCP로 로그인·네비게이션·CRUD 흐름을 자동화했습니다.
-->

---

## 📋 ADR 요약 — Q&A 준비

| ADR | 결정 | 핵심 이유 |
|---|---|---|
| **ADR-0001** | Flutter 선택 | 웹+Android 동시 지원, 단일 코드베이스 |
| **ADR-0002** | Provider 선택 | Flutter 공식 권장, 이 앱 규모엔 Redux 과도 |
| **ADR-0003** | Firebase+Hive | 서버 없이 오프라인-온라인 동기화 구현 |

**예상 Q&A**

> **Q. 왜 Supabase 대신 Firebase?**  
> Flutter 공식 패키지 성숙도, 무료 플랜, 국내 레퍼런스 다양 — ADR-0003

> **Q. Redux 대신 Provider를 쓴 이유?**  
> 이 앱 규모에서 Redux는 보일러플레이트 과다. Provider가 공식 권장 — ADR-0002

> **Q. 오프라인·온라인 충돌이 나면?**  
> `updatedAt` 타임스탬프 비교 → Last-Write-Wins. 동일 시각이면 서버 우선 — ADR-0003

<!--
[대사 — 15초]
기술 결정은 모두 ADR 문서로 남겼습니다.
Q&A 질문이 오면 ADR 번호로 바로 답변할 수 있습니다.
-->

---

## 🚀 활용 방안 & 향후 발전 방향

<div class="cols">
<div>

**현재 활용 가능**

<div class="card-green">

✅ 개인 할일 관리 + AI 미루기 분석
✅ 오프라인에서도 완전 동작
✅ 웹(Chrome) + Android 멀티플랫폼
✅ Google 계정 로그인 · 멀티 디바이스 동기화

</div>

**GitHub**

```
github.com/hyeji203/delay-detective
잔디 확인 → https://num.slogs.dev
```

**기술 자산화**

> AUTHORING.hyeji.md 한 파일로 5개 에이전트 부트스트랩  
> → 다음 프로젝트 템플릿으로 재사용  
> LLM Wiki `notes/` 5개 파일 축적

</div>
<div>

**향후 발전 방향**

| 우선순위 | 기능 |
|---|---|
| 🔴 높음 | FCM 푸시 알림 (마감 D-1) |
| 🔴 높음 | iOS TestFlight 배포 |
| 🟡 중간 | 미루기 패턴 장기 통계 |
| 🟡 중간 | Notion·GitHub 소태스크 자동 연동 |
| 🟢 낮음 | AI 인사이트 대시보드 |

<div class="card" style="margin-top:14px;">

**가산점 요약**

| 항목 | 증빙 | 점수 |
|---|---|---|
| AI Agent 워크플로우 | `.claude/agents/` 5종 | +1 |
| 나만의 기법 | `AUTHORING.hyeji.md` | +2 |
| LLM Wiki | `notes/` 5개 파일 | +1 |

</div>

</div>
</div>

<!--
[대사 — 20초]
이 앱은 지금 바로 웹과 Android에서 사용할 수 있습니다.
향후에는 FCM 푸시 알림과 iOS 지원을 먼저 추가하고 싶습니다.
AUTHORING.hyeji.md 템플릿과 LLM Wiki는 다음 프로젝트의 자산이 됐습니다.
-->

---

<!-- _class: ending -->

## 감사합니다 🙏

> "AI가 물어봐주면, 미루기가 시작된다"

📦 **GitHub**: github.com/hyeji203/delay-detective

🌿 **잔디**: https://num.slogs.dev

**Q & A**

<!--
[대사 — 10초]
이상으로 Delay Detective 최종 발표를 마칩니다. 감사합니다.
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

## B2. AI 인터뷰 흐름

```
System Prompt:
  "공감적인 미루기 코치. 2~3턴 내에 원인 파악 후 소태스크 3개를 JSON으로."

1턴: "이 태스크를 미룬 이유가 뭔가요?" (개방형)
2턴: 원인 유형 확인 (복잡함/두려움/우선순위/환경)
3턴: "15분 안에 할 수 있는 첫 번째 단계는?" → SubTask 추출

→ stream: true 로 실시간 타이핑 효과
→ JSON 파싱 실패 시 fallback 소태스크 자동 제공
```

---

## B3. 테스트 & 보안 체크

```bash
flutter test test/unit/            # 단위 테스트 11개
npx playwright test e2e/           # E2E 전체

# .gitignore 필수 항목
google-services.json  GoogleService-Info.plist
keystore.jks  key.properties  .env
```
