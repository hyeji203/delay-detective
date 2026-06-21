/**
 * 30초+ 데모 영상 녹화
 * 흐름: 로그인 → 홈 → 할일(지연태스크) → AI인터뷰 → 분석결과 → 통계
 *
 * 탭 위치 (viewport 390×844):
 *   홈(x=49) | 할일(x=146) | AI분석(x=244) | 통계(x=341)  — y=820
 *
 * 실행: cd e2e && npx playwright test demo-record --project=chromium --retries=0
 */
import { test } from '@playwright/test';
import { chromium } from '@playwright/test';
import * as path from 'path';
import * as fs from 'fs';

const TAB_Y = 820;
const TAB_HOME = { x: 49, y: TAB_Y };
const TAB_TASKS = { x: 146, y: TAB_Y };
const TAB_AI = { x: 244, y: TAB_Y };
const TAB_STATS = { x: 341, y: TAB_Y };

async function tap(page: any, x: number, y: number, label: string) {
  console.log(`  → 탭: ${label} (${x}, ${y})`);
  await page.mouse.click(x, y);
}

test('데모 영상 녹화', async () => {
  test.setTimeout(180_000);

  // ── Hive IndexedDB 초기화 (데모 데이터 새로 시딩) ────────────
  const tempBrowser = await chromium.launch({ headless: true });
  const tempCtx = await tempBrowser.newContext({ viewport: { width: 390, height: 844 } });
  const tempPage = await tempCtx.newPage();
  await tempPage.goto('http://localhost:5000');
  await tempPage.waitForTimeout(4000);
  await tempPage.evaluate(async () => {
    const dbs = await (indexedDB as any).databases?.() ?? [];
    for (const db of dbs) {
      if (db.name) indexedDB.deleteDatabase(db.name);
    }
  });
  console.log('Hive 초기화 완료');
  await tempCtx.close();
  await tempBrowser.close();

  // ── 녹화 시작 ──────────────────────────────────────────────
  const browser = await chromium.launch({ headless: false, slowMo: 60 });
  const context = await browser.newContext({
    viewport: { width: 390, height: 844 },
    recordVideo: {
      dir: path.join(__dirname, 'videos'),
      size: { width: 390, height: 844 },
    },
    deviceScaleFactor: 2,
  });
  const page = await context.newPage();

  // ── 1. 로그인 화면 (0~3초) ──────────────────────────────────
  console.log('1. 로그인 화면...');
  await page.goto('http://localhost:5000');
  await page.waitForTimeout(3000);

  // ── 2. 데모 모드 진입 (3~8초) ──────────────────────────────
  console.log('2. 데모로 보기 클릭 (y=585)...');
  await tap(page, 195, 585, '데모로 보기');
  await page.waitForTimeout(4000);

  // ── 3. 할일 탭 — 지연 태스크 목록 (8~14초) ────────────────
  console.log('3. 할일 탭...');
  await tap(page, TAB_TASKS.x, TAB_TASKS.y, '할일 탭');
  await page.waitForTimeout(2500);

  // ── 4. 지연 태스크 탭 → AI 인터뷰 화면 (14~16초) ──────────
  // "발표 슬라이드 디자인" 지연 태스크 — 할일 목록에서 첫 번째 카드
  // AppBar(56) + TabBar(49) + 패딩(16) + 카드 높이(~80) = 약 y=220
  console.log('4. 지연 태스크 탭 → 인터뷰 화면...');
  await tap(page, 195, 220, '지연 태스크 (발표 슬라이드)');
  await page.waitForTimeout(2000);

  // ── 5. AI 인터뷰 화면 — 첫 질문 로딩 (16~28초) ─────────────
  console.log('5. AI 인터뷰 첫 질문 로딩 중...');
  await page.waitForTimeout(10000); // AI API 응답 대기

  // ── 6. 짧은 답변 입력 + 전송 (28~35초) ─────────────────────
  // 답변 입력창: 화면 하단 y≈650, x=195 (TextField)
  console.log('6. 답변 입력...');
  await tap(page, 195, 650, '답변 입력창');
  await page.waitForTimeout(800);
  await page.keyboard.type('어디서 시작해야 할지 몰라서요', { delay: 60 });
  await page.waitForTimeout(800);

  // 전송 버튼 (IconButton.filled, x≈360, y≈650)
  await tap(page, 362, 650, '전송 버튼');
  await page.waitForTimeout(8000); // 2번째 질문 로딩

  // ── 7. 뒤로 가기 — 할일 탭으로 복귀 (35~39초) ──────────────
  // X 닫기 버튼: AppBar 왼쪽 x≈24, y≈38
  console.log('7. 인터뷰 닫기...');
  await tap(page, 24, 38, 'X 닫기');
  await page.waitForTimeout(2000);

  // ── 8. 분석 완료 태스크 탭 → 결과 화면 (39~42초) ───────────
  // "앱 기획서 작성" (demo-2, 분석완료) — 할일 목록에서 두 번째 카드 y≈310
  console.log('8. 분석완료 태스크 탭 → 결과 화면...');
  await tap(page, 195, 310, '분석완료 태스크 (앱 기획서)');
  await page.waitForTimeout(2000);

  // ── 9. 분석 결과 화면 (42~52초) ────────────────────────────
  console.log('9. 분석 결과 화면 확인...');
  await page.mouse.wheel(0, 200);
  await page.waitForTimeout(2500);
  await page.mouse.wheel(0, 200);
  await page.waitForTimeout(2000);
  await page.mouse.wheel(0, -400);
  await page.waitForTimeout(2000);

  // ── 10. 홈으로 버튼 (52~54초) ──────────────────────────────
  // AppBar 오른쪽 '홈으로' 텍스트버튼 x≈350, y≈38
  console.log('10. 홈으로...');
  await tap(page, 350, 38, '홈으로');
  await page.waitForTimeout(2000);

  // ── 11. 통계 탭으로 마무리 (54~60초) ─────────────────────
  console.log('11. 통계 탭...');
  await tap(page, TAB_STATS.x, TAB_STATS.y, '통계 탭');
  await page.waitForTimeout(4000);

  console.log('✅ 녹화 완료');
  await context.close();
  await browser.close();

  // 최신 영상을 docs/demo.webm으로 저장
  const videoDir = path.join(__dirname, 'videos');
  const files = fs.readdirSync(videoDir)
    .filter(f => f.endsWith('.webm'))
    .sort((a, b) =>
      fs.statSync(path.join(videoDir, b)).mtimeMs -
      fs.statSync(path.join(videoDir, a)).mtimeMs
    );
  if (files.length > 0) {
    const src = path.join(videoDir, files[0]);
    const dest = path.join(__dirname, '..', 'docs', 'demo_raw.webm');
    fs.copyFileSync(src, dest);
    console.log(`✅ 원본 저장: docs/demo_raw.webm`);
  }
});
