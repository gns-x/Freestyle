.PHONY: install clean status check-gitlab gitlab-port-forward gitlab-info help

# Variables
GITLAB_NAMESPACE := gitlab
GITLAB_RELEASE := gitlab

# Installation
install:
	@echo "Making installation script executable..."
	chmod +x scripts/install.sh
	@echo "Running installation script..."
	./scripts/install.sh

# Cleanup
clean:
	@echo "Cleaning up GitLab..."
	helm uninstall $(GITLAB_RELEASE) -n $(GITLAB_NAMESPACE) || true
	kubectl delete namespace $(GITLAB_NAMESPACE) || true
	@echo "GitLab cleanup completed"

# Status
status:
	@echo "GitLab Status:"
	kubectl get pods -n $(GITLAB_NAMESPACE)
	@echo "\nGitLab Services:"
	kubectl get svc -n $(GITLAB_NAMESPACE)

# GitLab Management
check-gitlab:
	@echo "Checking GitLab status..."
	@if ! kubectl get namespace $(GITLAB_NAMESPACE) &> /dev/null; then \
		echo "GitLab namespace not found"; \
		exit 1; \
	fi
	@echo "GitLab is running"

gitlab-port-forward:
	@echo "Starting GitLab port forwarding..."
	kubectl port-forward svc/gitlab-webservice -n $(GITLAB_NAMESPACE) 8080:8181

# GitLab Information
gitlab-info:
	@echo "\n=== GitLab Connection Information ==="
	@echo "Web Interface URL: http://localhost:8080"
	@echo "Username: root"
	@echo "Password: $$(kubectl get secret gitlab-gitlab-initial-root-password -n $(GITLAB_NAMESPACE) -o jsonpath="{.data.password}" | base64 -d)"
	@echo "\n=== Port Forwarding Status ==="
	@if pgrep -f "kubectl port-forward svc/gitlab-webservice" > /dev/null; then \
		echo "Port forwarding is ACTIVE (8080:8181)"; \
	else \
		echo "Port forwarding is INACTIVE"; \
		echo "Run 'make gitlab-port-forward' to start"; \
	fi
	@echo "\n=== Connection Test ==="
	@if curl -s http://localhost:8080 > /dev/null; then \
		echo "Connection to GitLab is SUCCESSFUL"; \
	else \
		echo "Connection to GitLab FAILED"; \
		echo "Make sure port forwarding is active"; \
	fi

# Help
help:
	@echo "Available commands:"
	@echo "  make install           - Install GitLab"
	@echo "  make clean            - Clean up GitLab"
	@echo "  make status           - Show GitLab status"
	@echo "  make check-gitlab     - Check GitLab status"
	@echo "  make gitlab-port-forward - Start GitLab port forwarding"
	@echo "  make gitlab-info      - Show GitLab credentials and status"
	@echo "  make help             - Show this help message" 