# Quick Start

## Option 1: Local Development (2 terminals)

### 1. Setup (one-time)
```bash
./setup.sh
```

### 2. Configure API Key
Edit `.env` and add your GLM API key:
```bash
GLM_API_KEY=your_actual_api_key_here
```

Get your API key from: https://open.bigmodel.cn/

### 3. Run
**Terminal 1** (Backend):
```bash
./start_backend.sh
```

**Terminal 2** (Frontend):
```bash
./start_frontend.sh
```

Open http://localhost:5176 and click "Start Chat"! 🎤

---

## Option 2: Public Deployment (Cloudflared)

Make your voice agent publicly accessible in one command!

### 1. Install Cloudflared

**macOS:**
```bash
brew install cloudflare/cloudflare/cloudflared
```

**Linux/Other:**
Visit: https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/installation/

### 2. Setup & Configure (if not done)
```bash
./setup.sh
# Edit .env and add GLM_API_KEY
```

### 3. Deploy
```bash
./start_cloudflared.sh
```

That's it! The script will:
- Build the frontend automatically
- Start the backend
- Create a public tunnel
- Display your public URL

**Example output:**
```
🎉 Voice agent is now publicly accessible!
📍 https://xxxxx.trycloudflare.com
```

**Features:**
- ✅ Frontend and backend accessible at the same URL
- ✅ Each user gets their own isolated chat session
- ✅ WebSocket connections work automatically
- ✅ Share the URL with anyone!

**Note:** The URL changes each time you restart cloudflared. Perfect for testing and demos!

---

See [README.md](README.md) for full documentation.

