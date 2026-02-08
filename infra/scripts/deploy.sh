#!/bin/bash
# Deployment Wrapper Script for Todo AI Chatbot
# Phase IV - Cloud-Native Kubernetes Deployment
# Purpose: One-command deployment to Minikube

set -e  # Exit on error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
HELM_CHART_DIR="$REPO_ROOT/infra/helm/todo-app"
NAMESPACE="${NAMESPACE:-default}"
RELEASE_NAME="${RELEASE_NAME:-todo-app}"

echo "🚀 Deploying Todo AI Chatbot to Kubernetes..."

# Check if Minikube is running
if ! minikube status &> /dev/null; then
    echo "❌ Error: Minikube is not running"
    echo "Run: ./infra/scripts/setup-minikube.sh"
    exit 1
fi

# Check if Helm chart exists
if [ ! -d "$HELM_CHART_DIR" ]; then
    echo "❌ Error: Helm chart not found at $HELM_CHART_DIR"
    exit 1
fi

# Check if container images exist
echo "📦 Checking container images..."
FRONTEND_IMAGE="${FRONTEND_IMAGE:-todo-frontend:v1.0.0}"
BACKEND_IMAGE="${BACKEND_IMAGE:-todo-backend:v1.0.0}"

if ! docker image inspect "$FRONTEND_IMAGE" &> /dev/null; then
    echo "❌ Error: Frontend image not found: $FRONTEND_IMAGE"
    echo "Build it first: docker build -t $FRONTEND_IMAGE -f infra/docker/frontend/Dockerfile ."
    exit 1
fi

if ! docker image inspect "$BACKEND_IMAGE" &> /dev/null; then
    echo "❌ Error: Backend image not found: $BACKEND_IMAGE"
    echo "Build it first: docker build -t $BACKEND_IMAGE -f infra/docker/backend/Dockerfile ."
    exit 1
fi

echo "✅ Container images found"

# Load images to Minikube
echo "📤 Loading images to Minikube..."
minikube image load "$FRONTEND_IMAGE"
minikube image load "$BACKEND_IMAGE"
echo "✅ Images loaded to Minikube"

# Check if secrets exist
echo "🔐 Checking Kubernetes secrets..."
if ! kubectl get secret todo-app-secrets -n "$NAMESPACE" &> /dev/null; then
    echo "⚠️  Warning: Kubernetes secret 'todo-app-secrets' not found"
    echo ""
    echo "Create it with:"
    echo "kubectl create secret generic todo-app-secrets \\"
    echo "  --from-literal=BETTER_AUTH_SECRET=your-secret-here \\"
    echo "  --from-literal=COHERE_API_KEY=your-api-key-here \\"
    echo "  --from-literal=DATABASE_URL=your-database-url-here \\"
    echo "  -n $NAMESPACE"
    echo ""
    read -p "Continue without secrets? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    echo "✅ Secrets found"
fi

# Validate Helm chart
echo "🔍 Validating Helm chart..."
helm lint "$HELM_CHART_DIR"
echo "✅ Helm chart valid"

# Check if release already exists
if helm list -n "$NAMESPACE" | grep -q "$RELEASE_NAME"; then
    echo "⚠️  Release '$RELEASE_NAME' already exists"
    read -p "Upgrade existing release? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "⬆️  Upgrading Helm release..."
        helm upgrade "$RELEASE_NAME" "$HELM_CHART_DIR" \
            --namespace "$NAMESPACE" \
            --set frontend.image.repository="${FRONTEND_IMAGE%:*}" \
            --set frontend.image.tag="${FRONTEND_IMAGE##*:}" \
            --set backend.image.repository="${BACKEND_IMAGE%:*}" \
            --set backend.image.tag="${BACKEND_IMAGE##*:}" \
            --wait \
            --timeout 5m
        echo "✅ Release upgraded"
    else
        echo "ℹ️  Skipping deployment"
        exit 0
    fi
else
    echo "📦 Installing Helm release..."
    helm install "$RELEASE_NAME" "$HELM_CHART_DIR" \
        --namespace "$NAMESPACE" \
        --set frontend.image.repository="${FRONTEND_IMAGE%:*}" \
        --set frontend.image.tag="${FRONTEND_IMAGE##*:}" \
        --set backend.image.repository="${BACKEND_IMAGE%:*}" \
        --set backend.image.tag="${BACKEND_IMAGE##*:}" \
        --wait \
        --timeout 5m
    echo "✅ Release installed"
fi

# Wait for pods to be ready
echo "⏳ Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod \
    --selector=app.kubernetes.io/instance="$RELEASE_NAME" \
    --namespace "$NAMESPACE" \
    --timeout=300s

echo "✅ All pods ready"

# Display deployment status
echo ""
echo "📊 Deployment Status:"
echo "===================="
echo ""
echo "📦 Pods:"
kubectl get pods -n "$NAMESPACE" -l app.kubernetes.io/instance="$RELEASE_NAME"
echo ""
echo "🌐 Services:"
kubectl get svc -n "$NAMESPACE" -l app.kubernetes.io/instance="$RELEASE_NAME"
echo ""
echo "🔀 Ingress:"
kubectl get ingress -n "$NAMESPACE" -l app.kubernetes.io/instance="$RELEASE_NAME"
echo ""

# Get ingress host
INGRESS_HOST=$(kubectl get ingress -n "$NAMESPACE" -l app.kubernetes.io/instance="$RELEASE_NAME" -o jsonpath='{.items[0].spec.rules[0].host}' 2>/dev/null || echo "")

if [ -n "$INGRESS_HOST" ]; then
    MINIKUBE_IP=$(minikube ip)
    echo "✅ Deployment complete!"
    echo ""
    echo "🌐 Access the application:"
    echo "  1. Add to /etc/hosts (or C:\\Windows\\System32\\drivers\\etc\\hosts on Windows):"
    echo "     $MINIKUBE_IP $INGRESS_HOST"
    echo ""
    echo "  2. Open in browser:"
    echo "     http://$INGRESS_HOST"
    echo ""
else
    echo "⚠️  Warning: Ingress host not found"
    echo "Check ingress configuration: kubectl get ingress -n $NAMESPACE"
fi

echo "💡 Useful commands:"
echo "  - kubectl get pods -n $NAMESPACE           # List pods"
echo "  - kubectl logs -f <pod-name> -n $NAMESPACE # View logs"
echo "  - kubectl describe pod <pod-name>          # Pod details"
echo "  - helm status $RELEASE_NAME -n $NAMESPACE  # Release status"
echo "  - ./infra/scripts/cleanup.sh               # Cleanup deployment"
