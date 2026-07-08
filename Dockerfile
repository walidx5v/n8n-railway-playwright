FROM node:20-alpine

USER root

# Install Chromium and system dependencies
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    tini

# Install n8n globally
RUN npm install -g n8n

# Set environment variables
ENV PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1
ENV PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH=/usr/bin/chromium-browser
ENV N8N_USER_FOLDER=/home/node/.n8n

# Install Playwright community node
RUN mkdir -p /home/node/.n8n/nodes && \
    cd /home/node/.n8n/nodes && \
    npm install n8n-nodes-playwright

RUN chown -R node:node /home/node

USER node

EXPOSE 5678

ENTRYPOINT ["tini", "--"]
CMD ["n8n", "start"]
