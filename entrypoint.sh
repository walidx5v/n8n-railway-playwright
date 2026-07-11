#!/bin/sh

# Find where Chromium actually is on this system
CHROMIUM_PATH=""
for p in /usr/bin/chromium /usr/bin/chromium-browser /usr/lib/chromium/chromium /usr/lib/chromium-browser/chromium-browser; do
  if [ -f "$p" ]; then
    CHROMIUM_PATH="$p"
    break
  fi
done

if [ -z "$CHROMIUM_PATH" ]; then
  echo "ERROR: Chromium not found! Searching..."
  find /usr -name "chrom*" -type f 2>/dev/null
  exec n8n start
fi

echo "Found Chromium at: $CHROMIUM_PATH"

NODES_PATH="/home/node/.n8n/nodes"
mkdir -p "$NODES_PATH"
cd "$NODES_PATH"

if [ ! -d "node_modules/n8n-nodes-playwright" ]; then
  echo "Installing n8n-nodes-playwright..."
  npm install n8n-nodes-playwright
fi

CHROME_DIR="$NODES_PATH/node_modules/n8n-nodes-playwright/dist/nodes/browsers/chromium-1228/chrome-linux"
mkdir -p "$CHROME_DIR"
ln -sf "$CHROMIUM_PATH" "$CHROME_DIR/chrome"

echo "Symlink created:"
ls -la "$CHROME_DIR/chrome"
echo "Testing if Chromium runs:"
"$CHROMIUM_PATH" --version 2>/dev/null || echo "Chromium test failed"

echo "Starting n8n..."
exec n8n start
