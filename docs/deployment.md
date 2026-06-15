# Delay Detective — 배포 가이드

## 사전 준비

| 도구 | 버전 | 확인 명령 |
|---|---|---|
| Flutter SDK | 3.x 이상 | `flutter --version` |
| Node.js | 18 이상 | `node --version` |
| Firebase CLI | 최신 | `firebase --version` |
| Android Studio / Xcode | 최신 | (GUI) |

---

## 1. 웹 배포 (Firebase Hosting)

### 1-1. Firebase Hosting 초기화 (최초 1회)

```bash
npm install -g firebase-tools
firebase login
firebase init hosting
```

선택 옵션:
- Existing project 선택 → 현재 Firebase 프로젝트 선택
- Public directory: `build/web`
- Single-page app: **Yes**
- GitHub Actions auto-deploy: 선택 사항

### 1-2. 빌드 & 배포

```bash
flutter build web --release
firebase deploy --only hosting
```

배포 후 URL 형식: `https://<project-id>.web.app`

### 1-3. 로컬 개발 서버 (Google OAuth 사용 시 포트 5000 고정)

```bash
flutter run -d chrome --web-port 5000
```

> Google Cloud Console에 `http://localhost:5000`이 승인된 Origin으로 등록되어 있음.
> 다른 포트 사용 시 `400: origin_mismatch` 오류 발생.

---

## 2. Android 배포

### 2-1. APK 빌드 (테스트 배포용)

```bash
flutter build apk --release
```

결과물: `build/app/outputs/flutter-apk/app-release.apk`

### 2-2. Google Play Console 배포

```bash
# AAB(Android App Bundle) 형식으로 빌드 — Play Store 요구 형식
flutter build appbundle --release
```

결과물: `build/app/outputs/bundle/release/app-release.aab`

**Google Play Console 업로드 순서:**
1. [Google Play Console](https://play.google.com/console) 접속
2. 앱 생성 → 내부 테스트 트랙 선택
3. AAB 파일 업로드
4. 테스터 이메일 등록
5. 테스터에게 링크 공유

### 2-3. 서명 키 설정 (프로덕션 배포 전 필수)

```bash
# 서명 키 생성
keytool -genkey -v -keystore key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias delay-detective
```

`android/key.properties` 파일 생성:
```properties
storePassword=<비밀번호>
keyPassword=<비밀번호>
keyAlias=delay-detective
storeFile=../key.jks
```

---

## 3. iOS 배포 (TestFlight)

> macOS + Xcode 필요

```bash
flutter build ios --release
```

이후 Xcode에서:
1. Product → Archive
2. Distribute App → App Store Connect
3. TestFlight에서 내부 테스터 초대

---

## 4. Firebase 설정 확인

### Firestore 보안 규칙

Firebase Console → Firestore → 규칙 탭에서 확인:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/tasks/{taskId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### Firebase Hosting 리라이트 규칙 (`firebase.json`)

```json
{
  "hosting": {
    "public": "build/web",
    "ignore": ["firebase.json", "**/.*", "**/node_modules/**"],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ]
  }
}
```

---

## 5. MCP 자동화 도구 설정

### 5-1. Playwright MCP (UI 자동 테스트)

```bash
# Claude Code에 Playwright MCP 추가
claude mcp add playwright -s local -- cmd /c npx @playwright/mcp@latest

# 앱 실행 후 Claude Code에서
/playwright test e2e/login.spec.ts
```

E2E 테스트 직접 실행:
```bash
cd e2e
npm install
npx playwright install chromium

# 별도 터미널에서 앱 먼저 실행
flutter run -d chrome --web-port 5000

# 테스트 실행
npx playwright test
npx playwright show-report
```

### 5-2. Notion MCP (분석 결과 저장)

```bash
# Claude Code에 Notion MCP 추가
claude mcp add --transport http notion https://mcp.notion.com/mcp
```

설정 후 Claude Code에서:
```
/notion 페이지 생성: "Delay Detective 지연 분석 결과 — 2026-06-15"
```

### 5-3. GitHub MCP (이슈 자동 생성)

```bash
# Claude Code에 GitHub MCP 추가
claude mcp add --transport http github https://api.githubcopilot.com/mcp/v1
```

설정 후 Claude Code에서:
```
/github issue 생성: "로그인 화면 버튼 간격 개선" — label: enhancement
```

---

## 6. CI/CD (GitHub Actions)

`.github/workflows/deploy.yml`:

```yaml
name: Deploy to Firebase Hosting

on:
  push:
    branches: [main]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.x'
          
      - name: Install dependencies
        run: flutter pub get
        
      - name: Build web
        run: flutter build web --release
        
      - name: Deploy to Firebase Hosting
        uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: ${{ secrets.GITHUB_TOKEN }}
          firebaseServiceAccount: ${{ secrets.FIREBASE_SERVICE_ACCOUNT }}
          projectId: <your-firebase-project-id>
```

---

## 7. 체크리스트 (배포 전 확인)

- [ ] `flutter build web --release` 성공
- [ ] Firebase Hosting 보안 규칙 적용 확인
- [ ] Google OAuth 승인된 도메인에 배포 URL 추가
  - Firebase Console → Authentication → Sign-in method → Google → 승인된 도메인
- [ ] Anthropic API 키 환경변수 설정 확인
- [ ] Firestore 인덱스 설정 (복합 쿼리 사용 시)
- [ ] `flutter test` 통과 확인
- [ ] E2E 테스트 통과 확인
