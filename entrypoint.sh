#!/bin/sh

NODES_PATH="/home/node/.n8n/nodes"
mkdir -p "$NODES_PATH"
chown -R node:node /home/node/.n8n

# Wait for n8n to finish installing community packages
echo "Starting n8n in background to let it install packages..."
su -s /bin/sh node -c "n8n start" &
N8N_PID=$!

# Wait for the node to be installed
echo "Waiting for n8n-nodes-playwright to be installed..."
UTILS_FILE="$NODES_PATH/node_modules/n8n-nodes-playwright/dist/nodes/playwright/utils.js"
WAITED=0
while [ ! -f "$UTILS_FILE" ] && [ $WAITED -lt 120 ]; do
  sleep 3
  WAITED=$((WAITED + 3))
  echo "Waiting... ($WAITED seconds)"
done

if [ -f "$UTILS_FILE" ]; then
  echo "Found utils.js — patching Chromium path..."

  # Create the exact directory and symlink the node expects
  CHROME_DIR="$NODES_PATH/node_modules/n8n-nodes-playwright/dist/nodes/browsers/chromium-1228/chrome-linux"
  mkdir -p "$CHROME_DIR"
  ln -sf /usr/lib/chromium/chromium "$CHROME_DIR/chrome"
  chown -R node:node "$NODES_PATH/node_modules/n8n-nodes-playwright/dist"

  echo "Symlink created:"
  ls -la "$CHROME_DIR/chrome"
else
  echo "Timeout waiting for playwright node to install"
fi

# Keep container running with n8n
wait $N8N_PID
