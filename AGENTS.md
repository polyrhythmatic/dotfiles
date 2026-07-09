# Dotfiles

Managed by chezmoi. Source files in this repo are applied to `~`.

## Use the dotfiles CLI for repo operations

Prefer the `dotfiles` wrapper instead of running raw `chezmoi`, `rulesync`,
Homebrew, or git commands from arbitrary directories. It resolves the chezmoi
source path, prints compact status summaries, and has explicit non-interactive
write flags for agents.

The command list lives in `README.md`. Do not answer interactive prompts on
behalf of the user. In non-interactive agent runs, commands that write should
use `--yes` or `--apply`; otherwise the CLI should refuse to proceed.

## chezmoi ignores dot-prefixed directories in the source

By design, chezmoi skips all `.`-prefixed files and directories in the source
tree (except `.chezmoi*` files). A `.foo/` in this repo is invisible to chezmoi
and won't conflict with a `private_dot_foo/` that targets `~/.foo/`. Use
`.gitignore` to keep tool-generated dot-directories out of git; never use
`.chezmoiignore` for this, since that matches target paths and would block the
corresponding `private_dot_*` entry from deploying.

## Don't commit tool-managed blocks

External tools may append blocks directly to `~/.zshrc`. These are owned by
those tools, not this repo. Don't pull them into `runcom/.zshrc`; expect
divergence when diffing. Ask the user if unsure whether a block should be
included.
