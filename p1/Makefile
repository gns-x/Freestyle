.PHONY: up down destroy ssh-server ssh-worker kubeconfig status clean

# Start the K3s cluster
up:
	@echo "🚀 Starting K3s cluster..."
	@echo "⏳ This might take a few minutes..."
	vagrant up
	@echo "✅ Cluster is up and running!"

# Stop the K3s cluster
down:
	@echo "🛑 Stopping K3s cluster..."
	vagrant halt
	@echo "💤 Cluster is now stopped"

# Destroy the K3s cluster
destroy:
	@echo "💥 Destroying K3s cluster..."
	vagrant destroy -f
	@echo "🗑️  Cluster has been destroyed"

# SSH into the server node
ssh-server:
	@echo "🔑 Connecting to server node..."
	vagrant ssh hahadiouS

# SSH into the worker node
ssh-worker:
	@echo "🔑 Connecting to worker node..."
	vagrant ssh hahadiouSW

# Get kubeconfig
kubeconfig:
	@echo "📋 Getting kubeconfig..."
	vagrant ssh hahadiouS -c "cat /home/vagrant/.kube/config" > kubeconfig.yaml
	@echo "✅ Kubeconfig saved to kubeconfig.yaml"

# Check cluster status
status:
	@echo "📊 Checking cluster status..."
	@echo "🌐 Nodes:"
	vagrant ssh hahadiouS -c "sudo kubectl get nodes"
	@echo "\n📦 Pods:"
	vagrant ssh hahadiouS -c "sudo kubectl get pods -A"

# Clean everything
clean:
	@echo "🧹 Cleaning up everything..."
	@if [ -f kubeconfig.yaml ]; then \
		rm kubeconfig.yaml; \
		echo "🗑️  Removed kubeconfig.yaml"; \
	fi
	@if [ -d .vagrant ]; then \
		vagrant destroy -f; \
		echo "💥 Destroyed Vagrant environment"; \
	fi
	@echo "✨ Cleanup complete!"

# Help command
help:
	@echo "🤖 Available commands:"
	@echo "  make up         🚀 Start the K3s cluster"
	@echo "  make down       🛑 Stop the K3s cluster"
	@echo "  make destroy    💥 Destroy the K3s cluster"
	@echo "  make ssh-server 🔑 SSH into the server node"
	@echo "  make ssh-worker 🔑 SSH into the worker node"
	@echo "  make kubeconfig 📋 Get the kubeconfig file"
	@echo "  make status     📊 Check cluster and pods status"
	@echo "  make clean      🧹 Remove all generated files and destroy environment"
