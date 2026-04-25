#!/bin/bash
# Merge editor preferences into VSCode, Cursor, and Zed settings files.
#
# These apps own their settings.json (they rewrite it whenever you change
# things in the UI), so we deep-merge our keys in via jq instead of tracking
# the file directly. Re-runs whenever this script's content changes.

set -euo pipefail

if ! command -v jq >/dev/null 2>&1; then
  echo "jq not found — skipping editor settings merge." >&2
  exit 0
fi

merge_into() {
  local file="$1" payload="$2"
  mkdir -p "$(dirname "$file")"

  if [[ -s "$file" ]]; then
    if ! jq -e . "$file" >/dev/null 2>&1; then
      echo "Skipping $file: not valid JSON (likely contains // comments). Merge our keys in by hand." >&2
      return 0
    fi
    local tmp
    tmp=$(mktemp)
    jq --argjson p "$payload" '. * $p' "$file" > "$tmp" && mv "$tmp" "$file"
  else
    echo "$payload" | jq . > "$file"
  fi
  echo "Updated $file"
}

# VSCode + Cursor: open .svg with the text editor instead of the image preview.
# (Right-click → Reopen With… → Image Preview still works for one-off renders.)
VSCODE_PAYLOAD='{"workbench.editorAssociations":{"*.svg":"default"}}'
merge_into "$HOME/Library/Application Support/Code/User/settings.json"   "$VSCODE_PAYLOAD"
merge_into "$HOME/Library/Application Support/Cursor/User/settings.json" "$VSCODE_PAYLOAD"

# Zed: opens SVG as text by default (no image preview), but pin the language
# association to XML for syntax highlighting.
ZED_PAYLOAD='{"file_types":{"XML":["svg"]}}'
merge_into "$HOME/.config/zed/settings.json" "$ZED_PAYLOAD"
