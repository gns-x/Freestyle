#!/bin/bash

echo "🚀 Applying Kubernetes configurations..."

# Apply all manifests
sudo kubectl apply -f manifests/deployments/app1.yaml || exit 1
sudo kubectl apply -f manifests/deployments/app2.yaml || exit 1
sudo kubectl apply -f manifests/deployments/app3.yaml || exit 1
sudo kubectl apply -f manifests/ingress.yaml || exit 1

# Wait for deployments to be ready
echo "⏳ Waiting for deployments to be ready..."
sudo kubectl wait --for=condition=available --timeout=300s deployment/app1 || exit 1
sudo kubectl wait --for=condition=available --timeout=300s deployment/app2 || exit 1
sudo kubectl wait --for=condition=available --timeout=300s deployment/app3 || exit 1

# Wait for ingress controller to be ready and get its IP
echo "⏳ Waiting for ingress controller to be ready..."
sudo kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s || exit 1

# Get the ingress controller IP
IP=$(sudo kubectl get service ingress-nginx-controller -n ingress-nginx -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

echo "✅ Configuration applied successfully!"
echo "📝 Add these entries to your /etc/hosts file:"
echo "$IP app1.com"
echo "$IP app2.com"
echo "$IP app3.com"
echo ""
echo "🌐 You can now access:"
echo "- App1 at http://app1.com"
echo "- App2 at http://app2.com"
echo "- App3 at http://app3.com (or any other hostname)" 