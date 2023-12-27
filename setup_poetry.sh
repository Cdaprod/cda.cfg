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

# Install Python3 and pip3
log "Installing Python3 and pip3..."
apt install -y python3 python3-pip

# Install Poetry
log "Installing Poetry..."
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python3

# Clone the repository containing the Python project
log "Cloning the Python project repository..."
git clone [Your-Python-Project-Repo-URL] $HOME/python-project
cd $HOME/python-project

# Install project dependencies using Poetry
log "Installing project dependencies using Poetry..."
poetry install

# (Optional) Build the project if necessary
# poetry build

# Deploy the project to Kubernetes
log "Deploying the project to Kubernetes..."
kubectl apply -f kubernetes/deployment.yaml

# Verify the deployment
log "Verifying deployment..."
kubectl get deployments

log "Python environment with Poetry deployment completed successfully."