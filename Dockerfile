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
ENV N8N_USER_FOLDER=/home/node/.n8n

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN chown -R node:node /home/node

USER node

EXPOSE 5678

ENTRYPOINT ["/entrypoint.sh"]
