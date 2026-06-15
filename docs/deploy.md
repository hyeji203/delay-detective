# Delay Detective — 배포 가이드

## 1. 빌드 종류

| 모드 | 명령 | 용도 |
|---|---|---|
| debug | `flutter run --debug` | 개발 중 핫 리로드, DevTools |
| release | `flutter build apk --release` | 실배포, 성능 최적화 |
| profile | `flutter run --profile` | 성능 프로파일링 |

```bash
# 웹 디버그 (Google OAuth 포트 고정)
flutter run -d chrome --web-port 5000

# Android 릴리스 APK
flutter build apk --release --split-per-abi

# Android Play Store (AAB)
flutter build appbundle --release

# 웹 릴리스
flutter build web --release
```

## 2. 서명 / 인증서 관리

### Android 릴리즈 서명

| 파일 | 위치 | git |
|---|---|---|
| 릴리즈 키스토어 | `android/upload-keystore.jks` | ❌ 제외 |
| 키 설정 | `android/key.properties` | ❌ 제외 |
| 디버그 키스토어 | `~/.android/debug.keystore` | ❌ 제외 |

`android/key.properties` 형식:
```properties
storePassword=<비밀번호>
keyPassword=<비밀번호>
keyAlias=upload
storeFile=../upload-keystore.jks
```

### Firebase용 SHA-1 추출 (디버그)
```bash
keytool -list -rfc \
  -keystore ~/.android/debug.keystore \
  -alias androiddebugkey -storepass android \
  | openssl x509 -noout -fingerprint -SHA1
```

## 3. 환경별 설정

현재 프로젝트는 단일 Firebase 프로젝트를 사용합니다.  
향후 개발/운영 분리 시:

```
.env.dev   → Firebase 개발 프로젝트, verbose 로깅
.env.prod  → Firebase 운영 프로젝트, 로깅 최소화
```

- `.env.example`만 git에 커밋
- 실제 `.env*`는 `.gitignore` 처리
- API 키·시크릿은 절대 코드에 하드코딩하지 않음

현재 Anthropic API 키 위치: `lib/data/remote/ai_service.dart` → 환경변수로 이전 권장

## 4. 배포 채널

| 채널 | 대상 | 방법 |
|---|---|---|
| Firebase App Distribution | 내부 테스터 | APK 업로드 → 이메일 초대 |
| Google Play 내부 테스트 | 내부 테스터 | AAB 업로드 → 이메일 초대 |
| Firebase Hosting | 웹 | `firebase deploy --only hosting` |
| 직접 설치 (사이드로드) | 1인 데모 | APK를 기기에 직접 복사 |

### Firebase Hosting 배포
```bash
npm install -g firebase-tools
firebase login
flutter build web --release
firebase deploy --only hosting
```

### Google Play 내부 테스트
1. [play.google.com/console](https://play.google.com/console) → 앱 생성
2. 테스트 → 내부 테스트 → 새 버전 만들기
3. `build/app/outputs/bundle/release/app-release.aab` 업로드

## 5. 버전 관리 규칙 (SemVer)

`pubspec.yaml`의 `version` 필드: `MAJOR.MINOR.PATCH+BUILD`

| 버전 | 언제 올림 |
|---|---|
| MAJOR | 호환 불가 변경 (데이터 스키마 변경 등) |
| MINOR | 기능 추가 (하위 호환 유지) |
| PATCH | 버그 수정 |
| BUILD (+숫자) | 스토어 제출마다 1씩 증가 (필수) |

```yaml
# pubspec.yaml 예시
version: 1.0.0+1   # 첫 릴리즈
version: 1.0.1+2   # 버그 수정
version: 1.1.0+3   # 기능 추가
```

## 6. 롤백 방법

### 앱 롤백
```bash
# 이전 버전 태그로 체크아웃
git checkout v1.0.0

# 이전 버전으로 빌드 & 재배포
flutter build appbundle --release
# → Play Console에서 이전 버전으로 출시 전환
```

### Firebase Firestore 롤백
- Firebase Console → Firestore → 데이터 내보내기/복원
- 중요 변경 전 `firestore export` 백업 권장

### 웹 롤백 (Firebase Hosting)
```bash
# 이전 배포 버전 목록 확인
firebase hosting:releases:list

# 특정 버전으로 롤백
firebase hosting:clone <release-id>:live <project-id>:live
```

## 보안 체크리스트

- [x] `android/upload-keystore.jks` → `.gitignore` 등록
- [x] `android/key.properties` → `.gitignore` 등록
- [x] `.env` → `.gitignore` 등록
- [x] Firestore 보안 규칙 — `uid == request.auth.uid` 검증
- [x] Google 로그인 — Firebase Auth 사용, 직접 비밀번호 저장 없음
- [x] HTTPS 강제 — Firebase Hosting 기본 HTTPS
- [ ] Anthropic API 키 — 현재 클라이언트 코드에 있음 → 서버 프록시 이전 권장
- [x] 통신 암호화 — Firestore SDK 기본 TLS
- [x] 로컬 저장 민감정보 — Hive에 API 키 저장 없음
