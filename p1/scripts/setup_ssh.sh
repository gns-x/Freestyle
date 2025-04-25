#!/bin/bash

# Create confs directory if it doesn't exist
mkdir -p ../confs

# Generate SSH key pair if it doesn't exist
if [ ! -f ../confs/id_rsa ]; then
    ssh-keygen -t rsa -b 4096 -f ../confs/id_rsa -N ""
fi

# Set correct permissions
chmod 600 ../confs/id_rsa
chmod 644 ../confs/id_rsa.pub 