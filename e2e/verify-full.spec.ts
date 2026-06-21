import { test } from '@playwright/test';
import { chromium } from '@playwright/test';
import * as path from 'path';

const SS = (name: string) => path.join(__dirname, '..', `vf3_${name}.png`);

test('전체 플로우 최종 검증', async () => {
  test.setTimeout(360_000);

  const tempBrowser = await chromium.launch({ headless: true });
  const tempCtx = await tempBrowser.newContext({ viewport: { width: 390, height: 844 } });
  const tempPage = await tempCtx.newPage();
  await tempPage.goto('http://localhost:5000');
  await tempPage.waitForTimeout(5000);
  await tempPage.evaluate(async () => {
    const dbs = await (indexedDB as any).databases?.() ?? [];
    for (const db of dbs) { if (db.name) indexedDB.deleteDatabase(db.name); }
  });
  await tempCtx.close();
  await tempBrowser.close();

  const browser = await chromium.launch({ headless: true });
  const ctx = await browser.newContext({ viewport: { width: 390, height: 844 }, deviceScaleFactor: 2 });
  const page = await ctx.newPage();

  async function step(name: string, fn: () => Promise<void>) {
    await fn();
    await page.screenshot({ path: SS(name) });
    console.log(`✓ ${name}: ${page.url()}`);
  }

  await page.goto('http://localhost:5000');
  await page.waitForTimeout(2000);

  await step('01_login', async () => {});
  await step('02_home', async () => {
    await page.mouse.click(195, 585); await page.waitForTimeout(3500);
  });
  await step('03_sheet', async () => {
    await page.mouse.click(250, 490); await page.waitForTimeout(1500);
  });
  await step('04_addtask', async () => {
    await page.mouse.click(334, 720); await page.waitForTimeout(2000);
  });
  await step('05_typed', async () => {
    await page.keyboard.type('팀 발표 자료 정리', { delay: 60 });
    await page.waitForTimeout(500);
  });
  await step('06_saved', async () => {
    await page.mouse.click(355, 30); await page.waitForTimeout(2000);
    if (page.url().includes('add-task')) throw new Error('저장 실패');
  });
  await step('07_tasklist', async () => {
    await page.mouse.click(146, 820); await page.waitForTimeout(1500);
  });
  await step('08_options', async () => {
    await page.mouse.click(195, 460); await page.waitForTimeout(800);
  });
  await step('09_delayed', async () => {
    await page.mouse.click(195, 720); await page.waitForTimeout(2000);
  });
  await step('10_interview', async () => {
    await page.mouse.click(195, 460); await page.waitForTimeout(2500);
    if (!page.url().includes('interview')) throw new Error('인터뷰 미진입');
  });
  await step('11_q1', async () => { await page.waitForTimeout(18000); });

  await step('12_a1', async () => {
    await page.mouse.click(160, 820); await page.waitForTimeout(400);
    await page.keyboard.type('어디서부터 시작해야 할지 모르겠어요', { delay: 60 });
    await page.waitForTimeout(300); await page.keyboard.press('Enter');
    await page.waitForTimeout(2000);
  });
  await step('13_q2', async () => { await page.waitForTimeout(18000); });

  await step('14_a2', async () => {
    await page.mouse.click(160, 820); await page.waitForTimeout(400);
    await page.keyboard.type('완성 기준이 없어서 막막한 느낌이에요', { delay: 60 });
    await page.waitForTimeout(300); await page.keyboard.press('Enter');
    await page.waitForTimeout(2000);
  });
  await step('15_q3', async () => { await page.waitForTimeout(18000); });

  await step('16_a3', async () => {
    await page.mouse.click(160, 820); await page.waitForTimeout(400);
    await page.keyboard.type('일단 목차부터 써보면 될 것 같아요', { delay: 60 });
    await page.waitForTimeout(300); await page.keyboard.press('Enter');
    await page.waitForTimeout(3000);
  });
  await step('17_result', async () => { await page.waitForTimeout(20000); });

  await step('18_home', async () => {
    await page.mouse.click(350, 30); await page.waitForTimeout(2000);
  });
  await step('19_ai_tab', async () => {
    await page.mouse.click(244, 820); await page.waitForTimeout(2000);
  });
  await step('20_stats_tab', async () => {
    await page.mouse.click(341, 820); await page.waitForTimeout(2000);
  });

  console.log('✅ 최종 검증 완료');
  await browser.close();
});
