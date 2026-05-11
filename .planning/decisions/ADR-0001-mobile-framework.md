# ADR-0001: 모바일 프레임워크 선택

- 상태: Accepted
- 날짜: 2026-05-11
- 결정자: 혜지

## 배경

Delay Detective는 Android와 iOS 모두에서 동작하는 모바일 앱이 필요하다.
6주(10~14주차) 안에 혼자 개발해야 하며, Firebase/Hive 연동과 Anthropic API 호출이 핵심 기능이다.
프레임워크 선택이 개발 속도, 패키지 생태계, 유지보수에 직접 영향을 미친다.

## 고려한 대안

### 대안 A: Flutter (Dart)
- 장점:
  - 단일 코드베이스로 Android/iOS/Web 동시 지원
  - Firebase, Hive, Provider 공식 패키지 성숙도 높음
  - Google이 직접 관리하는 pub.dev 생태계
  - 세션 1에서 이미 프로젝트 세팅 완료
  - Anthropic API는 HTTP 패키지로 바로 호출 가능
- 단점:
  - Dart 언어 별도 학습 필요 (단, 문법이 단순함)
  - 네이티브 기능 일부는 채널(Platform Channel) 필요

### 대안 B: React Native (JavaScript/TypeScript)
- 장점:
  - JavaScript/TypeScript 기반으로 웹 개발 경험 활용 가능
  - 넓은 npm 생태계
- 단점:
  - 네이티브 브릿지 디버깅 오버헤드가 크다
  - Firebase React Native 패키지가 Flutter보다 설정 복잡
  - Hive 대응 로컬 DB(MMKV, AsyncStorage) 학습 추가 필요
  - 프로젝트 세팅을 처음부터 다시 해야 함

### 대안 C: 네이티브 (Swift + Kotlin)
- 장점:
  - 최상의 성능, 플랫폼 네이티브 UI/UX
  - iOS/Android 최신 기능 바로 접근 가능
- 단점:
  - iOS(Swift)와 Android(Kotlin) 코드를 각각 작성해야 함 → 사실상 2배 작업
  - 6주 일정으로는 현실적으로 불가능

## 결정

**대안 A — Flutter**를 선택한다.

## 이유

- 6주 일정에서 단일 코드베이스는 생존 조건이다
- 이미 세션 1에서 Flutter 프로젝트가 세팅되어 있어 즉시 개발 착수 가능
- Firebase + Hive + Provider 조합이 이 프로젝트에서 요구하는 모든 기능(오프라인 저장, 클라우드 동기화, 상태 관리)을 커버한다
- Dart는 타입 안전성이 강해 AI 에이전트가 생성한 코드의 오류를 컴파일 타임에 잡을 수 있다

## 결과 (예상되는 영향)

긍정:
- Android/iOS 동시 빌드 가능 → 발표 때 어느 기기에서도 시연 가능
- pub.dev의 공식 패키지로 안정적인 의존성 관리
- 위젯 기반 UI가 AI 인터뷰 채팅 화면 구현에 적합

부정 / 제약:
- 일부 네이티브 기능(알림 권한 등)은 플랫폼별 추가 설정 필요
- Dart를 처음 배운다면 초기 1~2일 학습 비용 발생

## 후속 작업

- [x] Flutter 프로젝트 기본 구조 생성 (세션 1 완료)
- [ ] `pubspec.yaml`에 전체 의존성 확정 (hive, firebase_core, provider 등)
- [ ] `flutter pub get` 오류 없이 통과 확인
