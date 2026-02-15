# Termux Agent Quick Reference Card

## 🚀 30-Second Setup

```bash
# Terminal 1: Start Ollama
ollama serve

# Terminal 2: Setup & Run Agent
source ~/.agentic-agent.env
cd ~/agentic-ancient-alien
python ancient-loopers/agent.py commands/predict_2030.json
```

---

## 📋 Essential Commands

| Command | Purpose |
|---------|---------|
| `pkg update && pkg upgrade -y` | Update Termux packages |
| `pip install web3` | Install Python dependencies |
| `ollama pull neural-chat` | Download LLM model |
| `ollama serve` | Start Ollama daemon |
| `python agent.py commands/predict_2030.json` | Run prediction cycle |
| `ps aux \| grep python` | Check if agent running |
| `tail -f ~/agent-logs/agent-continuous.log` | View live logs |
| `pkill -f "python.*agent"` | Stop agent loop |
| `tmux new-session -d -s agent "command"` | Run in background |
| `tmux attach -t agent` | Attach to background session |

---

## 🔑 API Keys Setup

```bash
# Create secure env file
nano ~/.agentic-agent.env

# Add these with YOUR actual keys:
HELIUS_API_KEY="your_helius_key"
ALCHEMY_API_KEY="your_alchemy_key"
BICONOMY_API_KEY="your_biconomy_key"
PRIVATE_KEY="your_ethereum_private_key"
SOLANA_TREASURY="your_solana_address"
OLLAMA_API_URL="http://localhost:11434"
OLLAMA_MODEL="neural-chat"

# Secure the file
chmod 600 ~/.agentic-agent.env

# Load it
source ~/.agentic-agent.env
```

---

## 🦙 Ollama Model Options

| Model | Size | Speed | Quality | RAM |
|-------|------|-------|---------|-----|
| **orca-mini** | 1.3GB | ⚡⚡⚡ | ★★★ | 2GB |
| **neural-chat** | 1.6GB | ⚡⚡ | ★★★★ | 2GB |
| **falcon** | 1.5GB | ⚡⚡ | ★★★ | 2GB |
| **mistral** | 4.1GB | ⚡ | ★★★★★ | 4GB |
| **llama2** | 3.8GB | ⚡ | ★★★★ | 4GB |

**Recommended for Android:** `neural-chat` (best balance) or `orca-mini` (lightest)

---

## 🔄 Running Modes

### Mode 1: Single Prediction
```bash
source ~/.agentic-agent.env
python ~/agentic-ancient-alien/ancient-loopers/agent.py commands/predict_2030.json
```
**Use:** Quick tests, manual runs

### Mode 2: Continuous Loop (Foreground)
```bash
python ~/continuous-agent-loop.py
# Press Ctrl+C to stop
```
**Use:** Interactive monitoring

### Mode 3: Continuous Loop (Background)
```bash
tmux new-session -d -s "agent-loop" "source ~/.agentic-agent.env && python ~/continuous-agent-loop.py"
tmux attach -t agent-loop      # View output
# Ctrl+B, D to detach
tmux kill-session -t agent-loop # Stop
```
**Use:** Long-running operations, overnight runs

---

## 🔴 Common Issues & Fixes

| Issue | Fix |
|-------|-----|
| **Connection refused** | Start Ollama: `ollama serve` |
| **No module 'web3'** | Install: `pip install web3` |
| **API key not found** | Load env: `source ~/.agentic-agent.env` |
| **Timeout errors** | Check WiFi, reduce cycle interval |
| **Phone gets hot** | Use `orca-mini`, reduce frequency |
| **Memory errors** | Kill other apps, restart Termux |
| **Port 11434 in use** | Kill Ollama: `pkill -f "ollama serve"` |

---

## 📊 Monitoring Commands

```bash
# View logs
tail -20 ~/agent-logs/agent-continuous.log

# Watch logs live
tail -f ~/agent-logs/agent-continuous.log

# Check running processes
ps aux | grep -E "python|ollama"

# Monitor system resources
top
free -h

# Verify Ollama is running
curl http://localhost:11434/api/tags
```

---

## 🔐 Security Checklist

- [ ] Never commit `.env` file to git
- [ ] Use `chmod 600` on `.env` file
- [ ] Use testnet keys for development
- [ ] Rotate API keys periodically
- [ ] Don't share private keys
- [ ] Use VPN if on public WiFi
- [ ] Disable Termux accessibility (if not needed)

---

## 📱 Required Installations

```bash
# Minimum (works)
pkg install -y python git

# Recommended (better experience)
pkg install -y python git curl wget node-lts vim tmux build-essential

# Full setup (best)
pkg install -y python git curl wget node-lts vim tmux build-essential \
  openssh clang make autoconf automake libtool zlib-dev
```

---

## 📞 Help Resources

- **Termux Wiki:** https://wiki.termux.com
- **Ollama Docs:** https://github.com/ollama/ollama
- **Agent Repo:** https://github.com/solalienseeker-mobile/agentic-ancient-alien
- **Python Docs:** https://docs.python.org/3/

---

**🎯 Pro Tip:** Keep Termux running on a charger for uninterrupted agent operation!
