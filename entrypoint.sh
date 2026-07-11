#!/bin/sh

NODES_PATH="/home/node/.n8n/nodes"

echo "Nodes path: $NODES_PATH"
mkdir -p "$NODES_PATH"
cd "$NODES_PATH"

if [ ! -d "node_modules/n8n-nodes-playwright" ]; then
  echo "Installing n8n-nodes-playwright..."
  npm install n8n-nodes-playwright
fi

CHROME_DIR="$NODES_PATH/node_modules/n8n-nodes-playwright/dist/nodes/browsers/chromium-1228/chrome-linux"
mkdir -p "$CHROME_DIR"
ln -sf /usr/bin/chromium "$CHROME_DIR/chrome"

echo "Symlink verify:"
ls -la "$CHROME_DIR/chrome"

echo "Starting n8n..."
exec n8n start
