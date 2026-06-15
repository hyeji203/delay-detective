// NOTE: 아래 테스트는 이미 로그인된 상태를 전제로 합니다.
// 실제 실행 전 Firebase Emulator 또는 테스트 계정 설정이 필요합니다.
//
// Firebase Emulator 설정 방법:
//   1. `firebase emulators:start --only auth,firestore` 실행
//   2. 앱의 firebase_options.dart에서 emulator host 설정
//   3. 테스트 계정으로 로그인 후 세션 쿠키/토큰을 storageState로 저장:
//      npx playwright codegen http://localhost:5000 --save-storage=auth.json
//   4. playwright.config.ts의 use.storageState를 'e2e/auth.json'으로 지정

import { test, expect } from '@playwright/test';

test.describe('태스크 관리 플로우 — 인증 필요', () => {
  test.skip('태스크 추가 플로우', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');

    // 할일 탭으로 이동
    await page.getByText('할일').click();

    // '+' 또는 '태스크 추가' 버튼 클릭
    await page.getByRole('button', { name: /추가|\+/i }).click();

    // 태스크 제목 입력
    await page.getByLabel(/제목|title/i).fill('E2E 테스트 태스크');

    // 마감일 설정 (날짜 피커 상호작용)
    // Flutter DatePicker는 네이티브 위젯이 아니므로 텍스트 기반 탐색 필요
    await page.getByText(/마감일|due date/i).click();
    // 내일 날짜 선택 (캘린더에서 다음 날)
    const tomorrow = new Date();
    tomorrow.setDate(tomorrow.getDate() + 1);
    await page.getByText(String(tomorrow.getDate())).first().click();
    await page.getByText(/확인|OK/i).click();

    // 저장 버튼 클릭
    await page.getByRole('button', { name: /저장|save/i }).click();

    // 목록에서 새 태스크 확인
    await expect(page.getByText('E2E 테스트 태스크')).toBeVisible({ timeout: 5000 });
  });

  test.skip('태스크 지연 감지 — 마감일 초과 태스크에 지연 배지 표시', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');

    await page.getByText('할일').click();

    // 이미 마감일이 지난 태스크가 목록에 존재한다고 가정
    // 지연 배지(예: '지연', '⚠', 빨간 표시) 확인
    await expect(
      page.getByText(/지연|overdue|늦음/i).first()
    ).toBeVisible({ timeout: 5000 });

    // 지연된 태스크 항목에 시각적 강조 확인 (색상은 CSS로 검증 불가, 텍스트로 대체)
    const delayedTask = page.locator('[data-testid="delayed-task"]').first();
    if (await delayedTask.isVisible()) {
      await expect(delayedTask).toBeVisible();
    }
  });

  test.skip('AI 분석 시작 — 인터뷰 화면 열기', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');

    // AI분석 탭 클릭
    await page.getByText('AI분석').click();
    await page.waitForTimeout(1000);

    // 분석 시작 버튼 또는 인터뷰 시작 트리거 클릭
    const analyzeButton = page.getByRole('button', { name: /분석 시작|인터뷰 시작|시작하기/i });
    await expect(analyzeButton).toBeVisible({ timeout: 5000 });
    await analyzeButton.click();

    // 인터뷰/채팅 인터페이스가 열렸는지 확인
    await expect(
      page.getByText(/왜|어떤 이유|언제부터/i).first()
    ).toBeVisible({ timeout: 10000 });
  });

  test.skip('통계 화면 렌더링 — 통계 카드 표시', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');

    // 통계 탭 클릭
    await page.getByText('통계').click();
    await page.waitForTimeout(500);

    // 통계 카드 항목들 확인
    await expect(page.getByText(/완료율|완료된 태스크/i)).toBeVisible({ timeout: 5000 });
    await expect(page.getByText(/지연|미완료|총 태스크/i)).toBeVisible({ timeout: 5000 });

    // 스크린샷 — 통계 화면 시각 기록
    await page.screenshot({ path: 'e2e/screenshots/stats-screen.png', fullPage: true });
  });

  test.skip('오프라인 상태 — Hive 로컬 저장 확인', async ({ page, context }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');

    // 태스크 추가 (온라인 상태)
    await page.getByText('할일').click();
    await page.getByRole('button', { name: /추가|\+/i }).click();
    await page.getByLabel(/제목|title/i).fill('오프라인 테스트 태스크');
    await page.getByRole('button', { name: /저장|save/i }).click();
    await expect(page.getByText('오프라인 테스트 태스크')).toBeVisible();

    // 네트워크 오프라인 시뮬레이션
    await context.setOffline(true);
    await page.waitForTimeout(500);

    // 오프라인 상태에서도 태스크 목록 유지 확인 (Hive 로컬 데이터)
    await expect(page.getByText('오프라인 테스트 태스크')).toBeVisible();

    // 네트워크 복구
    await context.setOffline(false);
  });

  test.skip('네트워크 복구 — Firestore 동기화 확인', async ({ page, context }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');

    // 오프라인 전환
    await context.setOffline(true);
    await page.waitForTimeout(500);

    // 오프라인 상태에서 태스크 추가
    await page.getByText('할일').click();
    await page.getByRole('button', { name: /추가|\+/i }).click();
    await page.getByLabel(/제목|title/i).fill('동기화 테스트 태스크');
    await page.getByRole('button', { name: /저장|save/i }).click();

    // 온라인 복구
    await context.setOffline(false);
    await page.waitForTimeout(2000); // 동기화 대기

    // 동기화 완료 표시 또는 태스크 유지 확인
    await expect(page.getByText('동기화 테스트 태스크')).toBeVisible({ timeout: 10000 });
  });
});
