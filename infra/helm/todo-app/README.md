# Todo App Helm Chart

Production-ready Helm chart for deploying Todo AI Chatbot to Kubernetes.

## Prerequisites

- Kubernetes 1.28+
- Helm 3.12+
- Minikube (for local deployment)
- Container images built and loaded to cluster

## Quick Start

### 1. Create Kubernetes Secrets

```bash
kubectl create secret generic todo-app-secrets \
  --from-literal=BETTER_AUTH_SECRET="your-secret-here" \
  --from-literal=COHERE_API_KEY="your-cohere-api-key" \
  --from-literal=DATABASE_URL="your-database-url"
```

Or use values from .env files:

```bash
# Extract values from backend/.env
BETTER_AUTH_SECRET=$(grep BETTER_AUTH_SECRET backend/.env | cut -d '=' -f2)
COHERE_API_KEY=$(grep COHERE_API_KEY backend/.env | cut -d '=' -f2)
DATABASE_URL=$(grep NEON_DB_URL backend/.env | cut -d '=' -f2)

# Create secret
kubectl create secret generic todo-app-secrets \
  --from-literal=BETTER_AUTH_SECRET="$BETTER_AUTH_SECRET" \
  --from-literal=COHERE_API_KEY="$COHERE_API_KEY" \
  --from-literal=DATABASE_URL="$DATABASE_URL"
```

### 2. Install the Chart

```bash
helm install todo-app infra/helm/todo-app \
  --set secrets.betterAuthSecret="$BETTER_AUTH_SECRET" \
  --set secrets.cohereApiKey="$COHERE_API_KEY" \
  --set secrets.databaseUrl="$DATABASE_URL"
```

### 3. Configure /etc/hosts

```bash
# Get Minikube IP
MINIKUBE_IP=$(minikube ip)

# Add to /etc/hosts (Linux/macOS)
echo "$MINIKUBE_IP todo.local" | sudo tee -a /etc/hosts

# Windows: Add to C:\Windows\System32\drivers\etc\hosts (as Administrator)
# <minikube-ip> todo.local
```

### 4. Access the Application

Open browser: http://todo.local

## Configuration

### Values File

The chart can be configured via `values.yaml` or command-line `--set` flags.

#### Frontend Configuration

```yaml
frontend:
  replicaCount: 1
  image:
    repository: todo-frontend
    tag: v1.0.0
  resources:
    requests:
      memory: "256Mi"
      cpu: "200m"
    limits:
      memory: "512Mi"
      cpu: "500m"
```

#### Backend Configuration

```yaml
backend:
  replicaCount: 1
  image:
    repository: todo-backend
    tag: v1.0.0
  resources:
    requests:
      memory: "512Mi"
      cpu: "300m"
    limits:
      memory: "1Gi"
      cpu: "1000m"
```

#### Ingress Configuration

```yaml
ingress:
  enabled: true
  className: nginx
  hosts:
    - host: todo.local
      paths:
        - path: /api
          pathType: Prefix
          backend: backend
        - path: /
          pathType: Prefix
          backend: frontend
```

### Secrets

Secrets can be provided via:

1. **Helm values** (not recommended for production):
```bash
helm install todo-app infra/helm/todo-app \
  --set secrets.betterAuthSecret="..." \
  --set secrets.cohereApiKey="..." \
  --set secrets.databaseUrl="..."
```

2. **Pre-created Kubernetes Secret** (recommended):
```bash
kubectl create secret generic todo-app-secrets \
  --from-literal=BETTER_AUTH_SECRET="..." \
  --from-literal=COHERE_API_KEY="..." \
  --from-literal=DATABASE_URL="..."
```

## Upgrading

```bash
helm upgrade todo-app infra/helm/todo-app \
  --set secrets.betterAuthSecret="$BETTER_AUTH_SECRET" \
  --set secrets.cohereApiKey="$COHERE_API_KEY" \
  --set secrets.databaseUrl="$DATABASE_URL"
```

## Uninstalling

```bash
helm uninstall todo-app
kubectl delete secret todo-app-secrets
```

## Troubleshooting

### Pods not starting

```bash
# Check pod status
kubectl get pods

# Describe pod for events
kubectl describe pod <pod-name>

# Check logs
kubectl logs <pod-name>
```

### Image pull errors

```bash
# Load images to Minikube
minikube image load todo-frontend:v1.0.0
minikube image load todo-backend:v1.0.0

# Verify images in Minikube
minikube ssh docker images | grep todo
```

### Ingress not working

```bash
# Check ingress status
kubectl get ingress

# Verify ingress controller
kubectl get pods -n ingress-nginx

# Check /etc/hosts entry
cat /etc/hosts | grep todo.local
```

## Chart Structure

```
todo-app/
├── Chart.yaml              # Chart metadata
├── values.yaml             # Default configuration values
├── README.md              # This file
└── templates/
    ├── _helpers.tpl       # Template helpers
    ├── deployment-frontend.yaml
    ├── deployment-backend.yaml
    ├── service-frontend.yaml
    ├── service-backend.yaml
    ├── ingress.yaml
    ├── secret.yaml
    ├── configmap.yaml
    └── NOTES.txt          # Post-install instructions
```

## Resources

- **Frontend**: 256Mi-512Mi memory, 200m-500m CPU
- **Backend**: 512Mi-1Gi memory, 300m-1000m CPU
- **Total**: ~1-2GB memory, ~500m-1500m CPU

## Health Checks

- **Frontend**: HTTP GET / on port 3000
- **Backend**: HTTP GET /health on port 8000

## Security

- Non-root containers (UID 1001)
- Secrets stored in Kubernetes Secrets
- Resource limits enforced
- Rolling updates with zero downtime

## License

Part of Todo AI Chatbot - Hackathon Phase IV
