FROM n8nio/n8n:latest

USER root

RUN apt-get update && apt-get install -y \
    chromium \
    chromium-driver \
    libnss3 \
    libfreetype6 \
    libharfbuzz0b \
    ca-certificates \
    fonts-freefont-ttf \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

ENV PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1
ENV PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH=/usr/bin/chromium

RUN cd /home/node/.n8n && \
    mkdir -p nodes && \
    cd nodes && \
    npm install n8n-nodes-playwright

RUN chown -R node:node /home/node/.n8n

USER node
