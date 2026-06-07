# AUTHORING.hyeji.md — Delay Detective 프로젝트 AI Agent 구성

**버전**: v0.7 (세션 5 진행 중 — 캘린더 UI 개선, 태스크 수정 기능, 오프라인 배너 수정)  
**프로젝트**: Delay Detective (지연 감지 & 재구성 AI 할 일 관리 앱)  
**시작**: 2026-05-04 (세션 1 오리엔테이션)  
**최근 업데이트**: 2026-06-06 (세션 5 UI 개선 진행 중)

---

## 📌 1. 프로젝트 개요 (옵션 C)

### 1.1 핵심 개념
```
사용자가 "나중에 해야지" 하고 미루는 태스크를 
AI가 감지 → 왜 미루는지 물어봄 → 태스크를 재구성해주는 앱
```

### 1.2 프로젝트 정보
| 항목 | 내용 |
|---|---|
| **앱 이름** | Delay Detective |
| **부제** | AI-Powered Procrastination Analyzer with Offline-First Architecture |
| **개발 전략** | 서브에이전트 5종 + MCP 3개로 손코딩 7주차 경험 적용 |
| **개발 기간** | 6주 (세션 2~7) |
| **난이도** | 5.5배 (손코딩 7주차 수준) |
| **GitHub Repo** | `delay-detective` |

### 1.3 옵션 C 선택 이유
✅ **서브에이전트** (5종) — 손코딩 7주차에서 배운 AI 팀 협업 패턴 재사용  
✅ **MCP** (3개) — Notion, GitHub, Playwright로 자동화 도구 통합  
✅ **오프라인-온라인 동기화** — Hive + Firestore로 실제 사용성 확보  
✅ **6주 완성** — 코드 생성은 AI, 검증은 내가 담당 (시간 효율적)

---

## 🤖 2. AI 팀 구성 (손코딩 7주차 기반)

### 2.1 서브에이전트 5종 (주역할, 권한, 모델)

| 에이전트 | 역할 | 권한 | 모델 | 배경색 |
|---|---|---|---|---|
| **product-manager-prd** | 앱 기획, 요구사항 정의(PRD), 일정 관리 | All tools | Sonnet | Red |
| **backend-architect** | Firebase 설계, Anthropic API, 동기화 로직 | All tools | Sonnet | Blue |
| **frontend-developer** | Flutter UI/UX 구현, 화면 설계 | All tools | Sonnet | Green |
| **qa-engineer** | 테스트 시나리오, Playwright 자동화 | All tools | Sonnet | Yellow |
| **ai-integration-specialist** | 지연 분석 프롬프트 엔지니어링, 최적화 | All tools | Sonnet | Purple |

### 2.2 협업 워크플로우

```
세션 2: PM 에이전트 → PRD 작성 (다른 에이전트들의 기준점)
세션 3: 백엔드 에이전트 → Firebase + Hive 동기화 설계
세션 4: 프론트 에이전트 → 기본 UI 구현
       AI 에이전트 → 지연 분석 프롬프트 설계
세션 5: QA 에이전트 → Playwright로 자동 테스트
       백엔드 에이전트 → 동기화 로직 완성
세션 6: 전체 에이전트 → 버그 수정, 배포 최적화
```

### 2.3 내 역할 = 팀 매니저

| 책임 | 내용 |
|---|---|
| **팀 조율** | 5개 에이전트에 작업 할당, 순서 조정 |
| **완전한 이해** | 각 에이전트의 산출물을 읽고 이해 가능할 때까지 질문 |
| **의사결정** | "이 설계가 맞나?", "이 기능 꼭 필요한가?" |
| **검증** | 코드 실행해보기, 버그 확인, 수정 지시 |
| **도구 연동** | MCP 3개 설정 & 자동화 관리 |
| **발표** | 모든 것을 자신의 말로 설명 가능하게 준비 |

---

## 🛠️ 3. 기술 스택 (옵션 C 최적화)

### 3.1 AI Agent 도구
| 도구 | 역할 | 용도 |
|---|---|---|
| **Claude Code** | 메인 AI | 통합 조정, 최종 검증 |
| **/agents** | 서브에이전트 | PM, 백엔드, 프론트, QA, AI통합 |
| **GitHub Copilot** | 코드 편집 | VS Code에서 자동 완성 |
| **Git + GitHub** | 버전 관리 | 코드 리포지토리 |

### 3.2 MCP 3개 (손코딩 7주차 경험 활용)
| MCP | 유형 | 용도 | 설치 명령 |
|---|---|---|---|
| **Notion MCP** | 원격 | 사용자 분석 결과 저장 | `claude mcp add --transport http notion https://mcp.notion.com/mcp` |
| **GitHub MCP** | 원격 | 태스크를 깃허브 이슈로 자동 생성 | `claude mcp add --transport http github [GitHub MCP URL]` |
| **Playwright MCP** | 로컬 | 앱 기능 자동 테스트 | `claude mcp add playwright -s local -- cmd /c npx @playwright/mcp@latest` |

### 3.3 기술 스택 (프로덕션)
| 계층 | 기술 | 상세 |
|---|---|---|
| **프론트엔드** | Flutter (Dart) | 크로스플랫폼 모바일 앱 |
| **상태 관리** | Provider | 권장 패턴 (간단하고 확장성 있음) |
| **온라인 DB** | Firebase (Firestore) | 실시간 동기화, 클라우드 스토리지 |
| **로컬 DB** | Hive | 오프라인에서도 데이터 유지 |
| **동기화 로직** | Hive ↔ Firestore Sync | Timestamp 기반 Conflict Resolution |
| **AI 분석** | Anthropic API (Claude) | 지연 원인 분석 |
| **자동 테스트** | Playwright (MCP) | UI 기능 검증 |
| **배포** | GitHub Actions + Vercel | CI/CD 자동화 |

### 3.4 배포 타겟
- 🍎 iOS (TestFlight)
- 🤖 Android (Google Play Console 또는 APK)
- 🌐 웹 (Vercel, Flutter Web)

---

## 🔄 4. 오프라인-온라인 동기화 전략 (옵션 C 핵심)

### 4.1 아키텍처

```
📱 온라인 상태 (네트워크 O)
    앱 (Provider State)
         ↓↑
    Firestore (클라우드)
    
📱 오프라인 상태 (네트워크 X)
    앱 (Provider State)
         ↓↑
    Hive (로컬 데이터베이스)
    
🔄 네트워크 복구
    Hive (변경사항 추적)
         ↓
    로컬에서 변경된 데이터 감지
         ↓
    Timestamp 비교 (Last-Write-Wins)
         ↓
    Firestore에 업로드/다운로드
         ↓
    동기화 완료 표시
```

### 4.2 구현 요소

| 요소 | 기술 | 설명 |
|---|---|---|
| **로컬 저장소** | Hive | 오프라인에서도 데이터 영구 보관 |
| **온라인 저장소** | Firestore | 멀티 디바이스 동기화 |
| **타임스탐프** | `DateTime.now()` | 어떤 데이터가 더 최신인지 판단 |
| **변경 추적** | Hive 리스너 | 로컬 변경 감지 |
| **네트워크 감지** | `connectivity_plus` | 온/오프라인 상태 감지 |
| **Conflict Resolution** | Last-Write-Wins | 충돌 시 최신 데이터 선택 |

### 4.3 Conflict Resolution 예시

```dart
// 시나리오: 오프라인에서 수정 후 온라인 상태에서 동기화
if (hiveData.lastModified > firestoreData.updatedAt) {
  // 로컬 데이터가 더 최신 → Firestore에 업로드
  await firestoreRef.set(hiveData.toMap());
} else if (hiveData.lastModified < firestoreData.updatedAt) {
  // 서버 데이터가 더 최신 → 로컬 업데이트
  await hiveBox.put(hiveData.id, firestoreData);
} else {
  // 타임스탐프 동일 → 사용자 선택
  showConflictResolutionDialog();
}
```

---

## 💬 5. MCP 활용 전략 (손코딩 7주차 연계)

### 5.1 3개 MCP의 협력 구조

```
1️⃣ Notion MCP
   → 지연 분석 결과를 노션에 자동 저장
   → "태스크별 지연 원인" 리포트 생성
   → 프로젝트 진행 상황 기록

2️⃣ GitHub MCP
   → 감지된 버그를 깃허브 이슈로 생성
   → 서브테스크를 깃허브에 연동
   → 개발 진행 상황 추적

3️⃣ Playwright MCP
   → 앱 기능 자동 테스트 (추가/삭제/수정/조회)
   → UI 동작 검증
   → 스크린샷 자동 캡처
```

### 5.2 워크플로우 예시

```
사용자: "내일 발표 준비하는데 자꾸 미뤄"
    ↓
앱 (Anthropic API) → 분석 결과 생성
    ↓
Notion MCP → "발표 준비 지연 분석" 문서 저장
    ↓
GitHub MCP → "발표 준비 세부 태스크" 이슈 생성
    ↓
Playwright MCP → 앱 전체 기능 자동 테스트
    ↓
QA 에이전트 → 테스트 결과 검증
```

---

## 🎁 6. 가산점 전략 (옵션 C로 +6점 노림)

### 6.1 +1점: AI Agent 적극 활용 ✅

**증거**:
- AUTHORING.hyeji.md에 5개 서브에이전트 명시
- MCP 3개 설치 & 연동 완료
- GitHub 커밋: "PM 에이전트로 PRD 생성", "QA 에이전트로 테스트" 등 명시
- README.md에 "서브에이전트 팀 + MCP 활용" 명시

**발표 설명** (2-3분):
```
"저는 손코딩 7주차에서 배운 서브에이전트를 활용해서,
PM, 백엔드, 프론트, QA, AI 통합 5개 팀을 구성했습니다.
각 에이전트가 전문 분야에서 협업하는 방식으로 개발했어요."
```

### 6.2 +2점: 본인만의 기법 (AUTHORING.hyeji.md) ✅✅

**목표**: 이 파일 하나로 전체 AI 팀 + MCP 워크플로우를 부트스트랩

**발표 설명** (5-7분):
```
"저는 AUTHORING.hyeji.md라는 문서로:

1. 5개 서브에이전트 역할을 정의하고
2. MCP 3개 (Notion, GitHub, Playwright)를 통합하고
3. Hive + Firestore 오프라인-온라인 동기화를 설계해서
4. AI 개발팀 + 자동화 도구를 완전히 관리했습니다.

이 파일 하나로 전체 프로젝트를 부트스트랩할 수 있어서,
나중에 다른 프로젝트에서도 이 템플릿을 재사용할 수 있어요."
```

### 6.3 +1점: LLM Wiki 운영 ✅

**위치**: `~/notes/delay-detective/`

**작성 계획**:
- `01-subagent-patterns.md` — 5개 에이전트 협업 경험
- `02-mcp-integration.md` — MCP 설치 & 활용 팁
- `03-offline-sync-strategy.md` — Hive + Firestore 동기화 구현 경험
- `04-conflict-resolution-bugs.md` — 실제 발생한 버그와 해결법
- `05-lessons-learned.md` — 6주 동안 배운 점

**발표 증명** (1-2분):
```
"이 프로젝트 동안 배운 AI 협업 방식, MCP 설정, 동기화 전략을
LLM Wiki에 정리해서 다음 프로젝트의 자산으로 만들었습니다."
```

### 6.4 +2점: AI Agent 리포트 발표 (10분+) ✅✅

**최종 발표 구성** (약 25분):

```
0-3분: 앱 소개 & 시연
    "이건 미루는 습관을 AI가 분석해주는 앱입니다"
    
3-8분: 기술 스택 & 오프라인-온라인 동기화
    "Hive로 오프라인 보관, Firestore로 동기화합니다"
    
8-18분: ⭐ "AI 에이전트 팀으로 만든 방식" (가산점!)
    • 5개 서브에이전트 역할 설명
    • 협업 워크플로우 (PM → 백엔드 → 프론트 → QA → AI)
    • MCP 3개 활용 (Notion 리서치, GitHub 이슈, Playwright 테스트)
    • AUTHORING.hyeji.md로 전체를 부트스트랩하는 방식
    
18-22분: 결과와 교훈
    • 손코딩 7주차 학습을 어떻게 적용했는가
    • 실제 동작하는 앱 데모
    
22-25분: Q&A
```

---

## 📋 7. 세션별 체크리스트

### 세션 2 (기획 & 일정 수립) ✅ 완료 (2026-05-11)
- [x] 비전 & 문제 정의 작성 (`.planning/00-vision.md`)
- [x] 사용자 시나리오 3개 + MoSCoW 작성 (`.planning/01-requirements.md`)
- [x] WBS 3단계 작성 (`.planning/02-wbs.md`)
- [x] 6주 일정표 + 위험 요소 5개 작성 (`.planning/04-schedule.md`)
- [x] 회의록 / 결정 사항 정리 (`.planning/meeting-01.md`)
- [x] 진행률 보고서 작성 (`.planning/progress-01.md`)
- [x] 모르는 영역 질문 목록 26개 작성 (`.planning/unknowns.md`)
- [x] ADR 3개 작성 (Flutter, Provider, Firebase+Hive 선택 이유)
- [x] BONUS.md 가산점 신청서 작성 (+6점 목표)
- [x] docs/ 디렉토리 구조 생성 (slides, screenshots, diagrams)
- [x] AUTHORING.hyeji.md 업데이트 (v0.4)
- [x] GitHub 커밋 & push (커밋: 90dcebd)

### 세션 3 (설계 & 환경 구축) ✅ 완료 (2026-05-18)
- [x] 4-레이어 아키텍처 설계 (Presentation / Application / Domain / Data)
- [x] Firestore 스키마 정의 (`docs/architecture.md` 포함)
- [x] Hive 로컬 DB 스키마 정의 (`docs/architecture.md` 포함)
- [x] `docs/architecture.md` 작성 (Mermaid 다이어그램 3개 포함)
- [x] `docs/setup.md` 작성 (환경 세팅 가이드)
- [x] ADR-0001~0003 4-레이어 내용으로 업데이트
- [x] `lib/` 4-레이어 폴더 구조 + 스켈레톤 코드 생성
  - Domain: Task, SubTask, DelayAnalysis, InterviewTurn, TaskStatus
  - Data: HiveService, FirestoreService, AIService, SyncService
  - Application: TaskProvider, AIProvider, SyncProvider
  - Presentation: HomeScreen, AddTaskScreen, InterviewScreen, AnalysisResultScreen, 위젯 3개
- [x] `pubspec.yaml` SDK 버전 수정 (`^3.9.2`), `flutter pub get` 성공
- [x] Hello World 빌드 성공 → GitHub push (커밋: 1819435)
- [x] 중간 발표 슬라이드 초안 (`docs/slides-midterm.md`, 3분 5장)
- [ ] MCP 3개 설치 확인 (Notion, GitHub, Playwright) → 세션 5 이후

### 세션 4 (구현 1 + 중간 발표) ✅ 완료 (2026-06-02)
- [x] 프론트 에이전트가 기본 UI 구현
  - HomeScreen (캘린더 + 태스크 목록)
  - AddTaskScreen (태스크 추가 폼)
  - TaskCard 위젯 (미루기/완료/삭제 바텀시트)
  - SyncBanner 위젯 (온/오프라인 상태 표시)
- [x] AI 에이전트가 지연 분석 인터뷰 설계 (InterviewScreen, AnalysisResultScreen)
- [ ] Firebase 연동 (인증, 기본 CRUD) → 세션 6으로 이월 (Firebase 미초기화 상태 유지)
- [x] Hive 로컬 저장 구현 (HiveService, offline-first 동작 확인)
- [x] 오프라인-온라인 동기화 기본 구조 완성 (SyncProvider, SyncService)
- [x] 중간 발표 슬라이드 작성 완료 (`docs/slides-midterm.md`)
- [x] AUTHORING.hyeji.md 업데이트

### 세션 5 (구현 2 + 테스트) 🚧 진행 중 (2026-06-05 ~ 2026-06-06)
- [x] **캘린더 UI 개선**
  - 토요일 날짜 파란색 표시 (일요일/공휴일 빨간색과 구분)
  - 날짜 셀 안에 일정 제목 직접 표시 (기존 빨간 점 마커 → 텍스트 라벨)
  - 날짜 숫자 상단 정렬 (rowHeight 72, mainAxisAlignment.start)
  - 헤더 한글화 "June 2026" → "6월"
  - 헤더 탭 시 연/월 선택 다이얼로그 (연도 ±, 월 그리드)
- [x] **태스크 수정 기능 추가**
  - TaskCard 바텀시트에 "수정하기" 항목 추가
  - AddTaskScreen을 수정 모드로도 동작하도록 개선 (기존 데이터 pre-fill)
  - 수정 저장 시 `updateTask` 호출
- [x] **오프라인 배너 수정**
  - Firebase 미연결 시 catch → `synced`로 처리해 불필요한 "오프라인" 배너 숨김
  - Firebase 연결 후 자동으로 정상 동기화 상태 전환
- [ ] 백엔드 에이전트가 동기화 로직 완성 (Conflict Resolution 포함)
- [ ] Hive ↔ Firestore 실제 동기화 테스트
- [ ] QA 에이전트가 Playwright로 자동 테스트
- [ ] 통계 화면 & 차트 추가
- [ ] 버그 수정 & 최적화
- [ ] AUTHORING.hyeji.md 업데이트

### 세션 6 (마감 & 배포)
- [ ] iOS/Android 빌드 & 실기기 테스트
- [ ] TestFlight 또는 Google Play Console 배포
- [ ] Notion MCP로 분석 결과 저장 테스트
- [ ] GitHub MCP로 이슈 생성 테스트
- [ ] Playwright MCP로 최종 자동 테스트
- [ ] 배포 가이드 문서화
- [ ] README.md 최종본
- [ ] AUTHORING.hyeji.md 최종 업데이트

### 세션 7 (최종 발표)
- [ ] 발표 슬라이드 (Marp 마크다운)
- [ ] "AI 에이전트 팀으로 만든 방식" 10분 발표 준비
- [ ] LLM Wiki 최종 점검 (5개 문서)
- [ ] Q&A 예상 답변 준비
- [ ] AUTHORING.hyeji.md v1.0 완성

---

## 🏆 8. 가산점 총합 목표

| 항목 | 점수 | 난이도 | 달성도 |
|---|---|---|---|
| AI Agent 적극 활용 | +1 | 중 | ✅ |
| 본인만의 기법 (AUTHORING.hyeji.md) | +2 | 중 | ✅ |
| LLM Wiki 운영 | +1 | 낮 | ✅ |
| AI Agent 리포트 발표 (10분+) | +2 | 높 | ✅ |
| **총 가산점** | **+6** | - | - |

---

## 📚 9. 참고 자료

### 손코딩 7주차에서 배운 내용
- 서브에이전트 생성 & 협업
- MCP 설치 (Notion, GitHub, Playwright)
- AI 개발팀 구성 및 역할 분담
- 5W1H 프레임워크

### Delay Detective 추가 자료
- Flutter + Firebase + Hive 동기화 패턴
- Conflict Resolution 알고리즘
- Anthropic API 프롬프트 엔지니어링

---

## 💭 10. 최종 당부

**"AI가 만든 것을 본인이 완전히 이해하고 설명할 수 있는가"**

이게 이 프로젝트의 핵심 평가 기준입니다.

- 5개 서브에이전트가 각각 뭘 하는지 설명할 수 있어야 함
- MCP 3개가 어떻게 협력하는지 보여줄 수 있어야 함
- Hive + Firestore 동기화가 왜 필요한지 말할 수 있어야 함
- 발표 때 Q&A에서 기술적인 답변을 할 수 있어야 함

6주 동안 **꼼꼼하고 성실하게** 진행하면, 손코딩 7주차 수준의 앱을 만들 수 있습니다! 🚀

---

**버전 히스토리**:
- v0.1 (2026-05-04) — 초안
- v0.2 (2026-05-04) — 상세 정리
- v0.3 (2026-05-04) — 옵션 C 최종본
- v0.4 (2026-05-11) — 세션 2 기획 완료 (비전/요구사항/WBS/ADR/BONUS)
- v0.5 (2026-05-18) — 세션 3 설계 완료 (4-레이어 아키텍처, 스켈레톤 코드, Hello World 빌드, 슬라이드 초안)
- v0.6 (2026-06-02) — 세션 4 완료 (기본 UI 전체 구현, AI 인터뷰 화면, Hive 로컬 저장, 중간 발표 슬라이드)
- **v0.7 (2026-06-06) — 세션 5 진행 중 (캘린더 UI 개선, 태스크 수정 기능, 오프라인 배너 수정)** ⭐

**다음 업데이트**: 세션 5 나머지 항목 완료 후 (Firebase 연동, Playwright 테스트)
