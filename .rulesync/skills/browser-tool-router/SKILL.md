---
name: browser-tool-router
description: Route any browser-ish task to the right mechanism AND the right operational config before touching a browser tool. Use whenever a task involves browser automation, web app QA, screenshots, forms, clicking or filling pages, login or auth-gated sites, bot walls (Cloudflare/Akamai/CAPTCHA), scraping or reading web pages, file downloads from websites, web profiling, Lighthouse, Core Web Vitals, console or network debugging, Electron or Slack automation, existing browser profiles, AppleScript browser control, remote CDP, cloud browsers, or a failed WebFetch/curl. Also use when about to hand-write a Playwright/puppeteer script or drive a browser from raw bash.
---

# Browser Tool Router

Two principles govern browser-tool choice:

1. **Most failures are configuration, not tool choice.** A routing decision must
   emit a *mechanism + config bundle*, not just a tool name.
2. **When the open web pushes back (bot walls, logins), mechanism choice is
   everything** — a wrong rung burns entire failure sequences.

Work through the steps below in order. Load a reference playbook only for the
route you actually take.

## Step 0 — Read repo memory first

If `<repo>/.claude/browser-domains.md` exists, read it before routing. It records
per-domain/per-target outcomes from prior sessions so you can skip known-doomed
mechanisms. After any notable success or failure against a domain or local target,
append one line:

```
- <domain-or-target>: <YYYY-MM-DD> <mechanism> <worked|failed> — <one-line why>
```

Examples of the *kind* of note (do not copy these literally):
`- example-portal.gov: 2026-07-01 playwright-cli failed — Akamai wall; AppleScript real-Chrome worked`
`- localhost dev: 2026-07-01 — multiple worktree servers; pin port via lsof before goto`

If not in a git repo, skip this step.

## Step 1 — Four gating factors (in order)

1. **Does this need a browser at all?** Only if the content is JS-rendered, the
   flow is interactive/multi-step, a session/token gates it, a visual or binary
   artifact is required, or a fetch *provably* failed for a browser-fixable
   reason. Otherwise stay in the no-browser tier (see `references/fetch-ladder.md`).
   Never route to a browser because the task text merely *mentions* browser tools
   or URLs — route on task shape (live/computed/interactive DOM needed?), not
   keywords.
2. **Is the target bot-walled?** Symptoms: "Just a moment…", "Access Denied",
   `errors.edgesuite.net`, 403 on a spoofed-UA curl, Turnstile/CAPTCHA.
   Cloudflare/Akamai fingerprint *automation, not visibility*: headless, headed,
   and `--persistent` launched browsers all fail identically. If yes →
   `references/real-browser.md`.
3. **Does it need the user's authenticated identity?** (Login-gated portal, "use
   my account", existing cookies/profile.) A fresh automated browser cannot
   satisfy this, and since Chrome 136 CDP-attach to the default profile yields a
   fresh login-less profile. If yes → `references/real-browser.md`.
4. **Attended or unattended?** A human present can hand-solve logins/CAPTCHAs in
   a visible browser; unattended runs need mechanisms that don't require one.

## Step 2 — Route table

| Route | When | First moves (config bundle) | Playbook |
|---|---|---|---|
| **No-browser**: WebFetch / curl / official API / CLI (e.g. `gws` for email) | Static or server-rendered content, docs, public repo files, documented APIs, email | Cheapest rung; know its three dead ends and the escalation ladder before retry-looping | `references/fetch-ladder.md` |
| **`playwright-cli`** (load its skill) | Visual/interaction QA on local dev servers or previews: screenshots, clicking, filling, verifying a fix looks right | **Pre-flight before first `goto`:** pin the dev-server port; named short session (`-s qa-$$`); `--headed --persistent` if a human must see or log in; screenshots only under `<repo>/.playwright-cli/` | `references/playwright-cli-ops.md` |
| **`chrome-devtools-cli`** (load its skill) | Chrome diagnostics: perf traces, LCP/CWV, console errors, network inspection, throttling | `--help` before unfamiliar subcommands (strict enum casing); `performance_start_trace` for perf (Lighthouse excludes it); `/tmp` writes are fine here | `references/playwright-cli-ops.md` (§chrome-devtools-cli) |
| **`agent-browser`** (load its skill) | Authenticated browsing that a persistent dedicated profile can satisfy (log in once, reuse), Electron/Slack, remote CDP/cloud browsers, messy real-site behavior | Reach for it *before* hand-rolling CDP scripts | `references/real-browser.md` |
| **Real logged-in browser**: `claude-in-chrome` MCP (attended) or AppleScript (unattended) | Bot-walled targets, or anything needing the user's actual default-profile session | Attended → MCP visible Chrome with human hand-offs; unattended → AppleScript against real Chrome/Safari | `references/real-browser.md` |
| **Raw Node+Playwright script** | Scale only: batch-capturing hundreds of shots, pixel-diffing, custom traces | Run from repo root (module resolution); everything in the playwright-cli pre-flight still applies | `references/playwright-cli-ops.md` (§graduating) |

`chrome-devtools` MCP is a last-resort fallback when the DevTools CLI cannot
express a needed capability — not a first stop.

## Hard rules (every route)

1. **Cheapest sufficient mechanism first; escalate only on proven failure** — and
   record *why* the rung failed in repo memory so the next session skips it.
2. **Verify every state-changing action independently** — screenshot, DOM-state
   read, or file-on-disk. Never trust a tool's own success report: ref-clicks
   "succeed" without submitting, form inputs update the a11y tree but not the
   DOM, downloads report success and write nothing, navigations silently bounce.
   "Reported success but state unchanged" is a failure.
3. **Reserved for the human, always:** credential entry, CAPTCHA, account
   creation, consequential Submit, and any SSN/financial step. This is a security
   rule, not a capability limit.
4. **Fix config before switching tools.** Most "tool failures" are a missing
   flag, wrong port, or wrong write path. Switch mechanisms only at a gating
   factor (bot wall, identity, missing capability).
5. **About to hand-write a browser script for an ordinary task?** (Probing
   `node_modules/.bin` for playwright is the tell.) Stop — load the tool's skill
   instead; hand-rolling re-hits already-solved problems.
