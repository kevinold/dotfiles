---
title: Modernize Dotfiles for 2026 Tech Stack
type: refactor
date: 2026-02-04
---

# Modernize Dotfiles for 2026 Tech Stack

## Overview

Complete modernization of the dotfiles repository to reflect your current 2026 tech stack, inspired by [nicknisi/dotfiles](https://github.com/nicknisi/dotfiles/tree/main). This includes restructuring the repository, removing outdated tooling (Ruby, Vundle, old bash configs), and adding support for your current tools: nvm/Node.js, uv/Python, Rust, Claude Code, LazyVim, Starship, Wezterm, Zed, bun, and dotenvx.

**Key Decision: Use chezmoi instead of custom scripts** (see [Approach Rationale](#approach-rationale-chezmoi-vs-custom-scripts))

## Problem Statement

The current dotfiles repo has accumulated technical debt over the years:

1. **Outdated Structure**: Files scattered at root level (`zshrc`, `vimrc`, `gitconfig`) instead of organized in `config/` and `home/` directories
2. **Obsolete Tools**: References to Ruby (gemrc, pryrc, irbrc, rbenv), Vundle (deprecated Vim plugin manager), bash configs, iTerm2, spacemacs
3. **Missing Modern Tools**: No Claude Code, no Rust tooling, no bun, no starship config, no modern nvim with lazy.nvim committed
4. **Fragile Install Process**: Current `install.sh` runs scripts in sequence without idempotency checks, may fail halfway leaving system in inconsistent state
5. **Scattered Configs**: Your actual configs exist in `~/.config/`, `~/.claude/`, `~/.local/`, `~/.wezterm.lua` but aren't committed to the repo
6. **Environment Variables in zshrc**: Should be in `zshenv` for proper loading order
7. **Duplicate PATH exports**: Multiple PATH additions in zshrc
8. **Security Issues**: Commented GitHub token in gitconfig (line 107), hardcoded paths

## Research Findings

### Current State Analysis

**Files to REMOVE** (outdated):
- `ackrc` - replaced by rg (ripgrep)
- `bash/` directory - you use zsh
- `bash_profile` - you use zsh
- `com.googlecode.iterm2.plist` - you use Wezterm
- `gemrc`, `irbrc`, `pryrc` - you rarely use Ruby
- `Rakefile` - Ruby-based, no longer needed
- `spacemacs` - you use nvim
- `snippets/` - legacy vim snippets
- `vim/` directory - you use nvim with lazy.nvim
- `vimrc` - you use nvim
- `install/vundle.sh` - you don't use Vundle
- `install/zsh.sh` - needs complete replacement

**Files to KEEP/MIGRATE**:
- `gitconfig` - migrate to `dot_gitconfig`, remove security issues
- `gitignore` - migrate to `private_dot_config/git/ignore`
- `install/brew.sh` - consolidate into Brewfile
- `install/brew-cask.sh` - consolidate into Brewfile
- `install/mas.sh` - keep for Mac App Store apps (reference in run_once script)

**External Configs to COMMIT**:
- `~/.claude/CLAUDE.md` - Claude Code instructions
- `~/.claude/settings.json` - Claude Code settings (audit for secrets first)
- `~/.config/nvim/` - LazyVim config
- `~/.config/zed/settings.json` - Zed editor config (sanitize database URLs)
- `~/.wezterm.lua` - Wezterm terminal config
- `~/.local/bin/linear-worktree` - custom scripts
- `~/.aws/config` - AWS CLI config (region settings only, no credentials)

### Approach Rationale: chezmoi vs Custom Scripts

Based on review feedback, **chezmoi is recommended over custom `dot` CLI scripts**.

| Feature | Custom `dot` CLI | chezmoi |
|---------|------------------|---------|
| Lines of code to write | ~300+ | 0 |
| Idempotency | Must implement | Built-in |
| Conflict resolution | Must implement | Built-in with diff |
| Backup before overwrite | Must implement | Automatic |
| Preview changes | Must implement | `chezmoi diff` |
| Multi-machine support | Via .local files | Templates, first-class |
| Secrets management | Manual | 1Password, age, gpg |
| Maintenance burden | High | None (maintained project) |

**Bootstrap comparison:**

Custom scripts:
```bash
git clone https://github.com/kevinold/dotfiles ~/.dotfiles
cd ~/.dotfiles
./install.sh  # Hope it works
```

chezmoi:
```bash
brew install chezmoi
chezmoi init --apply kevinold  # One command, handles everything
```

**Existing laptop adoption:**
```bash
brew install chezmoi
chezmoi init kevinold
chezmoi diff              # Preview what would change
chezmoi apply --dry-run   # Verify without making changes
chezmoi apply             # Apply configs; run_once scripts skip existing tools
```

### Modern Bootstrapping Tools Comparison

Per research from [chezmoi comparison](https://www.chezmoi.io/comparison-table/), [dotfiles.github.io](https://dotfiles.github.io/utilities/), and community discussions:

| Tool | Approach | Symlinks | Learning Curve | Best For |
|------|----------|----------|----------------|----------|
| **chezmoi** | Template-based | No (copies) | Moderate | Multi-machine, secrets |
| **yadm** | Git wrapper | No | Low | Git-native workflow |
| **dotbot** | YAML config | Yes | Low | Simple setups |
| **Nix/home-manager** | Declarative | No | High | Full system reproducibility |
| **GNU Stow** | Symlink farm | Yes | Low | Minimal approach |

**Recommendation**: chezmoi offers the best balance of features and simplicity for your use case.

Sources:
- [chezmoi comparison table](https://www.chezmoi.io/comparison-table/)
- [chezmoi quick start](https://www.chezmoi.io/quick-start/)
- [Dotfile Management Tools Battle](https://biggo.com/news/202412191324_dotfile-management-tools-comparison)
- [Declarative macOS with nix-darwin](https://carlosvaz.com/posts/declarative-macos-management-with-nix-darwin-and-home-manager/)

## Proposed Solution

### Directory Structure (chezmoi-based)

```
dotfiles/
├── .chezmoiignore                    # Files to ignore
├── .chezmoi.toml.tmpl                # chezmoi config template
│
├── .chezmoiscripts/
│   ├── run_once_01-install-homebrew.sh
│   ├── run_once_02-install-packages.sh.tmpl
│   ├── run_once_03-install-tools.sh
│   └── run_once_04-macos-defaults.sh
│
├── dot_zshenv                        # → ~/.zshenv
├── dot_zshrc                         # → ~/.zshrc
├── dot_gitconfig                     # → ~/.gitconfig
├── dot_wezterm.lua                   # → ~/.wezterm.lua
│
├── private_dot_config/
│   ├── nvim/                         # → ~/.config/nvim/
│   │   ├── init.lua
│   │   ├── lazy-lock.json
│   │   └── lua/
│   │       ├── config/
│   │       │   └── lazy.lua
│   │       └── plugins/
│   │
│   ├── starship.toml                 # → ~/.config/starship.toml
│   │
│   ├── zed/
│   │   └── settings.json             # → ~/.config/zed/settings.json
│   │
│   └── git/
│       └── ignore                    # → ~/.config/git/ignore
│
├── private_dot_aws/
│   └── config                        # → ~/.aws/config
│
├── private_dot_claude/
│   ├── CLAUDE.md                     # → ~/.claude/CLAUDE.md
│   └── settings.json                 # → ~/.claude/settings.json
│
├── private_dot_local/
│   └── bin/
│       └── executable_linear-worktree  # → ~/.local/bin/linear-worktree
│
├── Brewfile                          # Referenced by run_once script
├── LICENSE
└── README.md
```

### Phase 1: Create chezmoi Config

```toml
# .chezmoi.toml.tmpl
[data]
    email = "kevin@kevinold.com"
    name = "Kevin Old"
```

### Phase 2: Create Brewfile

```ruby
# Brewfile

# Taps
tap "homebrew/cask"
tap "homebrew/cask-fonts"

# ================================
# Core CLI Tools
# ================================
brew "bat"                    # Better cat
brew "coreutils"
brew "curl"
brew "fd"                     # Better find
brew "fzf"                    # Fuzzy finder
brew "gh"                     # GitHub CLI
brew "git"
brew "git-delta"              # Better git diff
brew "gnu-sed"
brew "grep"
brew "httpie"
brew "jq"
brew "mas"                    # Mac App Store CLI
brew "neovim"
brew "ripgrep"
brew "shellcheck"
brew "starship"               # Prompt
brew "tmux"
brew "tree"
brew "wget"
brew "zoxide"                 # Better cd
brew "zsh"
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"
brew "direnv"

# ================================
# Development
# ================================
brew "nvm"                    # Node version manager
brew "bun"                    # JS runtime/bundler

# ================================
# AWS
# ================================
brew "awscli"

# ================================
# Casks - Applications
# ================================
cask "alfred"
cask "claude-code"            # Claude Code CLI
cask "firefox"
cask "flameshot"
cask "google-chrome"
cask "keepingyouawake"
cask "microsoft-teams"
cask "obsidian"
cask "orbstack"               # Docker alternative
cask "rectangle"
cask "slack"
cask "visual-studio-code"
cask "wezterm"
cask "zed"

# ================================
# Fonts (Nerd Fonts for terminal/editor icons)
# ================================
cask "font-jetbrains-mono-nerd-font"  # Primary coding font
cask "font-fira-code-nerd-font"       # Alternative with ligatures
cask "font-hack-nerd-font"            # Clean monospace
cask "font-monaspace"                 # Variable font family

# ================================
# Mac App Store (via mas)
# ================================
mas "Tadam", id: 531349534
mas "Todoist", id: 585829637
```

### Phase 3: Create run_once Scripts

**`.chezmoiscripts/run_once_01-install-homebrew.sh`:**
```bash
#!/bin/bash
set -euo pipefail

if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "Homebrew already installed, updating..."
  brew update
fi
```

**`.chezmoiscripts/run_once_02-install-packages.sh.tmpl`:**
```bash
#!/bin/bash
set -euo pipefail

echo "Installing Homebrew packages..."
brew bundle --file="{{ .chezmoi.sourceDir }}/Brewfile" --no-lock
```

**`.chezmoiscripts/run_once_03-install-tools.sh`:**
```bash
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
```

**`.chezmoiscripts/run_once_04-macos-defaults.sh`:**
```bash
#!/bin/bash
set -euo pipefail

echo "Setting macOS defaults..."

# Expanding the save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Saving to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Check for software updates daily
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Disable smart quotes and smart dashes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Enable full keyboard access for all controls
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Key repeat speed
defaults write -g InitialKeyRepeat -int 10
defaults write -g KeyRepeat -int 2

# VS Code key repeat (only if installed)
if [[ -d "/Applications/Visual Studio Code.app" ]]; then
  defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
fi

# Safari Developer menu (only if Safari is default browser)
if defaults read com.apple.Safari &>/dev/null 2>&1; then
  defaults write com.apple.Safari IncludeDevelopMenu -bool true
  defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
  defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true
fi

# Web Inspector in web views
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

echo "macOS defaults set. Some changes require logout/restart."
```

### Phase 4: Create zshenv

**`dot_zshenv`:**
```bash
# ================================
# Environment Variables
# ================================
# This file is sourced on ALL shell invocations.
# Keep it fast and minimal - no output!

# XDG Base Directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# Editor
export EDITOR="nvim"
export VISUAL="nvim"
export GIT_EDITOR="nvim"

# History
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=50000
export SAVEHIST=50000

# PATH (typeset -U ensures unique entries)
typeset -U path
path=(
  "$HOME/.local/bin"
  "$HOME/.bun/bin"
  "$HOME/.cargo/bin"
  "/opt/homebrew/bin"
  "/opt/homebrew/sbin"
  $path
)

# Homebrew
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# NVM
export NVM_DIR="$HOME/.nvm"

# Rust
export CARGO_HOME="$HOME/.cargo"
export RUSTUP_HOME="$HOME/.rustup"

# Bun
export BUN_INSTALL="$HOME/.bun"

# ================================
# Local overrides (secrets, machine-specific)
# ================================
[[ -f "$HOME/.zshenv.local" ]] && source "$HOME/.zshenv.local"
```

### Phase 5: Create zshrc

**`dot_zshrc`:**
```bash
# ================================
# ZSH Configuration
# ================================

# Oh-My-Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""  # Using starship instead

# Plugins (minimal set for speed)
plugins=(
  git
  gh
  fzf
  zoxide
)

# Load Oh-My-Zsh (install if missing)
if [[ -d "$ZSH" ]]; then
  source "$ZSH/oh-my-zsh.sh"
fi

# ================================
# Completions
# ================================
if type brew &>/dev/null; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi
autoload -Uz compinit && compinit

# ================================
# Tool Initialization
# ================================

# NVM (with auto-load for .nvmrc)
_load_nvm() {
  if [[ -z "$_NVM_LOADED" ]]; then
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    export _NVM_LOADED=1
  fi
}

# Auto-load .nvmrc
autoload -U add-zsh-hook
load-nvmrc() {
  _load_nvm
  local nvmrc_path="$(nvm_find_nvmrc 2>/dev/null)"
  if [[ -n "$nvmrc_path" ]]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")" 2>/dev/null)
    if [[ "$nvmrc_node_version" = "N/A" ]]; then
      nvm install
    elif [[ "$nvmrc_node_version" != "$(nvm version)" ]]; then
      nvm use
    fi
  fi
}
add-zsh-hook chpwd load-nvmrc
[[ -f .nvmrc ]] && load-nvmrc

# Bun completions
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

# Direnv
if command -v direnv &>/dev/null; then
  eval "$(direnv hook zsh)"
fi

# Zoxide (better cd)
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

# Starship prompt
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

# dotenvx (conditional load)
if command -v dotenvx &>/dev/null; then
  alias dotenv='dotenvx run --'
fi

# OrbStack (if installed)
[[ -f ~/.orbstack/shell/init.zsh ]] && source ~/.orbstack/shell/init.zsh 2>/dev/null

# ================================
# Aliases
# ================================

# Editor
alias v='nvim'
alias vi='echo "use v instead!"'

# Claude Code
alias cld='claude'
alias clds='claude --model sonnet'
alias cldo='claude --model opus'

# Python (via uv)
alias py='uv run python'
alias uvvenv='uv venv --python 3.12 && source .venv/bin/activate'

# Listing
alias ll='ls -hlahtr'
alias cls='clear; ls'

# Git (supplement oh-my-zsh git plugin)
alias gp='git push --dry-run'
alias gp!='git push'

# NPM/Yarn/Bun
alias nt='npm test'
alias ns='npm start'
alias yt='yarn test'
alias ys='yarn start'
alias bt='bun test'
alias bs='bun start'

# ================================
# Functions
# ================================

# Edit files with git changes
ge() {
  git status --porcelain | sed 's/^...//' | xargs -o nvim
}

# ================================
# Local overrides
# ================================
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
```

### Phase 6: Create Starship Config

**`private_dot_config/starship.toml`:**
```toml
# Minimal, fast prompt

format = """
$directory\
$git_branch\
$git_status\
$nodejs\
$python\
$rust\
$character"""

[directory]
truncation_length = 3
truncate_to_repo = true

[git_branch]
symbol = " "
format = "[$symbol$branch]($style) "

[git_status]
format = '([$all_status$ahead_behind]($style) )'

[nodejs]
symbol = " "
format = "[$symbol($version )]($style)"
detect_files = ["package.json", ".nvmrc"]

[python]
symbol = " "
format = "[$symbol($version )]($style)"
detect_files = ["pyproject.toml", "requirements.txt", ".python-version"]

[rust]
symbol = " "
format = "[$symbol($version )]($style)"

[character]
success_symbol = "[❯](green)"
error_symbol = "[❯](red)"
```

### Phase 7: Create AWS Config

**`private_dot_aws/config`:**
```ini
[default]
region = us-east-1
cli_pager =
```

### Phase 8: Clean gitconfig

**`dot_gitconfig`** (remove hardcoded paths and security issues):
```ini
[core]
  pager = less -E -F -X
  excludesfile = ~/.config/git/ignore
  editor = nvim

[color]
  status = auto
  diff = auto
  interactive = auto

[alias]
  ci = commit
  cia = commit --amend
  co = checkout
  st = status
  br = branch
  di = diff
  unstage = reset HEAD
  staged = diff --cached
  cp = cherry-pick
  rb = rebase
  rbc = rebase --continue
  undo = reset --soft HEAD^
  lg = log -n 15 --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an> %Creset' --abbrev-commit --date=relative
  lga = log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an> %Creset' --abbrev-commit --date=relative

[merge]
  tool = vimdiff

[user]
  name = Kevin Old
  email = kevin@kevinold.com

[github]
  user = kevinold

[rerere]
  enabled = 1

[push]
  default = current

[init]
  defaultBranch = main

[hub]
  protocol = ssh
```

### Phase 9: Create README

**`README.md`:**
```markdown
# Kevin's Dotfiles

Modern dotfiles for macOS development, managed with [chezmoi](https://www.chezmoi.io/).

## What's Included

| Category | Tools |
|----------|-------|
| **Shell** | Zsh + Oh-My-Zsh + Starship prompt |
| **Editor** | Neovim (LazyVim), Zed, VS Code |
| **Terminal** | Wezterm |
| **Languages** | Node.js (nvm), Python (uv), Rust, Bun |
| **AI Tools** | Claude Code |
| **Apps** | Obsidian, OrbStack, Alfred, Rectangle |
| **Fonts** | JetBrains Mono, Fira Code, Hack (Nerd Fonts) |

---

## How It Works

```
┌─────────────────────────────────────────────────────────────────┐
│                    BOOTSTRAP FLOW                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  YOU DO ONCE (manual):                                          │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  1. Install Homebrew                                     │   │
│  │  2. brew install chezmoi                                 │   │
│  │  3. chezmoi init --apply kevinold                        │   │
│  └─────────────────────────────────────────────────────────┘   │
│                          │                                      │
│                          ▼                                      │
│  CHEZMOI DOES AUTOMATICALLY:                                    │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  run_once_01: Homebrew update (skips install if exists) │   │
│  │  run_once_02: brew bundle → all packages, apps, fonts   │   │
│  │  run_once_03: Rust, Bun, Node.js LTS, Claude Code       │   │
│  │  run_once_04: macOS defaults (keyboard, save panel)     │   │
│  │  + Copies all dotfiles to correct locations              │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  RESULT: Fully configured development environment               │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## New Laptop Setup

**Important:** You need to install Homebrew manually first, then chezmoi handles everything else.

### Bootstrap Steps

```bash
# 1. Install Homebrew (manual, required first)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

# 2. Install chezmoi
brew install chezmoi

# 3. chezmoi does EVERYTHING else automatically:
#    - Installs all Homebrew packages (CLI tools, apps, fonts)
#    - Installs Rust, Bun, Node.js LTS, Claude Code
#    - Sets up all dotfiles (zsh, nvim, git, wezterm, etc.)
#    - Configures macOS defaults
chezmoi init --apply kevinold
```

### What Gets Installed Automatically

After `chezmoi init --apply`, you'll have:
- **Homebrew packages**: neovim, ripgrep, starship, fzf, gh, etc.
- **Applications**: VS Code, Zed, Wezterm, Obsidian, OrbStack, etc.
- **Fonts**: JetBrains Mono Nerd Font, Fira Code, Hack, Monaspace
- **Languages**: Node.js (via nvm), Rust (via rustup), Bun
- **Tools**: Claude Code, direnv, zoxide
- **Configs**: zsh, nvim, git, starship, wezterm, zed

### Option 1: One-liner

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && eval "$(/opt/homebrew/bin/brew shellenv)" && brew install chezmoi && chezmoi init --apply kevinold
```

### Option 2: With SSH key generation

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

# Generate SSH key (optional)
ssh-keygen -t ed25519 -C "your-email@example.com"
eval "$(ssh-agent -s)"
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub  # Add to GitHub

# Install and apply dotfiles
brew install chezmoi
chezmoi init --apply kevinold
```

### Option 3: Clone first (for customization)

```bash
brew install chezmoi
chezmoi init kevinold --ssh
cd ~/.local/share/chezmoi
# Make any changes you want
chezmoi apply
```

## Existing Laptop (Already Has Tools)

If you already have your development environment set up and just want the config files:

```bash
# Install chezmoi
brew install chezmoi

# Initialize (does NOT apply yet)
chezmoi init kevinold

# Preview what would change
chezmoi diff

# See exactly what will happen (dry run)
chezmoi apply --dry-run

# Apply only the dotfiles (run_once scripts are idempotent)
chezmoi apply
```

**Note:** The `run_once` scripts check for existing tools before installing. Running `chezmoi apply` won't reinstall Homebrew, Rust, Node.js, etc. if they're already present.

---

## Migrating from Old Symlink-Based Dotfiles

If you currently have dotfiles managed with symlinks (like the old `install.sh` script):

### Understanding the Difference

```
BEFORE (symlink-based):
┌──────────────────────────────────────────────────────────────┐
│  ~/dotfiles/              ~/.zshrc → ~/dotfiles/zshrc        │
│  ├── zshrc                ~/.gitconfig → ~/dotfiles/gitconfig│
│  ├── gitconfig            ~/.config/nvim → ~/dotfiles/vim/   │
│  └── vim/                                                     │
└──────────────────────────────────────────────────────────────┘

AFTER (chezmoi-managed):
┌──────────────────────────────────────────────────────────────┐
│  ~/.local/share/chezmoi/  ~/.zshrc (actual file, not symlink)│
│  ├── dot_zshrc            ~/.gitconfig (actual file)         │
│  ├── dot_gitconfig        ~/.config/nvim/ (actual directory) │
│  └── private_dot_config/                                      │
│      └── nvim/                                                │
└──────────────────────────────────────────────────────────────┘

chezmoi COPIES files (not symlinks) and tracks changes via git
```

### Step-by-Step Migration

**Step 1: Backup your current symlinked configs**
```bash
mkdir -p ~/dotfiles-backup-$(date +%Y%m%d)
# Copy the actual content (follow symlinks with -L)
cp -L ~/.zshrc ~/dotfiles-backup-$(date +%Y%m%d)/ 2>/dev/null || true
cp -L ~/.gitconfig ~/dotfiles-backup-$(date +%Y%m%d)/ 2>/dev/null || true
cp -rL ~/.config/nvim ~/dotfiles-backup-$(date +%Y%m%d)/ 2>/dev/null || true
cp -L ~/.wezterm.lua ~/dotfiles-backup-$(date +%Y%m%d)/ 2>/dev/null || true
echo "Backup created at ~/dotfiles-backup-$(date +%Y%m%d)"
```

**Step 2: Remove old symlinks**
```bash
# Remove symlinks only (leaves regular files alone)
[ -L ~/.zshrc ] && rm ~/.zshrc
[ -L ~/.zshenv ] && rm ~/.zshenv
[ -L ~/.gitconfig ] && rm ~/.gitconfig
[ -L ~/.config/nvim ] && rm -rf ~/.config/nvim
[ -L ~/.wezterm.lua ] && rm ~/.wezterm.lua
# Your old dotfiles repo is untouched
```

**Step 3: Install chezmoi and apply new configs**
```bash
brew install chezmoi
chezmoi init --apply kevinold
```

**Step 4: Verify everything works**
```bash
# Restart terminal or source configs
source ~/.zshenv
source ~/.zshrc

# Test key tools
nvim --version
git --version
claude --version  # if installed
```

**Step 5: Archive old dotfiles repo (optional)**
```bash
# Once you're happy with the new setup
mv ~/dotfiles ~/dotfiles-old-archived
# Or delete it: rm -rf ~/dotfiles
```

### Why Migrate?

| Old Approach (Symlinks) | chezmoi |
|-------------------------|---------|
| Symlinks can break if repo moves | Files are actual copies, always work |
| No preview of changes | `chezmoi diff` shows changes before applying |
| Manual conflict resolution | Automatic backup before overwrite |
| No multi-machine templates | Built-in templating for different machines |
| Custom scripts to maintain | Zero maintenance (chezmoi is a maintained project) |

## Daily Usage

### Update dotfiles from repo

```bash
chezmoi update  # Pull latest changes and apply
```

### Edit a managed file

```bash
chezmoi edit ~/.zshrc  # Opens in $EDITOR
```

### See what's changed locally

```bash
chezmoi diff
```

### Add a new file to management

```bash
chezmoi add ~/.config/some-tool/config
```

### Re-apply all configs

```bash
chezmoi apply
```

## Customization

### Machine-specific settings

Add local overrides that won't be committed:

- `~/.zshenv.local` - Environment variables (secrets, API keys)
- `~/.zshrc.local` - Shell functions and aliases
- `~/.gitconfig.local` - Git settings (work email, etc.)

Example `~/.zshenv.local`:
```bash
export GITHUB_TOKEN="your-token-here"
export AWS_PROFILE="work"
```

### Adding new packages

Edit `~/.local/share/chezmoi/Brewfile` and run:
```bash
chezmoi apply
```

## Directory Structure

```
~/.local/share/chezmoi/           # Source of truth (this repo)
├── .chezmoi.toml.tmpl            # chezmoi config
├── .chezmoiignore                # Files to ignore
├── .chezmoiscripts/
│   ├── run_once_01-install-homebrew.sh
│   ├── run_once_02-install-packages.sh.tmpl
│   ├── run_once_03-install-tools.sh
│   └── run_once_04-macos-defaults.sh
│
├── dot_zshenv                    # → ~/.zshenv
├── dot_zshrc                     # → ~/.zshrc
├── dot_gitconfig                 # → ~/.gitconfig
├── dot_wezterm.lua               # → ~/.wezterm.lua
│
├── private_dot_config/
│   ├── nvim/                     # → ~/.config/nvim/
│   ├── starship.toml             # → ~/.config/starship.toml
│   ├── zed/settings.json         # → ~/.config/zed/settings.json
│   └── git/ignore                # → ~/.config/git/ignore
│
├── private_dot_aws/config        # → ~/.aws/config
├── private_dot_claude/
│   ├── CLAUDE.md                 # → ~/.claude/CLAUDE.md
│   └── settings.json             # → ~/.claude/settings.json
│
├── private_dot_local/bin/
│   └── executable_linear-worktree
│
├── Brewfile                      # Homebrew packages
└── README.md
```

### chezmoi Naming Conventions

| Prefix | Meaning |
|--------|---------|
| `dot_` | File starts with `.` (e.g., `dot_zshrc` → `.zshrc`) |
| `private_` | File permissions set to 0600 (user-only) |
| `executable_` | File is made executable (chmod +x) |
| `run_once_` | Script runs only once, ever |
| `run_onchange_` | Script runs when content changes |

---

## Troubleshooting

### Shell isn't loading new config

```bash
source ~/.zshenv
source ~/.zshrc
# Or restart your terminal
```

### Homebrew packages didn't install

```bash
chezmoi cd
brew bundle --file=Brewfile
```

### chezmoi says files are different but they look the same

```bash
# Check for whitespace/line ending differences
chezmoi diff ~/.zshrc | cat -A
```

### Force re-apply everything

```bash
chezmoi apply --force
```

### Re-run installation scripts

```bash
# Force re-run of run_once scripts
chezmoi state delete-bucket --bucket=scriptState
chezmoi apply
```

### NVM not working

```bash
source "$NVM_DIR/nvm.sh"
nvm install --lts
```

### Rollback changes

chezmoi keeps backups. Check `~/.local/share/chezmoi` for the source files.

## Credits

Inspired by [nicknisi/dotfiles](https://github.com/nicknisi/dotfiles).
```

## Acceptance Criteria

### Functional Requirements

- [ ] Running `chezmoi init --apply kevinold` on a fresh Mac completes without errors
- [ ] Running `chezmoi apply` on an existing Mac is idempotent (safe to re-run)
- [ ] `chezmoi diff` shows what would change before applying
- [ ] Shell starts with starship prompt
- [ ] `nvim` opens LazyVim configuration
- [ ] `claude` command is available
- [ ] `bun`, `node`, `npm`, `npx` commands work
- [ ] `rustc`, `cargo` commands work
- [ ] `uv`, `uvx` commands work
- [ ] Zed editor settings are applied
- [ ] Wezterm config is applied
- [ ] Git config and ignore files are applied
- [ ] AWS config is applied
- [ ] macOS defaults are applied
- [ ] Environment variables are in `zshenv`, not `zshrc`
- [ ] No Ruby-related files remain in repo
- [ ] No Vundle references remain
- [ ] No hardcoded paths in gitconfig
- [ ] No secrets in committed files

### Quality Gates

- [ ] All shell scripts pass `shellcheck`
- [ ] README includes both new laptop and existing laptop instructions
- [ ] All config files have comments explaining non-obvious settings
- [ ] `.zshenv.local` / `.zshrc.local` pattern is documented

## Implementation Order

1. **Install chezmoi locally**: `brew install chezmoi`
2. **Initialize chezmoi**: `chezmoi init`
3. **Create directory structure** in `~/.local/share/chezmoi/`
4. **Add existing configs** using `chezmoi add`:
   - `chezmoi add ~/.config/nvim`
   - `chezmoi add ~/.wezterm.lua`
   - `chezmoi add ~/.config/zed/settings.json`
   - `chezmoi add ~/.aws/config`
5. **Create new configs** (zshenv, zshrc, starship, gitconfig)
6. **Create Brewfile** with modern package list
7. **Create run_once scripts** for tool installation
8. **Add Claude Code configs** (CLAUDE.md, settings.json only)
9. **Test with `chezmoi apply --dry-run`**
10. **Delete obsolete files** from old structure
11. **Push to GitHub**
12. **Test on fresh environment** (or VM)

## Files to Create

| File | Description |
|------|-------------|
| `.chezmoi.toml.tmpl` | chezmoi configuration |
| `.chezmoiignore` | Files to exclude |
| `.chezmoiscripts/run_once_01-install-homebrew.sh` | Homebrew install |
| `.chezmoiscripts/run_once_02-install-packages.sh.tmpl` | Brew bundle |
| `.chezmoiscripts/run_once_03-install-tools.sh` | Rust, Bun, etc. |
| `.chezmoiscripts/run_once_04-macos-defaults.sh` | macOS settings |
| `dot_zshenv` | Environment variables |
| `dot_zshrc` | Shell configuration |
| `dot_gitconfig` | Git configuration (cleaned) |
| `dot_wezterm.lua` | Wezterm terminal config |
| `private_dot_config/nvim/*` | LazyVim (from ~/.config/nvim) |
| `private_dot_config/starship.toml` | Starship prompt |
| `private_dot_config/zed/settings.json` | Zed editor (sanitized) |
| `private_dot_config/git/ignore` | Global gitignore |
| `private_dot_aws/config` | AWS CLI config |
| `private_dot_claude/CLAUDE.md` | Claude Code instructions |
| `private_dot_claude/settings.json` | Claude Code settings |
| `private_dot_local/bin/executable_linear-worktree` | Custom script |
| `Brewfile` | Homebrew packages |
| `README.md` | Documentation |

## Files to Delete

| File | Reason |
|------|--------|
| `ackrc` | Using ripgrep |
| `bash/*` | Using zsh |
| `bash_profile` | Using zsh |
| `com.googlecode.iterm2.plist` | Using Wezterm |
| `gemrc` | Not using Ruby |
| `irbrc` | Not using Ruby |
| `pryrc` | Not using Ruby |
| `Rakefile` | Ruby-based |
| `spacemacs` | Using nvim |
| `snippets/*` | Legacy vim snippets |
| `vim/*` | Using nvim |
| `vimrc` | Using nvim |
| `install/vundle.sh` | Not using Vundle |
| `install/zsh.sh` | Replaced by chezmoi |
| `install/brew.sh` | Replaced by Brewfile |
| `install/brew-cask.sh` | Replaced by Brewfile |
| `install/node.sh` | Replaced by run_once script |
| `install.sh` | Replaced by chezmoi |

## Security Checklist

- [ ] Remove commented GitHub token from gitconfig (line 107)
- [ ] Audit `~/.claude/settings.json` for API keys before committing
- [ ] Sanitize database URLs in `~/.config/zed/settings.json`
- [ ] Use `private_` prefix for sensitive configs (chezmoi sets 0600 perms)
- [ ] Document `.local` file pattern for secrets
- [ ] Never commit `~/.aws/credentials`
- [ ] Never commit SSH private keys

## References

### Internal References
- Current zshrc: `/Users/kevinold/dotfiles/install/zshrc`
- LazyVim config: `/Users/kevinold/.config/nvim/`
- Claude settings: `/Users/kevinold/.claude/settings.json`
- Wezterm config: `/Users/kevinold/.wezterm.lua`
- Zed settings: `/Users/kevinold/.config/zed/settings.json`
- AWS config: `/Users/kevinold/.aws/config`

### External References
- [chezmoi Quick Start](https://www.chezmoi.io/quick-start/)
- [chezmoi Comparison Table](https://www.chezmoi.io/comparison-table/)
- [nicknisi/dotfiles](https://github.com/nicknisi/dotfiles/tree/main)
- [Claude Code Quickstart](https://code.claude.com/docs/en/quickstart)
- [Starship Documentation](https://starship.rs/config/)
- [LazyVim Documentation](https://www.lazyvim.org/)
