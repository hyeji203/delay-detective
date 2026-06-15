import { test, expect } from '@playwright/test';

test.describe('로그인 화면', () => {
  test('로그인 화면 기본 렌더링', async ({ page }) => {
    await page.goto('/');

    // Flutter 앱 부트스트랩 대기
    await page.waitForLoadState('networkidle');

    // 페이지 타이틀 확인 (Flutter Web은 index.html 타이틀 사용)
    const title = await page.title();
    expect(title.length).toBeGreaterThan(0);

    // 스크린샷 — 초기 로드 상태 기록
    await page.screenshot({ path: 'e2e/screenshots/login-initial.png', fullPage: true });

    // 'Google로 계속하기' 버튼 표시 확인
    const loginButton = page.getByText('Google로 계속하기');
    await expect(loginButton).toBeVisible({ timeout: 15000 });

    // 버튼이 비활성화 상태가 아닌지 확인
    await expect(loginButton).toBeEnabled();
  });

  test('로그인 버튼 클릭 시 팝업 또는 반응 확인', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');

    // Google OAuth 팝업이 열리면 즉시 닫아 크래시 방지
    page.on('popup', async (popup) => {
      await popup.close();
    });

    const loginButton = page.getByText('Google로 계속하기');
    await expect(loginButton).toBeVisible({ timeout: 15000 });

    await loginButton.click();

    // 클릭 후 1초 대기 — 로딩 상태 또는 팝업 처리 시간
    await page.waitForTimeout(1000);

    // 앱이 크래시하지 않았는지 확인: 버튼이 여전히 존재하거나 로딩 인디케이터 표시
    const buttonStillVisible = await page.getByText('Google로 계속하기').isVisible();
    const loadingVisible = await page.getByText(/로딩|loading/i).isVisible().catch(() => false);

    expect(buttonStillVisible || loadingVisible).toBe(true);
  });
});
