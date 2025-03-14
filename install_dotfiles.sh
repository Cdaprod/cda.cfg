# See @main /README.md

#!/bin/bash
set -e

# Detect system arch and hostname
ARCH=$(uname -m)
HOSTNAME=$(hostname)
BRANCH="@${HOSTNAME}/${ARCH}"

echo "Detected system: $HOSTNAME ($ARCH)"
echo "Checking out branch: $BRANCH"

# Clone dotfiles repo if not present
if [ ! -d "$HOME/.dotfiles" ]; then
    git clone --bare https://github.com/Cdaprod/cda.cfg.git "$HOME/.dotfiles"
fi

# Define dotfiles alias
alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

# Checkout the correct branch
dot fetch origin
if dot branch -r | grep -q "origin/$BRANCH"; then
    dot checkout "$BRANCH"
else
    echo "Branch $BRANCH not found, defaulting to main"
    dot checkout main
fi

# Apply updates
dot pull origin "$BRANCH" || true
dot submodule update --init --recursive

echo "Dotfiles successfully applied from branch: $BRANCH"