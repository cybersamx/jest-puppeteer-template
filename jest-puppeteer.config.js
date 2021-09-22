const debug = process.env.CS_DEBUG === 'true';

module.exports = {
  launch: {
    headless: !debug,
    slowMo: (debug) ? 50 : 0,
    args: [
      '--disable-dev-shm-usage',
      '--disable-gpu',
    ],
  },
};
