#!/bin/zsh

# Capture macOS defaults for auditing
# Run before and after the macos defaults script to see what changed.
#
# Usage:
#   ./testing/capture-defaults.sh before    # saves to /tmp/defaults-before/
#   # ... run macos defaults script ...
#   ./testing/capture-defaults.sh after     # saves to /tmp/defaults-after/
#   ./testing/capture-defaults.sh diff      # shows differences

set -euo pipefail

DOMAINS=(
  NSGlobalDomain
  com.apple.finder
  com.apple.dock
  com.apple.Safari
  com.apple.mail
  com.apple.terminal
  com.apple.Terminal
  com.apple.screencapture
  com.apple.screensaver
  com.apple.ActivityMonitor
  com.apple.TextEdit
  com.apple.DiskUtility
  com.apple.QuickTimePlayerX
  com.apple.SoftwareUpdate
  com.apple.commerce
  com.apple.TimeMachine
  com.apple.print.PrintingPrefs
  com.apple.LaunchServices
  com.apple.desktopservices
  com.apple.NetworkBrowser
  com.apple.ImageCapture
  com.apple.messageshelper.MessageController
  com.apple.helpviewer
  com.apple.driver.AppleBluetoothMultitouch.trackpad
  com.apple.frameworks.diskimages
  com.apple.appstore
)

ACTION="${1:-}"

case "$ACTION" in
  before|after)
    OUTDIR="/tmp/defaults-${ACTION}"
    mkdir -p "$OUTDIR"
    echo "Capturing defaults to $OUTDIR..."
    for domain in "${DOMAINS[@]}"; do
      defaults read "$domain" > "$OUTDIR/${domain}.plist" 2>/dev/null || true
    done
    echo "Done. Captured ${#DOMAINS[@]} domains."
    ;;

  diff)
    if [[ ! -d /tmp/defaults-before ]] || [[ ! -d /tmp/defaults-after ]]; then
      echo "Error: Run 'capture-defaults.sh before' and 'capture-defaults.sh after' first."
      exit 1
    fi
    echo "=== Defaults Changes ==="
    echo ""
    for domain in "${DOMAINS[@]}"; do
      BEFORE="/tmp/defaults-before/${domain}.plist"
      AFTER="/tmp/defaults-after/${domain}.plist"
      if [[ -f "$BEFORE" ]] && [[ -f "$AFTER" ]]; then
        CHANGES=$(diff "$BEFORE" "$AFTER" 2>/dev/null || true)
        if [[ -n "$CHANGES" ]]; then
          echo "--- $domain ---"
          echo "$CHANGES"
          echo ""
        fi
      elif [[ -f "$AFTER" ]] && [[ ! -f "$BEFORE" ]]; then
        echo "--- $domain (new) ---"
        echo ""
      fi
    done
    ;;

  *)
    echo "Usage: $0 {before|after|diff}"
    echo ""
    echo "  before  - Capture current defaults (run before macos script)"
    echo "  after   - Capture current defaults (run after macos script)"
    echo "  diff    - Show differences between before and after"
    exit 1
    ;;
esac
