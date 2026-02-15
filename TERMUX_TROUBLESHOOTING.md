# 🔧 Termux/Android Agent Troubleshooting Guide

Comprehensive guide to diagnose and fix issues running the Agentic Ancient Alien Agent on Android using Termux and Ollama.

---

## 📋 Contents

1. [Installation Issues](#installation-issues)
2. [Ollama Issues](#ollama-issues)
3. [Python & Dependency Issues](#python--dependency-issues)
4. [Network Issues](#network-issues)
5. [API & Key Issues](#api--key-issues)
6. [Performance Issues](#performance-issues)
7. [Data & Storage Issues](#data--storage-issues)
8. [Diagnostic Toolkit](#diagnostic-toolkit)

---

## 🔴 Installation Issues

### Issue: "pkg: command not found"

**Diagnosis:**
```bash
which pkg
# If empty, Termux is not properly set up
```

**Fix:**
- Reinstall Termux from F-Droid (NOT Google Play)
- Download: https://f-droid.org/packages/com.termux/
- Uninstall Google Play version first: `Settings > Apps > Termux > Uninstall`

### Issue: "Permission denied" running setup script

**Diagnosis:**
```bash
ls -la setup-termux.sh
# Should show: -rwxr-xr-x (with x flag)
```

**Fix:**
```bash
chmod +x setup-termux.sh
bash setup-termux.sh  # Use bash explicitly
```

### Issue: Packages fail to install ("E: Unable to locate package")

**Diagnosis:**
```bash
pkg update  # Run this first to refresh package lists
```

**Fix:**
```bash
# Update package lists
pkg update

# Clear cache
rm -rf $HOME/.termux/

# If still failing, check storage
du -sh $HOME/
# If > 90% full, free up space

# Try installing with force
pkg install -y --no-sandbox python
```

### Issue: "No space left on device"

**Diagnosis:**
```bash
df -h  # Check disk space
du -sh $HOME/  # Check home directory size
```

**Fix:**
```bash
# Find and remove large files
find $HOME -type f -size +100M -exec ls -lh {} \;

# Clean package cache
pkg clean

# Remove old logs
rm -rf ~/agent-logs/*

# Remove temporary files
rm -rf /tmp/*
```

---

## 🦙 Ollama Issues

### Issue: "ollama: command not found"

**Diagnosis:**
```bash
which ollama
# Should return: /path/to/ollama

ls -la /data/data/com.termux/files/usr/bin/ | grep ollama
# Check if Ollama binary exists
```

**Fix:**
```bash
# Method 1: Download APK from GitHub
# https://github.com/ollama/ollama/releases
# Install via system Settings > Apps > Install unknown apps

# Method 2: Check if Ollama app is installed
pm list packages | grep ollama
# Should show: package:com.ollama.ai (or similar)

# Method 3: Verify Termux storage access
# Settings > Permissions > Termux > Storage
# Enable "Read external storage" and "Write external storage"
```

### Issue: "Connection refused" (Ollama not running)

**Diagnosis:**
```bash
curl -v http://localhost:11434/api/tags
# Should NOT return "Connection refused"

netstat -tlnp | grep 11434
# Should show Ollama listening on port 11434

lsof -i :11434
# Alternative check for port usage
```

**Fix:**
```bash
# Start Ollama in foreground (to see errors)
ollama serve

# If it fails immediately:
ollama serve --verbose  # Show debug output

# If port is already in use:
lsof -i :11434  # Find process using port
kill -9 <PID>   # Force terminate

# If Ollama crashes repeatedly:
# Clear Ollama data and restart
rm -rf ~/.ollama/
ollama serve
```

### Issue: Port 11434 already in use

**Diagnosis:**
```bash
netstat -tlnp | grep 11434
# Shows what's using the port

ps aux | grep ollama
# Multiple Ollama instances running?
```

**Fix:**
```bash
# Kill all Ollama processes
pkill -9 ollama

# Wait 5 seconds
sleep 5

# Start fresh
ollama serve

# Or use different port (if running Ollama elsewhere):
OLLAMA_HOST=localhost:11435 ollama serve
# Then update ~/.agentic-agent.env:
# OLLAMA_API_URL="http://localhost:11435"
```

### Issue: Model download fails or is very slow

**Diagnosis:**
```bash
# Check network connectivity
ping -c 3 8.8.8.8

# Check WiFi
nmcli device show

# Monitor download
ls -lah ~/.ollama/models/
du -sh ~/.ollama/
```

**Fix:**
```bash
# 1. Ensure WiFi connection (not mobile data)
# Settings > WiFi > Connect to 5GHz if available

# 2. Try downloading smaller model
ollama pull orca-mini  # 1.3GB (fastest)

# 3. If download interrupted, resume
ollama pull neural-chat  # Resumes from where it stopped

# 4. Check disk space
df -h
# Need at least 5GB free for model + system

# 5. If still slow, try alternative:
# Download on desktop, transfer via USB:
# adb push model.gguf /data/data/com.ollama.ai/files/models/
```

### Issue: Model loading takes forever or hangs

**Diagnosis:**
```bash
# Check system memory
free -h

# Monitor while running
top  # Press 'q' to quit
# Look for memory usage, swap usage

# Check Ollama logs
tail -50 ~/.ollama/logs/server.log  # If exists
```

**Fix:**
```bash
# 1. Use lighter model
ollama rm neural-chat         # Remove current
ollama pull orca-mini        # Use lightweight

# 2. Force 32-bit mode (if on 32-bit device)
OLLAMA_SYSTEM_MEMORY=786432 ollama serve  # 768MB limit

# 3. Reduce batch size (if model supports)
export OLLAMA_NUM_THREAD=2   # Use fewer CPU threads
ollama serve

# 4. Restart system
# Phone: Restart via Settings
# Termux: pkill -9 -f ".*"

# 5. Monitor with smaller test
ollama generate orca-mini "Say 'Hi'"
```

---

## 🐍 Python & Dependency Issues

### Issue: "ModuleNotFoundError: No module named 'web3'"

**Diagnosis:**
```bash
python -c "import web3; print(web3.__version__)"
# If fails: module not installed

python -m pip list | grep web3
# Check if package appears

which python
# Verify correct Python interpreter
```

**Fix:**
```bash
# Install the package
pip install web3

# If pip command fails, try python -m pip
python -m pip install web3

# Verify installation
python -c "import web3; print('✓ web3 installed')"

# If installing to wrong Python:
which python3
python3 -m pip install web3  # Use python3 explicitly
```

### Issue: "pip: command not found"

**Diagnosis:**
```bash
which pip
python -m pip --version
# Check both commands
```

**Fix:**
```bash
# Install pip if missing
python -m ensurepip --upgrade

# Or upgrade Python with pip
pkg install -y python

# Use python -m pip if pip command missing
python -m pip install web3
```

### Issue: Python version mismatch or multiple versions

**Diagnosis:**
```bash
python --version
python3 --version
which python
which python3

# Check if linking to same binary
ls -la /data/data/com.termux/files/usr/bin/python*
```

**Fix:**
```bash
# Use consistent version (prefer python3)
cd ~/agentic-ancient-alien/ancient-loopers

# If using python command with wrong version:
python3 agent.py commands/predict_2030.json  # Use python3

# Or create symlink
ln -sf /data/data/com.termux/files/usr/bin/python3 \
       /data/data/com.termux/files/usr/bin/python
```

### Issue: "Syntax error" or "SyntaxError" in agent.py

**Diagnosis:**
```bash
python -m py_compile ancient-loopers/agent.py
# Reports syntax errors with line numbers

python -c "
import ast
with open('ancient-loopers/agent.py') as f:
    ast.parse(f.read())
"
# More detailed error info
```

**Fix:**
```bash
# Check Python version requirement
head -5 ancient-loopers/agent.py
# Should have shebang: #!/usr/bin/env python3

# Verify file wasn't corrupted
git checkout ancient-loopers/agent.py  # Reset if in git

# Check for line ending issues (CRLF vs LF)
file ancient-loopers/agent.py
# Should show: Python script, ASCII text, with very long lines

# Fix line endings if needed:
dos2unix ancient-loopers/agent.py  # If available
# OR
python -c "
with open('ancient-loopers/agent.py') as f:
    content = f.read()
with open('ancient-loopers/agent.py', 'wb') as f:
    f.write(content.encode('utf-8').replace(b'\r\n', b'\n'))
"
```

---

## 🌐 Network Issues

### Issue: "Failed to connect to API" or "Connection timeout"

**Diagnosis:**
```bash
# Check internet
ping -c 3 8.8.8.8
ping -c 3 api.devnet.solana.com
curl -I https://api.devnet.solana.com

# Check local Ollama
curl http://localhost:11434/api/tags

# Check RPC endpoints
curl https://api.helius.dev/status
```

**Fix:**
```bash
# 1. Switch to WiFi (if on mobile data)
Settings > WiFi > Select network

# 2. Try different RPC
# Edit ~/.agentic-agent.env:
SOLANA_RPC_URL="https://api.mainnet-beta.solana.com"  # Different endpoint
# Options:
# - https://api.devnet.solana.com (testnet)
# - https://api.mainnet-beta.solana.com (mainnet)
# - https://api.testnet.solana.com (old testnet)

# 3. Increase timeout
export CURL_TIMEOUT=60  # 60 seconds instead of 30

# 4. Use VPN if connectivity issues
# Download VPN app (ProtonVPN, Mullvad, etc.)

# 5. Check Saldo balance (for gas)
# RPC might be rate-limited
solana balance  # If installed
```

### Issue: "DNS resolution failed" or "Name or service not known"

**Diagnosis:**
```bash
nslookup api.devnet.solana.com
# Should return IP addresses

cat /etc/resolv.conf  # Check DNS servers

getent hosts api.devnet.solana.com
```

**Fix:**
```bash
# Try alternative DNS
# System Settings > WiFi > Advanced > DNS

# Or manually set in Termux:
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf

# Test again
curl https://api.devnet.solana.com
```

### Issue: "Firewall blocked" or port restriction

**Diagnosis:**
```bash
# Check if firewall blocks port
netstat -tlnp | grep LISTEN

# Try direct connection test
telnet api.devnet.solana.com 443
# If "Connected" message: OK
# If hangs: firewall likely blocking
```

**Fix:**
```bash
# 1. No built-in firewall in Termux, but check Android settings:
Settings > Apps > Permissions > Network

# 2. Disable WiFi & use mobile data (if available)
# Or switch WiFi network

# 3. Use VPN to tunnel around firewall
# Download: ProtonVPN or Mullvad app

# 4. If corporate WiFi: contact IT for whitelist
# May need to whitelist:
# - api.devnet.solana.com:443 (HTTPS)
# - localhost:11434 (Ollama local)
```

---

## 🔑 API & Key Issues

### Issue: "API key not found" or "Invalid API key"

**Diagnosis:**
```bash
# Check environment variables
echo $HELIUS_API_KEY
echo $ALCHEMY_API_KEY

# Check if .env file exists
ls -la ~/.agentic-agent.env

# Check file contents (hide actual keys)
grep "HELIUS_API_KEY" ~/.agentic-agent.env
```

**Fix:**
```bash
# 1. Ensure .env file exists
cp .agentic-agent.env.template ~/.agentic-agent.env

# 2. Edit with real keys
nano ~/.agentic-agent.env
# Replace YOUR_KEY_HERE with actual keys

# 3. Load in current shell
source ~/.agentic-agent.env

# 4. Verify loading
echo "Key loaded: $HELIUS_API_KEY" | wc -c
# Should show > 20 characters (not empty)

# 5. Add to .bashrc for automatic loading
echo 'source ~/.agentic-agent.env' >> ~/.bashrc
```

### Issue: "Invalid API key" (key is set but rejected)

**Diagnosis:**
```bash
# Test API directly
curl -i -H "Authorization: Bearer $HELIUS_API_KEY" \
  'https://api.helius.dev/v0/balances?owner=...'
# Check response code (200 = OK, 401 = unauthorized)
```

**Fix:**
```bash
# 1. Verify key format
# Helius key should be: hex string, 32+ characters
# Alchemy key should be: alphanumeric, 32+ characters
echo $HELIUS_API_KEY | grep -E '^[a-f0-9]{30,}$' && echo "Valid format" || echo "Invalid format"

# 2. Check key is correct
# Visit dashboard:
# - Helius: https://dashboard.helius.dev
# - Alchemy: https://alchemy.com/apps

# 3. Key might be expired or deactivated
# Create new key in dashboard

# 4. Check key scope/permissions
# Some keys limited to specific networks (devnet vs mainnet)
```

### Issue: "Private key invalid" or "Wallet error"

**Diagnosis:**
```bash
# Check private key format
echo $PRIVATE_KEY
# Should start with 0x followed by 64 hex characters

# Test with Web3
python3 << 'EOF'
from web3 import Web3
key = '0x...'  # your key from env
try:
    account = Web3().eth.account.from_key(key)
    print(f"✓ Valid key: {account.address}")
except:
    print("✗ Invalid key format")
EOF
```

**Fix:**
```bash
# 1. Regenerate key properly
# MetaMask: Settings > Security & Privacy > Reveal SRP
# Export personal key: Account menu > Export private key
# Format: 0x + 64 hex chars

# 2. Never share private key!
# Treat like password, store only in ~/.agentic-agent.env

# 3. Use testnet key for development (not mainnet)
# Or create throw-away account for testing

# 4. Verify key not already exposed
# If exposed: create new wallet immediately!
```

---

## ⚡ Performance Issues

### Issue: Agent runs very slowly (> 5 seconds per cycle)

**Diagnosis:**
```bash
# Monitor while running
while true; do
  free -h
  ps aux | grep -E "python|ollama" | grep -v grep
  sleep 2
done

# Check CPU usage
top -b -n 1 | head -20
```

**Fix:**
```bash
# 1. Close unused apps
# Settings > Apps > Force stop background apps

# 2. Use faster model
OLLAMA_MODEL=orca-mini python ~/continuous-agent-loop.py

# 3. Reduce API call frequency
# Edit ~/.agentic-agent.env:
# AGENT_LOOP_INTERVAL="60000"  # 60 seconds instead of 30

# 4. Reduce logging
LOG_LEVEL="error"  # Only log errors, not every cycle

# 5. Check phone temperature
# Should be warm, not hot
# If hot: let it cool, reduce cycle frequency
```

### Issue: Memory leak or increasing memory usage

**Diagnosis:**
```bash
# Monitor memory over time
for i in {1..10}; do
  echo "$(date): $(free -h | grep Mem)"
  sleep 5
done

# Check for zombie processes
ps aux | grep -E "python|ollama" | grep -v grep
```

**Fix:**
```bash
# 1. Restart agent regularly
# Edit crontab to restart daily:
crontab -e
# Add: 0 3 * * * pkill -f continuous-agent-loop && sleep 2 && python ~/continuous-agent-loop.py

# 2. Reduce logging level
LOG_LEVEL="error"

# 3. Clear logs periodically
find ~/agent-logs -mtime +7 -delete  # Delete logs older than 7 days

# 4. Limit model context (if supported)
# Some Ollama versions: OLLAMA_CONTEXT_LENGTH=256

# 5. Restart Termux
pkg clean  # Clean package cache
# Close and reopen Termux
```

### Issue: Phone overheating during agent runs

**Diagnosis:**
```bash
# Check temperature (if available)
cat /sys/class/thermal/thermal_zone*/temp

# Monitor while agent running
watch free -h  # Updates every 2 seconds
```

**Fix:**
```bash
# 1. Reduce cycle frequency
# ~/.agentic-agent.env:
AGENT_LOOP_INTERVAL="120000"  # 2 minutes

# 2. Disable model polling
# Let agent just predict, not query Ollama

# 3. Put phone in low-power mode
Settings > Battery > Low Power Mode

# 4. Place on cooling surface
# Aluminum heat sink or fan

# 5. Close all other apps
# Leave only Termux + Ollama running

# 6. Use lightweight model
ollama pull orca-mini
OLLAMA_MODEL=orca-mini python ~/continuous-agent-loop.py
```

---

## 💾 Data & Storage Issues

### Issue: "No space left on device" during Ollama model download

**Diagnosis:**
```bash
df -h              # Overall disk space
du -sh ~/.ollama/  # Ollama models directory
du -sh ~           # Total home directory
```

**Fix:**
```bash
# 1. Check what's taking space
du -sh ~/* | sort -hr  # Largest directories first

# 2. Remove unused models
ollama rm neural-chat  # Delete model

# 3. Clear package cache
pkg clean

# 4. Remove old logs
rm -rf ~/agent-logs/*.log  # Keep directory, clear logs

# 5. Move to SD card (if available)
# If phone has expandable storage:
mkdir -p /sdcard/ollama-models
ln -s /sdcard/ollama-models ~/.ollama/models_sd
OLLAMA_BASE=/sdcard/ollama-models ollama serve

# Tips:
# - Always keep >1GB free for OS
# - Move non-critical data to SD card
# - Consider using cloud storage for logs
```

### Issue: Logs growing too large

**Diagnosis:**
```bash
du -sh ~/agent-logs/
ls -lah ~/agent-logs/*
```

**Fix:**
```bash
# 1. Rotate logs (keep only recent)
find ~/agent-logs -mtime +7 -delete  # Delete older than 7 days

# 2. Compress old logs
gzip ~/agent-logs/agent-continuous.* # Only logs, not current

# 3. Move to external storage
tar -czf /sdcard/agent-logs-backup.tar.gz ~/agent-logs/

# 4. Clear logs entirely
rm ~/agent-logs/*.log*
# Loop will recreate on next run

# 5. Disable verbose logging
LOG_LEVEL="error"  # Only log errors
```

### Issue: Cannot write to directory (Permission denied)

**Diagnosis:**
```bash
ls -la ~/agent-logs/
# Check if you own directory (should show your username)

id  # Check current user
```

**Fix:**
```bash
# 1. Fix directory permissions
chmod 755 ~/agent-logs
chmod 644 ~/agent-logs/*

# 2. Change owner if needed
chown -R $(id -u):$(id -g) ~/agent-logs

# 3. Check file permissions on .env
chmod 600 ~/.agentic-agent.env

# 4. Recreate directories if corrupted
rm -rf ~/agent-logs
mkdir -p ~/agent-logs
```

---

## 🔧 Diagnostic Toolkit

### Comprehensive System Check

```bash
#!/bin/bash
echo "=== AGENTIC AGENT DIAGNOSTIC ==="
echo ""
echo "1. Termux Info:"
uname -a
echo ""
echo "2. Python:"
python --version
python -c "import sys; print('Executable:', sys.executable)"
echo ""
echo "3. Key Packages:"
python -m pip list | grep -E "web3|requests"
echo ""
echo "4. Ollama:"
which ollama
ollama --version 2>/dev/null || echo "Ollama not in PATH"
curl -s http://localhost:11434/api/tags | head -1 || echo "Ollama not running"
echo ""
echo "5. Network:"
ping -c 1 8.8.8.8 && echo "✓ Internet OK" || echo "✗ No internet"
curl -s -I https://api.helius.dev | head -1 || echo "Cannot reach APIs"
echo ""
echo "6. Storage:"
df -h | grep -E "Filesystem|/$"
du -sh ~
echo ""
echo "7. Environment:"
env | grep -i agent | head -5
echo ""
echo "8. Processes:"
ps aux | grep -E "python|ollama" | grep -v grep
echo ""
echo "9. Logs:"
tail -3 ~/agent-logs/agent-continuous.log 2>/dev/null || echo "No logs yet"
echo ""
echo "=== END DIAGNOSTIC ==="
```

### Log Analysis

```bash
# Count cycles
tail -100 ~/agent-logs/agent-continuous.log | grep "Cycle" | wc -l

# Count successes
tail -100 ~/agent-logs/agent-continuous.log | grep "success" | wc -l

# Show errors
grep "ERROR\|failed\|Failed" ~/agent-logs/agent-continuous.log | tail -10

# Timeline
grep "$(date +%H:%M)" ~/agent-logs/agent-continuous.log
```

---

## 📞 Getting Help

### When reporting issues, include:

1. **System info:**
   ```bash
   uname -a
   python --version
   pkg show-full/termux  # Show installed packages
   ```

2. **Error logs:**
   ```bash
   # Last 20 lines of error log
   tail -20 ~/agent-logs/agent-continuous.log
   
   # Full cycle showing error
   grep -A5 "ERROR" ~/agent-logs/agent-continuous.log
   ```

3. **Environment check:**
   ```bash
   # Hide actual keys
   env | grep -i agent | sed 's|=.*|=***|'
   ```

4. **Offline run test:**
   ```bash
   # Can the agent run locally without network?
   python ancient-loopers/agent.py commands/predict_2030.json
   ```

---

**Last Updated:** February 15, 2026  
**Compatible with:** Termux 0.118+, Ollama 0.1.0+, Android 7.0+
