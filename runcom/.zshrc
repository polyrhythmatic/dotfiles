# Startup Profiling (run: ZPROF=1 zsh -i -c exit)
# =====================
if [[ -n "$ZPROF" ]]; then
  zmodload zsh/zprof
fi

# Configurations
# =====================
# GIT_MERGE_AUTO_EDIT
# This variable configures git to not require a message when you merge.
export GIT_MERGE_AUTOEDIT='no'

# Helpful Functions
# =====================

# A function to CD into the desktop from anywhere
# USE: desktop
#      desktop subfolder
function desktop {
  cd /Users/$USER/Desktop/$@
}

# A function to easily grep for a matching process
# USE: psg postgres
function psg {
  FIRST=$(echo $1 | sed -e 's/^\(.\).*/\1/')
  REST=$(echo $1 | sed -e 's/^.\(.*\)/\1/')
  ps aux | grep "[$FIRST]$REST"
}

# A function to easily grep for a matching file
# USE: lg filename
function lg {
  ls -la | grep "$@"
}

# Time zsh startup (runs 10 iterations)
function timezsh {
  for i in $(seq 1 10); do /usr/bin/time zsh -i -c exit; done
}

# Aliases
# =====================
  # LS
  alias l='ls -lah'

  # Git
  alias gst="git status"
  alias gl="git pull"
  alias gp="git push"
  alias gc="git commit -v"
  alias gca="git commit -v -a"
  alias gb="git branch"
  alias gba="git branch -a"
  alias gcam="git commit -am"

  # open files with "chrome ____"
  alias chrome="open -a 'Google Chrome'"

  # Cursor editor
  if [ -x "/Applications/Cursor.app/Contents/Resources/app/bin/code" ]; then
    alias code="/Applications/Cursor.app/Contents/Resources/app/bin/code"
    export PATH="/Applications/Cursor.app/Contents/Resources/app/bin:$PATH"
  fi

# Version Managers & Environment Setup
# =====================

# agent-browser: namespace the default browser session per Claude Code
# session. Each Bash tool call re-sources this file and inherits
# CLAUDE_CODE_SESSION_ID, so every agent-browser command lands in a
# session named cc-<first8>. A SessionEnd hook
# (~/.claude/hooks/browser-session-cleanup.sh) then closes exactly that
# session on exit — never a pre-existing, explicitly-named, or concurrent
# session's browser. Only set under Claude Code; human shells are untouched.
if [ -n "$CLAUDE_CODE_SESSION_ID" ] && [ -z "$AGENT_BROWSER_SESSION" ]; then
  export AGENT_BROWSER_SESSION="cc-${CLAUDE_CODE_SESSION_ID:0:8}"
fi

# fnm (Fast Node Manager)
eval "$(fnm env --use-on-cd)"

# Homebrew Ruby (system Ruby 2.6 is EOL) + gem-installed CLIs on PATH.
# The gems/*/bin glob is version-proof across `brew upgrade ruby`.
if [ -d "${HOMEBREW_PREFIX}/opt/ruby/bin" ]; then
  export PATH="${HOMEBREW_PREFIX}/opt/ruby/bin:$PATH"
  for _gembin in "${HOMEBREW_PREFIX}"/lib/ruby/gems/*/bin(N); do
    export PATH="$_gembin:$PATH"
  done
  unset _gembin
fi

# History - Zsh specific settings
# =====================
export HISTSIZE=32768
export SAVEHIST=$HISTSIZE
export HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY

# Force emacs keymap. Without this, zsh auto-picks vi mode because
# EDITOR=vim, which leaves Option+Arrow (\eb/\ef from Ghostty) unbound
# and inserts the raw escape sequence as text on the command line.
bindkey -e

# Pop any leaked kitty-keyboard-protocol flags before each prompt. TUIs
# that crash or exit uncleanly leave the flags pushed, which silently
# changes how the next TUI in the same window encodes modified keys
# (e.g. cmd+backspace in Claude Code wipes the buffer instead of the line).
autoload -Uz add-zsh-hook
_reset_kitty_keyboard() { printf '\e[<u' }
add-zsh-hook precmd _reset_kitty_keyboard

# Zsh Completion System
# =====================
autoload -Uz compinit && compinit

# Case-Insensitive Auto Completion
# =====================
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Shell Plugins
# =====================

# HOMEBREW_PREFIX is exported by `brew shellenv` in .zprofile
# (/opt/homebrew on Apple Silicon, /usr/local on Intel)

# fzf key bindings and completion
if [ -f "${HOMEBREW_PREFIX}/opt/fzf/shell/key-bindings.zsh" ]; then
  source "${HOMEBREW_PREFIX}/opt/fzf/shell/key-bindings.zsh"
fi
if [ -f "${HOMEBREW_PREFIX}/opt/fzf/shell/completion.zsh" ]; then
  source "${HOMEBREW_PREFIX}/opt/fzf/shell/completion.zsh"
fi

# zsh-autosuggestions
if [ -f "${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# zsh-syntax-highlighting (must be last plugin sourced)
if [ -f "${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  source "${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# Prompt
# =====================

# Starship prompt (must be last — wraps precmd)
eval "$(starship init zsh)"

# Profiling output (must be near end)
if [[ -n "$ZPROF" ]]; then
  zprof
fi

# Source local/private settings if they exist
if [ -f ~/.zshrc.local ]; then
  source ~/.zshrc.local
fi
