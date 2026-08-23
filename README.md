# Dotfiles (Ubuntu 24)

Ansible-managed dotfiles for Ubuntu 24.04 LTS workstation setup.

## Quick Start

```bash
# Clone and run setup
curl -fsSL https://raw.githubusercontent.com/nejads/dotfiles/ubuntu/setup.sh | bash

# Then run the playbook
cd ~/dotfiles
ansible-playbook -K playbooks/bootstrap.yaml
```

## What's Included

| Role        | Purpose                                                               |
| ----------- | --------------------------------------------------------------------- |
| `apt`       | System packages via apt, snap, and manual installs (AWS CLI, SAM, gh) |
| `zsh`       | Zsh + Oh-My-Zsh + zsh-completions + syntax highlighting               |
| `spaceship` | Spaceship prompt theme                                                |
| `node`      | NVM + Node.js (LTS + latest)                                          |
| `npm`       | Global npm packages (json, prettier, surge, typescript)               |
| `git`       | Git config, aliases, diff-so-fancy                                    |
| `tmux`      | Tmux + TPM + Catppuccin theme + vim-tmux-navigator                    |
| `vscode`    | VS Code settings + extensions                                         |
| `hosts`     | Ad-blocking hosts file                                                |
| `ubuntu`    | GNOME desktop setup (font, keybindings, hyperkey, hints, clipboard)   |

## Run Specific Roles

```bash
# Only zsh and git
ansible-playbook -K playbooks/bootstrap.yaml --tags zsh,git

# Only tmux
ansible-playbook -K playbooks/bootstrap.yaml --tags tmux
```

## Removed (macOS-only)

These roles from the `main` branch are not applicable to Ubuntu:

- `homebrew` → replaced by `apt`
- `iterm` → use any Linux terminal (Alacritty, Kitty, etc.)
- `macos` → system preferences, not applicable
- `hammerspoon` → use a Linux tiling WM or window manager
- `touchbar_fix` → not applicable
- `cloudconfig` → iCloud-linked configs, handle manually on Linux

## Key Differences from macOS Branch

- **Package manager**: apt/snap instead of Homebrew
- **Clipboard**: `xclip` instead of `pbcopy`/`pbpaste`
- **Git credential**: `store` instead of `osxkeychain`
- **VS Code config path**: `~/.config/Code/User/` instead of `~/Library/Application Support/Code/User/`
- **Hosts file**: `/etc/hosts` instead of `/private/etc/hosts`
- **NVM**: Installed directly via curl (not via brew)
- **Tmux**: No `reattach-to-user-namespace` needed
- **Java**: Amazon Corretto in `/usr/lib/jvm/` instead of `/usr/libexec/java_home`

## Prerequisites

- Ubuntu 24.04 LTS
- `curl` and `git` (setup.sh installs everything else)

## Ubuntu Role Details

The `ubuntu` role configures the GNOME desktop environment:

- **JetBrains Mono Nerd Font** — Downloaded from GitHub, set as system monospace + terminal font
- **CTRL/Super key swap** — macOS-like behavior via xkb-options (works on X11 and Wayland)
- **Window management shortcuts** — Tile left/right, maximize, move between monitors/workspaces, resize/move modes
- **Clipboard history** — CopyQ with autostart and `Super+V` shortcut
- **Hints** — Vimium-like keyboard navigation for the desktop (`Super+;`)
- **Hyperkey** — CapsLock = Escape (tap) / Ctrl+Alt+Shift+Super (hold) via keyd
