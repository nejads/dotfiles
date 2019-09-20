#!/usr/bin/env bash

main() {
    # First things first, asking for sudo credentials
    ask_for_sudo
    # Installing Homebrew, the basis of anything and everything
    install_homebrew
    # Cloning Dotfiles repository for install_homebrew_formulae to have access to Brewfile
    clone_dotfiles_repo
    # Installing all packages in Dotfiles repository's Brewfile
    install_homebrew_formulae
    # Change default shcell to zsh
    change_default_shell_to_zsh
    # install oh-my-zsh
    install_oh_my_zsh
    # Installing pip packages so that setup_symlinks can setup the symlinks
    install_pip_packages
    # Installing yarn packages
    install_yarn_packages
    # Setting up symlinks so that setup_vim can install all plugins
    setup_symlinks
    # Setting up Vim
    setup_vim
    # Setting up tmux
    setup_tmux
    # Update /etc/hosts
    update_hosts_file
    # Setting up macOS defaults
    setup_macOS_defaults
    # Updating login items
    update_login_items
    # Install Cryptomator
    install_cryptomator
    # Install Keybase
    install_keybase
    # Install Keka
    install_keka
    # Install ePubee
    install_epubee
    # Restore application settings by mackup
    mackup_restore
}

DOTFILES_REPO=~/dotfiles

function ask_for_sudo() {
    info "Prompting for sudo password"
    if sudo --validate; then
        # Keep-alive
        while true; do sudo --non-interactive true; \
            sleep 10; kill -0 "$$" || exit; done 2>/dev/null &
        success "Sudo password updated"
    else
        error "Sudo password update failed"
        exit 1
    fi
}

function install_homebrew() {
    info "Installing Homebrew"
    if hash brew 2>/dev/null; then
        success "Homebrew already exists"
    else
        url=https://raw.githubusercontent.com/sam-hosseini/dotfiles/master/installers/homebrew_installer
        if /usr/bin/ruby -e "$(curl -fsSL ${url})"; then
            success "Homebrew installation succeeded"
        else
            error "Homebrew installation failed"
            exit 1
        fi
    fi
}

function clone_dotfiles_repo() {
    info "Cloning dotfiles repository into ${DOTFILES_REPO}"
    if test -e $DOTFILES_REPO; then
        substep "${DOTFILES_REPO} already exists"
        pull_latest $DOTFILES_REPO
        success "Pull successful in ${DOTFILES_REPO} repository"
    else
        url=https://github.com/nejads/dotfiles.git
        if git clone "$url" $DOTFILES_REPO && \
           git -C $DOTFILES_REPO remote set-url origin git@github.com:nejads/dotfiles.git; then
            success "Dotfiles repository cloned into ${DOTFILES_REPO}"
        else
            error "Dotfiles repository cloning failed"
            exit 1
        fi
    fi
}

function install_homebrew_formulae() {
    BREW_FILE_PATH="${DOTFILES_REPO}/brew/macOS.Brewfile"
    info "Installing packages within ${BREW_FILE_PATH}"
    if brew bundle check --file="$BREW_FILE_PATH" &> /dev/null; then
        success "Brewfile's dependencies are already satisfied "
    else
        if brew bundle --file="$BREW_FILE_PATH"; then
            success "Brewfile installation succeeded"
        else
            error "Brewfile installation failed"
            exit 1
        fi
    fi
}

function change_default_shell_to_zsh() {
    user=$(whoami)
    if sudo chsh -s /bin/zsh "$user"; then
        success "Zsh shell successfully set for \"${user}\""
    else
        error "Please try setting Zsh shell again"
    fi
}

function install_oh_my_zsh() {
    info "Installing Oh-my-zsh"
    if [ -f "/Users/$(whoami)/.oh-my-zsh/oh-my-zsh.sh" ]; then
            success "Oh-my-zsh already exists"
    else
        url=https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh
        if /bin/sh -c "$(curl -fsSL ${url})"; then
            success "Oh-my-zsh installation succeeded"
        else
            error "Oh-my-zsh installation failed"
            exit 1
        fi
    fi
}

function install_pip_packages() {
    pip_packages=(powerline-status requests tmuxp virtualenv mypy)
    info "Installing pip packages \"${pip_packages[*]}\""

    pip3_list_outcome=$(pip3 list)
    for package_to_install in "${pip_packages[@]}"
    do
        if echo "$pip3_list_outcome" | \
            grep --ignore-case "$package_to_install" &> /dev/null; then
            substep "\"${package_to_install}\" already exists"
        else
            if pip3 install "$package_to_install"; then
                substep "Package \"${package_to_install}\" installation succeeded"
            else
                error "Package \"${package_to_install}\" installation failed"
                exit 1
            fi
        fi
    done

    success "pip packages successfully installed"
}

function install_yarn_packages() {
    yarn_packages=(prettier typescript json vmd create-react-app gatsby-cli netlify-cli)
    info "Installing yarn packages \"${yarn_packages[*]}\""

    yarn_list_outcome=$(yarn global list)
    for package_to_install in "${yarn_packages[@]}"
    do
        if echo "$yarn_list_outcome" | \
            grep --ignore-case "$package_to_install" &> /dev/null; then
            substep "\"${package_to_install}\" already exists"
        else
            if yarn global add "$package_to_install"; then
                substep "Package \"${package_to_install}\" installation succeeded"
            else
                error "Package \"${package_to_install}\" installation failed"
                exit 1
            fi
        fi
    done

    success "yarn packages successfully installed"
}

function setup_symlinks() {
    APPLICATION_SUPPORT=~/Library/Application\ Support
    POWERLINE_ROOT_REPO=/usr/local/lib/python3.7/site-packages

    info "Setting up symlinks"
    symlink "git" ${DOTFILES_REPO}/git/gitconfig ~/.gitconfig
    symlink "gitignore" ${DOTFILES_REPO}/git/gitignore_global ~/.gitignore_global
    symlink "powerline" ${DOTFILES_REPO}/powerline ${POWERLINE_ROOT_REPO}/powerline/config_files
    symlink "tmux" ${DOTFILES_REPO}/tmux/tmux.conf ~/.tmux.conf
    symlink "vim" ${DOTFILES_REPO}/vim/vimrc ~/.vimrc
    symlink "zshrc" ${DOTFILES_REPO}/zsh/zshrc.zsh ~/.zshrc
    symlink "zshenv" ${DOTFILES_REPO}/zsh/env.zsh ~/.zshenv
    symlink "mackup" ${DOTFILES_REPO}/mackup/mackup.cfg ~/.mackup.cfg
    # TODO: symlink "hammerspoon" ${DOTFILES_REPO}/hammerspoon ~/.hammerspoon

    success "Symlinks successfully setup"
}

function setup_vim() {
    info "Setting up vim"
    substep "Installing Vundle"
    if test -e ~/.vim/bundle/Vundle.vim; then
        substep "Vundle already exists"
        pull_latest ~/.vim/bundle/Vundle.vim
        substep "Pull successful in Vundle's repository"
    else
        url=https://github.com/VundleVim/Vundle.vim.git
        if git clone "$url" ~/.vim/bundle/Vundle.vim; then
            substep "Vundle installation succeeded"
        else
            error "Vundle installation failed"
            exit 1
        fi
    fi
    substep "Installing all plugins"
    if vim +PluginInstall +qall 2> /dev/null; then
        substep "Plugins installations succeeded"
    else
        error "Plugins installations failed"
        exit 1
    fi
    success "vim successfully setup"
}

function setup_tmux() {
    info "Setting up tmux"
    substep "Installing tpm"
    if test -e ~/.tmux/plugins/tpm; then
        substep "tpm already exists"
        pull_latest ~/.tmux/plugins/tpm
        substep "Pull successful in tpm's repository"
    else
        url=https://github.com/tmux-plugins/tpm
        if git clone "$url" ~/.tmux/plugins/tpm; then
            substep "tpm installation succeeded"
        else
            error "tpm installation failed"
            exit 1
        fi
    fi

    substep "Installing all plugins"

    # sourcing .tmux.conf is necessary for tpm
    tmux source-file ~/.tmux.conf 2> /dev/null

    if ~/.tmux/plugins/tpm/bin/./install_plugins &> /dev/null; then
        substep "Plugins installations succeeded"
    else
        error "Plugins installations failed"
        exit 1
    fi
    success "tmux successfully setup"
}

function update_hosts_file() {
    info "Updating /etc/hosts"
    own_hosts_file_path=${DOTFILES_REPO}/hosts/own_hosts_file
    ignored_keywords_path=${DOTFILES_REPO}/hosts/ignored_keywords
    downloaded_hosts_file_path=/etc/downloaded_hosts_file
    downloaded_updated_hosts_file_path=/etc/downloaded_updated_hosts_file

    if sudo cp "${own_hosts_file_path}" /etc/hosts; then
        substep "Copying ${own_hosts_file_path} to /etc/hosts succeeded"
    else
        error "Copying ${own_hosts_file_path} to /etc/hosts failed"
        exit 1
    fi

    if sudo wget --quiet --output-document="${downloaded_hosts_file_path}" \
        https://someonewhocares.org/hosts/hosts; then
        substep "hosts file downloaded successfully"

        if ack --invert-match "$(cat ${ignored_keywords_path})" "${downloaded_hosts_file_path}" | \
            sudo tee "${downloaded_updated_hosts_file_path}" > /dev/null; then
            substep "Ignored patterns successfully removed from downloaded hosts file"
        else
            error "Failed to remove ignored patterns from downloaded hosts file"
            exit 1
        fi

        if cat "${downloaded_updated_hosts_file_path}" | \
            sudo tee -a /etc/hosts > /dev/null; then
            success "/etc/hosts updated"
        else
            error "Failed to update /etc/hosts"
            exit 1
        fi

    else
        error "Failed to download hosts file"
        exit 1
    fi
}

function setup_macOS_defaults() {
    info "Updating macOS defaults"

    current_dir=$(pwd)
    cd ${DOTFILES_REPO}/macOS
    if bash defaults.sh; then
        cd $current_dir
        success "macOS defaults updated successfully"
    else
        cd $current_dir
        error "macOS defaults update failed"
        exit 1
    fi
}

function update_login_items() {
    info "Updating login items"

    if osascript ${DOTFILES_REPO}/macOS/login_items.applescript &> /dev/null; then
        success "Login items updated successfully"
    else
        error "Login items update failed"
        exit 1
    fi
}

function install_cryptomator() {
    install_application "Cryptomator" "https://dl.bintray.com/cryptomator/cryptomator/1.4.15/Cryptomator-1.4.15.dmg"
}

function install_keybase() {
    install_application "Keybase" "https://prerelease.keybase.io/Keybase.dmg"
}

function install_keka() {
    install_application "Keka" "https://d.keka.io/"
}

function install_epubee() {
    install_from_zip "ePUBeeDRMRemoval" "http://download.epubee.com/epubee_v3.1.5.2.zip"
}

function mackup_restore() {
    info "Mackup using iCloud to restore your settings. Have you logged in iCloud?"
    run "Mackup restore" "mackup restore --force"
    success "Mackup restored."
}

################################
# Help functions
################################

function pull_latest() {
    substep "Pulling latest changes in ${1} repository"
    if git -C $1 pull origin master &> /dev/null; then
        return
    else
        error "Please pull latest changes in ${1} repository manually"
    fi
}

function symlink() {
    application=$1
    point_to=$2
    destination=$3
    destination_dir=$(dirname "$destination")

    if test ! -e "$destination_dir"; then
        substep "Creating ${destination_dir}"
        mkdir -p "$destination_dir"
    fi
    if rm -rf "$destination" && ln -s "$point_to" "$destination"; then
        substep "Symlinking for \"${application}\" done"
    else
        error "Symlinking for \"${application}\" failed"
        exit 1
    fi
}

function install_application() {
    name=$1
    url=$2
    applications_folder=/Applications
    application=/Applications/$name.app
    downloaded_file=~/Downloads/$name.dmg
    mount_folder=/Volumes/$name
    mounted_file=$mount_folder/${name}.app

    info "Installing ${name}"

    if test -e $application; then
        success "${application} already exists"
    else
        run "Download ${name}" "$(curl --location --silent --output ${downloaded_file} ${url})"
        run "Mount ${name}" "hdiutil attach -quiet -mountpoint ${mount_folder} ${downloaded_file}"
        run "Install ${name}" "cp -R ${mounted_file} ${applications_folder}"
        run "Unmount ${name}" "hdiutil unmount ${mounted_file}"
        run "Delete downloaded ${name}" "rm -rf ${downloaded_file}"

        success "${name} installed successfully."
    fi
}

function install_from_zip() {
    name=$1
    url=$2
    applications_folder=/Applications
    application=/Applications/$name.app
    downloaded_file=~/Downloads/$name.zip
    unziped_file=~/Downloads/$name.app

    info "Installing ${name}"

    if test -e $application; then
        success "${application} already exists"
    else
        run "Download ${name}" "$(curl --location --silent --output ${downloaded_file} ${url})"
        run "Unzip ${name}" "sudo unzip -oq ${downloaded_file} -d ${applications_folder}"
        run "Delete downloaded ${name}" "rm -rf ${downloaded_file}"

        success "${name} installed successfully."
    fi
}

function run() {
    command_name=$1
    command=$2
    if eval $command; then
        success "${command_name} succeeded"
    else
        error "${command_name} failed"
        exit 1
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
