#!/bin/bash

# Simple script to publish the voice agent using cloudflared
# This serves both frontend and backend from a single port

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo "🌐 Setting up voice agent for cloudflared..."
echo ""

# Check if cloudflared is installed
if ! command -v cloudflared &> /dev/null; then
    echo "❌ cloudflared is not installed."
    echo "   Install it from: https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/installation/"
    echo "   Or on macOS: brew install cloudflare/cloudflare/cloudflared"
    exit 1
fi

# Check if frontend is built
if [ ! -d "frontend/dist" ]; then
    echo "📦 Building frontend..."
    cd frontend
    if [ ! -d "node_modules" ]; then
        echo "❌ Node modules not found. Run npm install first"
        exit 1
    fi
    npm run build
    cd ..
    echo "✅ Frontend built"
    echo ""
fi

# Check if backend is ready
if [ ! -d "venv" ]; then
    echo "❌ Virtual environment not found. Run ./setup.sh first"
    exit 1
fi

if [ ! -f ".env" ]; then
    echo "❌ .env file not found. Copy env.example to .env and add your API key"
    exit 1
fi

echo "🚀 Starting backend server on port 8000..."
echo "   (This will serve both the API and frontend)"
echo ""

# Start backend
source venv/bin/activate
cd backend

# Start backend in background
python -m uvicorn main:app --host 0.0.0.0 --port 8000 --log-level info &
BACKEND_PID=$!
cd ..

# Wait for backend to start
sleep 3

# Check if backend started successfully
if ! kill -0 $BACKEND_PID 2>/dev/null; then
    echo "❌ Backend failed to start"
    exit 1
fi

echo "✅ Backend started (PID: $BACKEND_PID)"
echo ""

echo "🌐 Creating cloudflared tunnel..."
echo ""

# Start cloudflared tunnel
cloudflared tunnel --url http://localhost:8000 &
TUNNEL_PID=$!

# Wait a moment for tunnel to establish
sleep 4

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎉 Voice agent is now publicly accessible!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📍 Check the cloudflared output above for your public URL"
echo "   (Look for: https://...trycloudflare.com)"
echo ""
echo "   The frontend and backend are both accessible at this URL!"
echo ""
echo "Press Ctrl+C to stop"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Cleanup function
cleanup() {
    echo ""
    echo "🛑 Stopping services..."
    kill $BACKEND_PID $TUNNEL_PID 2>/dev/null || true
    echo "✅ All services stopped"
    exit 0
}

trap cleanup INT TERM

# Wait for user interrupt
wait
