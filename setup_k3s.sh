#!/bin/bash

# Function to log messages
log() {
    echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*"
}

# Check if running as root
if [ "$(id -u)" != "0" ]; then
   log "This script must be run as root" 1>&2
   exit 1
fi

# Update and upgrade packages
log "Updating and upgrading packages..."
apt update && apt upgrade -y

# Install necessary dependencies
log "Installing necessary dependencies..."
apt install -y git curl

# Initialize the Kubernetes cluster (assuming you're using k3s for simplicity)
log "Installing Kubernetes (k3s)..."
curl -sfL https://get.k3s.io | sh -

# Verify Kubernetes is installed
log "Verifying Kubernetes installation..."
kubectl cluster-info

# Clone your configuration repository
log "Cloning configuration repository..."
git clone https://github.com/Cdaprod/cda.cfg.git $HOME/cda-config
cd $HOME/cda-config

# Apply Kubernetes configurations
log "Applying Kubernetes configurations..."
kubectl apply -f kubernetes/

# Additional configurations (network, storage, etc.)
# ...

log "Deployment completed successfully."