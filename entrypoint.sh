#!/bin/sh

# Cover both possible paths regardless of N8N_USER_FOLDER setting
PATHS="
/home/node/.n8n/nodes
/home/node/.n8n/.n8n/nodes
/root/.n8n/nodes
"

for NODES_PATH in $PATHS; do
  echo "Setting up: $NODES_PATH"
  mkdir -p "$NODES_PATH"
  cd "$NODES_PATH"

  if [ ! -d "node_modules/n8n-nodes-playwright" ]; then
    echo "Installing n8n-nodes-playwright in $NODES_PATH..."
    npm install n8n-nodes-playwright
  fi

  CHROME_DIR="$NODES_PATH/node_modules/n8n-nodes-playwright/dist/nodes/browsers/chromium-1228/chrome-linux"
  mkdir -p "$CHROME_DIR"
  ln -sf /usr/bin/chromium "$CHROME_DIR/chrome"
  echo "Symlink created at: $CHROME_DIR/chrome"
done

echo "All paths configured. Starting n8n..."
exec n8n start
