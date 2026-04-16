# Dotfiles

Managed by chezmoi. Source files in this repo are applied to `~`.

## chezmoi ignores dot-prefixed directories in the source

By design, chezmoi skips all `.`-prefixed files and directories in the source tree (except `.chezmoi*` files). A `.foo/` in this repo is invisible to chezmoi — it won't conflict with a `private_dot_foo/` that targets `~/.foo/`. Use `.gitignore` to keep tool-generated dot-directories out of git; never use `.chezmoiignore` for this, since that matches *target* paths and would block the corresponding `private_dot_*` entry from deploying.

## Don't commit tool-managed blocks

External tools may append blocks directly to `~/.zshrc`. These are owned by those tools, not this repo. Don't pull them into `runcom/.zshrc` — expect divergence when diffing. Ask the user if unsure whether a block should be included.
