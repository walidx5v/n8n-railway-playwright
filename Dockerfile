FROM node:22-alpine

USER root

RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    tini \
    make \
    g++ \
    python3

RUN npm install -g n8n

ENV PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1
ENV N8N_USER_FOLDER=/home/node

# Install Playwright community node
RUN mkdir -p /home/node/.n8n/nodes && \
    cd /home/node/.n8n/nodes && \
    npm install n8n-nodes-playwright

# Create exact path the node expects and symlink system Chromium there
RUN mkdir -p /home/node/.n8n/nodes/node_modules/n8n-nodes-playwright/dist/nodes/browsers/chromium-1228/chrome-linux && \
    ln -sf /usr/bin/chromium \
    /home/node/.n8n/nodes/node_modules/n8n-nodes-playwright/dist/nodes/browsers/chromium-1228/chrome-linux/chrome

RUN chown -R node:node /home/node

USER node

EXPOSE 5678

ENTRYPOINT ["tini", "--"]
CMD ["n8n", "start"]
