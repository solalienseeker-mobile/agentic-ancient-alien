# 🤖 Agentic Ancient Alien Agent Setup on Android (Termux + Ollama)

A complete guide to running the **Omega-Prime Data-Forge** autonomous agent loop on your Android phone using **Termux** terminal emulator and **Ollama** for local LLM inference.

---

## 📋 Table of Contents

1. [Prerequisites](#prerequisites)
2. [Installation Steps](#installation-steps)
3. [Ollama Setup](#ollama-setup)
4. [Agent Configuration](#agent-configuration)
5. [Running the Agent](#running-the-agent)
6. [Continuous Loop Execution](#continuous-loop-execution)
7. [API Key Management](#api-key-management)
8. [Troubleshooting](#troubleshooting)
9. [Performance Tips](#performance-tips)

---

## 📱 Prerequisites

### Required on Android Phone:
- **Android 7.0+** (API 24+)
- **4GB RAM minimum** (8GB+ recommended)
- **2GB free storage** for Ollama models
- **Termux app** (from F-Droid or GitHub, NOT Google Play)
- **Ollama for Android** (0.1.0+) - https://github.com/ollama/ollama
- **USB cable** (optional, for file transfer)

### Network Requirements:
- WiFi connection (recommended)
- For API keys: internet access
- Optional: Local network for connecting desktop to phone

---

## 🚀 Installation Steps

### Step 1: Install Termux

**Option A - F-Droid (Recommended)**
```bash
# Install from F-Droid
# F-Droid URL: https://f-droid.org/packages/com.termux/
```

**Option B - GitHub**
```bash
# Download APK from:
# https://github.com/termux/termux-app/releases
# Choose: termux-app_*.apk (latest release)
```

**Option C - Google Play (Don't Use)**
```
⚠️  The Google Play version is outdated and will cause issues.
Use F-Droid or GitHub instead.
```

### Step 2: Initial Termux Setup

After installing Termux, open it and run:

```bash
# Update package list
pkg update

# Upgrade packages
pkg upgrade -y

# Install essential tools
pkg install -y git curl wget python node-lts

# Install development tools (optional but recommended)
pkg install -y build-essential clang make
```

### Step 3: Install Ollama on Android

**Download Ollama APK:**
```bash
# Visit https://github.com/ollama/ollama/releases
# Download the latest .apk file for Android
# Or use termux to download:
wget https://github.com/ollama/ollama/releases/download/v0.1.0/ollama.apk
```

**Install via Termux:**
```bash
# Option 1: Copy APK to phone and install via settings
# Settings > Apps > Install unknown apps > Termux > Allow
# Then transfer ollama.apk and open with system installer

# Option 2: Direct installation (if permissions allow)
pm install ./ollama.apk
```

---

## 🦙 Ollama Setup

### Step 1: Start Ollama Service

```bash
# In Termux, start Ollama daemon
ollama serve

# Output should show:
# listening on 127.0.0.1:11434
```

**Keep this terminal open!** (or use separate Termux session)

### Step 2: Pull LLM Model (Second Terminal)

Open a **new Termux session** while Ollama is running:

```bash
# List available models
ollama list

# Pull a lightweight model (recommended for Android)
ollama pull llama2       # 3.8GB - Standard
# OR
ollama pull mistral      # 4.1GB - Better quality
# OR
ollama pull neural-chat  # 1.6GB - Lightweight (best for low RAM)
```

**Model Selection Guide:**
| Model | Size | RAM Needed | Speed | Quality |
|-------|------|-----------|-------|---------|
| neural-chat | 1.6GB | 2GB | Fast | Good |
| orca-mini | 1.3GB | 2GB | Very Fast | Fair |
| mistral | 4.1GB | 4GB | Medium | Excellent |
| llama2 | 3.8GB | 4GB | Medium | Very Good |
| dolphin-mixtral | 26GB | 12GB+ | Slow | Best |

### Step 3: Test Ollama Connection

```bash
# Test local inference
curl http://localhost:11434/api/generate -d '{
  "model": "neural-chat",
  "prompt": "What is AI?",
  "stream": false
}'

# Should return JSON with generated text
```

---

## 🔑 Agent Configuration

### Step 1: Create Environment File

```bash
# Create .env file in agent directory
nano ~/.agentic-agent.env
```

**Add the following (modify with your actual keys):**

```bash
# === BLOCKCHAIN RPC ENDPOINTS ===
SOLANA_RPC_URL="https://api.devnet.solana.com"
NEON_RPC_URL="https://devnet.neonevm.org"

# === API KEYS (REQUIRED) ===
HELIUS_API_KEY="your_helius_api_key_here"
ALCHEMY_API_KEY="your_alchemy_api_key_here"
BICONOMY_API_KEY="your_biconomy_api_key_here"

# === BLOCKCHAIN ADDRESSES ===
PRIVATE_KEY="your_ethereum_private_key_here"
SOLANA_TREASURY="your_solana_wallet_address_here"

# === OLLAMA CONFIG ===
OLLAMA_API_URL="http://localhost:11434"
OLLAMA_MODEL="neural-chat"

# === AGENT CONFIG ===
AGENT_LOOP_INTERVAL="30000"
LOG_LEVEL="info"
```

### Step 2: Load Environment Variables

```bash
# Export environment variables
source ~/.agentic-agent.env

# Verify loading
echo "OLLAMA_MODEL=$OLLAMA_MODEL"
echo "HELIUS_API_KEY is set: $([ -n \"$HELIUS_API_KEY\" ] && echo 'YES' || echo 'NO')"
```

### Step 3: Secure Your Keys (Important!)

```bash
# Set restricted permissions
chmod 600 ~/.agentic-agent.env

# Never commit .env file to git
echo ".env" >> ~/.gitignore
echo ".agentic-agent.env" >> ~/.gitignore

# Use environment-specific configs
# Development: ~/.agentic-agent.env
# Do NOT store keys in code or version control
```

---

## 📥 Get the Agent Code

### Option 1: Clone from GitHub

```bash
# Clone the repository
git clone https://github.com/solalienseeker-mobile/agentic-ancient-alien.git
cd agentic-ancient-alien

# Install Python dependencies
pip install web3
```

### Option 2: Download ZIP

```bash
# Download via curl
mkdir -p ~/agentic-ancient-alien
cd ~/agentic-ancient-alien
wget https://github.com/solalienseeker-mobile/agentic-ancient-alien/archive/refs/heads/main.zip
unzip main.zip
cd agentic-ancient-alien-main
```

---

## 🎯 Running the Agent

### Single Prediction Cycle

```bash
# Load environment variables
source ~/.agentic-agent.env

# Run single prediction for 2030
cd ancient-loopers/
python agent.py commands/predict_2030.json

# Expected output:
# {
#   "year": 2030,
#   "mutation_rate": 120,
#   "efficiency": 104.06,
#   "adaptability": 40
# }
```

### Deploy EVM Contract

```bash
# Test EVM deployment (simulation mode)
python agent.py commands/deploy_evm.json

# Output shows deployment attempts and gas calculations
```

### Query Ollama with Agent

```bash
# Run custom AI query through agent
python agent.py << 'EOF'
{
  "action": "ai_query",
  "prompt": "Explain quantum computing in simple terms"
}
EOF
```

---

## 🔄 Continuous Loop Execution

### Setup TypeScript Environment (Optional)

```bash
# Install Node.js dependencies
cd ~/agentic-ancient-alien/percolator-CoAgentAutonomous/
npm install

# Verify installation
node --version
npm --version
```

### Run Forge Initialization

```bash
# Initialize the forge structure
node forge-autonomous.js

# Creates:
# - data/ (raw, processed)
# - scripts/ (agents, utils)
# - logs/ (tracking)
# - genesis-record.md
```

### Start Continuous Loop (Python Version)

Create `~/agentic-ancient-alien/continuous-agent-loop.py`:

```python
#!/usr/bin/env python3
"""
Continuous Agent Loop for Android/Termux
Runs prediction cycles every 30 seconds with Ollama integration
"""

import os
import json
import time
import subprocess
from datetime import datetime
from pathlib import Path

class TermuxAgentLoop:
    def __init__(self):
        self.env_file = Path.home() / ".agentic-agent.env"
        self.load_env()
        self.cycle_count = 0
        self.success_count = 0
        self.log_dir = Path.home() / "agent-logs"
        self.log_dir.mkdir(exist_ok=True)

    def load_env(self):
        """Load environment variables from .env file"""
        if self.env_file.exists():
            with open(self.env_file) as f:
                for line in f:
                    if line.strip() and not line.startswith('#'):
                        key, value = line.strip().split('=', 1)
                        os.environ[key] = value.strip('"\'')
        else:
            print(f"⚠️  Environment file not found: {self.env_file}")

    def log(self, message, level='INFO'):
        """Log message to file and console"""
        timestamp = datetime.now().isoformat()
        log_msg = f"[{timestamp}] [{level}] {message}"
        print(log_msg)
        
        log_file = self.log_dir / "agent-continuous.log"
        with open(log_file, 'a') as f:
            f.write(log_msg + '\n')

    def query_ollama(self, prompt):
        """Query Ollama locally"""
        try:
            api_url = os.environ.get('OLLAMA_API_URL', 'http://localhost:11434')
            model = os.environ.get('OLLAMA_MODEL', 'neural-chat')
            
            cmd = f'curl -s {api_url}/api/generate -d \'{{"model": "{model}", "prompt": "{prompt}", "stream": false}}\''
            result = subprocess.run(cmd, shell=True, capture_output=True, text=True, timeout=30)
            
            if result.returncode == 0:
                response = json.loads(result.stdout)
                return response.get('response', 'No response')
            else:
                return f"Ollama error: {result.stderr}"
        except Exception as e:
            return f"Query failed: {str(e)}"

    def run_prediction(self):
        """Run prediction cycle"""
        try:
            agent_dir = Path.home() / "agentic-ancient-alien" / "ancient-loopers"
            cmd = f"cd {agent_dir} && python agent.py commands/predict_2030.json"
            result = subprocess.run(cmd, shell=True, capture_output=True, text=True, timeout=30)
            
            if result.returncode == 0:
                data = json.loads(result.stdout)
                return True, data
            else:
                return False, {"error": result.stderr}
        except Exception as e:
            return False, {"error": str(e)}

    def run_cycle(self):
        """Run single agent cycle"""
        self.cycle_count += 1
        self.log(f"🔄 Starting cycle #{self.cycle_count}")
        
        # Run prediction
        success, result = self.run_prediction()
        
        if success:
            self.success_count += 1
            efficiency = result.get('efficiency', 0)
            self.log(f"✓ Cycle #{self.cycle_count} success - efficiency={efficiency}%", 'SUCCESS')
            
            # Optional: Query Ollama for insights
            if os.environ.get('OLLAMA_MODEL'):
                insight_prompt = f"The AI efficiency prediction is {efficiency}%. What does this mean?"
                insight = self.query_ollama(insight_prompt)
                self.log(f"💡 AI Insight: {insight[:100]}...", 'INFO')
        else:
            error = result.get('error', 'Unknown error')
            self.log(f"❌ Cycle #{self.cycle_count} failed: {error}", 'ERROR')

    def main(self):
        """Main loop"""
        print("\n╔════════════════════════════════════════════╗")
        print("║  Agentic Ancient - Termux Continuous Loop  ║")
        print("║  Running on Android with Ollama             ║")
        print("╚════════════════════════════════════════════╝\n")
        
        self.log("🚀 Starting agent loop...")
        
        try:
            while True:
                self.run_cycle()
                
                print(f"\n💓 Status: cycles={self.cycle_count}, success={self.success_count}")
                print("⏳ Next cycle in 30s... (Ctrl+C to stop)\n")
                
                time.sleep(30)
        except KeyboardInterrupt:
            self.log("🛑 Loop stopped by user", 'INFO')
            print(f"\n✋ Stopped. Completed {self.cycle_count} cycles ({self.success_count} successful)\n")

if __name__ == "__main__":
    loop = TermuxAgentLoop()
    loop.main()
```

**Install and run:**

```bash
# Save the file
cat > ~/continuous-agent-loop.py << 'EOF'
# [paste the code above]
EOF

# Make executable
chmod +x ~/continuous-agent-loop.py

# Run the loop
python ~/continuous-agent-loop.py

# Output:
# 🔄 Starting cycle #1
# ✓ Cycle #1 success - efficiency=104.06%
# 💓 Status: cycles=1, success=1
# ⏳ Next cycle in 30s...
```

### Run in Background (Using tmux)

```bash
# Install tmux
pkg install -y tmux

# Create a tmux session
tmux new-session -d -s agent-loop

# Run agent loop in background
tmux send-keys -t agent-loop "source ~/.agentic-agent.env && python ~/continuous-agent-loop.py" Enter

# View output
tmux attach -t agent-loop

# Detach: Ctrl+B then D
# Kill session: tmux kill-session -t agent-loop
```

---

## 🔐 API Key Management

### Getting Your API Keys

#### 1. **Helius API Key**
```bash
# Visit: https://dashboard.helius.dev
# Sign up → Create project → Copy API Key
export HELIUS_API_KEY="your_key_here"
```

#### 2. **Alchemy API Key**
```bash
# Visit: https://alchemy.com
# Sign up → Create App → Copy API Key
export ALCHEMY_API_KEY="your_key_here"
```

#### 3. **Biconomy API Key**
```bash
# Visit: https://dashboard.biconomy.io
# Sign up → Create Project → Copy Dashboard API Key
export BICONOMY_API_KEY="your_key_here"
```

#### 4. **Private Key / Wallet Address**
```bash
# Generate a new wallet:
# MetaMask: Export Private Key from wallet
# Phantom (Solana): Export Secret Key

# NEVER paste real keys in code!
# Store securely in ~/.agentic-agent.env
```

### Security Best Practices

```bash
# ✅ DO:
# Store keys in ~/.agentic-agent.env
# Use file permissions: chmod 600 ~/.agentic-agent.env
# Use environment variables in code
# Rotate keys periodically
# Use testnet keys for development

# ❌ DON'T:
# Store keys in code or version control
# Share keys via chat or email
# Use mainnet keys for testing
# Commit .env files to git
# Leave Termux session unattended
```

---

## 🐛 Troubleshooting

### Issue: "Ollama not found" or "Connection refused"

**Solution:**
```bash
# 1. Check if Ollama is running
netstat -tlnp | grep 11434
# OR
curl http://localhost:11434/api/tags

# 2. Start Ollama in new terminal
ollama serve

# 3. Check Ollama logs
logcat | grep ollama
```

### Issue: "ModuleNotFoundError: No module named 'web3'"

**Solution:**
```bash
# Install missing Python package
pip install web3

# Or use requirements file
pip install -r requirements.txt
```

### Issue: "Timeout" or "Connection reset by peer"

**Solution:**
```bash
# Check network connectivity
ping -c 3 8.8.8.8

# Increase timeout in scripts
# Modify: timeout=60 in agent.py

# Check WiFi connection
nmcli device show
```

### Issue: "Permission denied" on .env file

**Solution:**
```bash
# Fix file permissions
chmod 600 ~/.agentic-agent.env

# Verify
ls -la ~/.agentic-agent.env
# Should show: -rw------- (600)
```

### Issue: Low Memory / App Crashes

**Solution:**
```bash
# Use lightweight model
ollama pull orca-mini  # Only 1.3GB

# Free up RAM
# Kill other apps on phone
# Restart Termux

# Monitor memory usage
free -h
top
```

### Issue: Model Download Too Slow

**Solution:**
```bash
# Use WiFi instead of mobile data
# Download on desktop, transfer file:
scp ollama-models.tar.gz user@phone:/data/local/tmp/

# Or use Ollama on desktop + SSH to phone:
ssh android-phone "curl http://desktop:11434/api/generate ..."
```

---

## ⚡ Performance Tips

### 1. Optimize for Android

```bash
# Use smaller models
# Recommended: neural-chat, orca-mini

# Reduce logging
# Set LOG_LEVEL=error in .env

# Batch requests
# Run multiple cycles together
```

### 2. Network Optimization

```bash
# Use WiFi 5GHz for faster API calls
# Connect to same network as desktop (if using API)
# Disable mobile data to prevent unexpected switching
```

### 3. Storage Management

```bash
# Check available space
df -h

# Move logs to SD card (if available)
ln -s /sdcard/agent-logs ~/agent-logs

# Clean old logs
find ~/agent-logs -mtime +7 -delete
```

### 4. Battery Optimization

```bash
# Enable battery saver
# Set screen timeout to 1 minute
# Use 'Doze mode' settings

# For continuous operation:
# Keep phone plugged in
# Use cooling pad if overheating
```

---

## 📊 Monitoring & Logs

### View Real-time Logs

```bash
# Watch continuous logs
tail -f ~/agent-logs/agent-continuous.log

# Or with color highlighting
tail -f ~/agent-logs/agent-continuous.log | grep --color -E "SUCCESS|ERROR|cycle"
```

### Check Agent Status

```bash
# List processes
ps aux | grep python

# Monitor system resources
top

# Check Ollama status
curl http://localhost:11434/api/tags | jq '.models'
```

### Export Logs

```bash
# Create backup
tar -czf ~/agent-logs-backup.tar.gz ~/agent-logs/

# Transfer to desktop via SCP
scp ~/agent-logs-backup.tar.gz user@desktop:/backup/

# Or email
# cat ~/agent-logs/agent-continuous.log | wc -l  # See line count before copying
```

---

## 🎓 Example Workflows

### Workflow 1: Daily AI Predictions

```bash
# Add to crontab (Termux cron)
# Run prediction every hour

# Edit crontab
crontab -e

# Add line:
# 0 * * * * cd ~/agentic-ancient-alien && /data/data/com.termux/files/usr/bin/python3 ancient-loopers/agent.py commands/predict_2030.json >> ~/agent-logs/predictions.log
```

### Workflow 2: Continuous Monitoring

```bash
# Terminal 1: Start Ollama
ollama serve

# Terminal 2 (tmux): Start agent loop
tmux new-session -d -s "agent" "source ~/.agentic-agent.env && python ~/continuous-agent-loop.py"

# Terminal 3: Monitor logs
tail -f ~/agent-logs/agent-continuous.log

# Terminal 4: System monitoring
top
```

### Workflow 3: Multi-Model Testing

```bash
# Test different Ollama models
for model in neural-chat mistral orca-mini; do
  echo "Testing $model..."
  OLLAMA_MODEL=$model python ~/continuous-agent-loop.py &
  sleep 300  # Run for 5 minutes
  killall python
done
```

---

## 📞 Support & Resources

### Official Links
- **Ollama:** https://ollama.ai
- **Ollama Android:** https://github.com/ollama/ollama
- **Termux:** https://termux.dev
- **Termux Wiki:** https://wiki.termux.com

### Useful Commands Reference

```bash
# File Management
ls -la              # List files with permissions
cd                  # Change directory
mkdir -p            # Create directory recursively
rm -rf              # Remove directory recursively

# Process Management
ps aux              # List running processes
kill PID            # Kill process
pkill -f "name"     # Kill by name

# Environment
env                 # Show all env variables
source ~/.bashrc    # Reload shell config
which python        # Find command location

# Network (Ollamab)
curl -v http://localhost:11434/api/tags  # Verbose API call
netstat -tlnp       # View open ports
ss -tlnp            # Alternative to netstat

# Python
python --version    # Check Python version
pip list            # List installed packages
python -m venv .venv  # Create virtual environment
```

---

## 🚀 Quick Start Summary

```bash
# 1. Open Termux
termux-open-url https://termux.dev

# 2. Install basics
pkg update && pkg upgrade -y
pkg install -y python git curl

# 3. Get environment and code
source ~/.agentic-agent.env
git clone https://github.com/solalienseeker-mobile/agentic-ancient-alien.git

# 4. Start Ollama (Terminal 1)
ollama serve

# 5. Download model (Terminal 2)
ollama pull neural-chat

# 6. Run agent (Terminal 2)
cd agentic-ancient-alien
python ancient-loopers/agent.py commands/predict_2030.json

# 7. Start continuous loop (Terminal 3)
python ~/continuous-agent-loop.py

# Done! 🎉
```

---

**Last Updated:** February 15, 2026  
**Agent Version:** v1.1  
**Status:** ✓ Tested and verified on Android 11+  

For issues or questions, please refer to the [main repository](https://github.com/solalienseeker-mobile/agentic-ancient-alien).
