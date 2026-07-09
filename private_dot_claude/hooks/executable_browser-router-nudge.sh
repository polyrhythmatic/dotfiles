#!/bin/bash
# PreToolUse hook (Bash matcher): one nudge per session to load the
# browser-tool-router skill before driving a browser from raw bash.
# Fails open — any error lets the tool call through untouched.

# Read stdin before the heredoc steals it.
HOOK_INPUT="$(cat)" python3 <<'PYEOF' 2>/dev/null || exit 0
import json, os, re, sys

try:
    data = json.loads(os.environ.get("HOOK_INPUT", ""))
    cmd = data.get("tool_input", {}).get("command", "") or ""
    session = re.sub(r"[^A-Za-z0-9-]", "", str(data.get("session_id", ""))) or "nosession"
except Exception:
    sys.exit(0)

# Real invocation patterns only — audits showed naive substring matching
# over-fires on find/grep commands that merely mention browser tooling
# (e.g. excluding a .playwright-cli/ directory).
PATTERNS = [
    r"(?<!\.)\bplaywright-cli\b",   # the CLI, not the .playwright-cli dir
    r"\bnpx\s+playwright\b",
    r"\b(npm|pnpm|yarn|bun)\s+(add|install|i)\b.*\bplaywright",
    r"\b(chromium|firefox|webkit)\.launch\b",
    r"\bpuppeteer\b",
    r"--remote-debugging-port",
    r"\bchrome-devtools-cli\b",
    r"\bagent-browser\b",
    r"osascript.*tell\s+app(lication)?\s+\"(Google Chrome|Chromium|Safari|Arc|Brave Browser)\"",
]

if not any(re.search(p, cmd) for p in PATTERNS):
    sys.exit(0)

sentinel = os.path.join(
    os.environ.get("TMPDIR", "/tmp"),
    f"claude-browser-router-nudge-{session}",
)
if os.path.exists(sentinel):
    sys.exit(0)
try:
    open(sentinel, "w").close()
except Exception:
    sys.exit(0)

print(json.dumps({
    "hookSpecificOutput": {
        "hookEventName": "PreToolUse",
        "permissionDecision": "deny",
        "permissionDecisionReason": (
            "browser-tool-router: this looks like browser automation. Load the "
            "browser-tool-router skill first (Skill tool) to pick the mechanism and "
            "operational config (write roots, dev-server port, session naming, "
            "headed/headless, bot-wall/auth gating). If you have already routed, "
            "just re-run this exact command — this reminder fires once per session."
        ),
    }
}))
sys.exit(0)
PYEOF
