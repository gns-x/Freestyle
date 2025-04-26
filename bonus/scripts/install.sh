#!/bin/bash

# Exit on error
set -e

# Variables
GITLAB_NAMESPACE="gitlab"
GITLAB_RELEASE="gitlab"
GITLAB_CHART_VERSION="7.10.0"  # Latest stable version
TIMEOUT=1200  # 20 minutes timeout

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

# Create values file for GitLab with fixes
cat > gitlab-values.yaml << EOF
global:
  hosts:
    domain: localhost
    https: false
  ingress:
    configureCertmanager: false
    class: traefik
    enabled: false
  minio:
    enabled: false
  appConfig:
    artifacts:
      enabled: false
    lfs:
      enabled: false
    uploads:
      enabled: false
    packages:
      enabled: false
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
    auth:
      enabled: false
  shell:
    port: 32022
  workhorse:
    port: 8181
  kas:
    enabled: false
  pages:
    enabled: false
  registry:
    enabled: false
  praefect:
    enabled: false
  spamcheck:
    enabled: false
  webservice:
    extraEnv:
      GITLAB_OMNIBUS_CONFIG: |
        gitlab_rails['gitlab_shell_ssh_port'] = 32022
gitlab:
  gitaly:
    persistence:
      enabled: false
    resources:
      requests:
        memory: 200Mi
        cpu: 100m
      limits:
        memory: 400Mi
        cpu: 200m
    replicas: 1
    startupProbe:
      enabled: false
    livenessProbe:
      enabled: false
    readinessProbe:
      enabled: false
  gitlab-shell:
    service:
      type: ClusterIP
      port: 32022
  webservice:
    service:
      type: ClusterIP
      port: 8181
    resources:
      requests:
        memory: 200Mi
        cpu: 100m
      limits:
        memory: 400Mi
        cpu: 200m
    replicas: 1
    startupProbe:
      enabled: false
    livenessProbe:
      enabled: false
    readinessProbe:
      enabled: false
    extraEnv:
      GITLAB_OMNIBUS_CONFIG: |
        gitlab_rails['gitlab_shell_ssh_port'] = 32022
    init:
      resources:
        requests:
          memory: 100Mi
          cpu: 50m
        limits:
          memory: 200Mi
          cpu: 100m
  sidekiq:
    persistence:
      enabled: false
    resources:
      requests:
        memory: 100Mi
        cpu: 50m
      limits:
        memory: 200Mi
        cpu: 100m
    replicas: 1
    startupProbe:
      enabled: false
    livenessProbe:
      enabled: false
    readinessProbe:
      enabled: false
    init:
      resources:
        requests:
          memory: 100Mi
          cpu: 50m
        limits:
          memory: 200Mi
          cpu: 100m
  toolbox:
    enabled: false
postgresql:
  persistence:
    enabled: false
  resources:
    requests:
      memory: 100Mi
      cpu: 50m
    limits:
      memory: 200Mi
      cpu: 100m
  primary:
    podAnnotations:
      "cluster-autoscaler.kubernetes.io/safe-to-evict": "true"
    startupProbe:
      enabled: false
    livenessProbe:
      enabled: false
    readinessProbe:
      enabled: false
redis:
  master:
    persistence:
      enabled: false
    resources:
      requests:
        memory: 100Mi
        cpu: 50m
      limits:
        memory: 200Mi
        cpu: 100m
    podAnnotations:
      "cluster-autoscaler.kubernetes.io/safe-to-evict": "true"
    startupProbe:
      enabled: false
    livenessProbe:
      enabled: false
    readinessProbe:
      enabled: false
nginx-ingress:
  enabled: false
certmanager:
  install: false
prometheus:
  install: false
gitlab-runner:
  install: false
EOF

# Install GitLab
echo "Installing GitLab..."
helm upgrade --install $GITLAB_RELEASE gitlab/gitlab \
  --namespace $GITLAB_NAMESPACE \
  --version $GITLAB_CHART_VERSION \
  -f gitlab-values.yaml \
  --timeout ${TIMEOUT}s \
  --wait

# Wait for GitLab to be ready
echo "Waiting for GitLab to be ready..."
echo "This may take a few minutes..."

# Function to check deployment status
check_deployment_status() {
    local deployment=$1
    local status=$(kubectl get deployment -n $GITLAB_NAMESPACE $deployment -o jsonpath='{.status.conditions[?(@.type=="Available")].status}' 2>/dev/null)
    echo $status
}

# Function to check pod status
check_pod_status() {
    local deployment=$1
    local pod_name=$(kubectl get pod -n $GITLAB_NAMESPACE -l app=$deployment -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)
    if [ -n "$pod_name" ]; then
        local status=$(kubectl get pod -n $GITLAB_NAMESPACE $pod_name -o jsonpath='{.status.phase}' 2>/dev/null)
        echo $status
    else
        echo "No pod found"
    fi
}

# Function to get pod events
get_pod_events() {
    local deployment=$1
    local pod_name=$(kubectl get pod -n $GITLAB_NAMESPACE -l app=$deployment -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)
    if [ -n "$pod_name" ]; then
        kubectl describe pod -n $GITLAB_NAMESPACE $pod_name | grep -A 10 Events:
    fi
}

# Function to get pod logs
get_pod_logs() {
    local deployment=$1
    local pod_name=$(kubectl get pod -n $GITLAB_NAMESPACE -l app=$deployment -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)
    if [ -n "$pod_name" ]; then
        kubectl logs -n $GITLAB_NAMESPACE $pod_name --tail=50
    fi
}

# Wait for deployments to be ready with detailed status
for deployment in gitlab-webservice-default gitlab-sidekiq-all-in-1-v2; do
    echo "Waiting for $deployment to be ready..."
    start_time=$(date +%s)
    
    # First wait for the deployment to be created
    echo "Waiting for deployment $deployment to be created..."
    while ! kubectl get deployment -n $GITLAB_NAMESPACE $deployment &>/dev/null; do
        current_time=$(date +%s)
        elapsed_time=$((current_time - start_time))
        
        if [ $elapsed_time -gt $TIMEOUT ]; then
            echo "Timeout waiting for deployment $deployment to be created"
            echo "Current cluster status:"
            kubectl get all -n $GITLAB_NAMESPACE
            exit 1
        fi
        
        echo "Deployment not created yet... (${elapsed_time}s elapsed)"
        sleep 10
    done
    
    # Now wait for the deployment to be available
    while true; do
        current_time=$(date +%s)
        elapsed_time=$((current_time - start_time))
        
        if [ $elapsed_time -gt $TIMEOUT ]; then
            echo "Timeout waiting for $deployment"
            echo "Current deployment status:"
            kubectl describe deployment -n $GITLAB_NAMESPACE $deployment
            echo "Pod events:"
            get_pod_events $deployment
            echo "Pod logs:"
            get_pod_logs $deployment
            exit 1
        fi
        
        deployment_status=$(check_deployment_status $deployment)
        pod_status=$(check_pod_status $deployment)
        
        echo "Deployment status: $deployment_status"
        echo "Pod status: $pod_status"
        echo "Waiting... (${elapsed_time}s elapsed)"
        
        if [ "$deployment_status" == "True" ]; then
            echo "$deployment is ready!"
            break
        fi
        
        sleep 30
    done
done

# Get GitLab root password
echo "GitLab root password:"
kubectl get secret gitlab-gitlab-initial-root-password -n $GITLAB_NAMESPACE -o jsonpath="{.data.password}" | base64 -d
echo

# Create port forwarding
echo "Setting up port forwarding..."
kubectl port-forward svc/gitlab-webservice-default -n $GITLAB_NAMESPACE 8080:8181 &

echo "GitLab installation completed!"
echo "Access GitLab at: http://localhost:8080"
echo "Username: root"
echo "Password: (see above)" 