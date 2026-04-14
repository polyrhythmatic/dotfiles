#!/bin/bash
# Install Claude Code via native installer (auto-updates).
# See: https://docs.anthropic.com/en/docs/claude-code/setup

set -euo pipefail

if command -v claude &>/dev/null; then
  echo "Claude Code already installed: $(claude --version)"
  exit 0
fi

echo "Installing Claude Code (native)..."
curl -fsSL https://claude.ai/install.sh | bash

echo "Claude Code installed."
