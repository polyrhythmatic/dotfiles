#!/bin/bash
# Launch AppCleaner once so its SmartDelete Agent initializes and macOS
# surfaces any Accessibility/Automation permission prompts. The SmartDelete
# preference is set by run_onchange_after_20-macos-defaults.sh.tmpl, but the
# agent only spins up after the app has been opened at least once.
#
# Runs once per machine. Safe to re-run — `open -a` is a no-op if the app
# is already running.

set -euo pipefail

if [ ! -d "/Applications/AppCleaner.app" ]; then
	echo "AppCleaner not installed — skipping launch."
	exit 0
fi

echo "Launching AppCleaner to initialize SmartDelete Agent..."
echo "Approve any permission prompts macOS shows (Accessibility / Automation)."
open -a AppCleaner
