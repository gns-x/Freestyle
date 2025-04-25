.PHONY: up down destroy ssh-server ssh-worker kubeconfig status clean verify scripts

# Make scripts executable
scripts:
	@echo "🔧 Making scripts executable..."
	chmod +x scripts/*.sh
	@echo "✅ Scripts are now executable"

# Generate SSH keys
ssh-keys:
	@echo "🔑 Generating SSH keys..."
	./scripts/generate_ssh_keys.sh
	@echo "✅ SSH keys generated!"

# Start the K3s cluster
up: scripts ssh-keys
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

# Verify everything is working properly
verify:
	@echo "🔍 Starting verification process..."
	@echo "\n1️⃣ Checking VM status..."
	@vagrant status
	@echo "\n2️⃣ Verifying network connectivity..."
	@echo "   Server IP (192.168.56.110):"
	@vagrant ssh hahadiouS -c "ip a show eth1 | grep inet"
	@echo "   Worker IP (192.168.56.111):"
	@vagrant ssh hahadiouSW -c "ip a show eth1 | grep inet"
	@echo "\n3️⃣ Testing passwordless SSH..."
	@echo "   Testing server to worker:"
	@vagrant ssh hahadiouS -c "ssh -i /home/vagrant/.ssh/id_rsa -o StrictHostKeyChecking=no vagrant@192.168.56.111 'echo ✅ SSH test successful'"
	@echo "   Testing worker to server:"
	@vagrant ssh hahadiouSW -c "ssh -i /home/vagrant/.ssh/id_rsa -o StrictHostKeyChecking=no vagrant@192.168.56.110 'echo ✅ SSH test successful'"
	@echo "\n4️⃣ Checking K3s installation..."
	@echo "   Server K3s status:"
	@vagrant ssh hahadiouS -c "sudo systemctl status k3s"
	@echo "   Worker K3s status:"
	@vagrant ssh hahadiouSW -c "sudo systemctl status k3s-agent"
	@echo "\n5️⃣ Verifying Kubernetes cluster..."
	@echo "   Nodes:"
	@vagrant ssh hahadiouS -c "sudo kubectl get nodes -o wide"
	@echo "\n   All pods:"
	@vagrant ssh hahadiouS -c "sudo kubectl get pods -A"
	@echo "\n   System pods:"
	@vagrant ssh hahadiouS -c "sudo kubectl get pods -n kube-system"
	@echo "\n✅ Verification complete!"

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
	@echo "  make verify     🔍 Verify all components are working"
	@echo "  make clean      🧹 Remove all generated files and destroy environment"
