Running the Agent in Termux

Prerequisites
- A device with Termux installed (Android).
- Basic familiarity with Termux, `pkg`, and shell commands.

Quick setup
1. Open Termux and update packages:

```sh
pkg update -y && pkg upgrade -y
pkg install git python nodejs -y
```

2. (Optional) install a small venv and upgrade pip:

```sh
python -m pip install --upgrade pip
python -m venv venv
source venv/bin/activate
```

3. Clone this repository (or transfer it to the device) and install Python deps:

```sh
git clone <repo-url>     # or transfer repo files to Termux
cd agentic-ancient-alien  # or the repo folder name you used
pip install -r requirements-dev.txt
```

Running the loop agent
- The workspace includes an agent runner in `ancient-loopers`.
- Two quick ways to start it:

```sh
cd ancient-loopers
chmod +x run-copilot.sh
./run-copilot.sh
# or run the Python runner directly
python3 copilot.py
```

Notes about Copilot CLI / auth
- Some scripts may call external Copilot/AI CLIs that require authentication.
- If a script prompts for interactive auth in Termux, follow the on-screen instructions.
- If you want to avoid OAuth flows on device, run provisioning on a desktop and copy any required tokens or config files into Termux.

Troubleshooting
- If you see missing packages, install them via `pkg install <pkg>`.
- If `pip` installation fails, ensure `python` and `pip` are up to date and consider using `--no-cache-dir`.

Security
- Be careful with secrets and keys inside Termux. Store them in a file with restricted permissions and do not commit them.

If you'd like, I can tailor this README with exact environment variables or the repo URL and commit it to `main` now.
