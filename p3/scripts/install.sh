#!/bin/bash

# Exit on error
set -e

# Detect OS
OS=$(uname -s)

# Install Docker if not already installed
if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    if [ "$OS" = "Darwin" ]; then
        # macOS
        if ! command -v brew &> /dev/null; then
            echo "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        echo "Installing Docker Desktop..."
        brew install --cask docker
        echo "Please open Docker Desktop application and start it"
        echo "After Docker Desktop is running, press Enter to continue..."
        read
    else
        # Linux
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        sudo usermod -aG docker $USER
        rm get-docker.sh
    fi
fi

# Verify Docker is running
if ! docker info &> /dev/null; then
    echo "Docker is not running. Please start Docker Desktop and try again."
    exit 1
fi

# Install kubectl if not already installed
if ! command -v kubectl &> /dev/null; then
    echo "Installing kubectl..."
    if [ "$OS" = "Darwin" ]; then
        brew install kubectl
    else
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
        sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
        rm kubectl
    fi
fi

# Install K3d if not already installed
if ! command -v k3d &> /dev/null; then
    echo "Installing K3d..."
    if [ "$OS" = "Darwin" ]; then
        brew install k3d
    else
        curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
    fi
fi

# Create K3d cluster
echo "Creating K3d cluster..."
k3d cluster create iot-cluster --api-port 6550 -p "8888:80@loadbalancer"

# Install Argo CD
echo "Installing Argo CD..."
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for Argo CD to be ready
echo "Waiting for Argo CD to be ready..."
kubectl wait --for=condition=available deployment/argocd-server -n argocd --timeout=300s

# Get Argo CD admin password
echo "Argo CD admin password:"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
echo

# Create dev namespace
kubectl create namespace dev

echo "Installation completed successfully!" 