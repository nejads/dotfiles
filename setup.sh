#!/bin/bash
# setup.sh

# Function to install Homebrew if not already installed
install_homebrew() {
  echo "Checking if Homebrew is installed..."

  # Check if Homebrew is already installed
  if command -v brew &>/dev/null; then
    echo "Homebrew is already installed."
  else
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
}

# Function to clone or pull the dotfiles repository
manage_dotfiles() {
  echo "Managing dotfiles repository..."

  # Define the target directory for the dotfiles
  DOTFILES_DIR="$HOME/dotfiles"

  # Check if the dotfiles repo already exists
  if [ -d "$DOTFILES_DIR" ]; then
    echo "Dotfiles repository exists. Pulling latest changes..."
    cd "$DOTFILES_DIR" || exit
    git pull origin main
  else
    echo "Dotfiles repository not found. Cloning..."
    git clone https://github.com/nejads/dotfiles.git "$DOTFILES_DIR"
  fi
}

# Function to install formulae if not already installed
install_formulae() {
  echo "Checking if required formulae are installed..."

  # Check if ansible is installed
  if ! command -v ansible &>/dev/null; then
    echo "Ansible is not installed. Installing..."
    brew install ansible
  else
    echo "Ansible is already installed."
  fi

  # Check if python3 is installed
  if ! command -v python3 &>/dev/null; then
    echo "Python3 is not installed. Installing..."
    brew install python3
  else
    echo "Python3 is already installed."
  fi
}

# Main script execution
echo "Starting setup..."

# Install Homebrew (only if not already installed)
install_homebrew

# Clone or update the dotfiles repository
manage_dotfiles

# Install the required formulae (if not already installed)
install_formulae

echo "Setup completed!"
