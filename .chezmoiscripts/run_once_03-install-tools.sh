#!/bin/bash
set -euo pipefail

# Oh My Zsh (skip if already installed)
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "Oh My Zsh already installed"
fi

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

# fnm - install latest LTS Node if not already installed
if command -v fnm &>/dev/null; then
  if ! fnm ls | grep -q default; then
    echo "Installing Node.js LTS via fnm..."
    fnm install --lts
    fnm default lts-latest
  else
    echo "Node.js already installed: $(fnm current)"
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
