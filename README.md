# Inception-of-Things (IoT) - System Administration with K3d and K3s

This project implements a complete Kubernetes-based infrastructure using K3d and K3s, with GitLab integration for CI/CD capabilities.

## Table of Contents
1. [Project Overview](#project-overview)
2. [Architecture](#architecture)
3. [Prerequisites](#prerequisites)
4. [Part 3: K3d and K3s Setup](#part-3-k3d-and-k3s-setup)
5. [Bonus: GitLab Integration](#bonus-gitlab-integration)
6. [Usage Guide](#usage-guide)
7. [Troubleshooting](#troubleshooting)
8. [Cleanup](#cleanup)

## Project Overview

This project consists of two main parts:
1. **Part 3**: Setting up a local Kubernetes cluster using K3d and K3s
2. **Bonus**: Integrating GitLab for CI/CD capabilities

### Key Features
- Local Kubernetes cluster using K3d
- K3s lightweight Kubernetes distribution
- Argo CD for GitOps
- GitLab for source code management and CI/CD
- Automated deployment scripts
- Comprehensive monitoring and logging

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Local Development                     │
│                                                         │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐  │
│  │  K3d        │    │  GitLab     │    │  Argo CD    │  │
│  │  Cluster    │◄──►│  Instance   │◄──►│  Server     │  │
│  └─────────────┘    └─────────────┘    └─────────────┘  │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

## Prerequisites

- Docker Desktop
- kubectl
- Helm
- K3d
- Git
- Sufficient system resources (recommended: 8GB RAM, 4 CPU cores)

## Part 3: K3d and K3s Setup

### Directory Structure
```
p3/
├── scripts/
│   ├── install.sh          # Main installation script
│   ├── setup_k3d.sh        # K3d cluster setup
│   ├── setup_k3s.sh        # K3s installation
│   └── setup_networking.sh # Network configuration
├── confs/
│   └── k3d-config.yaml     # K3d configuration
├── Makefile                # Automation commands
└── README.md              # Documentation
```

### Installation Steps

1. **Setup K3d Cluster**
   ```bash
   cd p3
   make setup-k3d
   ```
   This creates a local K3d cluster with:
   - 3 worker nodes
   - Custom networking
   - Load balancer
   - Ingress controller

2. **Install K3s**
   ```bash
   make setup-k3s
   ```
   Installs K3s on the cluster with:
   - Lightweight Kubernetes distribution
   - Built-in container runtime
   - Automatic TLS management

3. **Configure Networking**
   ```bash
   make setup-networking
   ```
   Sets up:
   - Network policies
   - Service mesh
   - Ingress rules

4. **Deploy Applications**
   ```bash
   make deploy
   ```
   Deploys:
   - Argo CD
   - Monitoring stack
   - Sample applications

### Accessing the Cluster

1. **Argo CD**
   ```bash
   make argocd-info
   ```
   - URL: http://localhost:8080
   - Username: admin
   - Password: (generated during installation)

2. **Cluster Status**
   ```bash
   make status
   ```
   Shows:
   - Node status
   - Pod status
   - Service status

## Bonus: GitLab Integration

### Directory Structure
```
bonus/
├── scripts/
│   └── install.sh      # GitLab installation script
├── confs/              # Configuration files
├── Makefile           # Automation commands
└── README.md          # Documentation
```

### Installation Steps

1. **Install GitLab**
   ```bash
   cd bonus
   make install
   ```
   This:
   - Installs Helm (if not present)
   - Adds GitLab Helm repository
   - Creates GitLab namespace
   - Installs GitLab components
   - Sets up port forwarding

2. **Access GitLab**
   ```bash
   make gitlab-info
   ```
   - URL: http://localhost:8080
   - Username: root
   - Password: (generated during installation)

### Integration with Argo CD

1. Create a new project in GitLab
2. Configure Argo CD to use GitLab repository:
   - Update repository URL
   - Configure authentication
   - Set up webhooks

## Usage Guide

### Common Commands

#### Part 3 Commands
```bash
make setup-k3d          # Setup K3d cluster
make setup-k3s          # Install K3s
make setup-networking   # Configure networking
make deploy            # Deploy applications
make status            # Check cluster status
make argocd-info       # Show Argo CD credentials
```

#### Bonus Commands
```bash
make install           # Install GitLab
make status           # Check GitLab status
make gitlab-info      # Show GitLab credentials
make gitlab-port-forward # Start port forwarding
```

### Monitoring

1. **Cluster Monitoring**
   ```bash
   kubectl get nodes
   kubectl get pods -A
   kubectl get svc -A
   ```

2. **Application Monitoring**
   - Argo CD dashboard
   - GitLab monitoring
   - Kubernetes dashboard

## Troubleshooting

### Common Issues

1. **K3d Cluster Issues**
   ```bash
   k3d cluster list
   k3d cluster start
   k3d cluster stop
   ```

2. **GitLab Issues**
   ```bash
   make check-gitlab
   make gitlab-port-forward
   ```

3. **Network Issues**
   ```bash
   kubectl get networkpolicies -A
   kubectl get ingress -A
   ```

### Logs
```bash
# K3d logs
k3d cluster logs

# GitLab logs
kubectl logs -n gitlab -l app=gitlab

# Argo CD logs
kubectl logs -n argocd -l app.kubernetes.io/name=argocd-server
```

## Cleanup

### Full Cleanup
```bash
# Part 3 cleanup
cd p3
make clean

# Bonus cleanup
cd bonus
make clean
```

### Partial Cleanup
```bash
# Clean K3d cluster
k3d cluster delete

# Clean GitLab
kubectl delete namespace gitlab
helm uninstall gitlab -n gitlab
```

## Security Considerations

1. **Cluster Security**
   - Network policies
   - RBAC configuration
   - TLS management
   - Secret management

2. **GitLab Security**
   - Change default passwords
   - Configure access controls
   - Set up SSL
   - Regular updates

3. **Argo CD Security**
   - Secure repository access
   - Configure authentication
   - Set up webhook security

## Performance Optimization

1. **Resource Management**
   - Monitor resource usage
   - Adjust resource limits
   - Configure persistence
   - Optimize networking

2. **Best Practices**
   - Regular backups
   - Monitoring setup
   - Log management
   - Update procedures

## Maintenance

### Regular Tasks
1. Update Kubernetes components
2. Monitor resource usage
3. Check security patches
4. Backup configurations
5. Review logs

### Backup and Recovery
1. Export configurations
2. Backup persistent data
3. Document procedures
4. Test recovery process