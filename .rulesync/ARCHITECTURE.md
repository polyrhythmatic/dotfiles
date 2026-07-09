# AI Agent Config

## rulesync Owns Everything It Can

**rulesync** (`.rulesync/`) is the source of truth for all agent config it can manage: skills, subagents, MCP servers, permissions, hooks. `rulesync generate --global` writes to each tool's expected paths. Targets are configured in `rulesync.jsonc`.

External skills (agent-browser, chrome-devtools, playwright-cli, google workspace, difit, etc.) are declared as `sources` in `rulesync.jsonc` and pinned in `rulesync.lock`. Normal setup uses `rulesync install --frozen` so machines use the git-tracked lockfile. Deliberate external-source updates use `rulesync install --update`, followed by reviewing and committing the lockfile diff.

No `npx skills add` or `playwright-cli install --skills` needed.

Project-specific config (coding standards, project-aware skills) lives in those projects' own `.rulesync/`, `AGENTS.md`, or `CLAUDE.md`, not here.

## chezmoi Handles the Rest

`~/.claude/settings.json` (model, env vars, effort level) is the one thing rulesync can't manage. chezmoi deploys it as a real file via `private_dot_claude/modify_settings.json` — a merge script that preserves any keys Claude Code or rulesync added (permissions, hooks, etc.) while keeping the base settings authoritative.

Real file deployment avoids the symlink performance bug (anthropics/claude-code#3575).

## chezmoi Apply Flow

1. chezmoi merges `~/.claude/settings.json`
2. `run_after_12-ensure-brew-packages.sh.tmpl` checks `Brewfile_cli` with `brew bundle check --no-upgrade` and repairs missing packages without upgrading installed packages
3. `run_after_15-rulesync-generate.sh.tmpl` runs `rulesync install --frozen`, verifies the curated skill cache against `rulesync.lock`, then runs `rulesync generate --global`

`.rulesync/` is invisible to chezmoi (dot-prefixed). `rulesync.jsonc` and `rulesync.lock` are in `.chezmoiignore`.

The ignored `.rulesync/skills/.curated/` directory is a fetched cache, not source. It is regenerated from `rulesync.lock`.

The repo-local `AGENTS.md` is canonical for agents working in this repository. `CLAUDE.md` is a compatibility shim containing `@AGENTS.md`. Both are in `.chezmoiignore` so they do not become `~/AGENTS.md` or `~/CLAUDE.md`.

## Operational CLI

Use the `dotfiles` wrapper for normal operations from any directory:

- `dotfiles doctor`
- `dotfiles preview`
- `dotfiles sync-ai --dry-run`
- `dotfiles sync-ai --apply`
- `dotfiles brew check`

The wrapper keeps output compact, backs up existing rulesync targets before writing, and refuses non-interactive writes unless the command uses `--yes` or `--apply`.

`dotfiles sync-ai --dry-run` may fetch locked external rulesync sources into `.rulesync/skills/.curated/`, but it does not write global Claude, Codex, Cursor, Warp, or Gemini files.

## Adding Things

- **Shared skill**: `.rulesync/skills/<name>/SKILL.md`
- **Tool-specific skill**: `.rulesync/skills/<name>/SKILL.md` with `targets: ["claudecode"]`
- **Skill from GitHub**: add to `sources` in `rulesync.jsonc`, run `rulesync install --update`, review `rulesync.lock`, then commit both files
