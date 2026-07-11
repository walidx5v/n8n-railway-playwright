#!/bin/sh
echo "Setting up Playwright community node..."

# Install community node if not already installed
mkdir -p /home/node/.n8n/nodes
cd /home/node/.n8n/nodes

if [ ! -d "node_modules/n8n-nodes-playwright" ]; then
  echo "Installing n8n-nodes-playwright..."
  npm install n8n-nodes-playwright
fi

# Create the exact path the node looks for and symlink system Chromium
echo "Creating Chromium symlink..."
mkdir -p /home/node/.n8n/nodes/node_modules/n8n-nodes-playwright/dist/nodes/browsers/chromium-1228/chrome-linux

ln -sf /usr/bin/chromium \
  /home/node/.n8n/nodes/node_modules/n8n-nodes-playwright/dist/nodes/browsers/chromium-1228/chrome-linux/chrome

echo "Symlink created. Starting n8n..."
exec n8n start
