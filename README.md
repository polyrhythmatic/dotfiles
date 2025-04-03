# Seth Kranzler's Dotfiles

These are my personal configuration files and setup scripts for macOS, optimized for Apple Silicon (M1/M2/M3) and Zsh. The goal is to automate the setup of a new development machine as much as possible.

## Prerequisites

1.  **Command Line Tools:** Before cloning, ensure the Command Line Tools are installed. If you run `git` on a fresh macOS install, it should prompt you to install them. Alternatively, run `xcode-select --install`.
2.  **Mac App Store:** Log in to the Mac App Store *before* running the installation script. This is required for `mas` to install Xcode.
3.  **iCloud Drive:** Ensure iCloud Drive is enabled and running if you want Mackup to sync application settings correctly.

## Installation

1.  **Clone the repository:**
    ```bash
    git clone <your-repository-url> ~/dotfiles
    ```
    *(Replace `<your-repository-url>` with the actual URL of your dotfiles repository)*

2.  **Run the installation script:**
    ```bash
    cd ~/dotfiles
    ./install.sh
    ```

## What it Does

The `install.sh` script performs the following actions:

*   Updates the dotfiles repository itself (if it's a git repo).
*   Creates symbolic links in your home directory (`~`) for key configuration files:
    *   `.zshrc` (Zsh interactive config)
    *   `.zprofile` (Zsh login config)
    *   `.gitconfig` (Git configuration)
    *   `.gitignore` (Global Git ignore rules)
*   Installs [Homebrew](https://brew.sh/) (if not already installed) and essential command-line tools listed in `install/brew.sh`.
*   Installs [NVM](https://github.com/nvm-sh/nvm), Node.js v22 (LTS), and global npm packages listed in `install/npm.sh`.
*   Installs [RVM](https://rvm.io/), Ruby v3.3, and gems (like Jekyll) listed in `install/gem.sh`. - disabled for now
*   Installs Xcode via the Mac App Store using `mas` (`install/mas.sh`).
*   Installs GUI applications via Homebrew Cask listed in `install/brew-cask.sh`.
*   Generates an SSH key (Ed25519) if one doesn't exist, configures `~/.ssh/config` for GitHub, adds the key to the agent/keychain, and copies the public key to the clipboard (`install/ssh-setup.sh`).
*   Applies various macOS system preferences using `defaults write` commands (`install/macos.sh`).
*   Backs up and restores application settings using [Mackup](https://github.com/lra/mackup) configured for iCloud Drive (`etc/.mackup.cfg`).

## Post-Installation Steps

1.  **Add SSH Key to GitHub:** The script copies your public SSH key to the clipboard. You **must** manually add this key to your GitHub account settings: [https://github.com/settings/keys](https://github.com/settings/keys)
2.  **Restart:** Some macOS preference changes and application installations may require a restart or logout/login to take full effect.
3.  **SSH Key Passphrase (Optional but Recommended):** The generated SSH key does not have a passphrase for automation purposes. You can add one for better security by running:
    ```bash
    ssh-keygen -p -f ~/.ssh/id_ed25519
    ```
4.  **Review Mackup:** Check if Mackup successfully restored your application settings. You might need to run `mackup restore` again or adjust the application list in `etc/.mackup.cfg`. Run `mackup list` to see supported applications.

## Customization

*   **Homebrew Packages:** Edit `install/brew.sh` to add or remove CLI tools.
*   **Global npm Packages:** Edit `install/npm.sh`.
*   **Ruby Gems:** Edit `install/gem.sh`.
*   **Mac App Store Apps:** Edit `install/mas.sh` (use `mas search <app_name>` to find IDs).
*   **Homebrew Casks (GUI Apps):** Edit `install/brew-cask.sh`.
*   **macOS Preferences:** Edit `install/macos.sh`. Add or remove `defaults write` commands.
*   **Zsh Configuration:** Edit `runcom/.zshrc` (for aliases, functions, interactive settings) and `runcom/.zprofile` (for PATH, environment variables). Consider adding a Zsh plugin manager like Oh My Zsh or Antigen.
*   **Git Configuration:** Edit `.gitconfig`.
*   **Global Gitignore:** Edit `.gitignore`.
*   **Mackup Configuration:** Edit `etc/.mackup.cfg` to change storage or synced applications.
