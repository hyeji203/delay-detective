// NOTE: 인증이 필요한 화면 테스트는 Firebase Auth 모킹이 필요합니다.
// 아래 테스트는 비인증 상태에서의 동작을 검증합니다.

import { test, expect } from '@playwright/test';

test.describe('네비게이션 — 비인증 상태', () => {
  test('비인증 사용자는 로그인 화면으로 리다이렉트', async ({ page }) => {
    await page.goto('/');

    // Flutter 앱이 완전히 초기화될 때까지 대기
    await page.waitForLoadState('networkidle');

    // Firebase Auth가 사용자 미인증 상태를 감지하면
    // 앱은 로그인 화면으로 이동해야 함
    const loginButton = page.getByText('Google로 계속하기');
    await expect(loginButton).toBeVisible({ timeout: 15000 });
  });

  test('로딩 중 스플래시 화면 표시', async ({ page }) => {
    await page.goto('/');

    // 앱 초기화 직후 — Flutter 엔진 로드 중에는 스플래시 또는 로딩 표시
    // networkidle 이전 시점을 캡처하기 위해 짧은 타임아웃 사용
    await page.waitForTimeout(500);

    // 스플래시 화면 또는 로딩 인디케이터가 존재하는지 확인
    // Flutter Web은 초기에 flutter_bootstrap.js가 실행되는 동안
    // index.html에 정의된 로딩 UI를 표시함
    const bodyContent = await page.locator('body').innerHTML();
    expect(bodyContent.length).toBeGreaterThan(0);

    // 스플래시 or 로딩 텍스트 존재 여부 (앱에 정의된 경우)
    const splashOrLoader =
      (await page.locator('[id="loading"]').isVisible().catch(() => false)) ||
      (await page.locator('flt-scene-host').isVisible().catch(() => false)) ||
      (await page.locator('flutter-view').isVisible().catch(() => false)) ||
      (await page.getByText(/로딩|loading|delay detective/i).isVisible().catch(() => false));

    // Flutter 엔진이 DOM을 마운트했거나 로딩 중임을 확인
    expect(splashOrLoader).toBe(true);
  });
});

// ──────────────────────────────────────────────
// 아래 테스트들은 인증된 상태에서 동작하는 메인 화면 네비게이션을 검증합니다.
// Firebase Emulator 또는 테스트 계정 설정 후 test.skip 제거하여 실행하세요.
// ──────────────────────────────────────────────

test.describe('메인 화면 네비게이션 — 인증 필요 (스킵)', () => {
  test.skip('홈 탭 — 캘린더와 태스크 목록 렌더링', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');

    // 바텀 네비게이션 홈 탭 클릭
    await page.getByText('홈').click();

    // 캘린더 위젯 확인
    await expect(page.locator('flt-semantics').filter({ hasText: /\d{4}년/ })).toBeVisible();

    // 태스크 목록 확인
    await expect(page.getByText(/태스크|task/i)).toBeVisible();
  });

  test.skip('할일 탭 — 진행중/완료 탭바 렌더링', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');

    await page.getByText('할일').click();

    await expect(page.getByText('진행중')).toBeVisible();
    await expect(page.getByText('완료')).toBeVisible();
  });

  test.skip('AI분석 탭 — 인터뷰 화면 렌더링', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');

    await page.getByText('AI분석').click();

    // AI 인터뷰 시작 버튼 또는 채팅 인터페이스 확인
    await expect(page.getByText(/분석|인터뷰|시작/i)).toBeVisible();
  });

  test.skip('통계 탭 — 통계 카드 렌더링', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');

    await page.getByText('통계').click();

    // 통계 카드 존재 확인
    await expect(page.getByText(/통계|완료율|지연/i)).toBeVisible();
  });
});
