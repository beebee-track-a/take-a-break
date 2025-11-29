#!/bin/bash

# Script to start cloudflared tunnel for the local dev server
# Usage: ./start-tunnel.sh

echo "=========================================="
echo "Starting cloudflared tunnel..."
echo "Local server: http://localhost:5173"
echo "=========================================="
echo ""
echo "Your public URL will appear below:"
echo "(Press Ctrl+C to stop the tunnel)"
echo ""

cloudflared tunnel --url http://localhost:5173

