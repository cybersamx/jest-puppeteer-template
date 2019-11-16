# CREDIT: https://github.com/Zenika/alpine-chrome
# Don't want to use edge package, created this Dockerfile that's based on
# zenika/alpine-chrome
FROM alpine:3

RUN apk update && apk upgrade

# Install Chromium version >=77 for it to run well with Alpine
RUN apk add --no-cache \
    ca-certificates \
    chromium>79 \
    freetype-dev \
    nodejs \
    nodejs-npm \
    tini \
    ttf-freefont \
    yarn

# Don't need Puppeteer to install Chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser \
    USER=puppeteer

# Add a user to run Chromium
RUN mkdir -p /home/${USER}  && \
    adduser -D ${USER} && \
    chown -R ${USER}:${USER} /home/${USER}
USER ${USER}
WORKDIR /home/${USER}

# Seaparately copy package.json over for caching
COPY package.json ./
RUN npm install

# Copy the test suite over
COPY --chown=${USER} . ./

# Run the test
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["npm", "test"]