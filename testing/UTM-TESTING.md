# UTM Visual Verification Checklist

Manual verification checklist for UTM (or Tart with GUI) after running `chezmoi apply`.

## Dock
- [ ] Dock is hidden (autohide enabled)
- [ ] No autohide delay (appears instantly)
- [ ] Icon size is 36px
- [ ] Scale effect on minimize (not genie)
- [ ] Hidden app icons are translucent
- [ ] Indicator lights visible for open apps
- [ ] No opening animation

## Finder
- [ ] Hidden files are visible (dotfiles shown)
- [ ] All filename extensions shown
- [ ] Path bar visible at bottom
- [ ] Status bar visible at bottom
- [ ] Full POSIX path in window title
- [ ] List view is default
- [ ] Folders sort before files
- [ ] ~/Library folder is visible (not hidden)
- [ ] Desktop icons: grid layout, 80px, 100px spacing

## Screenshots
- [ ] Screenshots save to ~/Desktop
- [ ] Format is PNG (check file extension)
- [ ] No drop shadow on window screenshots

## Keyboard
- [ ] Fast key repeat (type and hold a key)
- [ ] No press-and-hold character picker (key repeats instead)
- [ ] Tap-to-click on trackpad

## Shell
- [ ] Starship prompt renders correctly
- [ ] zsh-autosuggestions working (ghost text appears)
- [ ] zsh-syntax-highlighting working (commands colored)
- [ ] fzf integration working (Ctrl+R for history)
- [ ] fnm loads and `node --version` works

## Ghostty (if installed)
- [ ] Alabaster Dark theme active
- [ ] Berkeley Mono font (if installed)
- [ ] Config loaded from ~/.config/ghostty/config

## Safari
- [ ] Develop menu visible in menu bar
- [ ] Full URL shown in address bar
- [ ] Home page is about:blank
- [ ] No safe file auto-open after download

## Other Apps
- [ ] Activity Monitor: CPU usage in Dock icon
- [ ] Activity Monitor: shows all processes
- [ ] TextEdit: opens in plain text mode
- [ ] Mail: threaded view enabled
- [ ] Terminal: UTF-8 encoding, secure keyboard entry

## Claude Code (if installed)
- [ ] `readlink ~/.claude/standards` points to dotfiles repo
- [ ] `readlink ~/.claude/mcp.json` points to dotfiles repo
- [ ] `readlink ~/.claude/settings.json` points to dotfiles repo
- [ ] Skills symlinks resolve correctly
- [ ] Agent symlinks resolve correctly
