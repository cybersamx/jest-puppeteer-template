# Pin the chromium version to 89.
# For newer versions and more info on the base image, see https://github.com/Zenika/alpine-chrome.
FROM zenika/alpine-chrome:89-with-puppeteer

# Copy package.json separately so that Docker can cache this step
COPY package*.json ./
RUN npm install --no-optional --production && npm cache clean --force

# Copy the test suite over
COPY . ./

# Run the test
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["npm", "test"]
