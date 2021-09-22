# Jest-Puppeteer Template

A template project for writing end-to-end tests using [Jest](https://jestjs.io) and [Puppeteer](https://github.com/GoogleChrome/puppeteer).

## Setup

Run the tests locally.

1. Install packages.

   ```bash
   $ npm install
   ```
   
1. Run the tests.

   ```bash
   $ # Run the tests in headless mode.
   $ npm test
   $ # Run the tests visually on web browser.
   $ CS_DEBUG=1 npm test
   ```

Run the tests in Docker - great for CI and running it in the Cloud.

1. Build the Docker image.

   ```bash
   $ docker-compose build
   ```
   
1. Run the Docker image.

   ```bash
   $ docker-compose up
   ```

## Notes

### Jest-Puppeteer 

If you are just using puppeteer for the e2e testing, you would write your test this way:

```js
describe('Google', () => {
  it('should display Google', async () => {
    const browser = await puppeteer.launch();
    const page = await browser.newPage();
    await page.goto('https://google.com');
    await expect(page.title()).resolves.toMatch('Google');
    await browser.close();
  }, 30000);
});
```

This project leverages [jest-puppeteer](https://github.com/smooth-code/jest-puppeteer), which allows us to declare configurations in our config files. When jest runs the tests, the package will initializes some global variables according to the declared configurations.

We also use the package [expect-puppeteer](https://github.com/smooth-code/jest-puppeteer/tree/master/packages/expect-puppeteer) for better test assertion handling.

With this setup:

```js
// jest-puppeteer.config.js
module.exports = {
   launch: {
      headless: !debug,
      args: [
         '--disable-dev-shm-usage',
         '--disable-gpu',
      ],
   },
};
```

In `jest.config.json`:

```json
{
   "globalSetup": "jest-environment-puppeteer/setup",
   "globalTeardown": "jest-environment-puppeteer/teardown",
   "testEnvironment": "jest-environment-puppeteer",
   "setupFilesAfterEnv": ["expect-puppeteer"]
}
```

Now that `browser` object is initialized and exposed at runtime, our test code becomes:

```js
describe('Google', () => {
   it('should display Google', async () => {
      await page.goto('https://google.com');
      await expect(page.title()).resolves.toMatch('Google');
   }, 30000);
});
```

### Docker

Running Puppeteer in Docker can be problematic at times. Here are some troubleshooting tips.

* If you see `Failed to move to new namespace` error message when running the Docker image. [See here for details](https://github.com/Zenika/alpine-chrome#3-ways-to-use-chrome-headless-with-this-image) on running Chromium headless as a non-privileged user. You need to pass the `--cap-add=SYS_ADMIN` option to Docker.
* Be careful when launching Chromium with the `-—no-sandbox` parameter. Make sure you understand its [implications](https://chromium.googlesource.com/chromium/src/+/master/docs/design/sandbox.md) especially for websites, with which you are unfamiliar.
* By default, Docker container is configured with `/dev/shm` of 64MB of shared memory. This isn't enough for Chromium to run. To run the Docker jest-puppeeter container properly, we pass the `--disable-dev-shm-usage` to direct Chromium to use `/tm` to write shared memory files. [See here for details](https://github.com/GoogleChrome/puppeteer/blob/master/docs/troubleshooting.md#tips).
* Given that only Chromium 77+ works on Alpine, we are installing Chromium directly using the Alpine apk package manager as opposed to using the Chromium installation step by Puppeteer. Because of this, be mindful of the recommended version of Chromium needed by a specific version of Puppeteer. [See all corresponding Chromium and Puppeteer versions](https://github.com/GoogleChrome/puppeteer/blob/v2.0.0/docs/api.md).
* If you see `mkdir: can't create directory '/tmp/jest_rs': No space left on device` when running the Docker container, it usually means that Docker system has limited space left. Run this command `docker system prune --all --force` to free up some resources.

## Reference and Credit

* [Babel](https://babeljs.io)
* [ESLint Rules](https://eslint.org/docs/rules)
* [Jest API](https://jestjs.io/docs/en/api)
* [Jest configurations](https://jestjs.io/docs/en/configuration.html)
* [Jest-Puppeteer](https://github.com/smooth-code/jest-puppeteer)
   * [Expect-Puppeteer](https://github.com/smooth-code/jest-puppeteer/tree/master/packages/expect-puppeteer)
   * [Jest-Environment-Puppeteer](https://github.com/smooth-code/jest-puppeteer/tree/master/packages/jest-environment-puppeteer)
* [Puppeteer](https://github.com/GoogleChrome/puppeteer)
   * [Puppeteer API](https://github.com/GoogleChrome/puppeteer/blob/v2.0.0/docs/api.md)
* [Running Puppeteer on Docker](https://github.com/GoogleChrome/puppeteer/blob/master/docs/troubleshooting.md#running-puppeteer-in-docker)
* [Zenika Chromium on Alpine Docker](https://github.com/Zenika/alpine-chrome)
