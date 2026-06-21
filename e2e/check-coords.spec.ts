import { test } from '@playwright/test';
import { chromium } from '@playwright/test';
import * as path from 'path';

test('주요 화면 스크린샷', async () => {
  test.setTimeout(60_000);
  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext({
    viewport: { width: 390, height: 844 },
    deviceScaleFactor: 2,
  });
  const page = await context.newPage();

  // Hive 초기화
  await page.goto('http://localhost:5000');
  await page.waitForTimeout(4000);
  await page.evaluate(async () => {
    const dbs = await (indexedDB as any).databases?.() ?? [];
    for (const db of dbs) { if (db.name) indexedDB.deleteDatabase(db.name); }
  });

  await page.goto('http://localhost:5000');
  await page.waitForTimeout(3500);
  await page.mouse.click(195, 585); // 데모로 보기
  await page.waitForTimeout(3500);

  await page.mouse.click(146, 820); // 할일 탭
  await page.waitForTimeout(2000);
  await page.screenshot({ path: path.join(__dirname, '..', 'screenshot_tasks.png') });
  console.log('할일 탭 저장');

  await page.mouse.click(195, 310); // 두 번째 카드
  await page.waitForTimeout(2000);
  await page.screenshot({ path: path.join(__dirname, '..', 'screenshot_result.png') });
  console.log('결과 화면 저장');

  await context.close();
  await browser.close();
});
