# Part 3: K3d and Argo CD

This directory contains the configuration for setting up K3d and Argo CD for continuous deployment.

## Directory Structure

```
p3/
├── scripts/
│   └── install.sh      # Installation script for K3d and dependencies
├── confs/
│   ├── application.yaml # Argo CD application configuration
│   └── deployment.yaml  # Playground application deployment
└── README.md           # This file
```

## Prerequisites

- Linux-based system
- Internet connection
- Sudo privileges

## Installation

1. Make the installation script executable:
   ```bash
   chmod +x scripts/install.sh
   ```

2. Run the installation script:
   ```bash
   ./scripts/install.sh
   ```

The script will:
- Install Docker if not present
- Install kubectl if not present
- Install K3d
- Create a K3d cluster
- Install Argo CD
- Create necessary namespaces

## Accessing Argo CD

After installation, you can access the Argo CD web interface:

1. Port-forward the Argo CD server:
   ```bash
   kubectl port-forward svc/argocd-server -n argocd 8080:443
   ```

2. Access the web interface at: https://localhost:8080
   - Username: admin
   - Password: (output from installation script)

## Deploying the Application

The playground application is automatically deployed by Argo CD using the configuration in `confs/application.yaml`. The application uses Wil's playground image (wil42/playground) with two versions available (v1 and v2).

### Testing the Application

1. Access the application:
   ```bash
   curl http://localhost:8888
   ```

2. To switch versions, edit `confs/deployment.yaml` and change the image tag from v1 to v2:
   ```yaml
   image: wil42/playground:v2
   ```

3. Commit and push the changes to your GitHub repository. Argo CD will automatically sync and update the deployment.

## Cleanup

To delete the K3d cluster:
```bash
k3d cluster delete iot-cluster
``` 