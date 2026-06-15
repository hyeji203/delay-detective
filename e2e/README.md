# Delay Detective — E2E 테스트 (Playwright)

## 개요

Flutter Web 앱 `http://localhost:5000` 을 대상으로 하는 Playwright 기반 E2E 테스트 모음입니다.

## 설치

```bash
# e2e/ 폴더에서 실행
cd e2e
npm install
npx playwright install chromium
```

## 실행

```bash
# 전체 테스트 실행
npm test
# 또는
npx playwright test

# UI 모드로 실행 (인터랙티브)
npm run test:ui

# 특정 파일만 실행
npx playwright test login.spec.ts

# HTML 리포트 확인
npm run test:report
```

## 테스트 파일 구성

| 파일 | 설명 | 인증 필요 |
|---|---|---|
| `login.spec.ts` | 로그인 화면 렌더링, 버튼 클릭 반응 | 불필요 |
| `navigation.spec.ts` | 비인증 리다이렉트, 스플래시 화면 | 불필요 (인증 테스트는 skip) |
| `task.spec.ts` | 태스크 CRUD, 지연 감지, AI 분석, 통계 | 필요 (현재 전체 skip) |

## Firebase Auth 모킹 — 전체 커버리지 확보

`task.spec.ts`의 스킵된 테스트를 실행하려면 인증 상태가 필요합니다.

### 방법 1: Firebase Emulator 사용 (권장)

```bash
# 1. Firebase Emulator 시작
firebase emulators:start --only auth,firestore

# 2. 앱에서 emulator 연결 설정 (firebase_options.dart 또는 main.dart)
#    FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
#    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);

# 3. 앱 빌드 및 서버 실행
flutter build web && cd build/web && python -m http.server 5000

# 4. 인증 세션 저장
npx playwright codegen http://localhost:5000 --save-storage=auth.json
```

### 방법 2: 테스트 계정 + storageState

```typescript
// playwright.config.ts에 추가
use: {
  storageState: 'e2e/auth.json',  // 저장된 인증 세션
}
```

## 스크린샷

실패 시 자동으로 `test-results/` 폴더에 저장됩니다.  
수동 스크린샷은 `e2e/screenshots/` 폴더에 저장됩니다.

## Flutter Web 선택자 팁

Flutter Web은 표준 HTML ID 대신 시맨틱 트리를 사용합니다.

```typescript
// 텍스트 기반 선택 (권장)
page.getByText('Google로 계속하기')
page.getByRole('button', { name: '저장' })

// Flutter 시맨틱 요소
page.locator('flt-semantics')
page.locator('flt-scene-host')

// 데이터 속성 (앱에 Semantics 위젯 추가 시)
page.locator('[data-testid="task-item"]')
```

## 주의 사항

- Flutter 앱 부트스트랩에 시간이 걸리므로 `waitForLoadState('networkidle')` 또는 충분한 타임아웃 설정이 필요합니다.
- Google OAuth 팝업은 테스트 환경에서 차단되므로 `page.on('popup', popup => popup.close())`로 처리합니다.
- 캔버스 렌더링 모드(`--web-renderer canvaskit`)에서는 DOM 선택자가 제한될 수 있습니다. HTML 렌더러(`--web-renderer html`) 사용을 권장합니다.
