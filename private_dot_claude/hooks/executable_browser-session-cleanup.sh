#!/bin/bash
# SessionEnd hook: dispose of the agent-browser session THIS Claude Code
# session opened, and nothing else.
#
# runcom/.zshrc sets AGENT_BROWSER_SESSION="cc-<first8 of session id>" for
# every shell under Claude Code, so all of this session's agent-browser
# work lands in that one named session. Closing it here therefore never
# touches pre-existing, explicitly-named (e.g. noon-prod), or concurrent
# Claude sessions' browsers — those carry different names and never match.
#
# Fails open: any error, missing binary, or unparsable input is swallowed.

command -v agent-browser >/dev/null 2>&1 || exit 0

HOOK_INPUT="$(cat)" python3 <<'PYEOF' 2>/dev/null || exit 0
import json, os, re, subprocess, sys

try:
    data = json.loads(os.environ.get("HOOK_INPUT", ""))
    # Mirror runcom/.zshrc: first 8 chars of the session id, alnum only.
    token = re.sub(r"[^A-Za-z0-9]", "", str(data.get("session_id", ""))[:8])
except Exception:
    sys.exit(0)

if not token:
    sys.exit(0)

try:
    subprocess.run(
        ["agent-browser", "--session", f"cc-{token}", "close"],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        timeout=15,
    )
except Exception:
    pass
sys.exit(0)
PYEOF
