# Delay Detective

> AI-Powered Procrastination Analyzer with Offline-First Architecture

미루는 태스크를 AI가 감지하고, 왜 미루는지 분석해서, 실행 가능한 단계로 재구성해주는 Flutter 앱

## 주요 기능

- **Google 로그인**: Firebase Auth 기반, 멀티 디바이스 동기화 지원
- **지연 감지**: 마감일 초과 또는 반복 미완료 태스크 자동 감지 (🔥 표시)
- **AI 분석 인터뷰**: "왜 미루고 있나요?" — Claude API 기반 3턴 대화형 분석
- **태스크 재구성**: AI가 큰 태스크를 15분 단위 소태스크로 분해
- **오프라인 지원**: 네트워크 없이도 완전 동작 (Hive 로컬 DB)
- **자동 동기화**: 네트워크 복구 시 Firestore와 자동 동기화 (Last-Write-Wins)
- **캘린더 뷰**: 날짜별 태스크 배치, 탭 시 해당 날짜 태스크 바텀시트
- **통계 대시보드**: 완료율, 지연 현황, AI 분석 건수 시각화

## 기술 스택

| 계층 | 기술 |
|---|---|
| 프론트엔드 | Flutter (Dart) |
| 상태 관리 | Provider + ChangeNotifierProxyProvider |
| 인증 | Firebase Auth (Google Sign-In) |
| 온라인 DB | Firebase Firestore |
| 로컬 DB | Hive (오프라인 우선) |
| AI | Anthropic API (Claude) |
| 테스트 | Flutter Test + Playwright (E2E) |

## 화면 구성

| 화면 | 설명 |
|---|---|
| SplashScreen | 앱 시작 로딩 (인증 상태 확인) |
| LoginScreen | Google 로그인 버튼 |
| HomeScreen | 캘린더 + 오늘의 태스크 |
| TaskListScreen | 진행중 / 완료 탭 목록 |
| AddTaskScreen | 태스크 추가 / 수정 |
| InterviewScreen | AI 지연 분석 인터뷰 |
| AnalysisResultScreen | 분석 결과 + 소태스크 목록 |
| HistoryScreen | AI 분석 이력 |
| StatsScreen | 통계 대시보드 |

## 오프라인-온라인 동기화 구조

```
📱 온라인: Provider ↕ Firestore (실시간)
📱 오프라인: Provider ↕ Hive (로컬)
🔄 복구 시: sync_queue → Firestore 업로드 (updatedAt 비교)
```

Conflict Resolution: Last-Write-Wins (updatedAt Timestamp 기준)

## AI 에이전트 팀

| 에이전트 | 역할 |
|---|---|
| `product-manager-prd` | PRD 작성, 일정 관리 |
| `backend-architect` | Firebase, Hive, 동기화 로직 |
| `frontend-developer` | Flutter UI 구현 |
| `qa-engineer` | 테스트, Playwright 자동화 |
| `ai-integration-specialist` | 지연 분석 프롬프트 엔지니어링 |

## MCP 자동화 도구

| MCP | 용도 |
|---|---|
| Playwright MCP | UI 기능 자동 테스트 |
| Notion MCP | 지연 분석 결과 저장 |
| GitHub MCP | 버그를 GitHub Issues로 자동 생성 |

## 시작하기

### 필요한 것

- Flutter SDK 3.x 이상
- Firebase 프로젝트 (Auth + Firestore 활성화)
- Anthropic API 키
- Node.js 18+ (Playwright 테스트용)

### 설치 및 실행

```bash
# 의존성 설치
flutter pub get

# 웹 (Google OAuth 포트 5000 고정)
flutter run -d chrome --web-port 5000

# Android
flutter run -d android

# iOS (macOS 필요)
flutter run -d ios
```

### 환경 설정

1. Firebase 프로젝트 생성 후 `flutterfire configure` 실행
2. `lib/services/ai_service.dart`에서 Anthropic API 키 설정

### E2E 테스트

```bash
cd e2e
npm install
npx playwright install chromium
npx playwright test
```

### 빌드

```bash
# 웹 프로덕션 빌드
flutter build web --release

# Android APK
flutter build apk --release

# Android Play Store
flutter build appbundle --release
```

## 배포

`docs/deployment.md` 참조

## 개발 기간

6주 (세션 2~7) — Shingu College AI 수업 프로젝트

---

*전체 설계 문서: `AUTHORING.hyeji.md`*  
*배포 가이드: `docs/deployment.md`*  
*아키텍처: `docs/architecture.md`*
