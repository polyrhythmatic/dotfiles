#!/bin/bash
# Claude Code statusline — Swiss-minimal, programmatic.
#
# Design rules (Bringhurst / webtypography.net + Gerstner):
#   - Tone is weight. Dim = ambient, normal = present, bold = alarm.
#   - Whitespace separates; no |, ❯, emoji, or other ornament.
#   - Two spaces between groups, one space within.
#   - Color escalates with state, never decorates.
#   - Conditional fields appear only when they have something to say.
#
# Layout: identity ─── state ────────── (right-justified) meta

set -u
input=$(cat)

D=$'\033[2m'    # dim
N=$'\033[22m'   # normal
B=$'\033[1m'    # bold
R=$'\033[0m'    # reset

CY=$'\033[36m'  # cyan
YL=$'\033[33m'  # yellow
RD=$'\033[31m'  # red
GN=$'\033[32m'  # green
MG=$'\033[35m'  # magenta

# ── Data ────────────────────────────────────────────────────────
get() { printf '%s' "$input" | jq -r "$1"; }

model=$(get '.model.display_name // "claude"')
cwd=$(get '.workspace.current_dir // ""')
ctx_pct=$(get '.context_window.used_percentage // 0' | awk -F. '{print $1}')
cost=$(get '.cost.total_cost_usd // 0')
duration_ms=$(get '.cost.total_duration_ms // 0')
vim_mode=$(get '.vim.mode // ""')
effort=$(get '.effort.level // ""')
output_style=$(get '.output_style.name // ""')
worktree_name=$(get '.worktree.name // ""')
worktree_branch=$(get '.worktree.branch // ""')
rl_5h=$(get '.rate_limits.five_hour.used_percentage // empty')
rl_7d=$(get '.rate_limits.seven_day.used_percentage // empty')

dir_base=$(basename "$cwd")
model_short=$(printf '%s' "$model" | awk '{print tolower($1)}')

# ── Buffers (colored + visible-length variants) ──────────────────
LC=""; LV=""; RC=""; RV=""

push() { # $1=side(L|R) $2=colored $3=visible
  if [ "$1" = L ]; then
    if [ -z "$LV" ]; then LC=$2; LV=$3
    else LC="${LC}  $2"; LV="${LV}  $3"; fi
  else
    if [ -z "$RV" ]; then RC=$2; RV=$3
    else RC="${RC}  $2"; RV="${RV}  $3"; fi
  fi
}

# ── Identity ─────────────────────────────────────────────────────
push L "${D}${model_short}${R}" "$model_short"
push L "$dir_base" "$dir_base"

# ── Branch + delta ───────────────────────────────────────────────
if [ -n "$cwd" ] && git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git -C "$cwd" branch --show-current 2>/dev/null)
  [ -z "$branch" ] && branch=$(git -C "$cwd" rev-parse --short HEAD 2>/dev/null)

  staged=$(git -C "$cwd" diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
  modified=$(git -C "$cwd" diff --numstat 2>/dev/null | wc -l | tr -d ' ')
  untracked=$(git -C "$cwd" ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')
  dirty=$((staged + modified + untracked))

  ahead=0; behind=0
  ud=$(git -C "$cwd" rev-list --left-right --count "@{u}...HEAD" 2>/dev/null) || true
  if [ -n "$ud" ]; then
    behind=$(printf '%s' "$ud" | awk '{print $1}')
    ahead=$(printf '%s' "$ud" | awk '{print $2}')
  fi

  if [ "$dirty" -gt 0 ] || [ "$ahead" -gt 0 ] || [ "$behind" -gt 0 ]; then
    bc="${CY}"
  else
    bc="${D}${CY}"
  fi
  bc_str="${bc}${branch}${R}"
  bv_str="$branch"

  if [ "$dirty" -gt 0 ]; then
    bc_str="${bc_str} ${D}~${dirty}${R}"; bv_str="${bv_str} ~${dirty}"
  fi
  if [ "$ahead" -gt 0 ]; then
    bc_str="${bc_str} ${D}+${ahead}${R}"; bv_str="${bv_str} +${ahead}"
  fi
  if [ "$behind" -gt 0 ]; then
    bc_str="${bc_str} ${D}-${behind}${R}"; bv_str="${bv_str} -${behind}"
  fi
  push L "$bc_str" "$bv_str"
fi

# ── Context % (always shown, color-graded) ───────────────────────
if   [ "$ctx_pct" -ge 90 ]; then ctx_c="${B}${RD}${ctx_pct}%${R}"
elif [ "$ctx_pct" -ge 80 ]; then ctx_c="${YL}${ctx_pct}%${R}"
elif [ "$ctx_pct" -ge 60 ]; then ctx_c="${ctx_pct}%"
else                             ctx_c="${D}${ctx_pct}%${R}"; fi
push L "${D}ctx${R} ${ctx_c}" "ctx ${ctx_pct}%"

# ── Conditional: vim mode ────────────────────────────────────────
if [ -n "$vim_mode" ] && [ "$vim_mode" != "NORMAL" ]; then
  vm=$(printf '%s' "$vim_mode" | tr '[:upper:]' '[:lower:]')
  case "$vim_mode" in
    INSERT)              vc="${GN}" ;;
    VISUAL|"VISUAL LINE") vc="${MG}" ;;
    *)                   vc="${D}" ;;
  esac
  push L "${vc}${vm}${R}" "$vm"
fi

# ── Conditional: non-default effort ──────────────────────────────
case "$effort" in
  high|"") ;;
  *) push L "${D}${effort}${R}" "$effort" ;;
esac

# ── Conditional: non-default output style ────────────────────────
case "$output_style" in
  ""|"default"|"Default") ;;
  *)
    os=$(printf '%s' "$output_style" | tr '[:upper:]' '[:lower:]')
    push L "${D}${os}${R}" "$os" ;;
esac

# ── Conditional: worktree (if it differs from the branch name) ───
if [ -n "$worktree_name" ] && [ "$worktree_name" != "$worktree_branch" ]; then
  push L "${D}@${worktree_name}${R}" "@${worktree_name}"
fi

# ── Conditional: rate limits (only if >=50%) ─────────────────────
add_rate() {
  local label=$1 raw=$2 pct rc
  pct=$(printf '%.0f' "$raw")
  [ "$pct" -lt 50 ] && return
  if   [ "$pct" -ge 80 ]; then rc="${RD}"
  else                         rc="${YL}"; fi
  push L "${rc}${label}:${pct}%${R}" "${label}:${pct}%"
}
[ -n "$rl_5h" ] && add_rate "5h" "$rl_5h"
[ -n "$rl_7d" ] && add_rate "7d" "$rl_7d"

# ── Cost (right) ─────────────────────────────────────────────────
cost_int=$(printf '%.0f' "$cost" 2>/dev/null || printf 0)
if   [ "$cost_int" -ge 5 ]; then cc="${YL}"
elif [ "$cost_int" -ge 1 ]; then cc=""
else                             cc="${D}"; fi
cost_str=$(printf '$%.2f' "$cost")
push R "${cc}${cost_str}${R}" "$cost_str"

# ── Duration (right) ─────────────────────────────────────────────
mins=$((duration_ms / 60000))
secs=$(((duration_ms % 60000) / 1000))
if [ "$mins" -gt 0 ]; then dur_str="${mins}m"
else                       dur_str="${secs}s"; fi
push R "${D}${dur_str}${R}" "$dur_str"

# ── Compose with right-justified meta ────────────────────────────
cols=${COLUMNS:-$(tput cols 2>/dev/null || echo 120)}
pad=$((cols - ${#LV} - ${#RV}))
[ "$pad" -lt 2 ] && pad=2

printf '%s%*s%s\n' "$LC" "$pad" "" "$RC"
