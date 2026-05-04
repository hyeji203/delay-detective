# Delay Detective

> AI-Powered Procrastination Analyzer with Offline-First Architecture

미루는 태스크를 AI가 감지하고, 왜 미루는지 분석해서, 실행 가능한 단계로 재구성해주는 Flutter 앱

## 주요 기능

- **지연 감지**: 마감일 초과 또는 반복 미완료 태스크 자동 감지
- **AI 분석 인터뷰**: "왜 미루고 있나요?" — Claude API 기반 대화형 분석
- **태스크 재구성**: AI가 큰 태스크를 15분 단위 소태스크로 분해
- **오프라인 지원**: 네트워크 없이도 완전 동작 (Hive 로컬 DB)
- **자동 동기화**: 네트워크 복구 시 Firestore와 자동 동기화
- **통계 대시보드**: 나의 미루기 패턴 시각화

## 기술 스택

| 계층 | 기술 |
|---|---|
| 프론트엔드 | Flutter (Dart) |
| 상태 관리 | Provider |
| 온라인 DB | Firebase Firestore |
| 로컬 DB | Hive |
| AI | Anthropic API (Claude) |
| 테스트 | Flutter Test + Playwright MCP |
| 배포 | GitHub Actions + Vercel |

## AI 에이전트 팀

이 프로젝트는 5개의 서브에이전트가 협업해서 개발했습니다:

| 에이전트 | 역할 |
|---|---|
| `product-manager-prd` | PRD 작성, 일정 관리 |
| `backend-architect` | Firebase, Hive, 동기화 로직 |
| `frontend-developer` | Flutter UI 구현 |
| `qa-engineer` | 테스트, Playwright 자동화 |
| `ai-integration-specialist` | 지연 분석 프롬프트 엔지니어링 |

## MCP 자동화 도구

- **Notion MCP**: 지연 분석 결과 저장
- **GitHub MCP**: 버그를 GitHub Issues로 자동 생성
- **Playwright MCP**: UI 기능 자동 테스트

## 시작하기

### 필요한 것
- Flutter SDK 3.x 이상
- Firebase 프로젝트
- Anthropic API 키

### 설치
```bash
flutter pub get
```

### 환경 변수 설정
```
ANTHROPIC_API_KEY=your_key_here
```

### 실행
```bash
flutter run
```

## 개발 기간
6주 (세션 2~7) — Shingu College AI 수업 프로젝트

---

*AUTHORING.hyeji.md에서 전체 설계 문서를 확인하세요.*
