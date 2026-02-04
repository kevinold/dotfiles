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

---

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

---

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

---

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

---

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
├── dot_aws/config                # → ~/.aws/config
├── dot_claude/
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

---

## Credits

Inspired by [nicknisi/dotfiles](https://github.com/nicknisi/dotfiles).
