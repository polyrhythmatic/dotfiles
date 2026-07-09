# Fetch ladder — reading web content without a browser

WebFetch/curl is the correct first rung for the large majority of "read a page"
tasks: static HTML, docs, pricing pages, public repo files, documented APIs.
Stay here unless the task needs live/computed/interactive DOM, a session, or a
visual/binary artifact.

## Three input classes where WebFetch always fails

Recognize these *before* the first call — none of them self-diagnose:

1. **Binary/image URLs** (including design-tool screenshot assets): 100% failure
   ("this is a PNG in binary format"). Correct path: `curl -o` the file, then
   `Read` the local copy (Read renders images). Never ask WebFetch to "describe
   this screenshot". For design files, prefer the structured API (design
   context / variable defs) over screenshot-description entirely.
2. **Bot/CDN gates**: 403/429, Cloudflare "Just a moment…", security-checkpoint
   interstitials. These defeat WebFetch *and* naive curl. See the ladder below —
   recognize the gate within 1–2 attempts instead of exhausting curl
   permutations.
3. **`file://` and non-http schemes**: WebFetch returns a bare `Invalid URL`.
   Use `Read` on the local path.

## URL rewrites worth knowing

- GitHub `…/blob/…` pages return a generic landing page via WebFetch — fetch
  `raw.githubusercontent.com/<org>/<repo>/<ref>/<path>` instead.
- `web.archive.org` is hard-blocked for WebFetch, and the Wayback API
  rate-limits aggressively — don't build an escalation plan around it.

## The escalation ladder (on a block)

```
WebFetch
  └─ 403/429/interstitial → curl with a real browser User-Agent
       └─ still blocked → reader proxy (https://r.jina.ai/<url>)
            └─ still blocked → WebSearch for an alternate source of the same content
                 └─ genuinely needs the page itself → real browser
                    (see ../SKILL.md gating factors; a real logged-in profile
                     may clear a JS challenge that automation cannot)
```

Record hard-blocked domains in `<repo>/.claude/browser-domains.md` so the next
session skips straight to the working rung.

## Common misjudgments

- **A single 403 on one static URL is weak evidence** that the whole domain is
  bot-walled or needs a browser. Distinguish "this URL is blocked" from "this
  domain requires interaction/session" with one more cheap probe before
  escalating mechanisms.
- **Don't blind-guess undocumented API endpoints** with curl (HTTP 400 loops).
  If no documented contract exists, capture a real request from a browser
  network trace first, then replay it headlessly.
- **Email is never a browser task** — use the Gmail/Workspace CLI (`gws`) or
  API.
- **A login wall is an account problem, not a mechanism problem.** No tool
  switch fixes a genuine account requirement — route around the *site* (find an
  alternate source) or hand off to the human.
