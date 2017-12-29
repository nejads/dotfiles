#!/usr/bin/env bash

main() {
    # First things first, asking for sudo credentials
    ask_for_sudo
    # Installing Homebrew, the basis of anything and everything
    install_homebrew
    # Installing mas using brew as the requirement for login_to_app_store
    brew_install mas
    # Ensuring the user is logged in the App Store so that
    # install_packages_with_brewfile can install App Store applications
    # using mas cli application
    login_to_app_store
    # Cloning Dotfiles repository for install_packages_with_brewfile
    # to have access to Brewfile
    clone_dotfiles_repo
    # Installing all packages in Dotfiles repository's Brewfile
    install_packages_with_brewfile
    # Changing default shell to Fish
    change_shell_to_fish
    # Configuring git config file
    configure_git
    # Installing powerline-status so that setup_symlinks can setup the symlinks
    pip2_install powerline-status
    # Setting up symlinks so that setup_vim can install all plugins
    setup_symlinks
    # Setting up Vim
    setup_vim
    # Setting up tmux
    setup_tmux
    # Configuring iTerm2
    configure_iterm2
}

DOTFILES_REPO=~/personal/dotfiles

function ask_for_sudo() {
    info "Prompting for sudo password..."
    if sudo --validate; then
        # Keep-alive
        while true; do sudo --non-interactive true; \
            sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
        success "Sudo credentials updated."
    else
        error "Obtaining sudo credentials failed."
        exit 1
    fi
}

function login_to_app_store() {
    info "Logging into app store..."
    if mas account >/dev/null; then
        success "Already logged in."
    else
        open -a "/Applications/App Store.app"
        until (mas account > /dev/null);
        do
            sleep 3
        done
        success "Login to app store successful."
    fi
}

function install_homebrew() {
    info "Installing Homebrew..."
    if hash brew 2>/dev/null; then
        success "Homebrew already exists."
    else
url=https://raw.githubusercontent.com/Sajjadhosn/dotfiles/master/installers/homebrew_installer
        if /usr/bin/ruby -e "$(curl -fsSL ${url})"; then
            success "Homebrew installation succeeded."
        else
            error "Homebrew installation failed."
            exit 1
        fi
    fi
}

function install_packages_with_brewfile() {
    info "Installing packages within ${DOTFILES_REPO}/brew/macOS.Brewfile ..."
    if brew bundle --file=$DOTFILES_REPO/brew/macOS.Brewfile; then
        success "Brewfile installation succeeded."
    else
        error "Brewfile installation failed."
        exit 1
    fi
}

function brew_install() {
    package_to_install="$1"
    info "brew install ${package_to_install}"
    if hash "$package_to_install" 2>/dev/null; then
        success "${package_to_install} already exists."
    else
        if brew install "$package_to_install"; then
            success "Package ${package_to_install} installation succeeded."
        else
            error "Package ${package_to_install} installation failed."
            exit 1
        fi
    fi
}

function change_shell_to_fish() {
    info "Fish shell setup..."
    if grep --quiet fish <<< "$SHELL"; then
        success "Fish shell already exists."
    else
        user=$(whoami)
        substep "Adding Fish executable to /etc/shells"
        if grep --fixed-strings --line-regexp --quiet "/usr/local/bin/fish" /etc/shells; then
            substep "Fish executable already exists in /etc/shells"
        else
            sudo su << END
echo /usr/local/bin/fish >> /etc/shells
END
            substep "Fish executable successfully added to /etc/shells"
        fi
        substep "Switching shell to Fish for \"${user}\""
        if sudo chsh -s /usr/local/bin/fish "$user"; then
            success "Fish shell successfully set for \"${user}\""
        else
            error "Please try setting the Fish shell again."
        fi
    fi
}

function configure_git() {
    username="Sajjad Hosseini"
    email="sajjad.hosseini@futurice.com"

    info "Configuring git..."
    if git config --global user.name "$username" && \
       git config --global user.email "$email"; then
        success "git configuration succeeded."
    else
        error "git configuration failed."
    fi
}

function clone_dotfiles_repo() {
    info "Cloning dotfiles repository into ${DOTFILES_REPO} ..."
    if test -e $DOTFILES_REPO; then
        substep "${DOTFILES_REPO} already exists."
        pull_latest $DOTFILES_REPO
    else
        url=https://github.com/Sajjadhosn/dotfiles.git
        if git clone "$url" $DOTFILES_REPO; then
            success "Cloned into ${DOTFILES_REPO}"
        else
            error "Cloning into ${DOTFILES_REPO} failed."
            exit 1
        fi
    fi
}

function pull_latest() {
    info "Pulling latest changes in ${1} repository..."
    if git -C $1 pull origin master; then
        success "Pull successful in ${1} repository."
    else
        error "Please pull the latest changes in ${1} repository manually."
    fi
}

function setup_vim() {
    info "Setting up vim..."
    substep "Installing Vundle"
    if test -e ~/.vim/bundle/Vundle.vim; then
        substep "Vundle already exists."
        pull_latest ~/.vim/bundle/Vundle.vim
    else
        url=https://github.com/VundleVim/Vundle.vim.git
        if git clone "$url" ~/.vim/bundle/Vundle.vim; then
            substep "Vundle installation succeeded."
        else
            error "Vundle installation failed."
            exit 1
        fi
    fi
    substep "Installing all plugins"
    if vim +PluginInstall +qall 2> /dev/null; then
        substep "Plugin installation succeeded."
    else
        error "Plugin installation failed."
        exit 1
    fi
    success "vim successfully setup."
}

function setup_tmux() {
    info "Setting up tmux..."
    substep "Installing tpm"
    if test -e ~/.tmux/plugins/tpm; then
        substep "tpm already exists."
        pull_latest ~/.tmux/plugins/tpm
    else
        url=https://github.com/tmux-plugins/tpm
        if git clone "$url" ~/.tmux/plugins/tpm; then
            substep "tpm installation succeeded."
        else
            error "tpm installation failed."
            exit 1
        fi
    fi

    substep "Installing all plugins"

    # sourcing .tmux.conf is necessary for tpm
    tmux source-file ~/.tmux.conf 2> /dev/null

    if ~/.tmux/plugins/tpm/bin/./install_plugins; then
        substep "Plugin installation succeeded."
    else
        error "Plugin installation failed."
        exit 1
    fi
    success "tmux successfully setup."
}

function configure_iterm2() {
    info "Configuring iTerm2..."
    if \
        defaults write com.googlecode.iterm2 \
            LoadPrefsFromCustomFolder -int 1 && \
        defaults write com.googlecode.iterm2 \
            PrefsCustomFolder -string "${DOTFILES_REPO}/iTerm2";
    then
        success "iTerm2 configuration succeeded."
    else
        error "iTerm2 configuration failed."
        exit 1
    fi
    substep "Opening iTerm2"
    if osascript -e 'tell application "iTerm" to activate'; then
        substep "iTerm2 activation successful"
    else
        error "Failed to activate iTerm2"
        exit 1
    fi
}

function setup_symlinks() {
    POWERLINE_ROOT_REPO=/usr/local/lib/python2.7/site-packages

    info "Setting up symlinks..."

    substep "Symlinking vim"
    if ln -Ffs ${DOTFILES_REPO}/vim/.vimrc ~/.vimrc;
    then
        substep "Symlinking vim done."
    else
        error "Symlinking vim failed."
        exit 1
    fi

    substep "Symlinking fish"
    if \
        ln -Ffs ${DOTFILES_REPO}/fish/completions ~/.config/fish/completions && \
        ln -Ffs ${DOTFILES_REPO}/fish/functions   ~/.config/fish/functions && \
        ln -Ffs ${DOTFILES_REPO}/fish/config.fish ~/.config/fish/config.fish && \
        ln -Ffs ${DOTFILES_REPO}/fish/oh_my_fish  ~/.config/omf;
    then
        substep "Symlinking fish done."
    else
        error "Symlinking fish failed."
        exit 1
    fi

    substep "Symlinking powerline"
    if ln -Ffs ${DOTFILES_REPO}/powerline ${POWERLINE_ROOT_REPO}/powerline/config_files;
    then
        substep "Symlinking powerline done."
    else
        error "Symlinking powerline failed."
        exit 1
    fi

    substep "Symlinking tmux"
    if ln -Ffs ${DOTFILES_REPO}/tmux/.tmux.conf ~/.tmux.conf;
    then
        substep "Symlinking tmux done."
    else
        error "Symlinking tmux failed."
        exit 1
    fi

    success "Symlinks successfully setup."
}

function pip2_install() {
    package_to_install="$1"

    info "pip2 install ${package_to_install}"
    if pip2 --quiet show "$package_to_install"; then
        success "${package_to_install} already exists."
    else
        if pip2 install "$package_to_install"; then
            success "Package ${package_to_install} installation succeeded."
        else
            error "Package ${package_to_install} installation failed."
            exit 1
        fi
    fi
}

function coloredEcho() {
    local exp="$1";
    local color="$2";
    local arrow="$3";
    if ! [[ $color =~ '^[0-9]$' ]] ; then
       case $(echo $color | tr '[:upper:]' '[:lower:]') in
        black) color=0 ;;
        red) color=1 ;;
        green) color=2 ;;
        yellow) color=3 ;;
        blue) color=4 ;;
        magenta) color=5 ;;
        cyan) color=6 ;;
        white|*) color=7 ;; # white or invalid color
       esac
    fi
    tput bold;
    tput setaf "$color";
    echo "$arrow $exp";
    tput sgr0;
}

function info() {
    coloredEcho "$1" blue "========>"
}

function substep() {
    coloredEcho "$1" magenta "===="
}

function success() {
    coloredEcho "$1" green "========>"
}

function error() {
    coloredEcho "$1" red "========>"
}

main "$@"
