// Jetbrains IDE doesn't parse env and globals from .eslintrc. This is a workaround.
// eslint-disable-next-line no-redeclare
/* global beforeAll, describe, expect, it, page */

const timeout = 30 * 1000; // In milliseconds

describe('Google', () => {
  beforeAll(async () => {
    await page.goto('https://google.com');
  });

  it('should see a title that says Google', async () => {
    await expect(page.title()).resolves.toMatch('Google');
  }, timeout);

  it('should enter text to the search box', async () => {
    await expect(page).toFillForm('form[action="/search"]', {
      q: 'jest puppeteer',
    });
  }, timeout);
});
