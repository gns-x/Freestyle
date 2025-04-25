# Bonus: GitLab Integration

This part of the project adds GitLab to the existing Kubernetes setup, integrating it with Argo CD for a complete CI/CD pipeline.

## Table of Contents
1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Architecture](#architecture)
4. [Directory Structure](#directory-structure)
5. [Installation](#installation)
6. [Configuration](#configuration)
7. [Usage](#usage)
8. [Integration with Argo CD](#integration-with-argo-cd)
9. [Troubleshooting](#troubleshooting)
10. [Cleanup](#cleanup)

## Overview

This implementation adds:
- GitLab instance running in Kubernetes
- Integration with existing Argo CD setup
- Local Git repository management
- CI/CD pipeline capabilities

## Prerequisites

- Completed Part 3 of the project
- Helm installed
- Sufficient system resources (recommended: 4GB RAM, 2 CPU cores)
- Docker Desktop running

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

## Directory Structure

```
bonus/
├── scripts/
│   └── install.sh      # Installation script for GitLab
├── confs/              # Configuration files
├── Makefile           # Automation commands
└── README.md          # This documentation
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
1. Installs Helm (if not present)
2. Adds GitLab Helm repository
3. Creates GitLab namespace
4. Installs GitLab using Helm
5. Sets up port forwarding
6. Configures initial settings

## Configuration

### GitLab Configuration
- Namespace: gitlab
- Web Interface: http://localhost:8080
- Default credentials:
  - Username: root
  - Password: (generated during installation)

### Integration Settings
- Argo CD integration enabled
- Local repository support
- CI/CD pipeline configuration

## Usage

### Accessing GitLab
1. Start port forwarding:
   ```bash
   make gitlab-port-forward
   ```

2. Access the web interface:
   - URL: http://localhost:8080
   - Username: root
   - Password: (from installation output)

### Managing GitLab

#### View Status
```bash
make status
```

#### Check Connection
```bash
make gitlab-info
```

## Integration with Argo CD

1. Create a new project in GitLab
2. Configure Argo CD to use GitLab repository:
   - Update repository URL in Argo CD
   - Configure authentication
   - Set up webhooks for automatic sync

## Troubleshooting

### Common Issues

1. **GitLab not starting**
   ```bash
   make check-gitlab
   ```

2. **Port forwarding issues**
   ```bash
   make gitlab-port-forward
   ```

3. **Integration problems**
   - Check Argo CD configuration
   - Verify GitLab repository settings
   - Test webhook connections

### Logs
- GitLab logs: `kubectl logs -n gitlab -l app=gitlab`
- Integration logs: `kubectl logs -n argocd -l app.kubernetes.io/name=argocd-server`

## Cleanup

### Full Cleanup
```bash
make clean
```

### Partial Cleanup
- Clean GitLab: `kubectl delete namespace gitlab`
- Clean Helm release: `helm uninstall gitlab -n gitlab`

## Security Considerations

1. **GitLab Security**
   - Change default root password
   - Configure proper access controls
   - Set up SSL if needed

2. **Integration Security**
   - Secure repository access
   - Configure proper authentication
   - Set up webhook security

## Performance Considerations

1. **Resource Allocation**
   - Monitor GitLab resource usage
   - Adjust resource limits as needed
   - Consider persistence for production use

2. **Network Performance**
   - Optimize local network settings
   - Configure proper port forwarding
   - Monitor integration performance

## Maintenance

### Regular Tasks
1. Update GitLab
2. Monitor resource usage
3. Check integration status
4. Backup configurations

### Backup and Recovery
1. Export GitLab configurations
2. Backup repository data
3. Document integration settings 