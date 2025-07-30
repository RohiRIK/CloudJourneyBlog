#!/bin/sh

# Exit on any error
set -e

echo "🚀 Starting Fabric AI..."

# Debug: Show all FABRIC environment variables
echo "🔍 Debug - Available FABRIC environment variables:"
env | grep FABRIC || echo "  No FABRIC variables found"

# Setup config directory and files
CONFIG_DIR="/root/.config/fabric"
mkdir -p "$CONFIG_DIR"

# Set environment variables for Fabric to use
export OLLAMA_API_URL="${FABRIC_OLLAMA_URL}"
export OLLAMA_BASE_URL="${FABRIC_OLLAMA_URL}"
export GEMINI_API_KEY="${FABRIC_GEMINI_API_KEY}"
export DEFAULT_VENDOR="ollama"
export DEFAULT_MODEL="${FABRIC_DEFAULT_MODEL}"
export FABRIC_API_KEY="${FABRIC_API_KEY}"

# Set Gin to release mode for production
export GIN_MODE=release

echo "✅ Environment variables set:"
echo "  OLLAMA_API_URL: $OLLAMA_API_URL"
echo "  DEFAULT_VENDOR: $DEFAULT_VENDOR"
echo "  DEFAULT_MODEL: $DEFAULT_MODEL"

echo "✅ Fabric setup completed!"

# Setup web interface
echo "🌐 Setting up Fabric Web Interface..."
cd /root/fabric-src/web

# Install web dependencies (only if not already installed)
if [ ! -d "node_modules" ]; then
    echo "📦 Installing web dependencies..."
    npm install
fi

echo "✅ Web dependencies ready!"

# Add allowedHosts to existing vite.config.ts
echo "🔧 Adding allowedHosts to Vite config..."
if ! grep -q "allowedHosts" vite.config.ts; then
    # Insert allowedHosts after the server: { line
    sed -i '/server: {/a\    host: "0.0.0.0",\n    port: 5173,\n    allowedHosts: [\n      "fabric.rohi.life",\n      "fabric-ai.rohi.life",\n      "localhost",\n      "127.0.0.1",\n      "0.0.0.0"\n    ],' vite.config.ts
    echo "✅ allowedHosts added to Vite config!"
else
    echo "✅ allowedHosts already configured!"
fi

# Start web interface in background
echo "🚀 Starting web interface on port 5173..."
npm run dev -- --host 0.0.0.0 --port 5173 &

# Give web interface time to start
sleep 3
echo "✅ Web interface started!"

cd /root

echo "✅ All services ready!"

# Debug: Show environment variables
echo "🔍 Debug - Environment variables:"
echo "  FABRIC_API_KEY: $FABRIC_API_KEY"
echo "  FABRIC_OLLAMA_URL: $FABRIC_OLLAMA_URL"

# Start the API directly with environment variables (this blocks)
echo "🚀 Starting Fabric API on port 8999..."
if [ -n "$FABRIC_API_KEY" ]; then
    exec /root/fabric-src/fabric --serve --address=0.0.0.0:8999 --api-key="$FABRIC_API_KEY"
else
    echo "⚠️  No API key found, starting without authentication..."
    exec /root/fabric-src/fabric --serve --address=0.0.0.0:8999
fi
