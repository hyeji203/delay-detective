# 서브에이전트 협업 패턴

> LLM Wiki — 세션별 배운 내용 기록  
> 작성자: 혜지

## 이 파일의 목적
5개 서브에이전트를 활용한 AI 팀 협업 경험에서 반복적으로 효과적인 패턴을 기록한다.

---

## 패턴 1 — "PRD 먼저, 코드 나중" 원칙

**발견 세션**: 세션 2 (product-manager-prd)

**내용**:  
product-manager-prd에게 기획 문서를 먼저 만들게 하면, 이후 backend-architect와 frontend-developer가 방향 없이 헤매지 않는다. PRD가 없으면 에이전트들이 각자 다른 방향으로 구현한다.

**적용 방법**:
```
1. product-manager-prd → 01-requirements.md, 02-wbs.md 완성
2. 완성된 PRD를 다른 에이전트 호출 시 컨텍스트로 붙여넣기
3. "이 PRD를 기준으로 구현해줘" 라고 명시
```

**효과**: 에이전트 간 의사결정 충돌 70% 감소 (추정)

---

## 패턴 2 — 에이전트 호출 시 "역할 + 결과물 형식" 명시

**발견 세션**: 세션 3 (backend-architect)

**내용**:  
에이전트를 호출할 때 "이걸 해줘" 만 하면 결과 형식이 제각각이다. 반드시 원하는 결과물 형식을 명시해야 한다.

**좋은 호출 예시**:
```
backend-architect에게:
"HiveService CRUD 구현해줘. 
결과: lib/services/hive_service.dart 파일 하나,
메서드: addTask, getTask, updateTask, deleteTask, getAllTasks"
```

**나쁜 호출 예시**:
```
"Hive 저장 기능 만들어줘" 
→ 파일 구조, 메서드명이 원하는 것과 다르게 나옴
```

---

## 패턴 3 — "왜 이렇게 했어?" 질문으로 이해 확인

**발견 세션**: 세션 3

**내용**:  
에이전트가 생성한 코드를 그냥 복사하면 나중에 버그가 생겼을 때 원인을 파악할 수 없다. 코드 생성 후 반드시 "왜 이렇게 구현했어?"를 물어봐서 이해한 뒤 적용한다.

**적용 방법**:
```
에이전트: [코드 생성]
나: "이 부분에서 왜 StreamController 대신 ChangeNotifier를 썼어?"
에이전트: [설명]
나: [이해 후 적용 or 수정 요청]
```

**효과**: 코드 소유권이 생겨서 발표 시 직접 설명 가능

---

## 패턴 4 — 병렬 에이전트 실행 가능한 작업 분리

**발견 세션**: 세션 4

**내용**:  
backend-architect(서비스 로직)와 ai-integration-specialist(프롬프트 설계)는 서로 의존성이 없어서 동시에 진행할 수 있다. 하지만 frontend-developer는 backend-architect 작업이 끝난 뒤에 해야 한다.

**의존 관계 정리**:
```
독립 (병렬 가능):
  - backend-architect 와 ai-integration-specialist
  - product-manager-prd 와 frontend-developer (UI 목업만)

순서 필요 (직렬):
  - product-manager-prd → backend-architect
  - backend-architect → frontend-developer (실제 데이터 연결)
  - frontend-developer → qa-engineer
```

---

## 패턴 5 — 에이전트 컨텍스트 유지를 위한 AUTHORING.hyeji.md 활용

**발견 세션**: 세션 2

**내용**:  
새 세션을 시작할 때 에이전트는 이전 세션을 기억하지 못한다. AUTHORING.hyeji.md를 대화 첫 번째 메시지에 붙여넣으면 에이전트가 프로젝트 전체 맥락을 즉시 이해한다.

**세션 시작 템플릿**:
```
[AUTHORING.hyeji.md 내용 붙여넣기]

위 컨텍스트를 기반으로, 오늘 세션 목표:
- [목표 1]
- [목표 2]
```

**효과**: 에이전트에게 배경 설명하는 시간 약 15분 절약

---

## 핵심 패턴 요약

| 패턴 | 핵심 키워드 | 효과 |
|---|---|---|
| PRD 먼저 | 기준점 문서 | 방향 일치 |
| 결과물 형식 명시 | 구체적 호출 | 재작업 감소 |
| "왜?" 질문 | 이해 확인 | 코드 소유권 |
| 병렬/직렬 구분 | 의존성 파악 | 시간 효율 |
| AUTHORING 부트스트랩 | 컨텍스트 복원 | 세션 연속성 |
