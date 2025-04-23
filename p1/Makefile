.PHONY: up down status ssh-server ssh-worker clean


# Default target
all: up

# Start the VMs
up:
	@echo "Starting VMs..."
	vagrant up

# Stop the VMs
down:
	@echo "Stopping VMs..."
	vagrant halt

# Show VM status
status:
	@echo "Checking VM status..."
	vagrant status

# SSH into server
ssh-server:
	@echo "Connecting to server..."
	vagrant ssh wilS

# SSH into worker
ssh-worker:
	@echo "Connecting to worker..."
	vagrant ssh wilSW

# Clean up (destroy VMs and remove all files)
clean:
	@echo "Cleaning up..."
	vagrant destroy -f
	rm -f node-token

# Rebuild everything
rebuild: clean up

# Check cluster status
cluster-status:
	@echo "Checking cluster status..."
	vagrant ssh wilS -c "kubectl get nodes"

# Get cluster info
cluster-info:
	@echo "Getting cluster information..."
	vagrant ssh wilS -c "kubectl cluster-info" 
