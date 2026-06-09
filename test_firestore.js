const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch({ headless: false });
  const page = await browser.newPage();

  console.log('앱 접속 중...');
  await page.goto('http://localhost:9000');
  await page.waitForTimeout(3000);

  // 스플래시 화면 지나가길 대기
  await page.waitForTimeout(2000);

  // + 할 일 추가 버튼 클릭
  console.log('할 일 추가 버튼 찾는 중...');
  await page.screenshot({ path: 'screenshot_home.png' });

  // FAB 버튼 클릭 (+ 할 일 추가)
  const fabButton = page.locator('text=할 일 추가');
  await fabButton.waitFor({ timeout: 10000 });
  await fabButton.click();
  await page.waitForTimeout(1000);

  // 제목 입력
  console.log('태스크 제목 입력 중...');
  await page.screenshot({ path: 'screenshot_add.png' });
  const titleInput = page.locator('input').first();
  await titleInput.fill('Firebase 연동 테스트 태스크');
  await page.waitForTimeout(500);

  // 저장 버튼 클릭
  const saveButton = page.locator('text=저장');
  await saveButton.click();
  await page.waitForTimeout(2000);

  console.log('태스크 추가 완료!');
  await page.screenshot({ path: 'screenshot_done.png' });

  await browser.close();
})();
