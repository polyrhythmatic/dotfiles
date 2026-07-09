# Real-browser playbook — bot walls, logins, and the user's own browser

You are here because a gating factor fired: the target is bot-walled, or it
needs the user's authenticated identity, or an automated-launched browser
already failed. Here mechanism choice matters more than configuration.

## Facts that decide the mechanism

- **Bot walls fingerprint automation, not visibility.** Headless, headed, and
  `--persistent` launched browsers all fail Cloudflare/Akamai identically.
  Re-launching "but headed this time" is a wasted rung.
- **CDP-attach beats fingerprinting but not authentication.** Attaching to a
  separately launched real Chrome passes bot walls (real-Chrome signature), but
  **since Chrome 136 the remote-debug port is ignored on the default profile** —
  you get a fresh, login-less profile, not the user's session.
- **Only the user's actual, already-logged-in browser** both clears bot walls
  and carries their identity. Two ways to drive it: the `claude-in-chrome` MCP
  extension (attended) and AppleScript (unattended-capable).
- **File-upload widgets on anti-automation sites** may only accept a real native
  file-chooser gesture — scripted workarounds reliably fail. Hand that step to
  the human.

## Choosing the mechanism

| Situation | Mechanism |
|---|---|
| Auth needed, but a *dedicated persistent profile* would do (log in once, reuse across sessions); Electron/Slack; remote CDP/cloud browsers | **`agent-browser`** (load its skill). Reach for it before hand-rolling CDP scripts. |
| Bot-walled or needs the user's default-profile session, **human present** | **`claude-in-chrome` MCP** (visible Chrome via extension), where connected. Hand login/CAPTCHA/final-submit to the human in the same window. |
| Bot-walled or needs the user's session, **human not reliably present**, user's browser is logged in | **AppleScript → real Chrome/Safari** (`osascript`). The only unattended mechanism that rides the real session. Still pause for CAPTCHAs and consequential submits. |
| Bot-walled only (no identity needed), unattended | CDP-attach to a user-launched real Chrome (non-default profile) — human can solve a CAPTCHA in-window once. |

## claude-in-chrome MCP — tool reliability hierarchy

Order for any fresh page: `read_page(filter:"interactive")` → `find` the target
→ act by ref → `screenshot` to verify.

- **Locator preference:** `find` > ref-click > coordinate-click — *except* when
  a ref-click reports success but the page doesn't advance (JS handler didn't
  fire): drop to coordinate-click.
- **Refs die after `navigate`** — always re-`read_page` first.
- **`form_input` is unsafe on reactive forms**: it updates the a11y tree but not
  the live DOM, so dependent fields never reveal. Re-verify with a screenshot or
  re-read after every fill.
- **`get_page_text` mis-selects DOM on legacy table-layout pages** and returns
  labels, not input values. If it returns junk, don't retry it — switch to
  screenshot + `find`.
- **Identical error after two different input methods = business-rule
  rejection**, not an automation bug. Read the error text; don't try a third
  input mechanism.
- **JS-popup links** (tooltip / `window.open` instead of navigation): stop
  clicking; read the `href` via `read_page` and `navigate` directly.
- **Expect extension disconnects** (cold start and mid-session). Checkpoint
  progress externally (e.g. a commit or note after each irreversible success) so
  a drop doesn't lose work.
- Use `browser_batch` for any repeatable multi-step sequence — a large
  efficiency win.

## AppleScript against the real browser — working patterns

- **Prerequisite:** the browser's "Allow JavaScript from Apple Events" toggle
  must be enabled manually by the user — the agent cannot flip or reliably query
  it. Ask once, up front.
- **No wait-for-selector exists.** Poll `document.readyState`/target-element
  presence via injected JS with growing delays.
- **Tab targeting:** `active tab of front window` grabs whatever the user last
  focused. Find the tab by URL match instead, and re-resolve it before each
  action batch.
- **No structured page-read or screenshot** → silent form bugs are the
  signature failure. Verify every fill/submit by reading back concrete DOM state
  (values, confirmation text) via injected JS; for anything consequential, ask
  the human to eyeball it.
- **Native download dialogs block scripted saves** — use cookie+curl below.

## Authenticated binary downloads (any real-browser mechanism)

Let the browser establish the session, then get the file *outside* it:
extract the session cookie (e.g. `playwright-cli cookie-list`, or via injected
JS) and `curl -H 'Cookie: …' -o` the artifact. Piping base64 through the CLI
truncates; in-page `fs.writeFileSync` is sandboxed and fails.

## Hard boundaries (restated from the router)

Credential entry, CAPTCHA, account creation, consequential Submit, and any
SSN/financial step belong to the human — an open debug port during such steps is
itself a risk. Silent failures are endemic in every mechanism on this page:
verify each state-changing action independently, and treat "reported success
but state unchanged" as failure. Record what worked per domain in
`<repo>/.claude/browser-domains.md`.
