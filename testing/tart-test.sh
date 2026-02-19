#!/bin/zsh

# Automated headless testing of dotfiles via Tart VM
# Prerequisites: brew install tart
#
# Usage: ./testing/tart-test.sh [--keep]
#   --keep: Don't delete the VM after testing (useful for debugging)

set -euo pipefail

VM_NAME="dotfiles-test-$(date +%s)"
BASE_IMAGE="ghcr.io/cirruslabs/macos-sequoia-base:latest"
KEEP_VM=false
REPO_URL="https://github.com/sethkranzler/dotfiles.git"

if [[ "${1:-}" == "--keep" ]]; then
  KEEP_VM=true
fi

cleanup() {
  if [[ "$KEEP_VM" == false ]]; then
    echo "Cleaning up VM: $VM_NAME"
    tart stop "$VM_NAME" 2>/dev/null || true
    tart delete "$VM_NAME" 2>/dev/null || true
  else
    echo "Keeping VM: $VM_NAME (use 'tart delete $VM_NAME' to remove)"
  fi
}
trap cleanup EXIT

echo "=== Dotfiles Tart VM Test ==="
echo ""

# Clone base image
echo "[1/5] Cloning base image..."
tart clone "$BASE_IMAGE" "$VM_NAME"

# Boot VM and wait for SSH
echo "[2/5] Booting VM (waiting for SSH)..."
tart run "$VM_NAME" --no-graphics &
VM_PID=$!

# Wait for VM to become reachable via SSH
echo "  Waiting for SSH to become available..."
for i in $(seq 1 60); do
  if tart ip "$VM_NAME" 2>/dev/null; then
    break
  fi
  sleep 5
done

VM_IP=$(tart ip "$VM_NAME" 2>/dev/null)
if [[ -z "$VM_IP" ]]; then
  echo "FAIL: Could not get VM IP after 5 minutes"
  exit 1
fi

SSH_CMD="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null admin@$VM_IP"

# Wait for SSH to actually accept connections
for i in $(seq 1 30); do
  if $SSH_CMD "echo ok" 2>/dev/null; then
    break
  fi
  sleep 2
done

# Install chezmoi and apply dotfiles
echo "[3/5] Installing chezmoi and applying dotfiles..."
$SSH_CMD "sh -c \"\$(curl -fsLS get.chezmoi.io)\" -- init --apply sethkranzler"

# Run verification checks
echo "[4/5] Running verification checks..."
echo ""

PASS=0
FAIL=0

check() {
  local desc="$1"
  local cmd="$2"
  if $SSH_CMD "$cmd" 2>/dev/null; then
    echo "  PASS: $desc"
    PASS=$((PASS + 1))
  else
    echo "  FAIL: $desc"
    FAIL=$((FAIL + 1))
  fi
}

# File existence checks
check "~/.gitconfig exists" "test -f ~/.gitconfig"
check "~/.config/starship.toml exists" "test -f ~/.config/starship.toml"
check "~/.config/ghostty/config exists" "test -f ~/.config/ghostty/config"
check "~/.zshrc exists" "test -f ~/.zshrc"
check "~/.zprofile exists" "test -f ~/.zprofile"

# Symlink checks
check "~/.claude/standards is a symlink" "test -L ~/.claude/standards"
check "~/.claude/mcp.json is a symlink" "test -L ~/.claude/mcp.json"
check "~/.claude/settings.json is a symlink" "test -L ~/.claude/settings.json"

# Content checks
check "~/.gitconfig contains [user] section" "grep -q '\\[user\\]' ~/.gitconfig"
check "~/.zshrc contains managed section" "grep -q 'CHEZMOI MANAGED' ~/.zshrc"
check "~/.zprofile contains managed section" "grep -q 'CHEZMOI MANAGED' ~/.zprofile"

# Command availability checks
check "chezmoi is available" "command -v chezmoi"
check "starship is available" "command -v starship"
check "fnm is available" "command -v fnm"
check "fzf is available" "command -v fzf"

# Report
echo ""
echo "[5/5] Results: $PASS passed, $FAIL failed"

if [[ $FAIL -gt 0 ]]; then
  echo "SOME CHECKS FAILED"
  exit 1
else
  echo "ALL CHECKS PASSED"
  exit 0
fi
