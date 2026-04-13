# Dotfiles

Personal configuration files for macOS, managed by [chezmoi](https://www.chezmoi.io/). Optimized for Apple Silicon and Zsh.

## Prerequisites

1. **Command Line Tools:** Run `xcode-select --install` or let `git clone` prompt you.
2. **Mac App Store:** Log in before running install (required for `mas` to install Xcode).

## Installation

Fresh machine (one command):

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply polyrhythmatic
```

Or if chezmoi is already installed:

```bash
chezmoi init --apply polyrhythmatic
```

First run will prompt for your name and email (used in `.gitconfig`).

### From a local clone (unpushed changes)

If you have local edits that aren't pushed yet — e.g. bootstrapping a new
machine where you can't push until the dotfiles generate an SSH key — point
chezmoi at the local clone instead:

```bash
# 1. Install chezmoi (skip if already installed).
#    The installer drops the binary at bin/chezmoi in the current directory
#    — it is NOT added to PATH, so invoke it by relative path below.
sh -c "$(curl -fsLS get.chezmoi.io)"

# 2. Clone (or copy) this repo to the new machine, e.g. ~/dotfiles
#    Then point chezmoi at it:
bin/chezmoi init --source=~/dotfiles

# 3. Preview changes before applying
bin/chezmoi diff

# 4. Apply
bin/chezmoi apply -v
```

(Once the Brewfile installs the `chezmoi` Homebrew package during apply,
later invocations can drop the `bin/` prefix.)

After the first apply generates an SSH key and you've added it to GitHub,
push your local changes and future machines can use the one-liner above.

## What it Does

`chezmoi apply` manages the following:

- **Shell config** (`.zshrc`, `.zprofile`) via modify scripts that preserve a managed section + `LOCAL` marker for external tool additions
- **Git config** (`.gitconfig` templated with name/email, `.gitignore`)
- **Homebrew** CLI tools and GUI apps (triggered on Brewfile changes)
- **fnm** (Fast Node Manager) + Node.js v22 LTS + global npm packages
- **Terminal configs** — Ghostty (Alabaster Dark theme, Berkeley Mono font) and iTerm2 Dynamic Profile
- **Starship prompt** — minimal Swiss-inspired config
- **Shell plugins** — fzf, zsh-autosuggestions, zsh-syntax-highlighting
- **SSH key** generation and GitHub config
- **macOS preferences** via `defaults write` (audited for modern macOS)
- **Claude Code** — symlinks standards, skills, agents, settings, and MCP config into `~/.claude/`

## Claude Code Multi-Agent Setup

The `claude/` directory contains a portable multi-agent configuration:

```
claude/
  standards/       # Shared coding standards
  skills/          # Skill definitions (design-reviewer, dev-reviewer, etc.)
  agents/          # Agent definitions (design-system-component, figma-design-qa)
  ARCHITECTURE.md  # Detailed architecture documentation
```

Chezmoi symlinks these into `~/.claude/` so Claude Code picks them up automatically.

## File Reference

| Chezmoi source | Target | Purpose |
|----------------|--------|---------|
| `dot_gitconfig.tmpl` | `~/.gitconfig` | Git config (templated) |
| `dot_gitignore_global` | `~/.gitignore` | Global gitignore |
| `modify_dot_zshrc` | `~/.zshrc` | Shell interactive config |
| `modify_dot_zprofile` | `~/.zprofile` | Shell login/env config |
| `private_dot_config/starship.toml` | `~/.config/starship.toml` | Starship prompt |
| `private_dot_config/ghostty/` | `~/.config/ghostty/` | Ghostty terminal |
| `private_dot_claude/` | `~/.claude/` | Claude Code symlinks |
| `Brewfile_cli` | (run script input) | CLI packages |
| `Brewfile_cask` | (run script input) | GUI applications |
| `runcom/.zshrc` | (sourced by modify script) | Zsh config source |
| `runcom/.zprofile` | (sourced by modify script) | Zprofile config source |
| `config/iterm2/Default.json` | (copied by run script) | iTerm2 Dynamic Profile |
| `claude/` | (symlink targets) | Claude Code config |

## Run Scripts

| Script | Type | Purpose |
|--------|------|---------|
| `run_once_before_00-migrate-from-symlinks.sh` | once | Remove old symlinks from legacy install |
| `run_once_before_01-install-homebrew.sh.tmpl` | once | Install Homebrew (arch-aware) |
| `run_onchange_before_02-install-brew-packages.sh.tmpl` | onchange | CLI tools via Brewfile |
| `run_onchange_before_03-install-brew-cask.sh.tmpl` | onchange | GUI apps via Brewfile |
| `run_onchange_before_04-install-npm.sh.tmpl` | onchange | fnm + Node v22 |
| `run_once_before_05-install-mas.sh` | once | Xcode via Mac App Store |
| `run_once_before_06-setup-ssh.sh.tmpl` | once | SSH key generation |
| `run_once_before_07-check-fonts.sh` | once | Berkeley Mono font check |
| `run_after_10-iterm2-profile.sh.tmpl` | after | iTerm2 Dynamic Profile |
| `run_onchange_after_20-macos-defaults.sh.tmpl` | onchange | macOS system preferences |

## Testing

See `testing/` directory:

- `tart-test.sh` — Automated headless VM test (requires `tart`)
- `tart-test-idempotent.sh` — Verify second apply produces no changes
- `capture-defaults.sh` — Capture macOS defaults before/after for auditing
- `UTM-TESTING.md` — Manual visual verification checklist

## Post-Installation

1. **Add SSH Key to GitHub:** The install script copies your public key to the clipboard. Add it at [github.com/settings/keys](https://github.com/settings/keys).
2. **Restart:** Some macOS preferences require logout/restart to take effect.
3. **Local shell additions:** External tools can safely append below the `LOCAL` marker in `~/.zshrc`.

## Known Issues / TODO

- **Audit legacy QuickLook plugins.** `qlcolorcode`, `qlstephen`, and `qlmarkdown`
  in `Brewfile_cask` are legacy `.qlgenerator` plugins. Apple dropped support
  for that format in macOS 15 (Sequoia) — they may install cleanly but do
  nothing. `quicklook-json` was already disabled by Homebrew on 2025-12-23 for
  the same reason and has been removed. A modern replacement for `qlcolorcode`
  is [`syntax-highlight`](https://formulae.brew.sh/cask/syntax-highlight) by
  sbarex, which uses the newer QuickLook App Extension API. Needs verification
  on macOS 15+ before swapping.
