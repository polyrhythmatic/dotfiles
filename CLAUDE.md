# Dotfiles

Managed by chezmoi. Source files in this repo are applied to `~`.

## Don't commit tool-managed blocks

External tools may append blocks directly to `~/.zshrc`. These are owned by those tools, not this repo. Don't pull them into `runcom/.zshrc` — expect divergence when diffing. Ask the user if unsure whether a block should be included.
