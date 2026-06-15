# Delay Detective — 테스트 가이드

## 1. 테스트 종류

| 종류 | 위치 | 실행 명령 |
|---|---|---|
| 단위 테스트 | `test/unit_test.dart` | `flutter test test/unit_test.dart` |
| 위젯 테스트 | `test/widget_test.dart` | `flutter test test/widget_test.dart` |
| 전체 Flutter 테스트 | `test/` | `flutter test` |
| E2E (Playwright) | `e2e/` | `cd e2e && npx playwright test` |

## 2. Flutter 단위 테스트

### 실행
```bash
flutter test
```

### 현재 테스트 커버리지 (11개)

| 그룹 | 테스트 | 결과 |
|---|---|---|
| `Task.shouldBeDelayed` | 과거 마감 → true | ✅ |
| `Task.shouldBeDelayed` | 미래 마감 → false | ✅ |
| `Task.shouldBeDelayed` | 완료된 태스크 → false | ✅ |
| `Task.shouldBeDelayed` | dueDate 없음 → false | ✅ |
| `SubTask isDone 토글` | 기본값 false | ✅ |
| `SubTask isDone 토글` | 토글 동작 | ✅ |
| `Task.toMap / fromMap` | 직렬화 왕복 일치 | ✅ |
| `Conflict Resolution` | newer > older | ✅ |
| `Conflict Resolution` | 동일 timestamp 충돌 | ✅ |
| `Task 생성` | 기본값 확인 | ✅ |
| `Task.shouldBeDelayed` | 내일 마감 → false | ✅ |

## 3. E2E 테스트 (Playwright)

### 설치
```bash
cd e2e
npm install
npx playwright install chromium
```

### 실행 (앱을 먼저 켜야 함)
```bash
# 터미널 1: 앱 실행
flutter run -d chrome --web-port 5000

# 터미널 2: 테스트 실행
cd e2e
npx playwright test

# 결과 리포트 보기
npx playwright show-report
```

### 현재 E2E 테스트 파일

| 파일 | 내용 | 상태 |
|---|---|---|
| `login.spec.ts` | 로그인 화면 렌더링, 버튼 클릭 반응 | 실행 가능 |
| `navigation.spec.ts` | 비인증 → 로그인 리다이렉트, 스플래시 | 실행 가능 |
| `task.spec.ts` | 태스크 추가/지연/분석/통계 | skip (Firebase 필요) |

### Firebase 인증이 필요한 테스트

`task.spec.ts`는 로그인 상태가 필요해서 현재 skip 처리됨.  
실행하려면 Firebase Emulator 설정 필요:

```bash
# Firebase Emulator 설치
npm install -g firebase-tools
firebase emulators:start --only auth,firestore

# 환경변수 설정 후 테스트
FIREBASE_AUTH_EMULATOR_HOST=localhost:9099 npx playwright test
```

## 4. 수동 테스트 시나리오

| 시나리오 | 확인 항목 |
|---|---|
| 앱 최초 실행 | 로그인 화면 표시 |
| Google 로그인 | 로그인 후 홈 화면 이동 |
| 태스크 추가 | 제목/날짜 입력 → 목록에 나타남 |
| 마감일 초과 | 🔥 배지 + 주황 강조 표시 |
| AI 분석 시작 | 인터뷰 화면 → 소태스크 생성 |
| 소태스크 체크 | 체크 후 앱 재시작 → 유지됨 |
| 오프라인 동작 | 비행기 모드 → 태스크 추가/조회 가능 |
| 로그아웃 | 프로필 버튼 → 로그인 화면으로 이동 |
| 통계 화면 | 완료율, 지연 현황 수치 정확 |

## 5. 알려진 제한사항

- Firebase Auth가 필요한 기능은 Playwright 자동화 불가 (Google OAuth 팝업 자동화 제한)
- iOS 테스트는 macOS 환경 필요
- Anthropic API 응답은 네트워크 상태에 따라 다를 수 있음
