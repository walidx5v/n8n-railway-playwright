#!/bin/sh

NODES_PATH="/home/node/.n8n/nodes"
CHROME_DIR="$NODES_PATH/node_modules/n8n-nodes-playwright/dist/nodes/browsers/chromium-1228/chrome-linux"

# Create nodes directory with correct ownership
mkdir -p "$NODES_PATH"
chown -R node:node /home/node/.n8n

# Install playwright node as node user if not present
if [ ! -d "$NODES_PATH/node_modules/n8n-nodes-playwright" ]; then
  echo "Installing n8n-nodes-playwright..."
  su -s /bin/sh node -c "cd $NODES_PATH && npm install n8n-nodes-playwright"
fi

# Create symlink to system Chromium
mkdir -p "$CHROME_DIR"
ln -sf /usr/lib/chromium/chromium "$CHROME_DIR/chrome"
chown -R node:node "$NODES_PATH/node_modules/n8n-nodes-playwright/dist"

echo "Symlink ready:"
ls -la "$CHROME_DIR/chrome"

echo "Starting n8n..."
exec su -s /bin/sh node -c "n8n start"
