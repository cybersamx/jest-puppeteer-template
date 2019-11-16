import puppeteer from 'puppeteer';

describe('Google', () => {
  const timeout = 30 * 100; // timeout in milliseconds

  const testFunc = async () => {
    const browser = await puppeteer.launch();
    const page = await browser.newPage();
    await page.goto('https://google.com');

    await expect(page.title()).resolves.toMatch('Google');

    browser.close();
  };

  test('Display Google', testFunc, timeout);
});
