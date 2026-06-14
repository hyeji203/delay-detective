# AGENTS.md — Delay Detective AI Agent 정책서

이 파일은 Delay Detective 프로젝트에서 사용하는 AI 에이전트(서브에이전트)의 역할, 권한, 협업 규칙, 호출 방법을 정의한다.  
Claude Code에서 `.claude/agents/` 폴더에 있는 5개 서브에이전트를 관리하는 중앙 정책 문서다.

---

## 에이전트 팀 구성

| 에이전트 ID | 역할 요약 | 모델 | 주요 산출물 |
|---|---|---|---|
| `product-manager-prd` | 기획, PRD, WBS, 일정 관리 | claude-sonnet-4-6 | `01-requirements.md`, `02-wbs.md`, `04-schedule.md` |
| `backend-architect` | Firebase, Hive, 동기화, API 연동 | claude-sonnet-4-6 | `HiveService`, `FirestoreService`, `SyncService`, `AIService` |
| `frontend-developer` | Flutter UI/UX, Provider 상태 관리 | claude-sonnet-4-6 | 화면 5개, 공통 위젯, Provider 3개 |
| `qa-engineer` | 테스트 계획, Playwright 자동화 | claude-sonnet-4-6 | 테스트 시나리오, `flutter_test`, Playwright 스크립트 |
| `ai-integration-specialist` | 지연 분석 프롬프트, AI 인터뷰 흐름 | claude-sonnet-4-6 | 프롬프트 템플릿, 응답 파서, 토큰 최적화 |

---

## 에이전트별 상세 역할

### 1. product-manager-prd

**역할**: Delay Detective 앱의 PM — 기획서, 요구사항 정의서(PRD), 일정을 작성하고 다른 에이전트의 기준점을 만든다.

**권한**: All tools

**책임**:
- 5W1H 프레임워크로 기능 요구사항 정의
- MoSCoW 우선순위 분류 (Must / Should / Could / Won't)
- WBS 3단계 깊이, 항목당 1~3일 추정
- 세션 체크리스트 업데이트 (`AUTHORING.hyeji.md`)

**호출 방법**:
```
새 기능 기획이 필요하거나 요구사항이 변경됐을 때 호출한다.
다른 에이전트보다 먼저 호출해 PRD를 먼저 완성한다.
```

**정책**:
- 기능 추가 전 반드시 MoSCoW 분류 먼저 결정
- 범위(scope) 변경은 반드시 혜지 승인 후 진행
- 한국어로 모든 문서 작성 (코드 제외)

---

### 2. backend-architect

**역할**: Firebase Firestore, Hive 로컬 DB, 오프라인-온라인 동기화, Anthropic API 연동을 설계하고 구현한다.

**권한**: All tools

**책임**:
- Firestore 컬렉션/문서 스키마 설계
- Hive Box 스키마 및 TypeAdapter 구현
- Timestamp 기반 Last-Write-Wins Conflict Resolution 구현
- `SyncService`: Hive ↔ Firestore 자동 동기화
- `AIService`: Anthropic API HTTP 클라이언트, 대화 맥락 관리

**호출 방법**:
```
데이터 저장 로직, 동기화 오류, Firebase 설정, API 연동 이슈 발생 시 호출.
frontend-developer보다 먼저 작업해야 UI가 데이터를 받을 수 있다.
```

**정책**:
- API 키 코드 하드코딩 절대 금지 → `.env` 또는 Firebase Remote Config 사용
- 모든 DB 작업 try-catch 필수
- Firestore read 최소화 (불필요한 쿼리 금지)
- 동기화 충돌 기본 전략: Last-Write-Wins (updatedAt 타임스탬프 비교)

---

### 3. frontend-developer

**역할**: Flutter로 Delay Detective 앱의 화면과 UI 컴포넌트를 구현한다.

**권한**: All tools

**책임**:
- 화면 5개 구현: `HomeScreen`, `AddTaskScreen`, `InterviewScreen`, `AnalysisResultScreen`, `HistoryScreen`
- Provider 3개 연결: `TaskProvider`, `AIProvider`, `SyncProvider`
- 오프라인 상태 배너, 지연 태스크 빨간 배지 표시
- Material Design 3 기반 일관된 UI

**호출 방법**:
```
화면 구현, UI 버그, 위젯 수정, 레이아웃 변경이 필요할 때 호출.
backend-architect가 서비스 클래스를 완성한 뒤 호출하면 효율적이다.
```

**정책**:
- StatelessWidget 우선 사용 (상태가 필요할 때만 StatefulWidget)
- 긴 build() 메서드는 private 메서드로 분리
- 모든 화면 스크롤 가능하게 구현 (소형 기기 대응)
- 한국어 UI 텍스트 사용

---

### 4. qa-engineer

**역할**: 테스트 시나리오를 작성하고 Flutter 테스트 + Playwright MCP 자동화를 실행한다.

**권한**: All tools

**책임**:
- 유닛 테스트: 동기화 로직, 지연 감지 알고리즘
- 위젯 테스트: 각 화면 렌더링 확인
- 통합 테스트: 태스크 CRUD 전체 흐름
- Playwright MCP: Flutter Web에서 UI 자동화 테스트 + 스크린샷

**호출 방법**:
```
새 기능 구현 완료 후, 또는 버그 재현이 필요할 때 호출.
각 세션 종료 전 회귀 테스트를 반드시 요청한다.
```

**정책**:
- 버그 발견 시 GitHub MCP로 즉시 이슈 생성
- 핵심 로직 테스트 커버리지 목표: 80% 이상
- 테스트 실패 시 다른 에이전트에 수정 위임 후 재실행

---

### 5. ai-integration-specialist

**역할**: Anthropic API를 활용한 지연 원인 분석 프롬프트 엔지니어링, AI 인터뷰 흐름 설계, 응답 파싱 최적화를 담당한다.

**권한**: All tools

**책임**:
- 3턴 AI 인터뷰 흐름 설계 (시작 → 후속 질문 → 결과 JSON)
- 프롬프트 템플릿 작성 및 A/B 테스트
- Claude API 응답 파싱 (공감 메시지 / 원인 요약 / 소태스크 분리)
- 토큰 비용 최적화 (Haiku: 인터뷰, Sonnet: 최종 분석)

**호출 방법**:
```
AI 인터뷰 프롬프트 수정, 응답 파싱 오류, 새 분석 시나리오 추가 시 호출.
프롬프트 변경 결과는 반드시 notes/에 기록하도록 요청한다.
```

**정책**:
- 사용자 데이터 최소화 원칙 (개인정보는 Anthropic에 전송 전 제거)
- 응답 실패 시 graceful fallback 처리 필수
- 프롬프트 변경 시 이전 버전 notes/에 기록 후 수정

---

## 협업 워크플로우

```
세션 시작 시 이 파일과 AUTHORING.hyeji.md를 먼저 참조한다.

세션 2:  product-manager-prd → PRD, WBS, 일정표 작성
세션 3:  backend-architect    → Firebase/Hive 스키마, SyncService 설계
세션 4:  frontend-developer   → 화면 5개 구현
         ai-integration-specialist → 프롬프트 설계
세션 5:  qa-engineer          → 테스트 자동화
         backend-architect    → 동기화 로직 완성
세션 6:  전체 에이전트        → 버그 수정, 배포 준비
```

**에이전트 간 의존 관계**:
```
product-manager-prd (PRD)
        ↓
backend-architect (서비스 클래스)
        ↓
frontend-developer (UI 연결)
        ↓
qa-engineer (테스트)

ai-integration-specialist (프롬프트) ← backend-architect와 병렬 진행 가능
```

---

## MCP 도구 정책

| MCP | 용도 | 호출 에이전트 |
|---|---|---|
| Notion MCP | AI 분석 결과 자동 저장 | ai-integration-specialist |
| GitHub MCP | 소태스크 → GitHub 이슈 자동 생성 | qa-engineer |
| Playwright MCP | UI 자동화 테스트 + 스크린샷 | qa-engineer |

---

## 에이전트 공통 규칙

1. **코드 생성 후 반드시 실행 확인** — 생성만 하고 확인 안 하면 의미 없음
2. **이해 안 되면 혜지에게 설명 요청** — "왜 이렇게 했어?"
3. **세션 종료 전 `AUTHORING.hyeji.md` 체크리스트 업데이트**
4. **배운 내용은 `notes/` 폴더에 기록** — 암묵지 축적
5. **API 키, 비밀번호, 개인정보 절대 코드에 하드코딩 금지**
6. **PR/커밋 메시지는 한국어로** (코드 주석 제외)

---

## 에이전트 정책 파일 위치

```
.claude/
└── agents/
    ├── product-manager-prd.md       ← PM 에이전트 상세 설정
    ├── backend-architect.md         ← 백엔드 에이전트 상세 설정
    ├── frontend-developer.md        ← 프론트엔드 에이전트 상세 설정
    ├── qa-engineer.md               ← QA 에이전트 상세 설정
    └── ai-integration-specialist.md ← AI 통합 에이전트 상세 설정
```

각 파일은 Claude Code의 서브에이전트 명세(`name`, `description`, `model`)와 상세 지침을 포함한다.

---

## 관련 문서

- [AUTHORING.hyeji.md](./AUTHORING.hyeji.md) — 프로젝트 전체 설계 & 세션 체크리스트
- [CLAUDE.md](./CLAUDE.md) — Claude Code 프로젝트 가이드
- [docs/architecture.md](./docs/architecture.md) — 시스템 아키텍처
- [notes/01-subagent-patterns.md](./notes/01-subagent-patterns.md) — 에이전트 협업 패턴 기록
