#!/bin/bash

# Exit on error
set -e

# Variables
GITLAB_NAMESPACE="gitlab"
GITLAB_RELEASE="gitlab"
GITLAB_CHART_VERSION="7.10.0"  # Latest stable version

# Check if Helm is installed
if ! command -v helm &> /dev/null; then
    echo "Installing Helm..."
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh
    rm get_helm.sh
fi

# Add GitLab Helm repository
echo "Adding GitLab Helm repository..."
helm repo add gitlab https://charts.gitlab.io/
helm repo update

# Create GitLab namespace
echo "Creating GitLab namespace..."
kubectl create namespace $GITLAB_NAMESPACE || true

# Create values file for GitLab
cat > gitlab-values.yaml << EOF
global:
  hosts:
    domain: localhost
    https: false
  ingress:
    configureCertmanager: false
  minio:
    enabled: false
  appConfig:
    object_store:
      enabled: false
  gitaly:
    persistence:
      enabled: false
  psql:
    host: postgresql
    password:
      secret: gitlab-postgres
      key: postgresql-password
  redis:
    password:
      enabled: false
  shell:
    port: 32022
  workhorse:
    port: 8181
gitlab:
  gitlab-shell:
    service:
      type: ClusterIP
      port: 32022
  webservice:
    service:
      type: ClusterIP
      port: 8181
  sidekiq:
    persistence:
      enabled: false
  toolbox:
    persistence:
      enabled: false
  gitaly:
    persistence:
      enabled: false
postgresql:
  persistence:
    enabled: false
redis:
  master:
    persistence:
      enabled: false
nginx-ingress:
  enabled: true
  controller:
    service:
      type: ClusterIP
certmanager:
  install: false
prometheus:
  install: false
EOF

# Install GitLab
echo "Installing GitLab..."
helm upgrade --install $GITLAB_RELEASE gitlab/gitlab \
  --namespace $GITLAB_NAMESPACE \
  --version $GITLAB_CHART_VERSION \
  -f gitlab-values.yaml \
  --timeout 600s

# Wait for GitLab to be ready
echo "Waiting for GitLab to be ready..."
kubectl wait --for=condition=available deployment/gitlab-webservice -n $GITLAB_NAMESPACE --timeout=300s

# Get GitLab root password
echo "GitLab root password:"
kubectl get secret gitlab-gitlab-initial-root-password -n $GITLAB_NAMESPACE -o jsonpath="{.data.password}" | base64 -d
echo

# Create port forwarding
echo "Setting up port forwarding..."
kubectl port-forward svc/gitlab-webservice -n $GITLAB_NAMESPACE 8080:8181 &

echo "GitLab installation completed!"
echo "Access GitLab at: http://localhost:8080"
echo "Username: root"
echo "Password: (see above)" 