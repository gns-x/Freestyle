# Part 1: K3s and Vagrant Setup Documentation

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

This part of the project sets up a K3s Kubernetes cluster using Vagrant. The cluster consists of:
- One server node (hahadiouS)
- One worker node (hahadiouSW)

### Key Features
- Automated VM provisioning with Vagrant
- K3s installation and configuration
- Passwordless SSH between nodes
- Automated verification and testing
- Easy-to-use Makefile commands

## 💻 System Requirements

### Host Machine Requirements
- Virtualization support (VT-x/AMD-V)
- 4GB RAM minimum (8GB recommended)
- 20GB free disk space
- Vagrant installed
- VMware provider for Vagrant

### VM Specifications
- Server Node (hahadiouS):
  - IP: 192.168.56.110
  - 1 CPU
  - 1024MB RAM
  - Ubuntu 22.04 LTS

- Worker Node (hahadiouSW):
  - IP: 192.168.56.111
  - 1 CPU
  - 1024MB RAM
  - Ubuntu 22.04 LTS

## 📁 Directory Structure

```
p1/
├── Vagrantfile           # VM configuration
├── Makefile             # Automation commands
├── scripts/             # Provisioning scripts
│   ├── server_provision.sh
│   ├── worker_provision.sh
│   └── generate_ssh_keys.sh
└── confs/               # Configuration files
    ├── id_rsa          # SSH private key
    └── id_rsa.pub      # SSH public key
```

## 🔧 Setup Process

### 1. Initial Setup
```bash
# Navigate to the p1 directory
cd p1

# Make scripts executable
make scripts

# Generate SSH keys
make ssh-keys
```

### 2. Starting the Cluster
```bash
# Start the cluster
make up
```
This will:
- Generate SSH keys if they don't exist
- Start both VMs
- Install and configure K3s
- Set up passwordless SSH
- Configure the worker node

### 3. Verification
```bash
# Verify the setup
make verify
```
This checks:
- VM status
- Network connectivity
- SSH configuration
- K3s installation
- Cluster status

## 📦 Component Details

### 1. Vagrantfile
The Vagrantfile defines:
- VM specifications
- Network configuration
- Provisioning scripts
- Resource allocation

### 2. Provisioning Scripts

#### server_provision.sh
- Updates system packages
- Installs required software
- Sets up SSH
- Installs and configures K3s server
- Creates kubeconfig

#### worker_provision.sh
- Updates system packages
- Sets up SSH
- Waits for server to be ready
- Joins the K3s cluster
- Configures K3s agent

#### generate_ssh_keys.sh
- Creates SSH key pair
- Sets proper permissions
- Places keys in confs directory

### 3. Makefile Commands
- `make up`: Start the cluster
- `make down`: Stop the cluster
- `make destroy`: Destroy the cluster
- `make ssh-server`: SSH into server
- `make ssh-worker`: SSH into worker
- `make kubeconfig`: Get kubeconfig
- `make status`: Check cluster status
- `make verify`: Verify setup
- `make clean`: Clean up everything

## 🚀 Usage Guide

### Starting the Cluster
```bash
make up
```

### Accessing Nodes
```bash
# Access server
make ssh-server

# Access worker
make ssh-worker
```

### Checking Status
```bash
# Check cluster status
make status

# Verify setup
make verify
```

### Getting Kubeconfig
```bash
make kubeconfig
```

### Cleaning Up
```bash
make clean
```

## 🔍 Verification Steps

### 1. VM Status
```bash
vagrant status
```

### 2. Network Connectivity
```bash
# On server
ip a show eth1

# On worker
ip a show eth1
```

### 3. SSH Configuration
```bash
# Test server to worker
ssh -i ~/.ssh/id_rsa vagrant@192.168.56.111

# Test worker to server
ssh -i ~/.ssh/id_rsa vagrant@192.168.56.110
```

### 4. K3s Status
```bash
# On server
systemctl status k3s

# On worker
systemctl status k3s-agent
```

### 5. Kubernetes Cluster
```bash
# Check nodes
kubectl get nodes

# Check pods
kubectl get pods -A
```

## ⚠️ Troubleshooting

### Common Issues

1. **SSH Connection Issues**
   - Check if SSH keys are generated
   - Verify key permissions
   - Check SSH service status

2. **K3s Installation Problems**
   - Check system requirements
   - Verify network connectivity
   - Check installation logs

3. **Worker Joining Issues**
   - Verify server is ready
   - Check token validity
   - Verify network connectivity

### Debugging Steps

1. **Check Logs**
```bash
# Server logs
journalctl -u k3s

# Worker logs
journalctl -u k3s-agent
```

2. **Network Testing**
```bash
# Test connectivity
ping 192.168.56.110
ping 192.168.56.111
```

3. **Service Status**
```bash
# Check services
systemctl status k3s
systemctl status k3s-agent
```

## 🔄 Maintenance

### Regular Checks
- Monitor system resources
- Check cluster health
- Verify SSH connectivity
- Update system packages

### Backup
- Backup SSH keys
- Backup kubeconfig
- Document any custom configurations

## 📚 Additional Resources

### Documentation
- [Vagrant Documentation](https://www.vagrantup.com/docs)
- [K3s Documentation](https://docs.k3s.io/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)

### Tools
- kubectl
- vagrant
- ssh
- systemctl

## 🎓 Learning Points

### Key Concepts
- Virtual Machine Management
- Kubernetes Architecture
- Network Configuration
- SSH Key Management
- System Service Management

### Skills Developed
- Infrastructure as Code
- Automation
- System Administration
- Troubleshooting
- Documentation 