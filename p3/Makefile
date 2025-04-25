.PHONY: install clean test status check-docker check-cluster check-argocd check-app \
        argocd-port-forward test-app logs-k3d logs-argocd logs-app reset-cluster \
        argocd-sync clean-cluster clean-argocd clean-app argocd-info

# Variables
CLUSTER_NAME := iot-cluster
ARGO_CD_NAMESPACE := argocd
APP_NAMESPACE := dev
APP_NAME := playground

# Installation
install:
	@echo "Making installation script executable..."
	chmod +x scripts/install.sh
	@echo "Running installation script..."
	./scripts/install.sh

# Cleanup
clean: clean-app clean-argocd clean-cluster
	@echo "Full cleanup completed"

clean-cluster:
	@echo "Deleting K3d cluster..."
	k3d cluster delete $(CLUSTER_NAME)

clean-argocd:
	@echo "Cleaning up Argo CD..."
	kubectl delete namespace $(ARGO_CD_NAMESPACE) || true

clean-app:
	@echo "Cleaning up application..."
	kubectl delete namespace $(APP_NAMESPACE) || true

# Testing
test: check-docker check-cluster check-argocd check-app
	@echo "All tests passed successfully"

check-docker:
	@echo "Checking Docker status..."
	@if ! docker info &> /dev/null; then \
		echo "Docker is not running. Please start Docker Desktop."; \
		exit 1; \
	fi
	@echo "Docker is running"

check-cluster:
	@echo "Checking K3d cluster status..."
	@if ! k3d cluster list | grep -q $(CLUSTER_NAME); then \
		echo "K3d cluster not found"; \
		exit 1; \
	fi
	@echo "K3d cluster is running"

check-argocd:
	@echo "Checking Argo CD status..."
	@if ! kubectl get namespace $(ARGO_CD_NAMESPACE) &> /dev/null; then \
		echo "Argo CD namespace not found"; \
		exit 1; \
	fi
	@echo "Argo CD is running"

check-app:
	@echo "Checking application status..."
	@if ! kubectl get deployment $(APP_NAME) -n $(APP_NAMESPACE) &> /dev/null; then \
		echo "Application not found"; \
		exit 1; \
	fi
	@echo "Application is running"

# Application Management
status:
	@echo "Cluster Status:"
	kubectl get nodes
	@echo "\nArgo CD Status:"
	kubectl get pods -n $(ARGO_CD_NAMESPACE)
	@echo "\nApplication Status:"
	kubectl get pods -n $(APP_NAMESPACE)

argocd-port-forward:
	@echo "Starting Argo CD port forwarding..."
	kubectl port-forward svc/argocd-server -n $(ARGO_CD_NAMESPACE) 8080:443

test-app:
	@echo "Testing application access..."
	curl -H "Host: localhost" http://localhost:8888

# Logs
logs-k3d:
	@echo "K3d logs:"
	k3d cluster list
	k3d cluster get $(CLUSTER_NAME)

logs-argocd:
	@echo "Argo CD logs:"
	kubectl logs -n $(ARGO_CD_NAMESPACE) -l app.kubernetes.io/name=argocd-server

logs-app:
	@echo "Application logs:"
	kubectl logs -n $(APP_NAMESPACE) -l app=$(APP_NAME)

# Troubleshooting
reset-cluster: clean-cluster
	@echo "Recreating K3d cluster..."
	k3d cluster create $(CLUSTER_NAME) --api-port 6550 -p "8888:80@loadbalancer"

argocd-sync:
	@echo "Syncing Argo CD application..."
	kubectl patch app $(APP_NAME) -n $(ARGO_CD_NAMESPACE) --type merge -p '{"metadata": {"annotations": {"argocd.argoproj.io/sync-wave": "0"}}}'

# Argo CD Information
argocd-info:
	@echo "\n=== Argo CD Connection Information ==="
	@echo "Web Interface URL: https://localhost:8080"
	@echo "Username: admin"
	@echo "Password: $$(kubectl -n $(ARGO_CD_NAMESPACE) get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)"
	@echo "\n=== Port Forwarding Status ==="
	@if pgrep -f "kubectl port-forward svc/argocd-server" > /dev/null; then \
		echo "Port forwarding is ACTIVE (8080:443)"; \
	else \
		echo "Port forwarding is INACTIVE"; \
		echo "Run 'make argocd-port-forward' to start"; \
	fi
	@echo "\n=== Connection Test ==="
	@if curl -s -k https://localhost:8080 > /dev/null; then \
		echo "Connection to Argo CD is SUCCESSFUL"; \
	else \
		echo "Connection to Argo CD FAILED"; \
		echo "Make sure port forwarding is active"; \
	fi

# Help
help:
	@echo "Available commands:"
	@echo "  make install           - Install all components"
	@echo "  make clean            - Clean up all components"
	@echo "  make test             - Run all tests"
	@echo "  make status           - Show current status"
	@echo "  make argocd-port-forward - Start Argo CD port forwarding"
	@echo "  make argocd-info      - Show Argo CD credentials and status"
	@echo "  make test-app         - Test application access"
	@echo "  make logs-k3d         - Show K3d logs"
	@echo "  make logs-argocd      - Show Argo CD logs"
	@echo "  make logs-app         - Show application logs"
	@echo "  make reset-cluster    - Reset K3d cluster"
	@echo "  make argocd-sync      - Sync Argo CD application"
	@echo "  make help             - Show this help message" 