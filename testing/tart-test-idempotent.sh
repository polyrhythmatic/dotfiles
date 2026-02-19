#!/bin/zsh

# Idempotency verification for chezmoi dotfiles via Tart VM
# Runs chezmoi apply twice and verifies the second run produces no changes.
#
# Prerequisites: brew install tart
# Usage: ./testing/tart-test-idempotent.sh

set -euo pipefail

VM_NAME="dotfiles-idempotent-$(date +%s)"
BASE_IMAGE="ghcr.io/cirruslabs/macos-sequoia-base:latest"
REPO_URL="https://github.com/sethkranzler/dotfiles.git"

cleanup() {
  echo "Cleaning up VM: $VM_NAME"
  tart stop "$VM_NAME" 2>/dev/null || true
  tart delete "$VM_NAME" 2>/dev/null || true
}
trap cleanup EXIT

echo "=== Dotfiles Idempotency Test ==="
echo ""

# Clone base image
echo "[1/4] Cloning base image..."
tart clone "$BASE_IMAGE" "$VM_NAME"

# Boot VM and wait for SSH
echo "[2/4] Booting VM (waiting for SSH)..."
tart run "$VM_NAME" --no-graphics &
VM_PID=$!

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

for i in $(seq 1 30); do
  if $SSH_CMD "echo ok" 2>/dev/null; then
    break
  fi
  sleep 2
done

# First apply
echo "[3/4] First apply: chezmoi init --apply..."
$SSH_CMD "sh -c \"\$(curl -fsLS get.chezmoi.io)\" -- init --apply sethkranzler"

# Second apply — capture diff
echo "[4/4] Second apply: checking for changes..."
DIFF_OUTPUT=$($SSH_CMD "chezmoi diff" 2>&1)

if [[ -z "$DIFF_OUTPUT" ]]; then
  echo ""
  echo "PASS: Second apply produced no changes (idempotent)"
  exit 0
else
  echo ""
  echo "FAIL: Second apply produced changes:"
  echo "$DIFF_OUTPUT"
  exit 1
fi
