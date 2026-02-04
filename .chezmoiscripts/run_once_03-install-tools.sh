#!/bin/bash
set -euo pipefail

# Claude Code (native install for auto-updates - skip if already installed)
if ! command -v claude &>/dev/null; then
  echo "Installing Claude Code..."
  curl -fsSL https://claude.ai/install.sh | bash
else
  echo "Claude Code already installed"
fi

# Rust (via rustup - skip if already installed)
if ! command -v rustc &>/dev/null; then
  echo "Installing Rust..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source "$HOME/.cargo/env"
else
  echo "Rust already installed"
fi

# NVM - install latest LTS Node if not already installed
export NVM_DIR="$HOME/.nvm"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  source "$NVM_DIR/nvm.sh"
  if ! nvm version default &>/dev/null 2>&1; then
    echo "Installing Node.js LTS..."
    nvm install --lts
    nvm alias default 'lts/*'
  else
    echo "Node.js already installed: $(nvm version default)"
  fi
fi

# Bun (skip if already installed)
if ! command -v bun &>/dev/null; then
  echo "Installing Bun..."
  curl -fsSL https://bun.sh/install | bash
else
  echo "Bun already installed"
fi

echo "Tool installation complete!"
