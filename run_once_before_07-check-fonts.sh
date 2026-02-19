#!/bin/bash
# Check for Berkeley Mono font installation.
# This is a purchased font — cannot be auto-installed.

set -euo pipefail

echo "Checking for Berkeley Mono font..."

FONT_FOUND=false

for dir in ~/Library/Fonts /Library/Fonts /System/Library/Fonts; do
  if ls "$dir"/BerkeleyMono* 2>/dev/null | grep -q . || \
     ls "$dir"/berkeley-mono* 2>/dev/null | grep -q . || \
     ls "$dir"/"Berkeley Mono"* 2>/dev/null | grep -q .; then
    FONT_FOUND=true
    break
  fi
done

if [ "$FONT_FOUND" = true ]; then
  echo "Berkeley Mono font found."
else
  echo "WARNING: Berkeley Mono not found."
  echo "Purchase at: https://berkeleygraphics.com/typefaces/berkeley-mono/"
  echo "Ghostty and iTerm2 will fall back to system monospace font."
fi
