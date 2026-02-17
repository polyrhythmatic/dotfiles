# Claude Code Multi-Agent Setup

## Design Decisions

### Content vs. Config Separation

The core insight: **standards are portable, tool wiring is not.**

- `claude/standards/` — Tool-agnostic markdown files containing engineering conventions. These are the real investment. If you switch from Claude Code to Codex, OpenCode, Cursor rules, etc., point the new tool at these files.
- `claude/skills/` — Claude Code-specific SKILL.md wrappers. Thin files that define role identity, frontmatter config, and `!cat` the portable standards in at invocation time.
- `claude/agents/` — Claude Code custom agent definitions (`.md` files). These run as isolated subagents with their own context windows.

### Skills vs. Agents

These are distinct Claude Code features:

| Feature | Purpose | Invocation | Context |
|---------|---------|-----------|---------|
| **Skills** | Reusable instructions/workflows | `/skill-name` or auto by Claude | Main conversation (unless `context: fork`) |
| **Agents** | Specialized isolated contexts | Task tool delegation | Isolated subagent context |

Skills define *what to do and how*. Agents provide *context isolation*. The orchestrator skill teaches Claude how to dispatch work to subagents using the Task tool.

### No Skill Inheritance

Claude Code skills can't directly include other skills. The workaround is shell preprocessing: `!cat ~/.claude/standards/file.md` injects file contents into the skill at invocation time. This is why `install.sh` symlinks `standards/` into `~/.claude/standards` — so the `!cat` paths resolve correctly.

## Directory Structure

```
dotfiles/claude/
  standards/                          # Portable, tool-agnostic
    svelte-conventions.md             #   Svelte 5 runes, SvelteKit patterns
    styling-conventions.md            #   Tailwind, cn(), design tokens
    code-quality.md                   #   TypeScript, formatting, naming
    review-checklist.md               #   Structured review checklist
  skills/                             # Claude Code-specific wrappers
    team-standards/SKILL.md           #   Auto-loaded, not user-invocable
    frontend-engineer/SKILL.md        #   /frontend-engineer
    design-reviewer/SKILL.md          #   /design-reviewer
    dev-reviewer/SKILL.md             #   /dev-reviewer
    orchestrator/SKILL.md             #   /orchestrator
  agents/                             # Claude Code custom agents
    figma-design-qa.md                #   Figma vs implementation comparison
    design-system-component.md        #   Build components from Figma specs
```

## How It Gets Installed

`install.sh` creates symlinks:

```
~/.claude/standards  ->  dotfiles/claude/standards/
~/.claude/skills/*   ->  dotfiles/claude/skills/*/     (per-directory)
~/.claude/agents/*.md -> dotfiles/claude/agents/*.md   (per-file)
```

Per-file/per-directory linking preserves any project-specific or non-dotfiles skills/agents that might exist in `~/.claude/`.

## Available Skills

| Skill | Slash Command | Description |
|-------|---------------|-------------|
| team-standards | *(auto only)* | Shared conventions, loaded contextually by Claude |
| frontend-engineer | `/frontend-engineer` | Build components, pages, features |
| design-reviewer | `/design-reviewer` | Compare implementation to Figma design |
| dev-reviewer | `/dev-reviewer` | Code review with severity levels |
| orchestrator | `/orchestrator` | Decompose complex tasks, dispatch to agents |

## Adding a New Skill

1. Create `dotfiles/claude/skills/<name>/SKILL.md`
2. Add frontmatter (name, description, any flags)
3. Pull in standards with `!cat ~/.claude/standards/<file>.md`
4. Add role-specific instructions
5. Re-run the symlink block from `install.sh` (or just `ln -sfv` the new directory)

## Adding a New Standard

1. Create `dotfiles/claude/standards/<name>.md` — plain markdown, no Claude Code syntax
2. Reference it from any skills that need it via `!cat ~/.claude/standards/<name>.md`

## Project-Specific vs. Global

- **Global** (this repo): Engineering conventions, role definitions, general-purpose agents
- **Project-level** (e.g., Axiom's `.claude/` and `CLAUDE.md`): Domain-specific context, repo structure, package names, API patterns, deployment details

Project-level config should reference global standards where possible, not duplicate them.
