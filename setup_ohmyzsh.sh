#!/bin/bash

# Ensure script is run as a normal user, not root
if [ "$EUID" -eq 0 ]; then 
  echo "Please run as a normal user, not root"
  exit
fi

# Define home directory
HOME_DIR=$HOME

# Install Oh My Zsh
echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install JetBrains Mono Nerd Font
echo "Installing JetBrains Mono Nerd Font..."
brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono-nerd-font

# Clone Powerlevel10k
echo "Cloning Powerlevel10k theme..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME_DIR/.oh-my-zsh/custom}/themes/powerlevel10k

# Configure Zsh to use Powerlevel10k
echo "Configuring Zsh to use Powerlevel10k..."
echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> $HOME_DIR/.zshrc

# Reload Zsh configuration
echo "Reloading Zsh configuration..."
source $HOME_DIR/.zshrc

echo "Setup complete."
