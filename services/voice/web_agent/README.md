# GLM-4-Voice Real-time Chat (Milo Voice Assistant)

Real-time voice conversation with GLM-4-Voice using streaming audio and server-side VAD. Meet Milo, your voice assistant for take-a-break!

## Features

- 🎤 Real-time voice chat with instant responses
- 🔊 Streaming audio playback
- 📝 Auto-transcription with OpenAI Whisper
- 🔄 Multi-turn conversations with context
- 🎯 Server-side speech detection (no "send" button)
- 🌐 Public deployment via Cloudflare Tunnel
- 🌍 English and Chinese language support

## Quick Start

See [QUICKSTART.md](QUICKSTART.md) for the fastest setup.

### Local Development

#### 1. Setup (one-time)

```bash
./setup.sh
```

#### 2. Configure API Key

Edit `.env` and add your GLM API key:
```bash
GLM_API_KEY=your_actual_api_key_here
```

Get your API key from: https://open.bigmodel.cn/

#### 3. Run Locally

**Terminal 1** (Backend):
```bash
./start_backend.sh
```

**Terminal 2** (Frontend):
```bash
./start_frontend.sh
```

Open http://localhost:5176 and click "Start Chat"! 🎤

### Public Deployment with Cloudflared

To make your voice agent publicly accessible (great for testing or sharing):

#### 1. Install Cloudflared

**macOS:**
```bash
brew install cloudflare/cloudflare/cloudflared
```

**Linux/Other:**
Download from: https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/installation/

#### 2. Build Frontend

```bash
cd frontend
npm run build
cd ..
```

#### 3. Start with Cloudflared

```bash
./start_cloudflared.sh
```

The script will:
- Build the frontend (if needed)
- Start the backend on port 8000 (serving both API and frontend)
- Create a cloudflared tunnel
- Display your public URL (e.g., `https://xxxxx.trycloudflare.com`)

**Note:** The URL changes each time you restart. Each user gets their own isolated chat session - no interference between users!

## Configuration

### Backend Settings

Edit `backend/config.py` for VAD and audio settings:

```python
# Adjust speech detection sensitivity
SILENCE_THRESHOLD = 500
MAX_SILENCE_MS = 500

# Change Whisper model (tiny/base/small/medium/large)
# Trade-off: speed vs accuracy
# Default: "medium"
```

### Milo System Prompt

Edit `backend/config.py` to customize Milo's personality and behavior:

```python
MILO_HEADER_SYSTEM_PROMPT = """You are Milo, the voice assistant for take-a-break..."""
```

## Project Structure

```
web_agent/
├── backend/
│   ├── main.py              # FastAPI server (serves API + frontend)
│   ├── glm_voice_client.py  # GLM API client with Whisper
│   ├── audio_utils.py       # Audio processing
│   ├── vad.py              # Speech detection
│   ├── config.py           # Settings + Milo prompt
│   └── session_manager.py  # Session state management
├── frontend/
│   ├── src/
│   │   ├── App.tsx         # Main UI
│   │   ├── audio/          # Recorder & player
│   │   ├── api/            # WebSocket client
│   │   └── types.ts        # TypeScript types
│   └── dist/               # Built frontend (served by backend)
├── start_backend.sh        # Start backend locally
├── start_frontend.sh       # Start frontend dev server
├── start_cloudflared.sh    # Deploy publicly with cloudflared
└── requirements.txt
```

## Architecture

- **Backend**: FastAPI server on port 8000
  - WebSocket endpoint: `/ws/voice`
  - Serves built frontend from `frontend/dist/`
  - Each WebSocket connection gets a unique session ID
  - Sessions are isolated - multiple users can chat simultaneously

- **Frontend**: React + TypeScript + Vite
  - Connects to backend via WebSocket
  - Auto-detects backend URL (works with cloudflared)
  - Build output served by backend in production

- **Cloudflared**: Creates a temporary public URL
  - Backend + Frontend both accessible at the same URL
  - One tunnel serves everything
  - WebSocket upgrades work automatically

## Troubleshooting

**Microphone not working**
- Use HTTPS or localhost
- Check browser permissions

**High latency**
- Switch to faster Whisper model: `whisper_model_name = "base"` in `config.py`

**Backend errors**
- Check logs for detailed messages
- Verify GLM API key is valid

## Requirements

- Python 3.8+
- Node.js 16+
- GLM API key from [open.bigmodel.cn](https://open.bigmodel.cn/)
