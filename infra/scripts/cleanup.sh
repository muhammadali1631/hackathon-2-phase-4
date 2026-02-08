#!/bin/bash
# Cleanup Script for Todo AI Chatbot
# Phase IV - Cloud-Native Kubernetes Deployment
# Purpose: Remove all Kubernetes resources and optionally stop Minikube

set -e  # Exit on error

NAMESPACE="${NAMESPACE:-default}"
RELEASE_NAME="${RELEASE_NAME:-todo-app}"

echo "🧹 Cleaning up Todo AI Chatbot deployment..."

# Check if Minikube is running
if ! minikube status &> /dev/null; then
    echo "⚠️  Minikube is not running"
    echo "Nothing to clean up"
    exit 0
fi

# Check if Helm release exists
if helm list -n "$NAMESPACE" | grep -q "$RELEASE_NAME"; then
    echo "🗑️  Uninstalling Helm release '$RELEASE_NAME'..."
    helm uninstall "$RELEASE_NAME" --namespace "$NAMESPACE"
    echo "✅ Helm release uninstalled"
else
    echo "ℹ️  Helm release '$RELEASE_NAME' not found"
fi

# Delete secrets if they exist
if kubectl get secret todo-app-secrets -n "$NAMESPACE" &> /dev/null; then
    read -p "Delete Kubernetes secrets? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🔐 Deleting secrets..."
        kubectl delete secret todo-app-secrets -n "$NAMESPACE"
        echo "✅ Secrets deleted"
    fi
fi

# Wait for pods to terminate
echo "⏳ Waiting for pods to terminate..."
kubectl wait --for=delete pod \
    --selector=app.kubernetes.io/instance="$RELEASE_NAME" \
    --namespace "$NAMESPACE" \
    --timeout=60s 2>/dev/null || echo "ℹ️  No pods to wait for"

# Display remaining resources
echo ""
echo "📊 Remaining Resources:"
echo "======================"
echo ""
echo "📦 Pods:"
kubectl get pods -n "$NAMESPACE" 2>/dev/null || echo "No pods found"
echo ""
echo "🌐 Services:"
kubectl get svc -n "$NAMESPACE" 2>/dev/null || echo "No services found"
echo ""
echo "🔀 Ingress:"
kubectl get ingress -n "$NAMESPACE" 2>/dev/null || echo "No ingress found"
echo ""

# Ask if user wants to stop Minikube
read -p "Stop Minikube cluster? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🛑 Stopping Minikube..."
    minikube stop
    echo "✅ Minikube stopped"
    echo ""
    echo "💡 To start again: minikube start"
else
    echo "ℹ️  Minikube still running"
fi

# Ask if user wants to delete Minikube
read -p "Delete Minikube cluster completely? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "⚠️  This will delete all data in the cluster!"
    read -p "Are you sure? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🗑️  Deleting Minikube cluster..."
        minikube delete
        echo "✅ Minikube cluster deleted"
        echo ""
        echo "💡 To recreate: ./infra/scripts/setup-minikube.sh"
    fi
fi

echo ""
echo "✅ Cleanup complete!"
echo ""
echo "💡 Next steps:"
echo "  - To redeploy: ./infra/scripts/deploy.sh"
echo "  - To setup fresh cluster: ./infra/scripts/setup-minikube.sh"
