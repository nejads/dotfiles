#!/bin/bash
# setup.sh - Ubuntu 24 dotfiles bootstrap

set -e

install_dependencies() {
  echo "Installing system dependencies..."
  sudo apt update
  sudo apt install -y software-properties-common git python3 python3-pip python3-venv
}

install_ansible() {
  echo "Checking if Ansible is installed..."
  if command -v ansible &>/dev/null; then
    echo "Ansible is already installed."
  else
    echo "Installing Ansible..."
    sudo apt-add-repository --yes --update ppa:ansible/ansible
    sudo apt install -y ansible
  fi
}

manage_dotfiles() {
  echo "Managing dotfiles repository..."
  DOTFILES_DIR="$HOME/dotfiles"
  if [ -d "$DOTFILES_DIR" ]; then
    echo "Dotfiles repository exists. Pulling latest changes..."
    cd "$DOTFILES_DIR" || exit
    git pull origin ubuntu
  else
    echo "Dotfiles repository not found. Cloning..."
    git clone -b ubuntu https://github.com/nejads/dotfiles.git "$DOTFILES_DIR"
  fi
}

echo "Starting Ubuntu dotfiles setup..."
install_dependencies
install_ansible
manage_dotfiles

echo ""
echo "Setup complete! Run the playbook with:"
echo "  cd ~/dotfiles && ansible-playbook -K playbooks/bootstrap.yaml"
echo ""
echo "Or run specific roles with tags:"
echo "  ansible-playbook -K playbooks/bootstrap.yaml --tags zsh,git,tmux"
