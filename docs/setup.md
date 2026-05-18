# Setup

새 컴퓨터에서 5분 안에 따라할 수 있도록 작성.

---

## 1. 사전 요구

| 도구 | 버전 | 확인 명령 |
|---|---|---|
| Git | 2.40+ | `git --version` |
| Flutter SDK | 3.19+ | `flutter --version` |
| Dart | 3.3+ (Flutter에 포함) | `dart --version` |
| Android Studio | 2023.x+ | 설치 확인 |
| VS Code (선택) | 최신 | - |

### Flutter 설치

#### 윈도우
```powershell
winget install Google.Flutter
```
설치 후 시스템 환경변수 PATH에 `C:\flutter\bin` 추가.

#### macOS
```bash
brew install --cask flutter
```

#### 공통 — 설치 확인
```bash
flutter doctor
```
`flutter doctor` 실행 후 ✓ 체크가 모두 초록이어야 한다.  
Android toolchain과 Connected device 항목이 가장 자주 문제가 생긴다.

---

## 2. 클론

```bash
git clone https://github.com/hyeji203/delay-detective.git
cd delay-detective
```

---

## 3. 의존성 설치

```bash
flutter pub get
```

성공 시: `Got dependencies!` 메시지 출력.

---

## 4. 환경 변수

프로젝트 루트에 `.env` 파일을 직접 만든다 (`.env.example`은 커밋되어 있음):

```bash
# Windows PowerShell
Copy-Item .env.example .env

# macOS / Linux
cp .env.example .env
```

`.env` 파일을 열어 아래 값을 채운다:

```
ANTHROPIC_API_KEY=sk-ant-...
```

각 키의 의미:
- `ANTHROPIC_API_KEY` — [Anthropic Console](https://console.anthropic.com)에서 발급. API Keys 메뉴 → Create Key

### Firebase 설정 (추가로 필요)

1. [Firebase Console](https://console.firebase.google.com)에서 `delay-detective` 프로젝트 접속
2. 프로젝트 설정 → 내 앱 → `google-services.json` 다운로드
3. 다운로드한 파일을 `android/app/` 폴더에 복사

> iOS 빌드 시: `GoogleService-Info.plist` 를 `ios/Runner/` 에 복사

---

## 5. 첫 실행

에뮬레이터 또는 실기기를 연결한 뒤:

```bash
# 연결된 기기 목록 확인
flutter devices

# 앱 실행
flutter run
```

성공 시: 기기 화면에 **"Delay Detective"** 앱이 실행되고 `HomeScreen`(태스크 목록 화면)이 보인다.

> Firebase 연결 전에는 `anonymous-placeholder` UID로 Hive 로컬 저장만 동작한다. 태스크 추가/삭제는 Firebase 없이도 확인 가능.

---

## 6. 자주 묻는 문제

### Q1. `flutter: command not found` 가 나와요
→ PATH 환경변수에 Flutter SDK 경로가 없는 것.  
윈도우: 시스템 속성 → 환경변수 → Path에 `C:\flutter\bin` 추가 후 터미널 재시작.  
macOS: `~/.zshrc` 에 `export PATH="$PATH:/flutter/bin"` 추가 후 `source ~/.zshrc`.

### Q2. `flutter pub get` 중 패키지 다운로드 오류
→ 회사/학교 네트워크 방화벽 문제일 수 있음.  
핫스팟으로 전환 후 재시도. 또는 `flutter pub get --no-example`.

### Q3. 에뮬레이터/실기기가 `flutter devices`에 안 잡혀요
→ Android: Android Studio에서 AVD Manager로 에뮬레이터 먼저 실행.  
실기기: USB 디버깅 활성화 (설정 → 개발자 옵션 → USB 디버깅 ON).

### Q4. `google-services.json` 파일이 없다는 오류
→ Firebase 연결 전 단계라면 `android/app/google-services.json.example`을 복사해 임시 사용.  
Firebase를 연결하려면 위 4번 항목 참고.

### Q5. Android Gradle 동기화 실패 (`Could not resolve...`)
→ Android Studio → File → Invalidate Caches / Restart.  
또는 `android/` 폴더에서 `./gradlew clean` 실행 후 `flutter run` 재시도.

---

## 관련 문서

- [아키텍처 설계](./architecture.md) — 4-레이어 구조 및 데이터 흐름
- [WBS & 일정](../.planning/02-wbs.md) — 개발 일정표
- [ADR-0001](../.planning/decisions/ADR-0001-mobile-framework.md) — Flutter 선택 이유
