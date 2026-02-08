# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

macOS dotfiles managed with [chezmoi](https://www.chezmoi.io/). Chezmoi copies files to their target locations (not symlinks) and tracks changes via git. The source of truth is this repo; `chezmoi apply` deploys everything.

## Key Commands

```bash
# Preview what chezmoi would change
chezmoi diff

# Apply all dotfiles and run scripts
chezmoi apply

# Apply with dry run (safe preview)
chezmoi apply --dry-run

# Add a new file to chezmoi management
chezmoi add ~/.config/some-tool/config

# Edit a managed file (opens source, not target)
chezmoi edit ~/.zshrc

# Pull latest and apply
chezmoi update

# Force re-run all run_once scripts
chezmoi state delete-bucket --bucket=scriptState && chezmoi apply

# Install Homebrew packages from Brewfile
brew bundle --file=Brewfile --no-upgrade

# Validate shell scripts
shellcheck .chezmoiscripts/*.sh
```

## Architecture

### chezmoi Naming Conventions

Files in this repo use chezmoi prefixes that determine how they are deployed:

| Prefix | Effect | Example |
|--------|--------|---------|
| `dot_` | Deployed with leading `.` | `dot_zshrc` → `~/.zshrc` |
| `private_` | Permissions set to 0600 | `private_dot_config/` → `~/.config/` |
| `executable_` | Made executable (chmod +x) | `executable_linear-worktree` |
| `run_once_` | Script runs once ever | Bootstrap scripts |
| `run_onchange_` | Script re-runs when content changes | Package install |

### Shell Configuration (zsh)

Two-file split following zsh conventions:
- **`dot_zshenv`** → `~/.zshenv` — Environment variables and PATH. Sourced on ALL shell invocations (including non-interactive). Must be fast, no output.
- **`dot_zshrc`** → `~/.zshrc` — Interactive shell setup: Oh-My-Zsh, tool initialization (fnm, direnv, zoxide, starship, pyenv, rbenv), aliases, functions. Only sourced for interactive shells.

PATH is built in `dot_zshenv` using `typeset -U path` (deduplicates). Homebrew shellenv is also evaluated there.

Local overrides (not committed): `~/.zshenv.local`, `~/.zshrc.local`, `~/.gitconfig.local`

### Bootstrap Scripts (`.chezmoiscripts/`)

Run in numbered order during `chezmoi apply`:
1. **01** — Install/update Homebrew
2. **02** — `brew bundle` from Brewfile (re-runs when Brewfile changes via `run_onchange_`)
3. **03** — Install Oh My Zsh, Claude Code, Rust, Node.js LTS (via fnm), Bun
4. **04** — macOS defaults (keyboard repeat, save panel, etc.)
5. **05** — Claude Code plugins and marketplaces

All scripts are idempotent — they check for existing installations before acting.

### Node.js Management

Uses **fnm** (Fast Node Manager), not nvm. The `nvm` command is aliased to `fnm` in `dot_zshrc` for muscle-memory compatibility. fnm reads `.nvmrc`/`.node-version` files automatically via `--use-on-cd`.

### Managed Configurations

| File | Target | Purpose |
|------|--------|---------|
| `dot_gitconfig` | `~/.gitconfig` | Git aliases, user info, delta pager |
| `dot_wezterm.lua` | `~/.wezterm.lua` | Terminal config (font size 22, `/bin/zsh` default) |
| `private_dot_config/nvim/` | `~/.config/nvim/` | LazyVim-based Neovim config |
| `private_dot_config/zed/` | `~/.config/zed/` | Zed editor settings (vim mode, Gemini AI) |
| `private_dot_config/git/ignore` | `~/.config/git/ignore` | Global gitignore |
| `dot_claude/` | `~/.claude/` | Claude Code CLAUDE.md and settings.json |
| `dot_aws/private_config` | `~/.aws/config` | AWS CLI defaults |
| `private_dot_local/bin/` | `~/.local/bin/` | Custom scripts (e.g., `linear-worktree`) |

### `.chezmoiignore`

Lists files that exist in the repo but should NOT be deployed as dotfiles: old legacy files (ackrc, bash/, vim/, etc.), documentation (docs/, README.md), and Claude Code runtime state directories.

### Template Data (`.chezmoi.toml.tmpl`)

Minimal — only `email` and `name` used for templating (e.g., in git config).

## Important Conventions

- **Brewfile** is the single source for all Homebrew packages, casks, and Mac App Store apps. It is referenced by the `run_onchange_02` script, not deployed as a dotfile.
- **`docs/plans/`** contains planning documents — never delete these.
- All tool initializations in `dot_zshrc` are guarded with `command -v` checks so the shell doesn't break if a tool isn't installed.
- The `dot_claude/` directory only manages `CLAUDE.md` and `settings.json` — all other `~/.claude/` subdirectories are in `.chezmoiignore` to avoid overwriting runtime state.
