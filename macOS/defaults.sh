#!/usr/bin/env bash

main() {
    # configure_plist_apps # Configure all apps whose configurations are plists
    # configure_iterm2 iterm will configure using mackup. Hold code to reuse for other program that mackup does not support.
    configure_system
    configure_dock
    configure_finder
}

function configure_plist_apps() {
    quit "Transmission"
    quit "The Unarchiver"
    import_plist "org.m0k.transmission" "Transmission.plist"
    import_plist "cx.c3.theunarchiver" "The_Unarchiver.plist"
}

function configure_iterm2() {
    defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -int 1
    defaults write com.googlecode.iterm2 PrefsCustomFolder -string ~/personal/dotfiles/iTerm2
}

function configure_system() {
    LOGIN_HOOK_PATH=~/personal/dotfiles/macOS/login_hook_script.sh
    LOGOUT_HOOK_PATH=~/personal/dotfiles/macOS/logout_hook_script.sh
    # Disable Gatekeeper for getting rid of unknown developers error
    sudo spctl --master-disable
    # Disable macOS startup chime sound
    sudo defaults write com.apple.loginwindow LoginHook $LOGIN_HOOK_PATH
    sudo defaults write com.apple.loginwindow LogoutHook $LOGOUT_HOOK_PATH
}

function configure_dock() {
    quit "Dock"
    # Don’t show recent applications in Dock
    defaults write com.apple.dock show-recents -bool false
    # Set the icon size of Dock items to 36 pixels
    defaults write com.apple.dock tilesize -int 36
    # Remove all (default) app icons from the Dock
    defaults write com.apple.dock persistent-apps -array
    defaults write com.apple.dock recent-apps -array
    # Show only open applications in the Dock
    defaults write com.apple.dock static-only -bool true
    # Don’t animate opening applications from the Dock
    defaults write com.apple.dock launchanim -bool false
    # Disable Dashboard
    defaults write com.apple.dashboard mcx-disabled -bool true
    # Don’t show Dashboard as a Space
    defaults write com.apple.dock dashboard-in-overlay -bool true
    # Automatically hide and show the Dock
    defaults write com.apple.dock autohide -bool true
    # Remove the auto-hiding Dock delay
    defaults write com.apple.dock autohide-delay -float 0

    open "Dock"
}

function configure_finder() {
    # Save screenshots to Downloads folder
    defaults write com.apple.screencapture location -string "${HOME}/Downloads"
    # Require password immediately after sleep or screen saver begins
    defaults write com.apple.screensaver askForPassword -int 1
    defaults write com.apple.screensaver askForPasswordDelay -int 0
    # allow quitting via ⌘ + q; doing so will also hide desktop icons
    defaults write com.apple.finder QuitMenuItem -bool true
    # disable window animations and Get Info animations
    defaults write com.apple.finder DisableAllAnimations -bool true
    # Set Home as the default location for new Finder windows
    defaults write com.apple.finder NewWindowTarget -string "PfLo"
    defaults write com.apple.finder NewWindowTargetPath -string \
        "file://${HOME}/"
    # enable status bar
    defaults write com.apple.finder ShowStatusBar -bool true
    # enable path bar
    defaults write com.apple.finder ShowPathbar -bool true
    # Display full POSIX path as Finder window title
    defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
    # Keep folders on top when sorting by name
    defaults write com.apple.finder _FXSortFoldersFirst -bool true
    # When performing a search, search the current folder by default
    defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
    # Disable disk image verification
    defaults write com.apple.frameworks.diskimages \
        skip-verify -bool true
    defaults write com.apple.frameworks.diskimages \
        skip-verify-locked -bool true
    defaults write com.apple.frameworks.diskimages \
        skip-verify-remote -bool true
    # Use list view in all Finder windows by default
    # Four-letter codes for view modes: icnv, clmv, Flwv, Nlsv
    defaults write com.apple.finder FXPreferredViewStyle -string clmv
    # Disable the warning before emptying the Trash
    defaults write com.apple.finder WarnOnEmptyTrash -bool false
}

################################
# Help functions
################################
function quit() {
    app=$1
    killall "$app" > /dev/null 2>&1
}

function open() {
    app=$1
    osascript << EOM
tell application "$app" to activate
tell application "System Events" to tell process "iTerm2"
set frontmost to true
end tell
EOM
}

function import_plist() {
    domain=$1
    filename=$2
    defaults delete "$domain" &> /dev/null
    defaults import "$domain" "$filename"
}

main "$@"
