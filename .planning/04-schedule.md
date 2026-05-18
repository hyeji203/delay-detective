1# 04-schedule.md — 6주 개발 일정

**버전**: v1.1  
**작성일**: 2026-05-11 / **최종 수정**: 2026-05-11  
**기간**: 10주차 ~ 14주차 (개발) + 15주차 (최종 발표)  
**중간 발표**: 12주차

---

## 전체 일정 개요

```
10주차  기획 & 설계 완성         ✅ 완료
11주차  데이터 레이어 + AI 시스템 기초
12주차  UI 구현 + 중간 발표 ⭐
13주차  알림/감지 + 테스트 & QA
14주차  배포 + 발표 준비
15주차  최종 발표 🏁
```

---

## 10주차 — 기획 & 설계 ✅ 완료 (2026-05-11)

**목표**: 코드 한 줄 쓰기 전에 설계를 완전히 끝낸다

| 항목 | 내용 |
|---|---|
| **주요 작업** | 기획 문서 작성, DB 스키마 설계, AI 플로우 설계, 개발 환경 세팅 |
| **담당 에이전트** | `product-manager-prd`, `backend-architect` |

### 주차별 산출물
- [x] `00-vision.md` — 비전 & 목표
- [x] `01-requirements.md` — 사용자 시나리오 + MoSCoW
- [x] `02-wbs.md` — WBS (3단계)
- [x] `04-schedule.md` — 6주 일정표 + 위험 요소 5개
- [x] `meeting-01.md` — 세션 2 회의록 & 결정 사항
- [x] `progress-01.md` — 진행률 보고서
- [x] `unknowns.md` — 모르는 영역 질문 목록 26개
- [x] `decisions/ADR-0001` — Flutter 선택 이유
- [x] `decisions/ADR-0002` — Provider 선택 이유
- [x] `decisions/ADR-0003` — Firebase+Hive 선택 이유
- [x] `BONUS.md` — 가산점 신청서 (+6점 목표)
- [x] `AUTHORING.hyeji.md` v0.4 업데이트
- [x] GitHub 커밋 & push 완료 (커밋: c132e4e)
- [ ] `03-architecture.md` — Firestore/Hive 스키마 → **11주차 시작 시 backend-architect 에이전트**
- [ ] Firebase `google-services.json` 연결 확인 → **11주차 시작 시 첫 번째 작업**

### 검증 결과
- ✅ 기획 문서 10개 GitHub push 완료
- ✅ ADR 3개로 주요 기술 선택 근거 문서화
- ✅ 5가지 자가 점검 질문 모두 답변 가능
- ⏭️ Firebase 연결 및 스키마 설계는 11주차로 이월 (정상 범위)

---

## 11주차 — 데이터 레이어 + AI 시스템 기초

**목표**: 화면 없이도 데이터 저장·동기화·AI 호출이 동작한다

| 항목 | 내용 |
|---|---|
| **주요 작업** | 모델 클래스, HiveService, FirestoreService, SyncService, AIService 구현 |
| **담당 에이전트** | `backend-architect`, `ai-integration-specialist` |

### 주차별 산출물
- [x] `Task`, `DelayAnalysis`, `SubTask`, `InterviewTurn` 모델 클래스 (2026-05-18 완료)
- [ ] `HiveService` (로컬 CRUD) — 스켈레톤 생성, 실제 구현 필요
- [ ] `FirestoreService` (클라우드 CRUD) — 스켈레톤 생성, 실제 구현 필요
- [ ] Firebase Auth (익명 로그인) — 스켈레톤 생성, 실제 구현 필요
- [ ] `SyncService` (Hive ↔ Firestore, Timestamp 기반) — 스켈레톤 생성, 실제 구현 필요
- [ ] `connectivity_plus` 네트워크 감지기
- [ ] `AIService` (Anthropic API 연동, 대화 맥락 관리) — 스켈레톤 생성, 실제 구현 필요
- [ ] 시스템 프롬프트 초안 (인터뷰 시작, 후속 질문, 결과 생성)
- [ ] AI 응답 파싱기 (공감 / 원인 / 소태스크 분리)

### 검증 방법
- `flutter test` — HiveService, FirestoreService 단위 테스트 통과
- 디버그 콘솔에서 AI 인터뷰 2턴 → 소태스크 3개 출력 확인
- 오프라인 상태에서 태스크 저장 → 온라인 전환 후 Firestore에 동기화 확인

---

## 12주차 — UI 구현 + 중간 발표 ⭐

**목표**: Must Have 기능이 동작하는 앱을 중간 발표에서 시연한다

| 항목 | 내용 |
|---|---|
| **주요 작업** | 화면 5개 구현, Provider 연결, 중간 발표 준비 |
| **담당 에이전트** | `frontend-developer`, `ai-integration-specialist` |

### 주차별 산출물
- [ ] 앱 테마 & 색상 시스템
- [ ] `HomeScreen` — 태스크 목록, 지연 태스크 빨간 강조
- [ ] `AddTaskScreen` — 태스크 생성/편집
- [ ] `InterviewScreen` — AI 챗봇 채팅 UI (2~3턴)
- [ ] `AnalysisResultScreen` — 공감 + 원인 + 소태스크 결과 화면
- [ ] `TaskProvider`, `AIProvider` 연결
- [x] **중간 발표 슬라이드** — `docs/slides-midterm.md` 초안 완료 (2026-05-18)
- [ ] **중간 발표 데모 시나리오** (시나리오 A 기준)

### 중간 발표 구성 (12주차)
```
0-2분: 앱 소개 & 문제 정의
2-5분: 핵심 기능 시연 (태스크 추가 → 지연 감지 → AI 인터뷰 → 결과)
5-8분: 기술 스택 & 서브에이전트 협업 방식
8-10분: 남은 개발 계획
```

### 검증 방법
- 실기기(Android 또는 iOS)에서 앱 실행 확인
- 시나리오 A 전체 플로우 (태스크 등록 → AI 인터뷰 → 소태스크 출력) 시연 성공
- 오프라인 상태에서도 태스크 목록 표시 확인

---

## 13주차 — 알림/감지 + 테스트 & QA

**목표**: Should Have 기능 완성 + 버그 없는 안정적인 앱

| 항목 | 내용 |
|---|---|
| **주요 작업** | 푸시 알림, 지연 감지 고도화, 단위/통합/UI 자동화 테스트 |
| **담당 에이전트** | `qa-engineer`, `backend-architect` |

### 주차별 산출물
- [ ] 자동 지연 감지 로직 (마감일 초과 → 상태 자동 전환)
- [ ] 수동 지연 표시 버튼 ("이거 미루고 있어요")
- [ ] 지연 상태 시각화 (배지, 정렬)
- [ ] D-3, D-1, D-day 로컬 알림 스케줄러
- [ ] `HistoryScreen` — AI 인터뷰 히스토리 목록
- [ ] `SyncProvider` — 동기화 상태 배너 UI
- [ ] `HiveService` / `FirestoreService` / `SyncService` 단위 테스트
- [ ] 오프라인→온라인 전환 통합 테스트
- [ ] Playwright MCP 자동화 테스트 (태스크 CRUD + AI 인터뷰 플로우)

### 검증 방법
- `flutter test` 전체 통과 (단위 + 통합)
- Playwright 자동화 테스트 스크린샷 캡처 성공
- D-3 알림이 실기기에서 정상 수신 확인
- 오프라인 5분 사용 후 온라인 전환 → 데이터 손실 없음 확인

---

## 14주차 — 배포 & 최종 발표 준비

**목표**: 실제 설치 가능한 앱 + 완성된 발표 자료

| 항목 | 내용 |
|---|---|
| **주요 작업** | Android/iOS 빌드, 문서 완성, 발표 준비 |
| **담당 에이전트** | `qa-engineer`, `product-manager-prd` |

### 주차별 산출물
- [ ] Android APK 빌드 (또는 AAB)
- [ ] iOS TestFlight 업로드 (또는 실기기 직접 설치)
- [ ] Notion MCP 연동 테스트 (분석 결과 자동 저장)
- [ ] `README.md` 최종본 (스크린샷, 설치 방법 포함)
- [ ] `AUTHORING.hyeji.md` v1.0 최종본
- [ ] LLM Wiki 5개 문서 완성
- [ ] **최종 발표 슬라이드** (25분 분량)
- [ ] **앱 데모 시나리오 스크립트** (Q&A 예상 답변 포함)

### 최종 발표 구성 (15주차)
```
0-3분:   앱 소개 & 문제 정의 ("왜 만들었나")
3-8분:   핵심 기능 라이브 데모
8-18분:  ⭐ AI 에이전트 팀 협업 방식 (가산점 핵심)
         • 5개 서브에이전트 역할 & 협업 플로우
         • MCP 3개 활용 (Notion, GitHub, Playwright)
         • AUTHORING.hyeji.md 부트스트랩 방식
18-22분: 기술 도전과 해결 (동기화 Conflict Resolution, AI 프롬프트)
22-25분: Q&A
```

### 검증 방법
- 실기기에서 APK 설치 후 전체 플로우 시연 성공
- 발표 슬라이드 25분 리허설 완료
- LLM Wiki 5개 문서 모두 채워져 있는지 확인

---

## 15주차 — 최종 발표 🏁

- 발표 당일 시연 기기 충전 확인
- 오프라인 환경에서도 앱 동작 확인 (Hive 기반)
- Q&A 예상 질문 5개 준비

---

## 위험 요소 5개 & 대응 방안

| # | 위험 요소 | 발생 가능성 | 영향도 | 대응 방안 |
|---|---|---|---|---|
| R1 | **Anthropic API 응답 지연 / 비용 초과** | 중 | 높 | 개발 중 mock 응답 사용. API 호출에 캐싱 적용. 세션당 호출 횟수 상한 설정 |
| R2 | **Hive ↔ Firestore 동기화 충돌** | 중 | 중 | Timestamp Last-Write-Wins 기본 적용. 동일 Timestamp일 때만 사용자 선택 다이얼로그 표시 |
| R3 | **12주차 중간 발표 전 UI 미완성** | 높 | 높 | Must Have 6개 기능을 11주차 말까지 완료 목표. `HistoryScreen` 등 Should Have는 13주차로 이동 허용 |
| R4 | **Firebase 설정 오류 (google-services.json)** | 낮 | 높 | 10주차에 Firebase 연결 테스트를 최우선으로 완료. 오류 시 Hive 단독으로 먼저 진행 |
| R5 | **Flutter / 패키지 버전 호환성 충돌** | 중 | 중 | `pubspec.yaml`에 버전 고정. 신규 패키지 추가 전 pub.dev 호환성 확인 필수 |

### 위험 대응 우선순위
```
R3 (중간 발표 미완성) → 가장 먼저 대비
  대책: 11주차 목요일 기준으로 Must Have 완료 여부 점검
  
R1 (API 비용) → 개발 초기부터 mock 사용
  대책: AIService에 mock 모드 스위치 추가 (환경변수로 전환)
  
R4 (Firebase 오류) → 10주차 첫 번째 할 일
  대책: 기획 완료 직후 Firebase 연결 테스트 실행
```
