---
marp: true
theme: default
paginate: true
backgroundColor: "#ffffff"
style: |
  section {
    font-family: 'Apple SD Gothic Neo', '맑은 고딕', sans-serif;
    font-size: 26px;
    padding: 48px;
  }
  section.cover {
    background: linear-gradient(135deg, #1F3864, #2E75B6);
    color: white;
    text-align: center;
    justify-content: center;
  }
  section.cover h1 { font-size: 56px; margin-bottom: 12px; }
  section.cover p  { font-size: 20px; opacity: 0.85; }
  h2 { color: #1F3864; border-bottom: 3px solid #2E75B6; padding-bottom: 8px; margin-bottom: 24px; }
  table { font-size: 22px; width: 100%; }
  th { background: #1F3864; color: white; }
  code { background: #F2F2F2; padding: 2px 8px; border-radius: 4px; font-size: 22px; }
  blockquote { border-left: 4px solid #2E75B6; background: #F0F6FF; padding: 12px 20px; margin: 16px 0; }
---

<!-- _class: cover -->

# 🔍 Delay Detective
### AI 기반 미루기 분석 & 태스크 재구성 앱

<br>

**중간 발표 — 12주차**
혜지 | Flutter · Claude API · Firebase

---

## 문제 & 솔루션 　　　　　　　　　　

> "할 일은 있는데… 왜 시작이 안 되지?"

기존 투두 앱은 **미룬 이유를 분석하지 않는다.**

<br>

**Delay Detective** 는 3단계로 해결한다.

| 단계 | 기능 |
|:---:|:---|
| 1️⃣ 감지 | 마감 초과 태스크를 자동으로 찾아낸다 |
| 2️⃣ 분석 | Claude AI가 3턴 인터뷰로 미루는 이유를 파악한다 |
| 3️⃣ 재구성 | 15분 단위 소태스크 3개로 쪼개서 제시한다 |

---

## 핵심 기능 3개 　　　　　　　　　　　　

**① 지연 감지**
마감일 초과 → 자동으로 🔴 빨간 배지 + 홈 화면 상단 고정

**② AI 인터뷰 (Claude API, 3턴 고정)**
```
턴 1: "왜 미루고 있나요?"
턴 2: "가장 막히는 부분이 뭔가요?"
턴 3: 공감 메시지 + 원인 요약 + 소태스크 생성
```

**③ 태스크 재구성**
"발표 자료 만들기" → ☐ 목차만 잡기 · ☐ 첫 장 쓰기 · ☐ 자료 1개 찾기

---

## 아키텍처 — 4-레이어 구조

```mermaid
graph TB
    P["🎨 Presentation\nHomeScreen · AddTask · Interview · Analysis"]
    A["⚙️ Application\nTaskProvider · AIProvider · SyncProvider"]
    D["📦 Domain\nTask · SubTask · DelayAnalysis"]
    Da["💾 Data\nHive(로컬) ↔ Firestore(클라우드) · Claude API"]

    P --> A --> D --> Da

    style P  fill:#DDEEFF,stroke:#2E75B6,color:#000
    style A  fill:#E8F5E9,stroke:#43A047,color:#000
    style D  fill:#FFF8E1,stroke:#F9A825,color:#000
    style Da fill:#FCE4EC,stroke:#E53935,color:#000
```

---

## 기술 스택 — 왜 선택했는지

```mermaid
mindmap
  root((Delay Detective))
    Flutter
      iOS · Android 단일 코드베이스
      Dart로 빠른 UI 개발
    Provider
      단순하고 예측 가능한 상태 관리
      ChangeNotifier로 화면 자동 갱신
    Hive
      오프라인에서도 데이터 유지
      NoSQL 키-값, 빠른 로컬 I/O
    Firestore
      실시간 클라우드 동기화
      멀티 디바이스 지원
    Claude API
      3턴 고정 인터뷰로 비용 제어
      미루는 이유 맞춤 분석
```

---

## 남은 계획 & 마무리 　　　　　　　　　

**12주차 남은 목표 (이번 주)**
- HiveService 구현 → 태스크 CRUD 동작
- Claude API 연결 → 인터뷰 2턴 확인
- HomeScreen · InterviewScreen 연결

<br>

**13~14주차**
알림 · 지연 감지 고도화 → QA → 최종 발표 준비

<br>

> 오늘 목표: 태스크 추가 → 지연 감지 → AI 인터뷰 **전체 흐름 시연**
