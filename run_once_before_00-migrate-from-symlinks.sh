#!/bin/bash
# One-time migration: remove old symlinks so chezmoi can create real files/dirs.
# Safe to run even if symlinks don't exist.

set -euo pipefail

echo "Migrating from old symlink-based dotfiles setup..."

remove_if_symlink() {
  if [ -L "$1" ]; then
    echo "  Removing symlink: $1"
    rm "$1"
  fi
}

# Git config files (were symlinked by old install.sh)
remove_if_symlink "$HOME/.gitconfig"
remove_if_symlink "$HOME/.gitignore"

# Ghostty config (was symlinked)
remove_if_symlink "$HOME/.config/ghostty/config"
remove_if_symlink "$HOME/.config/ghostty/themes/Alabaster Dark"

# Starship config (was symlinked)
remove_if_symlink "$HOME/.config/starship.toml"

# Claude Code symlinks (individual files/dirs)
remove_if_symlink "$HOME/.claude/standards"
remove_if_symlink "$HOME/.claude/mcp.json"
remove_if_symlink "$HOME/.claude/settings.json"

# Claude skill directories
for skill_dir in "$HOME/.claude/skills"/*/; do
  [ -L "${skill_dir%/}" ] && remove_if_symlink "${skill_dir%/}"
done

# Claude agent files
for agent_file in "$HOME/.claude/agents"/*.md; do
  [ -L "$agent_file" ] && remove_if_symlink "$agent_file"
done

echo "Symlink migration complete."
