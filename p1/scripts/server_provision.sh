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

# Ensure SSH service is running
systemctl enable ssh
systemctl start ssh

# Install K3s server
curl -sfL https://get.k3s.io | sh -s - server --cluster-init

# Get kubeconfig
mkdir -p /home/vagrant/.kube
cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
chown vagrant:vagrant /home/vagrant/.kube/config

# Enable and start K3s service
systemctl enable k3s
systemctl start k3s

# Wait for K3s to be ready
echo "⏳ Waiting for K3s to be ready..."
until kubectl get nodes >/dev/null 2>&1; do
    echo "K3s not ready yet, waiting..."
    sleep 5
done

echo "✅ Server provisioning completed!" 