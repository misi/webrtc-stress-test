FROM node:14-buster-slim
RUN apt-get update && apt-get install -y --no-install-recommends git python bash \
    ffmpeg curl xvfb unzip procps xvfb xauth sudo net-tools iproute2 \
    && apt-get clean

ENV CHROMIUM_DEB=chromium-browser-unstable_91.0.4469.0-1_amd64.deb

COPY chromium/$CHROMIUM_DEB /
RUN dpkg -i /$CHROMIUM_DEB || true \
    && apt-get install -y -f --no-install-recommends \
    && apt-get clean \
    && rm /$CHROMIUM_DEB \
    && rm -rf /var/cache/apt/* \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app/
COPY video.mp4 /app/

WORKDIR /app
COPY package.json yarn.lock observertc.js /app/
COPY scripts /app/scripts/
RUN yarn --production=true

COPY app.min.js* /app/
CMD xvfb-run -a yarn start
