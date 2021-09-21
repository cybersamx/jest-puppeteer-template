# Jest-Puppeteer Template

A template project for writing end-to-end tests using [Jest](https://jestjs.io) and [Puppeteer](https://github.com/GoogleChrome/puppeteer).

This project's purpose is to points to a website and perform end-to-end tests. It's completely white box testing, in which we don't need the source code. 

## Setup

Run the tests locally.

1. Install packages.

   ```bash
   $ npm install
   ```
   
1. Run the test.

   ```bash
   $ npm test
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

### Code Style

This project follows the [AirBnB JavaScript style guide](https://github.com/airbnb/javascript).

### Configurations

It's generally a [good practice to define configurations in JSON over JS](https://babeljs.io/docs/en/config-files#project-wide-configuration). So all static and dynamic configurations for the dev tools are defined in `*.json` and `*.js` files respectively.

### Docker

Docker image [jest-puppeteer](https://hub.docker.com/repository/docker/cybersamx/jest-puppeteer/) available on Docker Hub.

* If you see `Failed to move to new namespace` error message when running the Docker image. [See here for details](https://github.com/Zenika/alpine-chrome#3-ways-to-use-chrome-headless-with-this-image) on running Chromium headless as a non-privileged user. You need to pass the `--cap-add=SYS_ADMIN` option to Docker.
* Be careful when launching Chromium with the `-—no-sandbox` parameter. Make sure you understand its [implications](https://chromium.googlesource.com/chromium/src/+/master/docs/design/sandbox.md) especially for websites, with which you are unfamiliar.
* By default, Docker container is configured with `/dev/shm` of 64MB of shared memory. This isn't enough for Chromium to run. To run the Docker jest-puppeeter container properly, we pass the `--disable-dev-shm-usage` to direct Chromium to use `/tm` to write shared memory files. [See here for details](https://github.com/GoogleChrome/puppeteer/blob/master/docs/troubleshooting.md#tips).
* Given that only Chromium 77+ works on Alpine, we are installing Chromium directly using the Alpine apk package manager as opposed to using the Chromium installation step by Puppeteer. Because of this, be mindful of the recommended version of Chromium needed by a specific version of Puppeteer. [See all corresponding Chromium and Puppeteer versions](https://github.com/GoogleChrome/puppeteer/blob/v2.0.0/docs/api.md).    

## Troubleshooting

**You see `mkdir: can't create directory '/tmp/jest_rs': No space left on device` when running the Docker container.**

This usually means that Docker system has limited space left. Run this command `docker system prune --all --force` to free up some resources.

## Reference and Credit

* [AirBnB JavaScript style guide](https://github.com/airbnb/javascript)
* [Babel](https://babeljs.io)
* [ESLint Rules](https://eslint.org/docs/rules)
* [Jest API](https://jestjs.io/docs/en/api)
* [Jest configurations](https://jestjs.io/docs/en/configuration.html)
* [Puppeteer](https://github.com/GoogleChrome/puppeteer)
* [Puppeteer API](https://github.com/GoogleChrome/puppeteer/blob/v2.0.0/docs/api.md)
* [Running Puppeteer on Docker](https://github.com/GoogleChrome/puppeteer/blob/master/docs/troubleshooting.md#running-puppeteer-in-docker)
* [Zenika Chromium on Alpine Docker](https://github.com/Zenika/alpine-chrome)
