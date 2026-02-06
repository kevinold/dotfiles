#!/bin/bash
set -euo pipefail

# Install Claude Code plugins and marketplaces
# Requires: claude CLI (installed by 03-install-tools.sh)

if ! command -v claude &>/dev/null; then
  echo "Claude Code not installed, skipping plugin setup"
  exit 0
fi

echo "Setting up Claude Code marketplaces and plugins..."

# --- Marketplaces ---
add_marketplace() {
  local name="$1"
  local source="$2"
  if claude plugin marketplace list 2>/dev/null | grep -q "$name"; then
    echo "Marketplace '$name' already added"
  else
    echo "Adding marketplace '$name'..."
    claude plugin marketplace add "$source"
  fi
}

add_marketplace "claude-code-workflows" "wshobson/agents"
add_marketplace "claude-plugins-official" "anthropics/claude-plugins-official"
add_marketplace "every-marketplace" "https://github.com/EveryInc/compound-engineering-plugin.git"
add_marketplace "agent-browser" "https://github.com/vercel-labs/agent-browser.git"

# --- Plugins ---
install_plugin() {
  local plugin="$1"
  if claude plugin list 2>/dev/null | grep -q "${plugin%%@*}"; then
    echo "Plugin '$plugin' already installed"
  else
    echo "Installing plugin '$plugin'..."
    claude plugin install "$plugin" || echo "Warning: failed to install '$plugin'"
  fi
}

# claude-code-workflows plugins
install_plugin "javascript-typescript@claude-code-workflows"
install_plugin "python-development@claude-code-workflows"
install_plugin "backend-development@claude-code-workflows"
install_plugin "cloud-infrastructure@claude-code-workflows"
install_plugin "security-scanning@claude-code-workflows"
install_plugin "code-review-ai@claude-code-workflows"
install_plugin "full-stack-orchestration@claude-code-workflows"
install_plugin "code-documentation@claude-code-workflows"
install_plugin "debugging-toolkit@claude-code-workflows"
install_plugin "developer-essentials@claude-code-workflows"
install_plugin "multi-platform-apps@claude-code-workflows"

# Official plugins
install_plugin "typescript-lsp@claude-plugins-official"
install_plugin "pyright-lsp@claude-plugins-official"
install_plugin "rust-analyzer-lsp@claude-plugins-official"
install_plugin "frontend-design@claude-plugins-official"
install_plugin "linear@claude-plugins-official"
install_plugin "ralph-loop@claude-plugins-official"

# Third-party plugins
install_plugin "compound-engineering@every-marketplace"
install_plugin "agent-browser@agent-browser"

echo "Claude Code plugin setup complete!"
