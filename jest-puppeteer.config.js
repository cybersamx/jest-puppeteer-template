module.exports = {
  launch: {
    headless: process.env.HEADLESS || true,
    args: [
      '--disable-dev-shm-usage',
      '--disable-gpu',
    ],
  },
};
