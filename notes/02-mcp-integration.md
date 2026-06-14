# MCP 통합 패턴

> LLM Wiki — MCP(Model Context Protocol) 도구 활용 기록  
> 작성자: 혜지

## 이 파일의 목적
Playwright MCP, Notion MCP, GitHub MCP를 프로젝트에 통합하면서 배운 설치 방법, 활용 패턴, 주의사항을 기록한다.

---

## MCP 설치 명령어 모음

```bash
# Playwright MCP — UI 자동화 테스트
claude mcp add playwright -s local -- cmd /c npx @playwright/mcp@latest

# Notion MCP — AI 분석 결과 저장
claude mcp add --transport http notion https://mcp.notion.com/mcp

# GitHub MCP — 이슈/PR 자동 생성
claude mcp add --transport http github [GitHub MCP URL]
```

---

## Playwright MCP 활용 패턴

### 패턴 1 — Flutter Web 앱 자동 테스트 흐름

**내용**:  
Flutter 앱을 Playwright로 테스트하려면 `flutter run -d web-server --web-port 8080` 으로 먼저 웹 서버를 띄운 뒤 Playwright가 `localhost:8080`에 접근해야 한다.

**순서**:
```
1. flutter run -d web-server --web-port 8080 (백그라운드 실행)
2. qa-engineer에게 Playwright MCP로 테스트 요청
3. 테스트 결과 스크린샷 캡처 확인
```

**주의사항**:  
Flutter Web은 DOM 구조가 Canvas 기반이라 일반 HTML 셀렉터가 안 통한다. 텍스트 기반 셀렉터(`text=태스크 추가`)를 사용해야 한다.

---

### 패턴 2 — 스크린샷 기반 회귀 테스트

**내용**:  
기능 변경 후 스크린샷을 자동 캡처하면 육안으로 UI 회귀를 확인하기 쉽다. Playwright의 `page.screenshot()` 결과를 `test_screenshots/` 폴더에 저장한다.

**활용 방식**:
```
세션 종료 전:
  qa-engineer → Playwright로 스크린샷 촬영
  → 이전 세션 스크린샷과 비교
  → 의도치 않은 UI 변경 감지
```

---

## Notion MCP 활용 패턴

### 패턴 1 — AI 분석 결과 자동 저장

**내용**:  
사용자가 AI 인터뷰를 완료하면 분석 결과(공감 메시지, 원인 요약, 소태스크 3개)를 Notion 데이터베이스에 자동 저장할 수 있다. 나중에 패턴 분석에 활용 가능.

**데이터 구조**:
```
Notion DB: delay-detective-analysis
  - 태스크명 (Title)
  - 지연 원인 (Text)
  - 소태스크 목록 (Multi-select)
  - 분석 일시 (Date)
  - 완료 여부 (Checkbox)
```

---

## GitHub MCP 활용 패턴

### 패턴 1 — 버그 발견 시 자동 이슈 생성

**내용**:  
qa-engineer가 테스트 중 버그를 발견하면 GitHub MCP로 즉시 이슈를 생성한다. 수동으로 이슈를 작성하는 것보다 일관된 형식이 유지된다.

**이슈 자동 생성 형식**:
```
제목: [버그] {화면명} - {현상 요약}
레이블: bug
본문:
  ## 재현 단계
  1. ...
  ## 기대 결과
  ## 실제 결과
  ## 스크린샷 (Playwright 자동 캡처)
```

---

## MCP 공통 주의사항

| 주의사항 | 이유 |
|---|---|
| MCP 설정은 프로젝트 단위로 관리 | 전역 설정 변경 시 다른 프로젝트에 영향 |
| API 토큰 `.env`에 저장, 커밋 금지 | 보안 |
| MCP 오류 시 에이전트에게 재시도 전에 수동 확인 | 자동 재시도가 오히려 데이터 중복 생성 가능 |
| Playwright는 headless 모드 기본 | 디버깅 필요 시 `--headed` 옵션 추가 |

---

## MCP 3개 설정 현황

| MCP | 설치 상태 | 용도 |
|---|---|---|
| Playwright MCP | ✅ 설정 완료 | UI 자동화 테스트, 스크린샷 캡처 |
| Notion MCP | 설치 예정 (14주차) | AI 분석 결과 자동 저장 |
| GitHub MCP | 설치 예정 (14주차) | 소태스크 → GitHub 이슈 자동 생성 |
