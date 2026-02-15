# Ancient Loopers - Cryptogene Empire Builder

AI agent for gasless contract deployment on Solana & Neon EVM with Biconomy.

## Quick Start
```bash
cd ancient-loopers
npm install
chmod +x agent.py

# Test prediction
python3 agent.py commands/predict_2030.json

# Deploy EVM (gasless via Biconomy)
python3 agent.py commands/deploy_evm.json

# Deploy to Neon EVM
npm run deploy
```

## Features
✅ Biconomy gasless transactions configured
✅ Solana zero-cost deployment
✅ Cryptogene evolution logic (2026-2046)
✅ Ollama AI integration
✅ CLI-based execution

## Architecture
- `agent.py` - Core CLI agent
- `Cryptogene.sol` - Self-evolving contract
- `deploy.js` - Hardhat deployment
- `commands/` - JSON command files
