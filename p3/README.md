# Part 3: K3d and Argo CD

This part of the project focuses on setting up a Kubernetes development environment using K3d and implementing continuous deployment with Argo CD.

## Table of Contents
1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Architecture](#architecture)
4. [Directory Structure](#directory-structure)
5. [Installation](#installation)
6. [Configuration](#configuration)
7. [Usage](#usage)
8. [Testing](#testing)
9. [Troubleshooting](#troubleshooting)
10. [Cleanup](#cleanup)

## Overview

This implementation sets up:
- A local Kubernetes cluster using K3d
- Argo CD for continuous deployment
- A sample application (Wil's playground) with version management
- Automated deployment pipeline

## Prerequisites

- macOS or Linux system
- Docker Desktop installed and running
- Git installed
- Internet connection
- Sudo privileges (for Linux systems)

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Local Development                     │
│                                                         │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐  │
│  │  K3d        │    │  Argo CD    │    │  Playground │  │
│  │  Cluster    │◄──►│  Server     │◄──►│  App        │  │
│  └─────────────┘    └─────────────┘    └─────────────┘  │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Components:
1. **K3d Cluster**: Lightweight Kubernetes distribution running in Docker containers
2. **Argo CD**: GitOps continuous delivery tool for Kubernetes
3. **Playground Application**: Sample application with two versions (v1 and v2)

## Directory Structure

```
p3/
├── scripts/
│   └── install.sh      # Installation script for K3d and dependencies
├── confs/
│   ├── application.yaml # Argo CD application configuration
│   └── deployment.yaml  # Playground application deployment
├── Makefile            # Automation commands
└── README.md           # This documentation
```

## Installation

### Automated Installation
```bash
make install
```

### Manual Installation Steps
1. Make the installation script executable:
   ```bash
   chmod +x scripts/install.sh
   ```

2. Run the installation script:
   ```bash
   ./scripts/install.sh
   ```

The installation process:
1. Installs Docker (if not present)
2. Installs kubectl
3. Installs K3d
4. Creates a K3d cluster
5. Installs Argo CD
6. Creates necessary namespaces
7. Sets up the playground application

## Configuration

### K3d Cluster Configuration
- Cluster name: iot-cluster
- API port: 6550
- Application port: 8888
- Load balancer configuration

### Argo CD Configuration
- Namespace: argocd
- Admin credentials:
  - Username: admin
  - Password: (generated during installation)

### Application Configuration
- Namespace: dev
- Image: wil42/playground
- Versions: v1 and v2
- Port: 8888

## Usage

### Accessing Argo CD
1. Start port forwarding:
   ```bash
   make argocd-port-forward
   ```

2. Access the web interface:
   - URL: https://localhost:8080
   - Username: admin
   - Password: (from installation output)

### Managing the Application

#### View Application Status
```bash
make status
```

#### Switch Application Version
1. Edit `confs/deployment.yaml`
2. Change the image tag (v1 or v2)
3. Commit and push changes
4. Argo CD will automatically update the deployment

#### Access the Application
```bash
make test-app
```

## Testing

### Automated Testing
```bash
make test
```

### Manual Testing Steps
1. Verify K3d cluster:
   ```bash
   make check-cluster
   ```

2. Verify Argo CD:
   ```bash
   make check-argocd
   ```

3. Test application access:
   ```bash
   make test-app
   ```

## Troubleshooting

### Common Issues

1. **Docker not running**
   ```bash
   make check-docker
   ```

2. **K3d cluster issues**
   ```bash
   make reset-cluster
   ```

3. **Argo CD sync issues**
   ```bash
   make argocd-sync
   ```

4. **Application not accessible**
   ```bash
   make check-app
   ```

### Logs
- K3d logs: `make logs-k3d`
- Argo CD logs: `make logs-argocd`
- Application logs: `make logs-app`

## Cleanup

### Full Cleanup
```bash
make clean
```

### Partial Cleanup
- Clean K3d cluster: `make clean-cluster`
- Clean Argo CD: `make clean-argocd`
- Clean application: `make clean-app`

## Security Considerations

1. **Docker Security**
   - Docker daemon should be running with appropriate security settings
   - Regular updates should be applied

2. **Kubernetes Security**
   - RBAC is properly configured
   - Network policies are in place
   - Resource limits are set

3. **Argo CD Security**
   - Admin password is properly managed
   - Git repository access is secured
   - RBAC is configured

## Performance Considerations

1. **Resource Allocation**
   - Docker Desktop: Minimum 4GB RAM, 2 CPU cores
   - K3d cluster: Configured with appropriate resources
   - Application: Resource limits and requests set

2. **Network Performance**
   - Local network configuration optimized
   - Port forwarding properly configured
   - Load balancer settings appropriate

## Maintenance

### Regular Tasks
1. Update Docker and K3d
2. Monitor cluster health
3. Check Argo CD sync status
4. Verify application performance

### Backup and Recovery
1. Configuration files are version controlled
2. Cluster state can be recreated
3. Application state is managed by Argo CD

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make changes
4. Submit a pull request

## License

This project is part of the Inception-of-Things exercise. 