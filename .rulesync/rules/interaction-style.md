---
root: true
targets: ["*"]
description: "Personal interaction preferences"
globs: ["**/*"]
---

# Interaction Style

When presenting options or choices for me to respond to, label them numerically or alphabetically so I can reply with just the label. Keep each option clear, concise, and focused — don't omit information, but don't be overly verbose.

# Dotfiles Operations

When operating Seth's dotfiles from any directory, prefer the `dotfiles` CLI
over raw `chezmoi`, `rulesync`, Homebrew, or git commands. It resolves the
chezmoi source path and prints compact summaries.

Use status and preview commands first:

```bash
dotfiles doctor
dotfiles status
dotfiles preview
dotfiles sync-ai --dry-run
dotfiles brew check
```

Only write when explicitly asked, and use non-interactive flags:

```bash
dotfiles apply --yes
dotfiles sync-ai --apply
dotfiles brew install --yes
dotfiles pull-apply --yes
```

Do not answer interactive prompts on behalf of the user. If a command would
write files and lacks `--yes` or `--apply`, stop and ask for confirmation.

`dotfiles sync-ai --dry-run` may fetch locked external rulesync sources into the
ignored rulesync cache, but it must not write global Claude, Codex, Cursor,
Warp, or Gemini files. Use `dotfiles sync-ai --apply` only when the user has
approved writing generated global agent config.

# Browser Tool Routing

For anything browser-ish — automation, web app QA, screenshots, forms,
login/auth-gated sites, bot walls, scraping, file downloads, Chrome debugging,
profiling, or browser MCP work — load the `browser-tool-router` skill before
picking a browser tool or hand-writing a browser script. It routes on four
gating factors (needs a browser at all? bot-walled? needs the user's logged-in
identity? attended?) and emits an operational config bundle (write roots,
dev-server port, session naming, headed/headless), not just a tool name.
Choose one mechanism before loading tool-specific skills; prefer CLI browser
tools over MCP when the CLI can complete the task (`chrome-devtools` MCP is a
last resort).
