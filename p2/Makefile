.PHONY: up down destroy ssh status verify clean scripts logs restart-apps

# Make scripts executable
scripts:
	@echo "🔧 Making scripts executable..."
	@chmod +x scripts/*.sh
	@echo "✅ Scripts are now executable"

# Start the VM and deploy applications
up: scripts
	@echo "🚀 Starting VM and deploying applications..."
	@echo "⏳ This might take a few minutes..."
	@vagrant up || (echo "❌ Failed to start VM. Please check the Vagrantfile and try again." && exit 1)
	@echo "✅ VM is up and running!"
	@echo "📦 Deploying applications..."
	@vagrant ssh hahadiouS -c "cd /vagrant && ./scripts/apply_configs.sh" || (echo "❌ Failed to deploy applications. Please check the logs and try again." && exit 1)
	@echo "✅ Applications deployed successfully!"
	@echo "📝 Add these entries to your /etc/hosts file:"
	@echo "192.168.56.110 app1.com"
	@echo "192.168.56.110 app2.com"
	@echo "192.168.56.110 app3.com"

# Stop the VM
down:
	@echo "🛑 Stopping VM..."
	@vagrant halt || (echo "❌ Failed to stop VM." && exit 1)
	@echo "💤 VM is now stopped"

# Destroy the VM
destroy:
	@echo "💥 Destroying VM..."
	@vagrant destroy -f || (echo "❌ Failed to destroy VM." && exit 1)
	@echo "🗑️  VM has been destroyed"

# SSH into the VM
ssh:
	@echo "🔑 Connecting to VM..."
	@vagrant ssh hahadiouS || (echo "❌ Failed to connect to VM. Is it running?" && exit 1)

# Check cluster status
status:
	@echo "📊 Checking cluster status..."
	@echo "🌐 Nodes:"
	@vagrant ssh hahadiouS -c "sudo kubectl get nodes" || (echo "❌ Failed to get nodes status." && exit 1)
	@echo "\n📦 Deployments:"
	@vagrant ssh hahadiouS -c "sudo kubectl get deployments" || (echo "❌ Failed to get deployments status." && exit 1)
	@echo "\n📦 Pods:"
	@vagrant ssh hahadiouS -c "sudo kubectl get pods" || (echo "❌ Failed to get pods status." && exit 1)
	@echo "\n🌐 Services:"
	@vagrant ssh hahadiouS -c "sudo kubectl get services" || (echo "❌ Failed to get services status." && exit 1)
	@echo "\n🌐 Ingress:"
	@vagrant ssh hahadiouS -c "sudo kubectl get ingress" || (echo "❌ Failed to get ingress status." && exit 1)

# Show application logs
logs:
	@echo "📜 Showing application logs..."
	@echo "\n📝 App1 logs:"
	@vagrant ssh hahadiouS -c "sudo kubectl logs -l app=app1" || (echo "❌ Failed to get App1 logs." && exit 1)
	@echo "\n📝 App2 logs:"
	@vagrant ssh hahadiouS -c "sudo kubectl logs -l app=app2" || (echo "❌ Failed to get App2 logs." && exit 1)
	@echo "\n📝 App3 logs:"
	@vagrant ssh hahadiouS -c "sudo kubectl logs -l app=app3" || (echo "❌ Failed to get App3 logs." && exit 1)

# Restart applications
restart-apps:
	@echo "🔄 Restarting applications..."
	@vagrant ssh hahadiouS -c "cd /vagrant && ./scripts/apply_configs.sh" || (echo "❌ Failed to restart applications." && exit 1)
	@echo "✅ Applications restarted successfully!"

# Verify everything is working properly
verify:
	@echo "🔍 Starting verification process..."
	@echo "\n1️⃣ Checking VM status..."
	@vagrant status || (echo "❌ Failed to get VM status." && exit 1)
	@echo "\n2️⃣ Verifying network connectivity..."
	@echo "   VM IP (192.168.56.110):"
	@vagrant ssh hahadiouS -c "ip a show eth1 | grep inet" || (echo "❌ Failed to get network information." && exit 1)
	@echo "\n3️⃣ Checking K3s installation..."
	@echo "   K3s status:"
	@vagrant ssh hahadiouS -c "sudo systemctl status k3s" || (echo "❌ Failed to get K3s status." && exit 1)
	@echo "\n4️⃣ Verifying Kubernetes cluster..."
	@echo "   Nodes:"
	@vagrant ssh hahadiouS -c "sudo kubectl get nodes -o wide" || (echo "❌ Failed to get nodes information." && exit 1)
	@echo "\n   All pods:"
	@vagrant ssh hahadiouS -c "sudo kubectl get pods -A" || (echo "❌ Failed to get pods information." && exit 1)
	@echo "\n   System pods:"
	@vagrant ssh hahadiouS -c "sudo kubectl get pods -n kube-system" || (echo "❌ Failed to get system pods information." && exit 1)
	@echo "\n5️⃣ Checking Ingress Controller..."
	@echo "   Ingress controller status:"
	@vagrant ssh hahadiouS -c "sudo kubectl get pods -n ingress-nginx" || (echo "❌ Failed to get ingress controller status." && exit 1)
	@echo "\n6️⃣ Verifying Applications..."
	@echo "   App1 deployment:"
	@vagrant ssh hahadiouS -c "sudo kubectl get deployment app1" || (echo "❌ Failed to get App1 deployment status." && exit 1)
	@echo "   App2 deployment:"
	@vagrant ssh hahadiouS -c "sudo kubectl get deployment app2" || (echo "❌ Failed to get App2 deployment status." && exit 1)
	@echo "   App3 deployment:"
	@vagrant ssh hahadiouS -c "sudo kubectl get deployment app3" || (echo "❌ Failed to get App3 deployment status." && exit 1)
	@echo "\n7️⃣ Checking Ingress Configuration..."
	@echo "   Ingress rules:"
	@vagrant ssh hahadiouS -c "sudo kubectl get ingress apps-ingress -o yaml | grep -A 10 'rules:'" || (echo "❌ Failed to get ingress rules." && exit 1)
	@echo "\n8️⃣ Testing Application Access..."
	@echo "   Testing App1..."
	@vagrant ssh hahadiouS -c "curl -s -H 'Host: app1.com' http://localhost" || (echo "❌ Failed to access App1." && exit 1)
	@echo "   Testing App2..."
	@vagrant ssh hahadiouS -c "curl -s -H 'Host: app2.com' http://localhost" || (echo "❌ Failed to access App2." && exit 1)
	@echo "   Testing App3..."
	@vagrant ssh hahadiouS -c "curl -s -H 'Host: app3.com' http://localhost" || (echo "❌ Failed to access App3." && exit 1)
	@echo "\n✅ Verification complete!"

# Clean everything
clean:
	@echo "🧹 Cleaning up everything..."
	@if [ -d .vagrant ]; then \
		vagrant destroy -f || (echo "❌ Failed to destroy VM." && exit 1); \
		echo "💥 Destroyed Vagrant environment"; \
	fi
	@echo "✨ Cleanup complete!"

# Help command
help:
	@echo "🤖 Available commands:"
	@echo "  make up           🚀 Start VM and deploy applications"
	@echo "  make down         🛑 Stop the VM"
	@echo "  make destroy      💥 Destroy the VM"
	@echo "  make ssh          🔑 SSH into the VM"
	@echo "  make status       📊 Check cluster and applications status"
	@echo "  make logs         📜 Show application logs"
	@echo "  make restart-apps 🔄 Restart all applications"
	@echo "  make verify       🔍 Verify all components are working"
	@echo "  make clean        🧹 Remove all generated files and destroy environment" 