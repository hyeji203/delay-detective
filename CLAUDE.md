# Delay Detective — Claude Code 가이드

## 프로젝트 개요
미루는 태스크를 AI가 감지 → 이유 분석 → 재구성해주는 Flutter 앱  
상세 기획: `AUTHORING.hyeji.md` 참고

## 기술 스택
- **프론트엔드**: Flutter (Dart)
- **상태 관리**: Provider
- **온라인 DB**: Firebase Firestore
- **로컬 DB**: Hive (오프라인 지원)
- **AI 분석**: Anthropic API (Claude)
- **테스트**: Playwright MCP

## 폴더 구조
```
delay-detective/
├── lib/
│   ├── main.dart
│   ├── models/          # Task, DelayAnalysis 데이터 모델
│   ├── providers/       # TaskProvider, SyncProvider
│   ├── screens/         # HomeScreen, AddTaskScreen, AnalysisScreen
│   ├── services/        # FirestoreService, HiveService, SyncService, AIService
│   └── widgets/         # 공통 UI 컴포넌트
├── .claude/
│   └── agents/          # 서브에이전트 5종
├── notes/               # LLM Wiki (세션별 학습 기록)
├── AUTHORING.hyeji.md   # 프로젝트 설계 문서
└── CLAUDE.md            # 이 파일
```

## 서브에이전트 사용법
```
/agents 목록에서 선택:
- product-manager-prd    → PRD, 일정 관리
- backend-architect      → Firebase, 동기화 로직
- frontend-developer     → Flutter UI 구현
- qa-engineer            → 테스트 시나리오, Playwright
- ai-integration-specialist → 지연 분석 프롬프트
```

## 핵심 규칙
- 코드 생성 후 반드시 직접 실행해서 확인
- 이해 안 되면 에이전트에게 설명 요청 ("왜 이렇게 했어?")
- 세션 종료 전 `AUTHORING.hyeji.md` 체크리스트 업데이트
- `notes/` 폴더에 배운 내용 기록

## MCP 설치 명령어
```bash
# Notion MCP
claude mcp add --transport http notion https://mcp.notion.com/mcp

# GitHub MCP
claude mcp add --transport http github [GitHub MCP URL]

# Playwright MCP
claude mcp add playwright -s local -- cmd /c npx @playwright/mcp@latest
```

## Flutter 설치 후 실행 순서
```bash
flutter pub get          # 패키지 설치
flutter run              # 앱 실행
flutter test             # 테스트 실행
```
