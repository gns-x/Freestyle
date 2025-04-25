#!/bin/bash

# Create confs directory if it doesn't exist
mkdir -p confs

# Generate SSH key pair if they don't exist
if [ ! -f confs/id_rsa ]; then
    echo "🔑 Generating new SSH key pair..."
    ssh-keygen -t rsa -b 4096 -f confs/id_rsa -N "" -q
    echo "✅ SSH keys generated successfully!"
else
    echo "🔑 Using existing SSH keys..."
fi

# Set proper permissions
chmod 600 confs/id_rsa
chmod 644 confs/id_rsa.pub

echo "📁 SSH keys are ready in the confs directory!" 