#!/bin/sh

NODES_PATH="/home/node/.n8n/nodes"
CHROME_DIR="$NODES_PATH/node_modules/n8n-nodes-playwright/dist/nodes/browsers/chromium-1228/chrome-linux"

mkdir -p "$NODES_PATH"
chown -R node:node /home/node/.n8n

# Background watcher — keeps symlink alive no matter what
(
  while true; do
    if [ -d "$NODES_PATH/node_modules/n8n-nodes-playwright" ]; then
      mkdir -p "$CHROME_DIR"
      ln -sf /usr/lib/chromium/chromium "$CHROME_DIR/chrome" 2>/dev/null
      chown -R node:node "$NODES_PATH/node_modules/n8n-nodes-playwright/dist" 2>/dev/null
    fi
    sleep 5
  done
) &

echo "Symlink watcher started in background"
echo "Starting n8n..."
exec su -s /bin/sh node -c "n8n start"
