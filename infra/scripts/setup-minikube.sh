#!/bin/bash
# Minikube Setup Script for Todo AI Chatbot
# Phase IV - Cloud-Native Kubernetes Deployment
# Purpose: Initialize local Kubernetes cluster with required addons

set -e  # Exit on error

echo "🚀 Setting up Minikube for Todo AI Chatbot..."

# Check prerequisites
echo "📋 Checking prerequisites..."

if ! command -v minikube &> /dev/null; then
    echo "❌ Error: minikube is not installed"
    echo "Install from: https://minikube.sigs.k8s.io/docs/start/"
    exit 1
fi

if ! command -v kubectl &> /dev/null; then
    echo "❌ Error: kubectl is not installed"
    echo "Install from: https://kubernetes.io/docs/tasks/tools/"
    exit 1
fi

if ! command -v helm &> /dev/null; then
    echo "❌ Error: helm is not installed"
    echo "Install from: https://helm.sh/docs/intro/install/"
    exit 1
fi

if ! command -v docker &> /dev/null; then
    echo "❌ Error: docker is not installed"
    echo "Install from: https://docs.docker.com/get-docker/"
    exit 1
fi

echo "✅ All prerequisites installed"

# Check if Minikube is already running
if minikube status &> /dev/null; then
    echo "⚠️  Minikube is already running"
    read -p "Do you want to delete and recreate the cluster? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🗑️  Deleting existing Minikube cluster..."
        minikube delete
    else
        echo "ℹ️  Using existing cluster"
        exit 0
    fi
fi

# Start Minikube with recommended resources
echo "🎯 Starting Minikube cluster..."
minikube start \
    --cpus=4 \
    --memory=8192 \
    --disk-size=20g \
    --driver=docker \
    --kubernetes-version=v1.28.0

echo "✅ Minikube cluster started"

# Enable required addons
echo "🔌 Enabling Kubernetes addons..."
minikube addons enable ingress
minikube addons enable metrics-server

echo "✅ Addons enabled"

# Wait for ingress controller to be ready
echo "⏳ Waiting for ingress controller to be ready..."
kubectl wait --namespace ingress-nginx \
    --for=condition=ready pod \
    --selector=app.kubernetes.io/component=controller \
    --timeout=120s

echo "✅ Ingress controller ready"

# Display cluster info
echo ""
echo "📊 Cluster Information:"
echo "======================"
kubectl cluster-info
echo ""
echo "📦 Nodes:"
kubectl get nodes
echo ""
echo "🔌 Addons:"
minikube addons list | grep enabled
echo ""

# Configure kubectl context
echo "🔧 Configuring kubectl context..."
kubectl config use-context minikube

echo ""
echo "✅ Minikube setup complete!"
echo ""
echo "📝 Next steps:"
echo "  1. Load container images: minikube image load <image-name>"
echo "  2. Create Kubernetes secrets (see README.md)"
echo "  3. Deploy application: ./infra/scripts/deploy.sh"
echo ""
echo "💡 Useful commands:"
echo "  - minikube status          # Check cluster status"
echo "  - minikube dashboard       # Open Kubernetes dashboard"
echo "  - minikube ip              # Get cluster IP"
echo "  - kubectl get pods -A      # List all pods"
echo "  - minikube stop            # Stop cluster"
echo "  - minikube delete          # Delete cluster"
