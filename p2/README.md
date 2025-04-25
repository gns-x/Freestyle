# Part 2: Kubernetes Application Deployment

## 📋 Table of Contents
1. [Project Overview](#-project-overview)
2. [System Requirements](#-system-requirements)
3. [Directory Structure](#-directory-structure)
4. [Setup Process](#-setup-process)
5. [Component Details](#-component-details)
6. [Usage Guide](#-usage-guide)
7. [Troubleshooting](#-troubleshooting)
8. [Verification Steps](#-verification-steps)

## 🎯 Project Overview

This part of the project focuses on deploying applications on the K3s cluster we set up in Part 1. The main components include:

- Application deployment using Kubernetes manifests
- Service configuration and exposure
- Resource management and scaling
- Monitoring and logging setup
- Security configurations

### Key Features
- Automated deployment processes
- Service discovery and load balancing
- Resource optimization
- Monitoring and alerting
- Security best practices

## 💻 System Requirements

### Prerequisites
- Completed Part 1 setup
- Working K3s cluster
- kubectl configured
- Access to the cluster's kubeconfig

### Software Requirements
- kubectl
- helm (if needed)
- docker (for local development)
- git

## 📁 Directory Structure

```
p2/
├── manifests/           # Kubernetes manifests
│   ├── deployments/    # Deployment configurations
│   ├── services/       # Service definitions
│   ├── configmaps/     # Configuration files
│   └── secrets/        # Secret management
├── scripts/            # Automation scripts
├── monitoring/         # Monitoring setup
└── docs/              # Documentation
```

## 🔧 Setup Process

### 1. Initial Setup
```bash
# Navigate to the p2 directory
cd p2

# Create necessary directories
mkdir -p manifests/{deployments,services,configmaps,secrets} scripts monitoring docs
```

### 2. Cluster Verification
```bash
# Verify cluster access
kubectl cluster-info

# Check nodes
kubectl get nodes
```

### 3. Application Deployment
```bash
# Apply manifests
kubectl apply -f manifests/
```

## 📦 Component Details

### 1. Kubernetes Manifests
- Deployment configurations
- Service definitions
- ConfigMaps and Secrets
- Resource limits and requests

### 2. Monitoring Setup
- Metrics collection
- Logging configuration
- Alerting rules
- Dashboard setup

### 3. Security Configurations
- RBAC policies
- Network policies
- Secret management
- Pod security standards

## 🚀 Usage Guide

### Deploying Applications
```bash
# Apply all manifests
kubectl apply -f manifests/

# Check deployment status
kubectl get deployments

# View pod status
kubectl get pods
```

### Monitoring
```bash
# View cluster metrics
kubectl top nodes

# Check pod resource usage
kubectl top pods
```

### Scaling
```bash
# Scale deployments
kubectl scale deployment <deployment-name> --replicas=<number>
```

## 🔍 Verification Steps

### 1. Application Status
```bash
# Check deployments
kubectl get deployments

# View pods
kubectl get pods

# Check services
kubectl get services
```

### 2. Resource Usage
```bash
# Node resources
kubectl top nodes

# Pod resources
kubectl top pods
```

### 3. Logs
```bash
# View pod logs
kubectl logs <pod-name>
```

## ⚠️ Troubleshooting

### Common Issues

1. **Deployment Issues**
   - Check pod status
   - Review deployment events
   - Verify resource limits

2. **Service Connectivity**
   - Check service endpoints
   - Verify network policies
   - Test service access

3. **Resource Problems**
   - Monitor resource usage
   - Check for resource limits
   - Review node capacity

### Debugging Steps

1. **Check Pod Status**
```bash
# Get detailed pod information
kubectl describe pod <pod-name>

# View pod logs
kubectl logs <pod-name>
```

2. **Service Verification**
```bash
# Check service details
kubectl describe service <service-name>

# Test service connectivity
kubectl port-forward service/<service-name> <local-port>:<service-port>
```

3. **Resource Monitoring**
```bash
# Check resource usage
kubectl top pods
kubectl top nodes
```

## 🔄 Maintenance

### Regular Checks
- Monitor application health
- Check resource utilization
- Review security policies
- Update configurations

### Backup
- Backup configurations
- Document changes
- Version control manifests

## 📚 Additional Resources

### Documentation
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [K3s Documentation](https://docs.k3s.io/)
- [Helm Documentation](https://helm.sh/docs/)

### Tools
- kubectl
- helm
- k9s
- lens

## 🎓 Learning Points

### Key Concepts
- Kubernetes Deployments
- Service Discovery
- Resource Management
- Monitoring and Logging
- Security Best Practices

### Skills Developed
- Kubernetes Operations
- Application Deployment
- Resource Optimization
- Monitoring Setup
- Security Configuration 