# CREDIT: https://github.com/Zenika/alpine-chrome
# Don't want to use edge package, created this Dockerfile that's based on
# zenika/alpine-chrome
FROM alpine:3.14.2

RUN apk update && apk upgrade

# Install Chromium version >=77 for it to run well with Alpine
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" > /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/v3.12/main" >> /etc/apk/repositories \
    && apk upgrade -U -a \
    && apk add \
    libstdc++ \
    chromium \
    harfbuzz \
    nss \
    freetype \
    ttf-freefont \
    font-noto-emoji \
    wqy-zenhei \
    nodejs \
    nodejs-npm \
    tini

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
COPY package*.json ./
RUN npm install --no-optional --production && npm cache clean --force

# Copy the test suite over
COPY --chown=${USER} . ./

# Run the test
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["npm", "test"]
