---
marp: true
theme: default
paginate: true
size: 16:9
header: "Delay Detective — 최종 발표"
footer: "혜지 | Shingu College AI 앱프로그래밍응용 | 2026"
---

# Delay Detective
### AI-Powered Procrastination Analyzer

> "미루는 습관을 AI가 감지하고, 이유를 분석하고, 실행 가능한 단계로 재구성해주는 앱"

---

## 앱 소개 & 데모 (0:00 ~ 0:40)

**[데모 영상 30초 재생]**

| 기능 | 설명 |
|---|---|
| 🔥 지연 감지 | 마감 초과 태스크 자동 강조 |
| 💬 AI 인터뷰 | "왜 미루고 있나요?" Claude 분석 |
| ✂️ 재구성 | 큰 태스크 → 15분 소태스크 분해 |
| 🔄 오프라인 | Hive 로컬 DB, 네트워크 없이도 동작 |

---

## 기술 & 오프라인-온라인 동기화 (0:40 ~ 2:00)

```
Flutter + Provider
  ├─ Hive (로컬 DB)  ←──→  Firebase Firestore (클라우드)
  ├─ Firebase Auth (Google 로그인)        Last-Write-Wins
  └─ Anthropic API (Claude 분석)          updatedAt 비교
```

- 오프라인에서 추가 → 복구 시 자동 sync_queue 처리
- 충돌: updatedAt 타임스탬프 비교, 최신 데이터 선택
- 웹(Chrome) + Android 동시 지원

---

## ⭐ AI 에이전트 팀으로 만든 방식 (2:00 ~ 3:30)

**5개 서브에이전트 + 3개 MCP**

| 에이전트 | 담당 |
|---|---|
| product-manager-prd | PRD, 요구사항, 일정 |
| backend-architect | Firebase, Hive, 동기화 |
| frontend-developer | Flutter UI 전체 |
| qa-engineer | Playwright E2E 테스트 |
| ai-integration-specialist | Claude 프롬프트 |

MCP: **Playwright** (UI 테스트) · **Notion** (분석 저장) · **GitHub** (이슈 생성)

---

## ⭐ AUTHORING.hyeji.md — 내 방식 (3:30 ~ 4:20)

> 이 파일 하나로 전체 AI 팀 + MCP 워크플로우를 부트스트랩

- 5개 에이전트 역할 & 권한 정의
- 세션별 체크리스트 & 진행 관리
- 오프라인-온라인 동기화 설계 문서
- LLM Wiki 5개 (`notes/`) — 배운 것들 축적

→ 다른 프로젝트에서도 이 템플릿 그대로 재사용 가능

---

## 결과 & 가산점 어필 (4:20 ~ 5:00)

**빌드 산출물**: APK 49.9MB · AAB 43MB · 웹 · Galaxy S25 실기기 확인

| 가산점 항목 | 근거 | 점수 |
|---|---|---|
| AI Agent 적극 활용 | 서브에이전트 5종 커밋 명시 | +1 |
| 본인만의 기법 | AUTHORING.hyeji.md 템플릿 | +2 |
| LLM Wiki 운영 | notes/ 5개 파일 | +1 |
| AI Agent 리포트 발표 | 이 발표 전체 | +2 |
| **합계** | | **+6** |

> "코드는 AI가, 판단과 검증은 내가."
