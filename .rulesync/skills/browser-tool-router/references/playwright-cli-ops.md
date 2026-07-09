# playwright-cli operations playbook

The `playwright-cli` skill documents command syntax. This playbook covers the
operational environment. Run the pre-flight before the first `goto`, every
session.

Contents: pre-flight checklist · interaction contracts · verify what you
measure · chrome-devtools-cli notes · graduating to raw scripts.

## Pre-flight checklist

### 1. Pin the target server (the #1 source of wrong conclusions)

Multiple dev servers frequently run at once — especially across git worktrees,
where each checkout grabs an adjacent port. Screenshotting the wrong worktree's
app produces false conclusions ("the fix didn't take").

- Enumerate listeners first: `lsof -nP -iTCP -sTCP:LISTEN | grep -i node` (or
  scan the likely port range), then confirm which PID's working directory is
  *this* checkout (`lsof -p <pid> | grep cwd`).
- **Readiness lines lie.** A server can print `Ready in 376ms` and then exit 1
  (`Another next dev server is already running`). Verify the process is still
  alive and actually serving before trusting it.
- Reuse a healthy existing server for this checkout rather than racing it with a
  new one.
- Bind the session to the confirmed URL explicitly; never trust ambient tab state.

### 2. Session naming and liveness

- The `default` session does not reliably survive across separate bash calls —
  expect `The browser 'default' is not open`. Open a **named** session and reuse
  it.
- Keep names **short and unique**: `-s qa-$$` (PID-suffixed). Long or hyphenated
  names crash the CLI (`EINVAL`, socket path too long) or silently truncate.
- Parallel subagents sharing one daemon kill each other's sessions (`close-all`
  contention). When fanning out, give every agent its own named session and
  never call close-all.

### 3. Headed or headless — decide up front

- `open` defaults to **headless**, and `--persistent` does *not* imply headed.
- Any task where a human must see the window or log in ("I'll log in", "show
  me", auth-gated target) → `--headed` (usually with `--persistent`).
- If the target needs an *existing* logged-in identity rather than a fresh
  login, this is the wrong tool — see `references/real-browser.md`.

### 4. Screenshot write root

- Allowed roots are `<repo>/.playwright-cli/` and the repo root — `/tmp`,
  session scratchpads, and anything else are **denied** (`File access denied:
  ... outside allowed roots`).
- A bare relative filename "succeeds" by leaking an untracked PNG into the repo
  root. Always target `<repo>/.playwright-cli/<name>.png` and clean up after.
- This sandbox is a playwright-cli property; `chrome-devtools-cli` writes to
  `/tmp` freely.

### 5. Device scale factor

Retina/sharpness questions need `deviceScaleFactor: 2` (or 3) captures — DPR-1
screenshots give wrong verdicts on rendering-quality bugs.

## Interaction contracts

- **`run-code`, not multi-line `eval`, for anything async.** It expects a single
  `async page => { … }` expression — not a full script (`Unexpected token
  'const'` means you passed a script). `process`/`setTimeout` don't exist; use
  `page.waitForTimeout`. Raw `eval` async IIFEs don't await, so reads race UI
  timers.
- **Selectors:** Tailwind responsive classes break `querySelector` (`lg:` colons
  → "not a valid selector"), and bracket/quote-heavy selectors trip CLI arg
  parsing. Workaround: tag the element with a synthetic `#id` via eval, then
  select by id.
- **Real interactions, not synthetic events:** `dispatchEvent('mouseenter')`
  won't fire React's `onMouseEnter` — use the native `hover`/`click` commands.
  "Synthetic events pass but real clicks fail" means you're at the wrong
  automation layer.
- **State resets:** `goto` resets a prior `resize`; scroll position resets
  between calls. Re-establish viewport/scroll after navigation.

## Verify what you measure

- **Never measure an element that isn't rendered.** A breakpoint-hidden element
  returns confident nonsense (e.g. `top=0`). Screenshot at the actual width
  instead.
- **When a DOM metric and human perception disagree, the metric may be wrong**
  (measuring the wrong reference point). Inject `style.zoom` 4–6× and
  screenshot to arbitrate.
- Screenshot-verify every state-changing interaction (router hard rule 2).

## §chrome-devtools-cli notes

- Use for perf traces, LCP/TBT, console, network, throttled measurement.
- Run `--help` before unfamiliar subcommands — enum casing is strict (`image`,
  not `Image`).
- Use `performance_start_trace` for performance; `lighthouse_audit` **excludes**
  the performance category.
- The recurring `--localstorage-file` warning is harmless.
- Tight `emulate` loops blow the 2-minute bash timeout — script per-URL/per-run
  instead.

## §graduating to a raw Node+Playwright script

Legitimate only at scale: batch-capturing large screenshot matrices
(widths × DPRs), pixel-diffing, custom trace scripting, or a reusable
cross-engine smoke script. When you do:

- **Run from the repo root** — scripts executed from `/tmp` or a scratchpad die
  with `ERR_MODULE_NOT_FOUND: Cannot find package 'playwright'`.
- The default interactive shell may be zsh: bash-isms like `declare -A` fail
  with `bad substitution`. Write POSIX-ish or explicit `#!/usr/bin/env bash`.
- Every pre-flight item above (port pinning, write hygiene, DPR) still applies —
  hand-rolled scripts hit the same walls without the CLI's guardrails.
- For pixel-diffing there is no native command: the working pattern is
  ImageMagick `compare` against a control render (e.g. from a `git stash`
  baseline).

Hand-rolling for an *ordinary* task (one page, a few screenshots) is a smell —
load the `playwright-cli` skill instead.
