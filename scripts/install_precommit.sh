#!/usr/bin/env bash
set -euo pipefail

echo "Installing pre-commit and detect-secrets (user pip)..."
python3 -m pip install --user -r requirements-dev.txt

echo "Installing pre-commit hooks into this repo..."
python3 -m pip install --user pre-commit
~/.local/bin/pre-commit install || pre-commit install

echo "Generating initial secrets baseline (detect-secrets scan)..."
~/.local/bin/detect-secrets scan --all-files > .secrets.baseline || detect-secrets scan --all-files > .secrets.baseline

echo "Done. Run 'pre-commit run --all-files' to scan existing files."
my
