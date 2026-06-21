/**
 * 30초 데모 영상 녹화 스크립트
 * Flutter web은 Shadow DOM / CanvasKit을 사용하므로 좌표 기반 클릭 사용
 *
 * 탭 위치 (width=390, height=844):
 *   홈(x=49) | 할일(x=146) | AI분석(x=244) | 통계(x=341)  — y≈810
 *
 * 실행: cd e2e && npx playwright test demo-record --project=chromium
 */
import { test } from '@playwright/test';
import { chromium } from '@playwright/test';
import * as path from 'path';
import * as fs from 'fs';

const TAB_Y = 810;
const TAB_HOME = { x: 49, y: TAB_Y };
const TAB_TASKS = { x: 146, y: TAB_Y };
const TAB_AI = { x: 244, y: TAB_Y };
const TAB_STATS = { x: 341, y: TAB_Y };

async function click(page: any, x: number, y: number, label: string) {
  console.log(`  → 클릭: ${label} (${x}, ${y})`);
  await page.mouse.click(x, y);
}

test('30초 데모 영상 녹화', async () => {
  test.setTimeout(120_000); // 영상 녹화 + 파일 저장까지 충분한 시간

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

  // ── 1. 로그인 화면 (0~4초) ─────────────────────────────
  console.log('1. 로그인 화면...');
  await page.goto('http://localhost:5000');
  await page.waitForTimeout(3500);

  // ── 2. 데모 버튼 클릭 → 홈 화면 (4~8초) ──────────────
  // "데모로 보기" 버튼 — 스크린샷 기준 y≈780, x=195
  console.log('2. 데모로 보기 클릭...');
  await click(page, 195, 780, '데모로 보기');
  await page.waitForTimeout(3500); // 홈 화면 + 데이터 로드

  // ── 3. 할일 탭 — 지연 태스크 목록 (8~14초) ────────────
  console.log('3. 할일 탭...');
  await click(page, TAB_TASKS.x, TAB_TASKS.y, '할일 탭');
  await page.waitForTimeout(2500);
  // 화면을 천천히 스크롤해서 태스크 목록 보여주기
  await page.mouse.wheel(0, 150);
  await page.waitForTimeout(1000);
  await page.mouse.wheel(0, -150);
  await page.waitForTimeout(1500);

  // ── 4. AI분석 탭 (14~20초) ─────────────────────────────
  console.log('4. AI분석 탭...');
  await click(page, TAB_AI.x, TAB_AI.y, 'AI분석 탭');
  await page.waitForTimeout(4000); // HistoryScreen 로드

  // ── 5. 통계 탭 (20~27초) ──────────────────────────────
  console.log('5. 통계 탭...');
  await click(page, TAB_STATS.x, TAB_STATS.y, '통계 탭');
  await page.waitForTimeout(4000);

  // ── 6. 홈 탭으로 마무리 (27~30초) ─────────────────────
  console.log('6. 홈 탭으로 마무리...');
  await click(page, TAB_HOME.x, TAB_HOME.y, '홈 탭');
  await page.waitForTimeout(2500);

  console.log('✅ 녹화 완료, 브라우저 닫는 중...');
  await context.close();
  await browser.close();

  // 생성된 비디오를 docs/demo.webm으로 복사
  const videoDir = path.join(__dirname, 'videos');
  const files = fs.readdirSync(videoDir)
    .filter(f => f.endsWith('.webm'))
    .sort((a, b) => {
      return fs.statSync(path.join(videoDir, b)).mtimeMs
           - fs.statSync(path.join(videoDir, a)).mtimeMs;
    });

  if (files.length > 0) {
    const src = path.join(videoDir, files[0]);
    const dest = path.join(__dirname, '..', 'docs', 'demo.webm');
    fs.copyFileSync(src, dest);
    console.log(`✅ 영상 저장됨: docs/demo.webm`);
  } else {
    console.log('⚠️ 비디오 파일을 찾을 수 없습니다.');
  }
});
