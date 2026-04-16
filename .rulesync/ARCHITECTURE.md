# AI Agent Config

## rulesync Owns Everything It Can

**rulesync** (`.rulesync/`) is the source of truth for all agent config it can manage: skills, subagents, MCP servers, permissions, hooks. `rulesync generate --global` writes to each tool's expected paths. Targets are configured in `rulesync.jsonc`.

External skills (agent-browser, chrome-devtools, playwright-cli, google workspace, difit, etc.) are declared as `sources` in `rulesync.jsonc` and installed via `rulesync install`. No `npx skills add` or `playwright-cli install --skills` needed.

Project-specific config (coding standards, project-aware skills) lives in those projects' own `.rulesync/` or `CLAUDE.md`, not here.

## chezmoi Handles the Rest

`~/.claude/settings.json` (model, env vars, effort level) is the one thing rulesync can't manage. chezmoi deploys it as a real file via `private_dot_claude/modify_settings.json` — a merge script that preserves any keys Claude Code or rulesync added (permissions, hooks, etc.) while keeping the base settings authoritative.

Real file deployment avoids the symlink performance bug (anthropics/claude-code#3575).

## chezmoi Apply Flow

1. chezmoi merges `~/.claude/settings.json`
2. `run_after_15-rulesync-generate.sh.tmpl` runs `rulesync install && rulesync generate --global`

`.rulesync/` is invisible to chezmoi (dot-prefixed). `rulesync.jsonc` is in `.chezmoiignore`.

## Adding Things

- **Shared skill**: `.rulesync/skills/<name>/SKILL.md`
- **Tool-specific skill**: `.rulesync/skills/<name>/SKILL.md` with `targets: ["claudecode"]`
- **Skill from GitHub**: add to `sources` in `rulesync.jsonc`, then `rulesync install`
