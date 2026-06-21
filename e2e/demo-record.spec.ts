/**
 * 최종 데모 영상 녹화
 *
 * 플로우:
 *  1. 로그인 → "데모로 보기"
 *  2. 홈 캘린더 → 6/25 탭 → 할일 추가 → AddTask → 제목 입력 → AppBar ✓ 저장
 *  3. 할일 탭 → "팀 발표 자료 정리" → "미루고있어요"
 *  4. 지연 태스크 탭 → AI 인터뷰 3턴 (Enter 제출) → 분석결과
 *  5. "홈으로" → 홈 탭 → AI분석 탭 → 통계 탭
 *
 * 확정 좌표:
 *  - 데모로 보기:    (195, 585)
 *  - 6/25 날짜:      (250, 490)
 *  - 할일 추가:      (334, 720)   ← 캘린더 바텀시트
 *  - AppBar 체크:    (355,  30)   ← AddTask 저장
 *  - 할일 탭:        (146, 820)
 *  - 팀 발표 자료:   (195, 460)   ← 옵션 & 지연 후 인터뷰
 *  - 미루고있어요:   (195, 720)   ← 태스크 옵션 바텀시트
 *  - 인터뷰 입력란:  (160, 820)
 *  - 홈으로:         (350,  30)   ← 결과 화면 AppBar
 *  - 홈 탭:          ( 49, 820)
 *  - AI분석 탭:      (244, 820)
 *  - 통계 탭:        (341, 820)
 */
import { test } from '@playwright/test';
import { chromium } from '@playwright/test';
import * as path from 'path';
import * as fs from 'fs';

async function tap(page: any, x: number, y: number, label: string) {
  console.log(`  → ${label} (${x}, ${y})`);
  await page.mouse.click(x, y);
}

test('데모 영상 녹화', async () => {
  test.setTimeout(360_000);

  // ── Hive 초기화 (headless) ───────────────────────────────────
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
  console.log('✓ Hive 초기화');

  // ── 녹화 브라우저 ─────────────────────────────────────────────
  const browser = await chromium.launch({ headless: false, slowMo: 20 });
  const context = await browser.newContext({
    viewport: { width: 390, height: 844 },
    recordVideo: { dir: path.join(__dirname, 'videos'), size: { width: 390, height: 844 } },
    deviceScaleFactor: 2,
  });
  const page = await context.newPage();

  // ── 1. 로그인 화면 ────────────────────────────────────────────
  console.log('1. 로그인...');
  await page.goto('http://localhost:5000');
  await page.waitForTimeout(2500);

  // ── 2. 데모로 보기 → 홈 캘린더 ───────────────────────────────
  console.log('2. 데모로 보기...');
  await tap(page, 195, 585, '데모로 보기');
  await page.waitForTimeout(3500);

  // ── 3. 6/25 탭 → 바텀시트 ─────────────────────────────────────
  console.log('3. 6/25 탭...');
  await tap(page, 250, 490, '6/25');
  await page.waitForTimeout(1500);

  // ── 4. 할일 추가 → AddTask ────────────────────────────────────
  console.log('4. 할일 추가...');
  await tap(page, 334, 720, '할일 추가');
  await page.waitForTimeout(2000);

  // ── 5. 제목 입력 (autofocus=true → 즉시 타이핑) ──────────────
  console.log('5. 제목 입력...');
  await page.keyboard.type('팀 발표 자료 정리', { delay: 80 });
  await page.waitForTimeout(600);

  // ── 6. AppBar 체크 버튼으로 저장 ──────────────────────────────
  console.log('6. 저장 (AppBar ✓)...');
  await tap(page, 355, 30, 'AppBar 체크');
  await page.waitForTimeout(2500);

  // ── 7. 할일 탭 ────────────────────────────────────────────────
  console.log('7. 할일 탭...');
  await tap(page, 146, 820, '할일 탭');
  await page.waitForTimeout(2000);

  // ── 8. "팀 발표 자료 정리" → 옵션 시트 ───────────────────────
  console.log('8. 팀 발표 자료 정리 탭...');
  await tap(page, 195, 460, '팀 발표 자료 정리');
  await page.waitForTimeout(1000);

  // ── 9. "미루고있어요" ─────────────────────────────────────────
  console.log('9. 미루고있어요...');
  await tap(page, 195, 720, '미루고있어요');
  await page.waitForTimeout(2000);

  // ── 10. 지연된 태스크 탭 → 인터뷰 ────────────────────────────
  console.log('10. 지연 태스크 탭 → 인터뷰...');
  await tap(page, 195, 460, '지연된 팀발표자료');
  await page.waitForTimeout(3000);

  // ── 11. Q1 대기 ───────────────────────────────────────────────
  console.log('11. Q1 대기 (18초)...');
  await page.waitForTimeout(18000);

  // ── 12. Q1 답변 + Enter ───────────────────────────────────────
  console.log('12. Q1 답변...');
  await tap(page, 160, 820, '인터뷰 입력란');
  await page.waitForTimeout(400);
  await page.keyboard.type('어디서부터 시작해야 할지 모르겠어요', { delay: 70 });
  await page.waitForTimeout(300);
  await page.keyboard.press('Enter');
  await page.waitForTimeout(2000);

  // ── 13. Q2 대기 ───────────────────────────────────────────────
  console.log('13. Q2 대기 (18초)...');
  await page.waitForTimeout(18000);

  // ── 14. Q2 답변 + Enter ───────────────────────────────────────
  console.log('14. Q2 답변...');
  await tap(page, 160, 820, '인터뷰 입력란');
  await page.waitForTimeout(400);
  await page.keyboard.type('완성 기준이 없어서 막막한 느낌이에요', { delay: 70 });
  await page.waitForTimeout(300);
  await page.keyboard.press('Enter');
  await page.waitForTimeout(2000);

  // ── 15. Q3 대기 ───────────────────────────────────────────────
  console.log('15. Q3 대기 (18초)...');
  await page.waitForTimeout(18000);

  // ── 16. Q3 답변 + Enter ───────────────────────────────────────
  console.log('16. Q3 답변...');
  await tap(page, 160, 820, '인터뷰 입력란');
  await page.waitForTimeout(400);
  await page.keyboard.type('일단 목차부터 써보면 될 것 같아요', { delay: 70 });
  await page.waitForTimeout(300);
  await page.keyboard.press('Enter');
  await page.waitForTimeout(3000);

  // ── 17. 분석결과 대기 ─────────────────────────────────────────
  console.log('17. 분석결과 대기 (20초)...');
  await page.waitForTimeout(20000);

  // ── 18. 결과 화면 스크롤 ──────────────────────────────────────
  console.log('18. 결과 스크롤...');
  await page.mouse.wheel(0, 250);
  await page.waitForTimeout(1000);
  await page.mouse.wheel(0, 250);
  await page.waitForTimeout(1000);
  await page.mouse.wheel(0, -500);
  await page.waitForTimeout(1200);

  // ── 19. "홈으로" 버튼 (결과 AppBar 우측) ──────────────────────
  console.log('19. 홈으로...');
  await tap(page, 350, 30, '홈으로');
  await page.waitForTimeout(2000);

  // ── 20. 홈 탭 ─────────────────────────────────────────────────
  console.log('20. 홈 탭...');
  await tap(page, 49, 820, '홈 탭');
  await page.waitForTimeout(2500);

  // ── 21. AI분석 탭 ─────────────────────────────────────────────
  console.log('21. AI분석 탭...');
  await tap(page, 244, 820, 'AI분석 탭');
  await page.waitForTimeout(2500);

  // ── 22. 통계 탭 ───────────────────────────────────────────────
  console.log('22. 통계 탭...');
  await tap(page, 341, 820, '통계 탭');
  await page.waitForTimeout(4000);

  console.log('✅ 녹화 완료');
  await context.close();
  await browser.close();

  // ── webm → docs/demo_raw.webm ─────────────────────────────────
  const videoDir = path.join(__dirname, 'videos');
  const files = fs.readdirSync(videoDir)
    .filter(f => f.endsWith('.webm'))
    .sort((a, b) =>
      fs.statSync(path.join(videoDir, b)).mtimeMs -
      fs.statSync(path.join(videoDir, a)).mtimeMs
    );
  if (files.length > 0) {
    const docsDir = path.join(__dirname, '..', 'docs');
    if (!fs.existsSync(docsDir)) fs.mkdirSync(docsDir, { recursive: true });
    const src = path.join(videoDir, files[0]);
    const dest = path.join(docsDir, 'demo_raw.webm');
    fs.copyFileSync(src, dest);
    const size = (fs.statSync(dest).size / 1024 / 1024).toFixed(2);
    console.log(`✅ 저장: docs/demo_raw.webm (${size} MB)`);
  }
});
