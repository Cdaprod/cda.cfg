#!/bin/bash

# Initialize the bare Git repository for dotfiles
git init --bare $HOME/.cfg

# Add 'cfg' alias to the shell configuration
echo "alias cfg='/usr/bin/git --git-dir=\$HOME/.cfg/ --work-tree=\$HOME'" >> $HOME/.bashrc
source $HOME/.bashrc

# Add the remote repository
cfg remote add origin https://github.com/Cdaprod/cda.cfg.git

# Optional: Check out a specific branch
# cfg checkout linode/cdaprod-config
