#!/bin/bash

# ═══════════════════════════════════════════════════════════════════
# Agentic Ancient Alien Agent - Termux Auto-Setup Script
# ═══════════════════════════════════════════════════════════════════
# 
# Usage: bash setup-termux.sh
# Run this script to automatically set up the agent on Android/Termux
#
# ═══════════════════════════════════════════════════════════════════

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ═══════════════════════════════════════════════════════════════════
# Helper Functions
# ═══════════════════════════════════════════════════════════════════

print_header() {
    echo -e "\n${BLUE}╔════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║ $1${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}\n"
}

print_step() {
    echo -e "${YELLOW}▶ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# ═══════════════════════════════════════════════════════════════════
# Check Prerequisites
# ═══════════════════════════════════════════════════════════════════

print_header "Checking Prerequisites"

# Check if running on Termux
if [ ! -d "$HOME/.termux" ]; then
    print_error "This script must be run on Termux"
    exit 1
fi
print_success "Running on Termux"

# Check internet connectivity
print_step "Checking internet connectivity..."
if ! ping -c 1 8.8.8.8 &> /dev/null; then
    print_error "No internet connection. Please connect to WiFi."
    exit 1
fi
print_success "Internet connection OK"

# ═══════════════════════════════════════════════════════════════════
# Update System
# ═══════════════════════════════════════════════════════════════════

print_header "Updating Termux Packages"

print_step "Updating package list..."
pkg update -y || { print_error "Failed to update packages"; exit 1; }
print_success "Package list updated"

print_step "Upgrading packages..."
pkg upgrade -y || { print_error "Failed to upgrade packages"; exit 1; }
print_success "Packages upgraded"

# ═══════════════════════════════════════════════════════════════════
# Install Required Packages
# ═══════════════════════════════════════════════════════════════════

print_header "Installing Required Packages"

PACKAGES="python git curl wget vim nano"

for pkg in $PACKAGES; do
    print_step "Installing $pkg..."
    pkg install -y "$pkg" || { print_error "Failed to install $pkg"; exit 1; }
    print_success "$pkg installed"
done

# ═══════════════════════════════════════════════════════════════════
# Install Optional Packages
# ═══════════════════════════════════════════════════════════════════

print_header "Installing Optional Packages"

OPTIONAL_PACKAGES="node-lts tmux openssh build-essential"

for pkg in $OPTIONAL_PACKAGES; do
    print_step "Installing $pkg..."
    if pkg install -y "$pkg"; then
        print_success "$pkg installed"
    else
        print_info "$pkg installation skipped (optional)"
    fi
done

# ═══════════════════════════════════════════════════════════════════
# Install Python Dependencies
# ═══════════════════════════════════════════════════════════════════

print_header "Installing Python Dependencies"

print_step "Upgrading pip..."
python -m pip install --upgrade pip || print_info "pip upgrade skipped"
print_success "pip upgraded"

print_step "Installing web3 package..."
python -m pip install web3 || { print_error "Failed to install web3"; exit 1; }
print_success "web3 installed"

# ═══════════════════════════════════════════════════════════════════
# Clone Repository
# ═══════════════════════════════════════════════════════════════════

print_header "Setting Up Agent Repository"

AGENT_DIR="$HOME/agentic-ancient-alien"

if [ -d "$AGENT_DIR" ]; then
    print_info "Agent directory already exists at $AGENT_DIR"
    read -p "Do you want to re-clone? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$AGENT_DIR"
    else
        print_info "Using existing directory"
    fi
fi

if [ ! -d "$AGENT_DIR" ]; then
    print_step "Cloning repository..."
    git clone https://github.com/solalienseeker-mobile/agentic-ancient-alien.git "$AGENT_DIR" || {
        print_error "Failed to clone repository"
        print_info "Attempting alternative download..."
        mkdir -p "$AGENT_DIR"
        cd "$AGENT_DIR"
        wget -q https://github.com/solalienseeker-mobile/agentic-ancient-alien/archive/refs/heads/main.zip
        unzip -q main.zip
        cd ..
    }
    print_success "Repository cloned"
fi

# ═══════════════════════════════════════════════════════════════════
# Create Environment File
# ═══════════════════════════════════════════════════════════════════

print_header "Setting Up Environment Configuration"

ENV_FILE="$HOME/.agentic-agent.env"
TEMPLATE_FILE="$AGENT_DIR/.agentic-agent.env.template"

if [ -f "$ENV_FILE" ]; then
    print_info "Environment file already exists at $ENV_FILE"
    read -p "Do you want to recreate it? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Using existing environment file"
    else
        rm "$ENV_FILE"
    fi
fi

if [ ! -f "$ENV_FILE" ]; then
    print_step "Creating environment file from template..."
    if [ -f "$TEMPLATE_FILE" ]; then
        cp "$TEMPLATE_FILE" "$ENV_FILE"
        print_success "Environment file created"
    else
        print_error "Template file not found at $TEMPLATE_FILE"
    fi
fi

# Secure the environment file
chmod 600 "$ENV_FILE"
print_success "Environment file secured (chmod 600)"

# ═══════════════════════════════════════════════════════════════════
# Create Log Directory
# ═══════════════════════════════════════════════════════════════════

print_header "Creating Directories"

LOG_DIR="$HOME/agent-logs"
mkdir -p "$LOG_DIR"
print_success "Log directory created at $LOG_DIR"

# ═══════════════════════════════════════════════════════════════════
# Create Continuous Loop Script
# ═══════════════════════════════════════════════════════════════════

print_header "Creating Agent Loop Script"

LOOP_SCRIPT="$HOME/continuous-agent-loop.py"

if [ ! -f "$LOOP_SCRIPT" ]; then
    cat > "$LOOP_SCRIPT" << 'PYTHON_SCRIPT'
#!/usr/bin/env python3
import os, json, time, subprocess
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
        if self.env_file.exists():
            with open(self.env_file) as f:
                for line in f:
                    if line.strip() and not line.startswith('#'):
                        key, val = line.strip().split('=', 1)
                        os.environ[key] = val.strip('"\'')

    def log(self, msg, level='INFO'):
        ts = datetime.now().isoformat()
        log_msg = f"[{ts}] [{level}] {msg}"
        print(log_msg)
        with open(self.log_dir / "agent-continuous.log", 'a') as f:
            f.write(log_msg + '\n')

    def run_prediction(self):
        try:
            agent_dir = Path.home() / "agentic-ancient-alien" / "ancient-loopers"
            cmd = f"cd {agent_dir} && python agent.py commands/predict_2030.json"
            result = subprocess.run(cmd, shell=True, capture_output=True, text=True, timeout=30)
            if result.returncode == 0:
                return True, json.loads(result.stdout)
            else:
                return False, {"error": result.stderr}
        except Exception as e:
            return False, {"error": str(e)}

    def run_cycle(self):
        self.cycle_count += 1
        self.log(f"🔄 Cycle #{self.cycle_count}")
        success, result = self.run_prediction()
        if success:
            self.success_count += 1
            efficiency = result.get('efficiency', 0)
            self.log(f"✓ Cycle #{self.cycle_count} success - efficiency={efficiency}%", 'SUCCESS')
        else:
            error = result.get('error', 'Unknown')
            self.log(f"❌ Cycle #{self.cycle_count} failed: {error}", 'ERROR')

    def main(self):
        print("\n╔════════════════════════════════════════════╗")
        print("║  Agentic Ancient - Termux Continuous Loop  ║")
        print("╚════════════════════════════════════════════╝\n")
        self.log("🚀 Agent loop starting...")
        try:
            while True:
                self.run_cycle()
                print(f"\n💓 Cycles: {self.cycle_count} | Success: {self.success_count}")
                print("⏳ Next in 30s... (Ctrl+C to stop)\n")
                time.sleep(30)
        except KeyboardInterrupt:
            print(f"\n✋ Stopped. Completed {self.cycle_count} cycles\n")

if __name__ == "__main__":
    TermuxAgentLoop().main()
PYTHON_SCRIPT
    chmod +x "$LOOP_SCRIPT"
    print_success "Loop script created at $LOOP_SCRIPT"
else
    print_info "Loop script already exists"
fi

# ═══════════════════════════════════════════════════════════════════
# Configure Shell
# ═══════════════════════════════════════════════════════════════════

print_header "Configuring Shell"

BASHRC="$HOME/.bashrc"

# Add agent environment loading to .bashrc
if ! grep -q "agentic-agent.env" "$BASHRC"; then
    print_step "Adding environment loading to .bashrc..."
    cat >> "$BASHRC" << 'BASHRC_APPEND'

# Agentic Ancient Agent Configuration
if [ -f ~/.agentic-agent.env ]; then
    source ~/.agentic-agent.env
    echo "✓ Agent environment loaded"
fi
BASHRC_APPEND
    print_success "Shell configuration updated"
else
    print_info "Shell already configured"
fi

# ═══════════════════════════════════════════════════════════════════
# Instructions
# ═══════════════════════════════════════════════════════════════════

print_header "Setup Complete! ✓"

echo -e "${GREEN}All required packages have been installed.${NC}\n"

echo -e "${YELLOW}NEXT STEPS:${NC}\n"

echo "1. ${BLUE}Edit your environment file:${NC}"
echo "   nano ~/.agentic-agent.env"
echo "   • Replace YOUR_HELIUS_API_KEY, etc. with real values"
echo "   • Save: Ctrl+X, then Y, then Enter"
echo ""

echo "2. ${BLUE}In Termux Terminal 1, start Ollama:${NC}"
echo "   ollama serve"
echo ""

echo "3. ${BLUE}In Termux Terminal 2, download an model:${NC}"
echo "   ollama pull neural-chat"
echo "   (or: orca-mini, mistral, llama2)"
echo ""

echo "4. ${BLUE}In Termux Terminal 3, run the agent:${NC}"
echo "   source ~/.agentic-agent.env"
echo "   python ~/continuous-agent-loop.py"
echo ""

echo -e "${YELLOW}USEFUL COMMANDS:${NC}\n"

echo "• View logs:         tail -f ~/agent-logs/agent-continuous.log"
echo "• Check processes:   ps aux | grep python"
echo "• Stop agent:        pkill -f continuous-agent-loop"
echo "• Run once:          cd ~/agentic-ancient-alien/ancient-loopers && python agent.py commands/predict_2030.json"
echo ""

echo -e "${BLUE}For more help, see:${NC}"
echo "• TERMUX_ANDROID_SETUP.md (comprehensive guide)"
echo "• QUICK_REFERENCE.md (command reference)"
echo ""

print_success "Setup complete! Happy agent looping! 🚀"
