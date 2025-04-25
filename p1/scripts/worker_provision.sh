#!/bin/bash

# Update system
apt-get update
apt-get upgrade -y

# Install required packages
apt-get install -y curl wget openssh-server

# Set up passwordless SSH
mkdir -p /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
cp /vagrant/confs/id_rsa.pub /home/vagrant/.ssh/authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh

# Copy private key for SSH access to server
cp /vagrant/confs/id_rsa /home/vagrant/.ssh/
chmod 600 /home/vagrant/.ssh/id_rsa
chown vagrant:vagrant /home/vagrant/.ssh/id_rsa

# Ensure SSH service is running
systemctl enable ssh
systemctl start ssh

# Function to check if server is ready
check_server_ready() {
    # Check if server is responding
    if ! curl -k -s https://192.168.56.110:6443 >/dev/null; then
        return 1
    fi
    
    # Check if k3s service is running on server
    if ! ssh -i /home/vagrant/.ssh/id_rsa -o StrictHostKeyChecking=no vagrant@192.168.56.110 "systemctl is-active k3s" >/dev/null; then
        return 1
    fi
    
    # Check if node-token exists
    if ! ssh -i /home/vagrant/.ssh/id_rsa -o StrictHostKeyChecking=no vagrant@192.168.56.110 "sudo test -f /var/lib/rancher/k3s/server/node-token"; then
        return 1
    fi
    
    return 0
}

# Wait for server to be ready
echo "⏳ Waiting for server to be ready..."
while ! check_server_ready; do
    echo "Server not ready yet, waiting..."
    sleep 10
done

echo "✅ Server is ready!"

# Get token from server
TOKEN=$(ssh -i /home/vagrant/.ssh/id_rsa -o StrictHostKeyChecking=no vagrant@192.168.56.110 "sudo cat /var/lib/rancher/k3s/server/node-token")

# Install K3s agent
echo "🚀 Installing K3s agent..."
curl -sfL https://get.k3s.io | K3S_URL=https://192.168.56.110:6443 K3S_TOKEN=$TOKEN sh -

# Enable and start K3s agent service
echo "🔧 Enabling and starting K3s agent service..."
systemctl enable k3s-agent
systemctl start k3s-agent

# Wait for agent to be ready
echo "⏳ Waiting for agent to be ready..."
while ! systemctl is-active k3s-agent >/dev/null; do
    echo "Agent not ready yet, waiting..."
    sleep 5
done

echo "✅ Worker provisioning completed!" 