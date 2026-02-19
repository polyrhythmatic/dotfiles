# Chezmoi Migration Plan

## Overview

Migrating from hand-rolled `install.sh` + symlinks to **chezmoi** for idempotent dotfile management. Also auditing `macos.sh`, and setting up Tart/UTM for VM testing.

---

## Phase 1: Chezmoi initialization -- DONE

Created:
- `.chezmoi.toml.tmpl` — config template with `promptStringOnce` for name/email
- `.chezmoiignore` — skips README, runcom/, claude/, config/iterm2/, Brewfiles, testing/, install/

---

## Phase 2: Migrate dotfiles to chezmoi naming -- DONE

Completed renames and new files:

| File | Purpose |
|------|---------|
| `dot_gitconfig.tmpl` | `~/.gitconfig` with `{{ .name }}`/`{{ .email }}` templates |
| `dot_gitignore_global` | `~/.gitignore` (renamed from `.gitignore`) |
| `private_dot_config/ghostty/config` | `~/.config/ghostty/config` |
| `private_dot_config/ghostty/themes/Alabaster Dark` | `~/.config/ghostty/themes/Alabaster Dark` |
| `private_dot_config/starship.toml` | `~/.config/starship.toml` |
| `modify_dot_zshrc` | Modify script: managed section + LOCAL marker preservation |
| `modify_dot_zprofile` | Same pattern for `.zprofile` |
| `private_dot_claude/symlink_standards.tmpl` | `~/.claude/standards` → repo |
| `private_dot_claude/symlink_mcp.json.tmpl` | `~/.claude/mcp.json` → repo |
| `private_dot_claude/symlink_settings.json.tmpl` | `~/.claude/settings.json` → repo |
| `private_dot_claude/skills/symlink_<name>.tmpl` (x5) | Per-skill symlinks |
| `private_dot_claude/agents/symlink_<name>.tmpl` (x2) | Per-agent symlinks |

---

## Phase 3: Convert install scripts to chezmoi run scripts -- DONE

Created:

| Script | Type | Purpose |
|--------|------|---------|
| `run_once_before_00-migrate-from-symlinks.sh` | once | Remove old symlinks |
| `run_once_before_01-install-homebrew.sh.tmpl` | once | Install Homebrew (arch-aware) |
| `run_onchange_before_02-install-brew-packages.sh.tmpl` | onchange | CLI tools via `Brewfile_cli` |
| `run_onchange_before_03-install-brew-cask.sh.tmpl` | onchange | GUI apps via `Brewfile_cask` |
| `run_onchange_before_04-install-npm.sh.tmpl` | onchange | fnm + Node v22 |
| `run_once_before_05-install-mas.sh` | once | Xcode via App Store |
| `run_once_before_06-setup-ssh.sh.tmpl` | once | SSH key generation |
| `run_once_before_07-check-fonts.sh` | once | Berkeley Mono font check |
| `run_after_10-iterm2-profile.sh.tmpl` | after | iTerm2 Dynamic Profile |

Also created:
- `Brewfile_cli` — all CLI packages (added `chezmoi`, `tart`)
- `Brewfile_cask` — all GUI apps + QuickLook plugins (added `utm`)

---

## Phase 4: macos.sh audit -- DONE

Create `run_onchange_after_20-macos-defaults.sh.tmpl` from audited `macos.sh`.

### Remove (deprecated/obsolete):
- `com.apple.dashboard mcx-disabled` and `dashboard-in-overlay` — Dashboard removed in Catalina
- `AppleFontSmoothing` — subpixel rendering removed for Retina displays
- `NSUseAnimatedFocusRing` — no longer observed on modern macOS
- `NSTextShowsControlCharacters` — rarely applicable
- `com.apple.addressbook ABShowDebugMenu` — Contacts app changed
- `com.apple.appstore WebKitDeveloperExtras` and `ShowDebugMenu` — App Store redesigned
- `lsregister -kill` command — aggressive and can cause issues
- `"Address Book"` and `"Calendar"` from killall list
- `"System Preferences"` → `"System Settings"` in osascript quit command

### Keep as-is (still work on modern macOS):
- All Finder settings (hidden files, path bar, status bar, list view, extensions, etc.)
- Dock settings (autohide, icon size, scale effect, animation speeds)
- Keyboard/trackpad (tap-to-click, key repeat, press-and-hold disabled)
- Screenshots (location, format, no shadow)
- Activity Monitor, TextEdit, Time Machine, Photos hotplug
- Software updates, Mail, Messages, Terminal, Safari (mostly)

### Wrap PlistBuddy commands in error handling:
```bash
/usr/libexec/PlistBuddy -c "..." ... 2>/dev/null || true
```

### Mark for VM testing:
- Safari settings (increasingly locked behind TCC on newer macOS)
- Screensaver password settings

---

## Phase 5: VM testing setup -- DONE

### Files to create:

**`testing/tart-test.sh`** — Automated headless testing:
- Clone fresh macOS VM from Cirrus Labs base image (`ghcr.io/cirruslabs/macos-sequoia-base:latest`)
- Boot headless, SSH in
- Run `chezmoi init --apply` from repo
- Verification checks: file existence, symlink targets, command availability
- Report pass/fail

**`testing/tart-test-idempotent.sh`** — Idempotency verification:
- Run `chezmoi apply` twice
- Verify second run produces no changes (exit code 0, no diff)

**`testing/capture-defaults.sh`** — Defaults auditing helper:
- Dump `defaults read` for all relevant domains (NSGlobalDomain, com.apple.finder, com.apple.dock, etc.)
- Run before and after macos defaults script to see exactly what changed

**`testing/UTM-TESTING.md`** — Visual verification checklist:
- Dock appearance (autohide, 36px icons, scale effect)
- Finder settings (hidden files visible, list view, path bar, status bar)
- Screenshots (PNG, Desktop, no shadow)
- Keyboard (fast repeat, no press-and-hold)
- Ghostty theme (Alabaster Dark, Berkeley Mono)
- Starship prompt renders correctly
- Shell plugins load (autosuggestions, syntax highlighting, fzf)

---

## Phase 6: Cleanup and README -- DONE

- Rename `install.sh` → `install.sh.legacy`
- Remove `install/` directory (contents moved to run scripts)
- Remove empty `config/ghostty/` dirs (content moved to `private_dot_config/`)
- Keep `runcom/`, `claude/`, `config/iterm2/` as source content
- Update `README.md`:
  - New installation: `sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply sethkranzler`
  - Updated file reference table
  - Remove old TODO items, add chezmoi-specific docs

---

## Final repo structure

```
~/dotfiles/
├── .chezmoi.toml.tmpl
├── .chezmoiignore
├── .gitignore
├── README.md
├── MIGRATION-PLAN.md
│
├── dot_gitconfig.tmpl                    → ~/.gitconfig
├── dot_gitignore_global                  → ~/.gitignore
├── modify_dot_zshrc                      → modifies ~/.zshrc
├── modify_dot_zprofile                   → modifies ~/.zprofile
│
├── private_dot_config/
│   ├── starship.toml                     → ~/.config/starship.toml
│   └── ghostty/
│       ├── config                        → ~/.config/ghostty/config
│       └── themes/
│           └── Alabaster Dark            → ~/.config/ghostty/themes/Alabaster Dark
│
├── private_dot_claude/
│   ├── symlink_standards.tmpl
│   ├── symlink_mcp.json.tmpl
│   ├── symlink_settings.json.tmpl
│   ├── skills/symlink_<name>.tmpl  (x5)
│   └── agents/symlink_<name>.tmpl  (x2)
│
├── run_once_before_00-migrate-from-symlinks.sh
├── run_once_before_01-install-homebrew.sh.tmpl
├── run_onchange_before_02-install-brew-packages.sh.tmpl
├── run_onchange_before_03-install-brew-cask.sh.tmpl
├── run_onchange_before_04-install-npm.sh.tmpl
├── run_once_before_05-install-mas.sh
├── run_once_before_06-setup-ssh.sh.tmpl
├── run_once_before_07-check-fonts.sh
├── run_after_10-iterm2-profile.sh.tmpl
├── run_onchange_after_20-macos-defaults.sh.tmpl      ← Phase 4
│
├── Brewfile_cli
├── Brewfile_cask
│
├── runcom/                               (sourced by modify_ wrappers)
│   ├── .zshrc
│   └── .zprofile
│
├── claude/                               (symlink targets)
│   ├── settings.json
│   ├── mcp.json
│   ├── ARCHITECTURE.md
│   ├── standards/
│   ├── skills/
│   └── agents/
│
├── config/iterm2/                        (copied conditionally)
│   └── Default.json
│
├── install.sh.legacy                     (kept for reference)
│
└── testing/                              ← Phase 5
    ├── tart-test.sh
    ├── tart-test-idempotent.sh
    ├── capture-defaults.sh
    └── UTM-TESTING.md
```

---

## Rollback strategy

1. All original files in git history — `git checkout` restores them
2. `chezmoi purge` removes all chezmoi state
3. `install.sh.legacy` can be restored and re-run

---

## Verification checklist

1. `chezmoi diff` — preview changes (dry run)
2. `chezmoi apply -v` — single run, no errors
3. `chezmoi apply -v` again — second run produces no changes (idempotent)
4. New shell: Starship prompt, autosuggestions, syntax highlighting, fzf
5. `readlink ~/.claude/standards` → `~/dotfiles/claude/standards`
6. `cat ~/.gitconfig` — contains correct name/email
7. Tart VM: `tart-test.sh` passes all checks
8. UTM VM: visual checklist confirms Dock, Finder, keyboard settings
