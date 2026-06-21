---
marp: true
theme: default
paginate: true
size: 16:9
header: "Delay Detective — 최종 발표"
footer: "신혜지 | 2026.06.22"
style: |
  /* ── 기본 (다크 테마) ── */
  section {
    font-family: 'Apple SD Gothic Neo', '맑은 고딕', 'Noto Sans KR', sans-serif;
    font-size: 23px;
    padding: 40px 52px;
    color: #dce8ff;
    background: #0d1b3e !important;
  }
  header { color: #3d5a8a; font-size: 14px; top: 18px; }
  footer { color: #3d5a8a; font-size: 14px; bottom: 18px; }
  section::after { font-size: 14px; color: #3d5a8a; }

  /* ═══ 커버 ═══ */
  section.cover {
    background: linear-gradient(135deg, #1F3864, #2E75B6) !important;
    color: white !important;
    text-align: center;
    justify-content: center;
    padding: 48px 64px;
  }
  section.cover header,
  section.cover footer,
  section.cover::after { display: none; }
  section.cover h1 {
    font-size: 66px;
    font-weight: 800;
    color: #fff !important;
    margin: 10px 0 4px;
    letter-spacing: 1px;
    text-shadow: 0 2px 16px rgba(0,0,0,0.35);
  }
  section.cover h3 {
    color: rgba(255,255,255,0.85) !important;
    font-size: 22px;
    font-weight: 300;
    margin: 0 0 24px;
  }
  section.cover p {
    color: rgba(255,255,255,0.65) !important;
    font-size: 16px;
    margin: 4px 0;
  }
  .chips {
    display: flex;
    gap: 8px;
    justify-content: center;
    flex-wrap: wrap;
    margin: 10px 0;
  }
  .chip {
    background: rgba(255,255,255,0.15);
    color: #fff;
    padding: 5px 18px;
    border-radius: 20px;
    font-size: 17px;
    border: 1px solid rgba(255,255,255,0.28);
    backdrop-filter: blur(4px);
  }
  .chip-sm {
    background: rgba(255,255,255,0.10);
    color: rgba(255,255,255,0.85);
    padding: 3px 14px;
    border-radius: 16px;
    font-size: 15px;
    border: 1px solid rgba(255,255,255,0.20);
  }

  /* ── 헤딩 ── */
  h2 {
    color: #7eb8ff;
    font-size: 28px;
    border-bottom: 2px solid #2E75B6;
    padding-bottom: 8px;
    margin-bottom: 18px;
  }
  h3 { color: #93c5fd; font-size: 18px; margin: 10px 0 6px; }

  /* ── 테이블 ── */
  table {
    font-size: 18px;
    width: 100%;
    border-collapse: collapse;
    background: #111f40;
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 2px 12px rgba(0,0,0,0.35);
  }
  th { background: #1F3864; color: #ffffff; padding: 8px 12px; font-weight: 600; }
  td { padding: 6px 12px; border-bottom: 1px solid #1a2f5e; color: #e8f2ff; background: #1a3060; }
  tr:last-child td { border-bottom: none; }
  tr:nth-child(even) td { background: #0f1f3d; color: #e8f2ff; }

  /* ── 코드 ── */
  code { background: #1a2f5e; color: #93c5fd; padding: 1px 7px; border-radius: 4px; font-size: 17px; }
  pre {
    background: #07102a;
    color: #c8d8ff;
    padding: 14px 18px;
    border-radius: 10px;
    font-size: 15px;
    line-height: 1.65;
    border-left: 4px solid #2E75B6;
    box-shadow: 0 2px 16px rgba(0,0,0,0.5);
  }
  pre code { background: transparent; color: inherit; padding: 0; font-size: inherit; }

  /* ── 인용 ── */
  blockquote {
    border-left: 4px solid #2E75B6;
    background: #111f40;
    padding: 10px 18px;
    margin: 12px 0;
    border-radius: 0 8px 8px 0;
    font-size: 19px;
    color: #a5c8ff;
  }

  /* ── 카드 박스 ── */
  .card {
    background: #111f40;
    border-radius: 12px;
    padding: 16px 20px;
    border: 1px solid #1e3f7a;
    box-shadow: 0 2px 12px rgba(0,0,0,0.3);
    color: #c8dfff;
  }
  .card h3 { color: #93c5fd !important; }
  .card-green {
    background: #0a2518;
    border-radius: 12px;
    padding: 14px 18px;
    border: 1.5px solid #22c55e;
    color: #86efac;
  }
  .card-orange {
    background: #271300;
    border-radius: 12px;
    padding: 14px 18px;
    border: 1.5px solid #f97316;
    color: #fdba74;
  }
  .card-dark {
    background: #07102a;
    color: #c8d8ff;
    border-radius: 12px;
    padding: 14px 18px;
    border: 1.5px solid #2E75B6;
  }
  .card-dark h3 { color: #7eb8ff !important; }

  /* ── 레이아웃 ── */
  .cols { display: grid; grid-template-columns: 1fr 1fr; gap: 22px; margin-top: 6px; }

  /* ── 데모 슬라이드 ── */
  section.demo {
    background: linear-gradient(135deg, #142040, #1F3864) !important;
    color: #e8f0ff !important;
  }
  section.demo h2 { color: #7eb8ff !important; border-color: #2E75B6; }
  section.demo h3 { color: #a5c8ff !important; }
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
    background: linear-gradient(135deg, #1F3864, #2E75B6) !important;
    color: #fff !important;
    text-align: center;
    justify-content: center;
  }
  section.ending header,
  section.ending footer,
  section.ending::after { display: none; }
  section.ending h2 { color: #fff !important; border: none; font-size: 42px; margin-bottom: 16px; }
  section.ending p { color: rgba(255,255,255,0.85) !important; font-size: 19px; }
  section.ending a { color: #bfdbfe; }
  section.ending blockquote {
    background: rgba(255,255,255,0.12);
    border: none;
    border-radius: 16px;
    color: rgba(255,255,255,0.9) !important;
    font-size: 21px;
    padding: 12px 36px;
    display: inline-block;
  }
---

<!-- _class: cover -->

# 🔍 DELAY DETECTIVE

### AI 기반 미루기 분석 & 태스크 재구성 앱

<div class="chips">
  <span class="chip">Flutter</span>
  <span class="chip">Claude API</span>
  <span class="chip">Firebase Firestore</span>
  <span class="chip">Hive (오프라인)</span>
  <span class="chip">Provider</span>
</div>

<div class="chips">
  <span class="chip-sm">서브에이전트 5종</span>
  <span class="chip-sm">MCP 3개</span>
  <span class="chip-sm">최종 발표</span>
</div>

신혜지 · 최종 발표 · 2026-06-22

<!--
[대사 — 20초]
안녕하세요. 저는 AI 기반 할 일 미루기 분석 앱 'Delay Detective'를 개발한 신혜지입니다.
오늘 발표는 비전 제시부터 시연 데모, 기술 구조, 테스트까지 5분 안에 말씀드리겠습니다.
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

## 📅 프로젝트 계획 — WBS & 진행 현황

<style scoped>
section { padding-left: 20px; padding-right: 20px; }
table { font-size: 11.5px; border-collapse: collapse; width: 100% !important; display: table !important; margin-top: 8px; table-layout: fixed; }
th:nth-child(1) { width: 5%; }
th:nth-child(2) { width: 30%; }
th:nth-child(3) { width: 9%; }
th:nth-child(n+4) { width: 11.2%; }
th { background: #1F3864; color: #e8f2ff; text-align: center; padding: 4px 6px; font-size: 11.5px; border: 1px solid #2E75B6; }
td { padding: 3px 6px; border: 1px solid #2a4070; font-size: 11.5px; color: #ddeeff; background: #112244; }
tr:nth-child(even) td { background: #162b55; }
tr.sec td { background: #1e3f7a; font-weight: 700; color: #ffffff; border-color: #3b6bb5; }
tr.ms  td { background: #3a2800; font-weight: 700; color: #fde68a; border-color: #a06c00; }
.done  { background: #16a34a; color: white; border-radius: 8px; padding: 1px 7px; font-size: 10.5px; white-space: nowrap; }
.mstag { background: #dc2626; color: white; border-radius: 8px; padding: 1px 7px; font-size: 10.5px; white-space: nowrap; }
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

> **MCP 3개**: Notion · GitHub · Playwright

</div>
</div>

<!--
[대사 — 20초]
기술 선택의 핵심은 서버 없이 오프라인도 동작하는 앱이었습니다.
개발은 5개 서브에이전트 팀으로 나눠 각 전문 역할을 분담했습니다.
-->

---

## 📈 프로젝트 진행 과정

<div class="cols">
<div>

**6주 단계별 진행**

| 주차 | 기간 | 단계 | 핵심 산출물 |
|---|---|---|---|
| W10 | 05/11 | 기획·설계 | PRD, WBS, ADR 3종 |
| W11 | 05/18 | 백엔드 | Hive CRUD, Firestore, 동기화 |
| W12 | 06/01 | AI 시스템 | 인터뷰 플로우, 소태스크 생성 |
| W13 | 06/08 | UI·통합 | 4탭 네비, 캘린더, Google 로그인 |
| W14 | 06/15 | 배포·마무리 | APK·Web 빌드, 테스트, 문서 |

</div>
<div>

**AI 에이전트 협업 개발 방식**

<div class="card">

각 단계 시작 전 전담 서브에이전트 투입

```
W10: product-manager-prd → PRD 작성
W11: backend-architect  → DB·동기화 설계
W12: ai-integration-specialist → 프롬프트
W13: frontend-developer → UI 구현
W14: qa-engineer        → 테스트 자동화
```

</div>

<div class="card-green" style="margin-top:12px;">

✅ Must 기능 **100%** 완료  
✅ Should 기능 주요 항목 완료  
✅ 마일스톤 4개 모두 달성

</div>

</div>
</div>

<!--
[대사 — 20초]
6주 개발을 5단계로 나눠 각 단계마다 전담 AI 에이전트를 투입했습니다.
단계별 마일스톤을 모두 달성했고, Must 기능은 100% 구현했습니다.
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
오프라인 변경은 sync_queue에 쌓아두고, 네트워크 복구 시 타임스탬프를 비교해 더 최신 데이터를 선택합니다.
-->

---

## 🚀 활용 방안 & 기대 효과

<div class="cols">
<div>

**현재 활용 가능**

<div class="card-green">

✅ 개인 할일 관리 + AI 미루기 분석  
✅ 오프라인에서도 완전 동작  
✅ 웹(Chrome) + Android 멀티플랫폼  
✅ Google 계정 로그인 · 멀티 디바이스 동기화

</div>

<div class="card" style="margin-top:12px;">

**기술 자산화**

AUTHORING.hyeji.md 한 파일로 5개 에이전트 부트스트랩  
→ 다음 프로젝트 템플릿 재사용

LLM Wiki `notes/` 5개 파일 축적

</div>

</div>
<div>

**가산점 요약**

| 항목 | 점수 |
|---|---|
| AI Agent 워크플로우 (서브에이전트 5종) | +1 |
| 나만의 기법 (AUTHORING.hyeji.md) | +2 |
| LLM Wiki (`notes/` 5개 파일) | +1 |

**기대 효과**

<div class="card" style="margin-top:10px; font-size:17px;">

- 미루기 원인을 스스로 파악하는 습관 형성
- 15분 단위 소태스크로 즉시 실행 가능성 ↑
- AI 협업 개발 방법론의 실증 사례

</div>

</div>
</div>

<!--
[대사 — 20초]
이 앱은 지금 바로 웹과 Android에서 사용할 수 있습니다.
AUTHORING.hyeji.md 템플릿과 LLM Wiki는 다음 프로젝트의 자산이 됩니다.
-->

---

## 📋 ADR 요약 — Q&A 준비

| ADR | 결정 | 핵심 이유 |
|---|---|---|
| **ADR-0001** | Flutter 선택 | 웹+Android 동시 지원, 단일 코드베이스 |
| **ADR-0002** | Provider 선택 | Flutter 공식 권장, 이 규모엔 Redux 과도 |
| **ADR-0003** | Firebase+Hive | 서버 없이 오프라인-온라인 동기화 구현 |

**예상 Q&A**

> **Q. 왜 Supabase 대신 Firebase?**  
> Flutter 공식 패키지 성숙도, 무료 플랜, 국내 레퍼런스 — ADR-0003

> **Q. Redux 대신 Provider를 쓴 이유?**  
> 이 앱 규모에서 Redux는 보일러플레이트 과다 — ADR-0002

> **Q. 오프라인·온라인 충돌이 나면?**  
> `updatedAt` 비교 → Last-Write-Wins, 동일 시각이면 서버 우선 — ADR-0003

<!--
[대사 — 15초]
기술 결정은 모두 ADR 문서로 남겼습니다. Q&A 질문이 오면 ADR 번호로 바로 답변합니다.
-->

---

## 🏗️ 앱 구조 설명 — 4-레이어 폴더 구조

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
    ├── local/   HiveService
    ├── remote/  FirestoreService · AIService
    └── sync/    SyncService (sync_queue)
```

</div>
<div>

**레이어별 역할**

<div class="card">

| 레이어 | 역할 | 기술 |
|---|---|---|
| Presentation | UI 렌더링 | Flutter Widget |
| Application | 상태 관리 | Provider |
| Domain | 비즈니스 규칙 | 순수 Dart |
| Data | 저장·통신 | Hive + Firestore |

</div>

<div class="card" style="margin-top:12px;">

- Domain은 외부 의존 없음 → 독립 테스트 가능
- 오프라인 우선 (Hive → Firestore)
- `ChangeNotifierProxyProvider` uid 자동 재생성

</div>

</div>
</div>

<!--
[대사 — 20초]
클린 아키텍처의 4-레이어를 적용했습니다.
각 레이어는 단방향으로 의존하며, Domain 레이어는 외부 라이브러리에 전혀 의존하지 않습니다.
-->

---

## ⚙️ 개발 환경 설정

<div class="cols">
<div>

**개발 환경**

| 항목 | 내용 |
|---|---|
| Flutter | 3.x (Dart 3.x) |
| IDE | VS Code + Claude Code |
| Firebase | CLI + flutterfire_cli |
| 테스트 기기 | Galaxy S25 (Android 16) |
| AI 개발 도구 | Claude Code + MCP 3개 |

**Firebase 초기 설정**

```bash
firebase login
flutterfire configure
# → google-services.json 자동 생성
```

</div>
<div>

**필수 패키지 (pubspec.yaml)**

<div class="card-dark">

```yaml
dependencies:
  flutter:
  provider: ^6.x
  hive_flutter: ^1.x
  cloud_firestore: ^5.x
  firebase_auth: ^5.x
  google_sign_in: ^6.x
  anthropic_sdk_dart: ^0.x
  connectivity_plus: ^6.x
```

</div>

<div class="card-green" style="margin-top:12px;">

✅ `flutter pub get` 한 번으로 전체 설치  
✅ `flutterfire configure` 로 Firebase 자동 연결

</div>

</div>
</div>

<!--
[대사 — 15초]
개발 환경은 Flutter 3.x와 VS Code를 기반으로 Firebase CLI와 Claude Code를 함께 사용했습니다.
-->

---

## 📦 빌드와 배포 과정

<div class="cols">
<div>

**빌드 명령어**

```bash
# 디버그 실행
flutter run --debug
flutter run -d chrome --web-port 5000

# 릴리즈 빌드
flutter build apk --release        # 49.9 MB
flutter build appbundle --release  # 43 MB
flutter build web --release
```

**릴리즈 서명 설정**

```
android/key.properties
  storePassword / keyPassword / keyAlias / storeFile
→ build.gradle signingConfigs 연결
```

</div>
<div>

**배포 현황**

```bash
# Firebase Hosting 웹 배포
firebase deploy --only hosting
```

<div class="card-green" style="margin-top:12px;">

✅ APK + AAB 빌드 완료 (릴리즈 서명 키)  
✅ Firebase Hosting 배포 완료  
✅ `keystore`, `.env` → `.gitignore`  
✅ Play Console 업로드 준비 완료

</div>

<div class="card" style="margin-top:10px;">

**빌드 산출물**

| 타겟 | 파일 | 크기 |
|---|---|---|
| Android | app-release.apk | 49.9 MB |
| Android | app-release.aab | 43 MB |
| Web | build/web/ | — |

</div>

</div>
</div>

<!--
[대사 — 20초]
릴리즈 빌드는 서명 키 설정 후 appbundle로 Play Console에 업로드합니다.
Firebase Hosting으로 웹 배포도 완료했습니다.
-->

---

## 🔷 아키텍처 다이어그램 — 의존성 & 데이터 흐름

<div class="cols">
<div>

**4-레이어 의존성 방향 (단방향)**

<div class="card" style="text-align:center; font-size:20px; padding:28px 20px;">

🖥️ **Presentation**  
↓ (읽기 전용)  
⚙️ **Application** (Provider)  
↓ (호출)  
📦 **Domain** ← 🗄️ **Data**

</div>

<div class="card" style="margin-top:14px; font-size:17px;">

- Presentation → Application : `context.watch<TaskProvider>()`
- Application → Data : Service 호출
- Domain ← Data : 모델 변환 (`fromMap` / `toMap`)

</div>

</div>
<div>

**오프라인 우선 데이터 흐름**

<div class="card-dark" style="font-size:17px;">

```
사용자 액션
    ↓
TaskProvider (Application)
    ↓          ↓
HiveService  FirestoreService
(Local)      (Remote / 온라인 시)
    ↓
SyncService
  - sync_queue 처리
  - updatedAt 비교
  - Last-Write-Wins 적용
```

</div>

> 오프라인 → Hive 선저장  
> 온라인 복구 → Firestore 동기화

</div>
</div>

<!--
[대사 — 20초]
의존성은 단방향으로만 흐르고, 데이터는 오프라인 우선으로 Hive에 먼저 저장 후 Firestore와 동기화합니다.
-->

---

## 🐛 구현 시행착오 사례

**직접 겪고 해결한 버그 5가지**

| # | 문제 | 원인 | 해결 |
|---|---|---|---|
| 1 | Firestore 중복 데이터 | 로그아웃 후 UID 재생성 | Hive settings 박스로 UID 영속화 |
| 2 | `400: origin_mismatch` | OAuth 허용 도메인 미등록 | `--web-port 5000` 고정 + Firebase 등록 |
| 3 | 웹 로그인 후 화면 미전환 | `signInWithRedirect` 제한 | `signInWithPopup()` 전환 |
| 4 | Android 로그인 실패 | SHA-1 지문 미등록 | Firebase Console에 SHA-1 등록 |
| 5 | 로그아웃 후 Splash 멈춤 | `signOut()` 후 상태 미갱신 | signOut() 전 즉시 `notifyListeners()` |

<div class="card-orange" style="margin-top:16px; font-size:18px;">

**가장 어려웠던 문제**: 웹과 Android의 Google 로그인 방식 차이  
→ 웹은 `signInWithPopup`, Android는 `google_sign_in` 패키지로 완전히 다른 접근 필요

</div>

<!--
[대사 — 25초]
5가지 버그를 직접 겪고 해결했습니다.
가장 어려웠던 건 웹과 Android의 Google 로그인 방식 차이였습니다.
-->

---

## ⚡ 성능 최적화 노력

<div class="cols">
<div>

**캘린더 렌더링 최적화**

<div class="card-green">

- `LayoutBuilder` rowHeight 동적 계산  
  → 다양한 화면 크기 대응
- `IndexedStack` 탭 전환 시 상태 유지  
  → 탭 이동 시 리렌더링 방지
- `DateTime(y,m,d)` 비교로 날짜 오차 제거  
  → 시분초 차이로 인한 버그 방지

</div>

**상태 관리 최적화**

<div class="card" style="margin-top:10px;">

- `Consumer` / `Selector` 최소 범위 rebuild
- `ChangeNotifierProxyProvider`로 uid 변경 시 자동 재생성

</div>

</div>
<div>

**AI 응답 최적화**

<div class="card">

**Anthropic API `stream: true`**  
→ 실시간 타이핑 효과 구현

```dart
final stream = client.messages.stream(
  model: 'claude-sonnet-4-6',
  stream: true,
  ...
);
stream.listen((chunk) => setState(...));
```

</div>

<div class="card" style="margin-top:10px;">

- 인터뷰 **2~3턴 최소화** (UX 최적화)
- JSON 파싱 실패 시 **fallback 소태스크** 자동 제공
- 응답 캐싱으로 동일 태스크 재분석 방지

</div>

</div>
</div>

<!--
[대사 — 20초]
캘린더 렌더링은 LayoutBuilder로 동적 계산하고, AI 응답은 스트리밍으로 받아 실시간 타이핑 효과를 구현했습니다.
-->

---

## 🔐 코드 품질 관리

<div class="cols">
<div>

**보안 체크리스트**

<div class="card">

- `google-services.json` → `.gitignore` ✅
- `keystore.jks` + `key.properties` → `.gitignore` ✅
- Anthropic API 키 → `.env` (미커밋) ✅
- Firestore Security Rules: uid 격리 ✅

```
rules_version = '2';
service cloud.firestore {
  match /databases/{db}/documents {
    match /users/{uid}/{doc=**} {
      allow read, write: if request.auth.uid == uid;
    }
  }
}
```

</div>

</div>
<div>

**4-레이어 아키텍처로 관심사 분리**

<div class="card-green">

- Domain 레이어: 외부 의존 없음  
  → 순수 Dart로 독립 테스트 가능
- 각 Service 단독 교체 가능  
  → HiveService ↔ SQLite 교체 시 Domain 무변경
- Provider 범위 최소화  
  → `Consumer<TaskProvider>` 필요 위젯만 rebuild

</div>

**ADR 문서화**

<div class="card" style="margin-top:10px; font-size:17px;">

- ADR-0001: Flutter 선택 (vs Native)
- ADR-0002: Provider (vs Redux)
- ADR-0003: Firebase+Hive (vs 자체 서버)

</div>

</div>
</div>

<!--
[대사 — 20초]
보안 민감 파일은 모두 .gitignore로 처리하고, 4-레이어 아키텍처로 각 레이어를 독립적으로 테스트할 수 있게 구성했습니다.
-->

---

## ✅ 테스트 결과 — 단위 / 통합

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

</div>
<div>

**E2E — Playwright MCP 자동화**

```
e2e/login.spec.ts       로그인 화면·버튼
e2e/navigation.spec.ts  비인증 리다이렉트
e2e/task.spec.ts        할일 CRUD 플로우
```

<div class="card-green" style="margin-top:12px;">

✅ 단위 테스트 11개 전체 PASS  
✅ E2E 3개 시나리오 자동화 완료  
✅ Playwright MCP로 브라우저 직접 제어

</div>

<div class="card" style="margin-top:10px; font-size:17px;">

**테스트 실행**
```bash
flutter test test/unit/
npx playwright test e2e/
```

</div>

</div>
</div>

<!--
[대사 — 20초]
단위 테스트 11개 모두 통과했습니다.
E2E는 Playwright MCP로 로그인·네비게이션·CRUD 흐름을 자동화했습니다.
-->

---

## 📥 GitHub 설치 가이드

<div class="cols">
<div>

**설치 & 실행 (3단계)**

```bash
# 1. 클론
git clone https://github.com/hyeji203/delay-detective
cd delay-detective

# 2. 패키지 설치
flutter pub get

# 3. Firebase 연결
flutterfire configure
```

**실행**

```bash
# 웹 (Chrome)
flutter run -d chrome --web-port 5000

# Android
flutter run -d <device-id>

# 디버그 빌드
flutter run --debug
```

</div>
<div>

**사전 조건**

<div class="card">

| 항목 | 버전 |
|---|---|
| Flutter SDK | 3.x 이상 |
| Dart SDK | 3.x 이상 |
| Firebase CLI | 최신 |
| Node.js | 18+ (Playwright용) |

</div>

**환경 변수 설정**

<div class="card-dark" style="margin-top:12px;">

```bash
# .env 파일 생성 (미커밋)
ANTHROPIC_API_KEY=sk-ant-...

# Firebase 자동 설정
flutterfire configure
# → google-services.json 자동 생성
```

</div>

> 자세한 내용: `docs/setup.md` 참고

</div>
</div>

<!--
[대사 — 15초]
설치는 git clone → flutter pub get → flutterfire configure 3단계로 완료됩니다.
자세한 설치 방법은 docs/setup.md에 정리했습니다.
-->

---

<!-- _class: demo -->

## 🎬 시연 데모 — 앱 형태 & 기능

**바텀 네비게이션 4탭 구성**

<div class="cols">
<div>

<div class="card-dark">

```
🏠  홈 캘린더
    날짜별 할일 칩 · 바텀시트
    마감 초과 🔥 강조 표시

📋  할일 목록
    진행중 / 완료 탭 분리
    스와이프로 완료 처리

🤖  AI 분석
    인터뷰 채팅 → 소태스크 결과
    스트리밍 타이핑 효과

📊  통계
    완료율 · 지연 현황 차트
    주간 미루기 패턴 시각화
```

</div>

</div>
<div>

**주요 기능 요약**

<div class="step"><b>Google 로그인</b>  웹·Android 모두 지원</div>
<div class="step"><b>오프라인 동작</b>  Hive 로컬 저장 → 복구 시 동기화</div>
<div class="step"><b>마감 감지</b>  🔥 마감 초과 태스크 자동 강조</div>
<div class="step"><b>AI 인터뷰</b>  Claude 2~3턴 대화로 원인 분석</div>
<div class="step"><b>소태스크 생성</b>  15분 단위 3개 자동 생성</div>
<div class="step"><b>통계 시각화</b>  완료율 · 지연 현황 차트</div>

</div>
</div>

<!--
[대사 — 20초]
앱은 4개 탭으로 구성되어 있습니다.
홈 캘린더, 할일 목록, AI 분석, 통계 탭이며 오프라인에서도 모든 기능이 동작합니다.
-->

---

<!-- _class: demo -->

## 🎬 사용자 시나리오 기반 시연

<div class="cols">
<div>

**[데모 시나리오 — 30초]**

<div class="step"><b>1</b>  Google 로그인 → 메인 홈 캘린더</div>
<div class="step"><b>2</b>  할일 추가 (발표 준비, 마감 오늘)</div>
<div class="step"><b>3</b>  마감 초과 태스크 🔥 강조 확인</div>
<div class="step"><b>4</b>  AI 분석 시작 → Claude 인터뷰 3턴</div>
<div class="step"><b>5</b>  소태스크 3개 자동 생성 결과 확인</div>
<div class="step"><b>6</b>  📊 통계 탭 → 완료율 시각화</div>

</div>
<div>

**시나리오 흐름도**

<div class="card-dark" style="font-size:17px;">

```
로그인
  ↓
홈 화면 (캘린더)
  ↓
마감 초과 태스크 🔥 발견
  ↓
AI 분석 탭 진입
  ↓
Claude 인터뷰
  "왜 미루고 있나요?"
  ↓
소태스크 3개 생성
  ① 핵심 메시지 작성 (15분)
  ② 목차 구성 (15분)
  ③ 첫 슬라이드 작성 (15분)
  ↓
통계 탭 → 완료율 확인
```

</div>

</div>
</div>

<!--
[대사 — 30초]
Google 로그인 후 캘린더에 할일이 바로 표시됩니다.
마감이 지난 태스크는 불꽃 아이콘으로 강조되고, AI 분석을 시작하면 Claude가 왜 미루는지 질문합니다.
2~3턴 대화 후 소태스크 3개가 자동 생성되고, 통계 탭에서 진행률을 확인합니다.
-->

---

<!-- _class: demo -->

## ✨ 임팩트 있는 데모 장면 — AI 인터뷰 → 소태스크

<div class="cols">
<div>

**Before: 막막한 하나의 태스크**

<div class="card-orange">

📌 **"발표 자료 만들기"**  
마감: 오늘 🔥  
상태: 3일째 미루는 중…

</div>

**AI 인터뷰 (2턴)**

<div class="card-dark" style="margin-top:10px; font-size:17px;">

🤖 Claude: *"이 태스크를 미룬 이유가 뭔가요?"*

👤 사용자: *"어디서 시작해야 할지 모르겠어요"*

🤖 Claude: *"발표의 핵심 메시지 1문장을 먼저 써볼까요? 15분이면 충분합니다."*

</div>

</div>
<div>

**After: 15분 단위 소태스크 3개** ✅

<div class="card-green" style="font-size:18px;">

| # | 소태스크 | 예상 시간 |
|---|---|---|
| 1 | 핵심 메시지 1문장 작성 | 15분 |
| 2 | 슬라이드 목차 5개 나열 | 15분 |
| 3 | 첫 슬라이드 초안 작성 | 15분 |

</div>

<div class="card" style="margin-top:14px; font-size:18px;">

> **"막막한 하나"가**  
> **"시작 가능한 셋"으로**

AI가 물어봐주면, 미루기가 끝난다 🎯

</div>

</div>
</div>

<!--
[대사 — 25초]
이것이 Delay Detective의 핵심 장면입니다.
3일째 미루던 태스크가 AI 인터뷰 2턴 만에 15분짜리 소태스크 3개로 쪼개집니다.
막막했던 하나가 시작 가능한 셋으로 바뀌는 순간입니다.
-->

---

## 🌟 마무리 & 향후 발전 방향

<div class="cols">
<div>

**6주 개발 성과 요약**

<div class="card-green">

✅ Must 기능 100% 구현  
✅ 5개 서브에이전트 팀 협업 완료  
✅ 웹 + Android 동시 배포  
✅ 단위 11개 · E2E 3개 테스트 통과  
✅ ADR 3종 · LLM Wiki 5개 문서화

</div>

<div class="card" style="margin-top:12px;">

**재사용 가능한 기술 자산**

- AUTHORING.hyeji.md → 에이전트 부트스트랩 템플릿
- notes/ LLM Wiki → 오프라인 동기화, 충돌 해결 노하우

</div>

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

> AI와 함께라면 더 큰 앱도 가능하다는 것을 증명했습니다

</div>
</div>

<!--
[대사 — 20초]
6주 동안 Must 기능 100%, 웹과 Android 동시 배포, 테스트까지 완료했습니다.
향후에는 FCM 푸시 알림과 iOS 배포를 최우선으로 추진할 계획입니다.
-->

---

<!-- _class: ending -->

## 감사합니다 🙏

> "AI가 물어봐주면, 미루기가 시작된다"

📦 **github.com/hyeji203/delay-detective**

🌿 **잔디: https://num.slogs.dev**

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
  - dueDate, isCompleted, isDelayed
  - delayReason, delayCategory
  - createdAt, updatedAt   ← Last-Write-Wins 기준
  - subTasks: [{id, title, isCompleted}]

users/{uid}/sync_queue/{taskId}
  - taskId, action (upsert | delete), timestamp
```

---

## B2. AI 인터뷰 흐름

```
System: "공감적 미루기 코치. 2~3턴 내 원인 파악 후 소태스크 3개 JSON 제시."

1턴: "이 태스크를 미룬 이유가 뭔가요?"
2턴: 원인 유형 확인 (복잡함/두려움/우선순위/환경)
3턴: "15분 안에 할 수 있는 첫 번째 단계는?" → SubTask 추출

→ stream: true 로 실시간 타이핑
→ JSON 파싱 실패 시 fallback 소태스크 자동 제공
```

---

## B3. 테스트 & 보안

```bash
flutter test test/unit/          # 단위 11개
npx playwright test e2e/         # E2E 전체

# .gitignore 필수
google-services.json  GoogleService-Info.plist
keystore.jks  key.properties  .env
```
