# Todo AI Chatbot - Cloud-Native Kubernetes Deployment

Phase IV: Local Kubernetes deployment with AI-powered DevOps automation.

A production-ready, cloud-native Todo application with AI chatbot capabilities, deployed on local Kubernetes (Minikube) with intelligent DevOps operations powered by Gordon, kubectl-ai, and kagent.

## ⚡ Quickstart

**Get running in 8 steps (~10 minutes):**

```bash
# 1. Start Minikube
bash infra/scripts/setup-minikube.sh

# 2. Build images
docker build -t todo-frontend:v1.0.0 -f infra/docker/frontend/Dockerfile .
docker build -t todo-backend:v1.0.0 -f infra/docker/backend/Dockerfile .

# 3. Load to Minikube
minikube image load todo-frontend:v1.0.0 todo-backend:v1.0.0

# 4. Create secrets (use your own values)
kubectl create secret generic todo-app-secrets \
  --from-literal=BETTER_AUTH_SECRET="your-secret" \
  --from-literal=COHERE_API_KEY="your-key" \
  --from-literal=DATABASE_URL="your-db-url"

# 5. Deploy
helm install todo-app infra/helm/todo-app \
  --set secrets.betterAuthSecret="your-secret" \
  --set secrets.cohereApiKey="your-key" \
  --set secrets.databaseUrl="your-db-url" \
  --wait

# 6. Configure /etc/hosts
echo "$(minikube ip) todo.local" | sudo tee -a /etc/hosts

# 7. Access: http://todo.local
```

📖 **Detailed guide:** [docs/quickstart.md](docs/quickstart.md)

## 🎯 Features

- **Full-Stack Todo Application**: Next.js frontend + FastAPI backend
- **AI-Powered Chatbot**: Natural language task management using Cohere
- **Cloud-Native Architecture**: Containerized, orchestrated with Kubernetes
- **AI DevOps Automation**: Intelligent operations with Gordon, kubectl-ai, and kagent
- **Production-Ready**: Helm charts, health checks, resource limits, rolling updates
- **Secure**: JWT authentication, Kubernetes Secrets, user isolation

## 📋 Prerequisites

### Required Tools

| Tool | Minimum Version | Purpose | Installation |
|------|----------------|---------|--------------|
| **Docker** | 24.0+ | Container runtime | [Install Docker](https://docs.docker.com/get-docker/) |
| **Minikube** | 1.32+ | Local Kubernetes cluster | [Install Minikube](https://minikube.sigs.k8s.io/docs/start/) |
| **kubectl** | 1.28+ | Kubernetes CLI | [Install kubectl](https://kubernetes.io/docs/tasks/tools/) |
| **Helm** | 3.12+ | Kubernetes package manager | [Install Helm](https://helm.sh/docs/intro/install/) |

### Optional AI DevOps Tools

| Tool | Purpose | Installation |
|------|---------|--------------|
| **Gordon** | Docker AI agent for intelligent containerization | [Docker Desktop 4.53+ Beta](https://www.docker.com/products/docker-desktop/) |
| **kubectl-ai** | Natural language Kubernetes operations | [kubectl-ai GitHub](https://github.com/sozercan/kubectl-ai) |
| **kagent** | AI-powered cluster analysis and optimization | [kagent GitHub](https://github.com/GoogleCloudPlatform/kagent) |

### System Requirements

**Minimum Resources for Minikube:**
- **CPU**: 4 cores
- **Memory**: 8 GB RAM
- **Disk**: 20 GB free space
- **OS**: Windows 10+, macOS 10.14+, or Linux

**Application Resource Allocation:**
- Frontend: 256 Mi memory, 200m CPU
- Backend: 512 Mi memory, 300m CPU
- Total: ~1 GB memory, 500m CPU (leaves headroom for system pods)

### External Dependencies

- **Database**: Neon PostgreSQL (external, managed)
- **AI Service**: Cohere API (for chatbot functionality)

## 🚀 Quick Start (One-Command Deployment)

```bash
# 1. Setup Minikube cluster
./infra/scripts/setup-minikube.sh

# 2. Build container images (or use Gordon)
docker build -t todo-frontend:v1.0.0 -f infra/docker/frontend/Dockerfile .
docker build -t todo-backend:v1.0.0 -f infra/docker/backend/Dockerfile .

# 3. Create Kubernetes secrets
kubectl create secret generic todo-app-secrets \
  --from-literal=BETTER_AUTH_SECRET=your-secret-here \
  --from-literal=COHERE_API_KEY=your-cohere-api-key \
  --from-literal=DATABASE_URL=your-neon-database-url

# 4. Deploy application
./infra/scripts/deploy.sh

# 5. Configure /etc/hosts
# Add this line to /etc/hosts (or C:\Windows\System32\drivers\etc\hosts):
# <minikube-ip> todo.local

# 6. Access application
# Open browser: http://todo.local
```

## 📖 Detailed Setup

### Step 1: Verify Prerequisites

```bash
# Check Docker
docker --version
# Expected: Docker version 24.0.0 or higher

# Check Minikube
minikube version
# Expected: minikube version: v1.32.0 or higher

# Check kubectl
kubectl version --client
# Expected: Client Version: v1.28.0 or higher

# Check Helm
helm version
# Expected: version.BuildInfo{Version:"v3.12.0" or higher}
```

### Step 2: Setup Minikube Cluster

The setup script will:
- Start Minikube with recommended resources (4 CPU, 8GB RAM, 20GB disk)
- Enable ingress addon (for HTTP routing)
- Enable metrics-server addon (for resource monitoring)
- Configure kubectl context

```bash
./infra/scripts/setup-minikube.sh
```

**What it does:**
- Checks all prerequisites are installed
- Starts Minikube with Docker driver
- Enables ingress and metrics-server addons
- Waits for ingress controller to be ready
- Displays cluster information

**Expected output:**
```
✅ Minikube setup complete!
📊 Cluster Information:
Kubernetes control plane is running at https://...
```

### Step 3: Build Container Images

#### Option A: Using Gordon (Docker AI) - Recommended

```bash
# Frontend
docker ai build --tag todo-frontend:v1.0.0 frontend/

# Backend
docker ai build --tag todo-backend:v1.0.0 backend/
```

#### Option B: Manual Docker Build

```bash
# Frontend (multi-stage: Node build → Nginx serve)
docker build -t todo-frontend:v1.0.0 -f infra/docker/frontend/Dockerfile .

# Backend (Python slim + Uvicorn)
docker build -t todo-backend:v1.0.0 -f infra/docker/backend/Dockerfile .
```

**Verify images:**
```bash
docker images | grep todo
# Expected:
# todo-frontend    v1.0.0    <image-id>    <size>
# todo-backend     v1.0.0    <image-id>    <size>
```

### Step 4: Create Kubernetes Secrets

**Required secrets:**
- `BETTER_AUTH_SECRET`: JWT signing secret (generate with `openssl rand -base64 32`)
- `COHERE_API_KEY`: Your Cohere API key from [cohere.com](https://cohere.com)
- `DATABASE_URL`: Neon PostgreSQL connection string

```bash
kubectl create secret generic todo-app-secrets \
  --from-literal=BETTER_AUTH_SECRET=$(openssl rand -base64 32) \
  --from-literal=COHERE_API_KEY=your-cohere-api-key-here \
  --from-literal=DATABASE_URL=postgresql://user:pass@host/db

# Verify secret created
kubectl get secret todo-app-secrets
```

### Step 5: Deploy Application

The deployment script will:
- Validate Helm chart
- Load container images to Minikube
- Install/upgrade Helm release
- Wait for pods to be ready
- Display deployment status and access instructions

```bash
./infra/scripts/deploy.sh
```

**Expected output:**
```
✅ Deployment complete!
🌐 Access the application:
  1. Add to /etc/hosts:
     192.168.49.2 todo.local
  2. Open in browser:
     http://todo.local
```

### Step 6: Configure Local DNS

**Linux/macOS:**
```bash
# Get Minikube IP
MINIKUBE_IP=$(minikube ip)

# Add to /etc/hosts (requires sudo)
echo "$MINIKUBE_IP todo.local" | sudo tee -a /etc/hosts
```

**Windows:**
```powershell
# Get Minikube IP
minikube ip

# Add to C:\Windows\System32\drivers\etc\hosts (as Administrator)
# <minikube-ip> todo.local
```

### Step 7: Access Application

Open browser and navigate to: **http://todo.local**

**Test the application:**
1. Sign up with email/password
2. Log in
3. Chat with AI: "Add a task to buy groceries"
4. View tasks in the Tasks page
5. Update profile information

## 🤖 AI DevOps Operations

### Gordon (Docker AI)

Intelligent container image building with optimization recommendations.

```bash
# Build with Gordon
docker ai build --tag todo-frontend:v1.0.0 frontend/

# Get optimization suggestions
docker ai analyze todo-frontend:v1.0.0
```

### kubectl-ai

Natural language Kubernetes operations.

```bash
# Scale backend
kubectl ai "scale backend to 3 replicas"

# Debug pod issues
kubectl ai "check why backend pod is failing"

# View logs
kubectl ai "show logs for backend pods"

# Update image
kubectl ai "update backend image to v1.1.0"
```

### kagent

AI-powered cluster analysis and optimization.

```bash
# Analyze cluster health
kagent analyze health

# Optimize resources
kagent optimize resources for todo pods

# Get recommendations
kagent suggest fixes for high memory usage
```

## 🔍 Monitoring and Debugging

### Check Pod Status

```bash
# List all pods
kubectl get pods

# Watch pod status (live updates)
kubectl get pods -w

# Describe pod (detailed info)
kubectl describe pod <pod-name>
```

### View Logs

```bash
# Frontend logs
kubectl logs -f deployment/todo-app-frontend

# Backend logs
kubectl logs -f deployment/todo-app-backend

# All logs with label
kubectl logs -l app.kubernetes.io/instance=todo-app --all-containers=true
```

### Check Services and Ingress

```bash
# List services
kubectl get svc

# List ingress
kubectl get ingress

# Describe ingress
kubectl describe ingress todo-app-ingress
```

### Resource Usage

```bash
# Pod resource usage
kubectl top pods

# Node resource usage
kubectl top nodes
```

### Health Checks

```bash
# Frontend health
curl http://todo.local/health

# Backend health (via port-forward)
kubectl port-forward deployment/todo-app-backend 8000:8000
curl http://localhost:8000/health
```

## 🧹 Cleanup

### Remove Deployment

```bash
# Interactive cleanup (recommended)
./infra/scripts/cleanup.sh

# Manual cleanup
helm uninstall todo-app
kubectl delete secret todo-app-secrets
```

### Stop Minikube

```bash
# Stop cluster (preserves data)
minikube stop

# Delete cluster (removes all data)
minikube delete
```

## ❓ FAQ

### General Questions

**Q: How long does deployment take?**
A: Approximately 8-12 minutes for a fresh deployment, including image builds.

**Q: Can I use this in production?**
A: This is configured for local development with Minikube. For production, you'll need:
- Multi-node Kubernetes cluster
- External load balancer
- TLS certificates
- Database replication
- Monitoring and alerting
- See [Architecture Documentation](docs/architecture.md) for production recommendations.

**Q: What are the system requirements?**
A: Minimum 4 CPU cores, 6GB RAM, 20GB disk space. Docker Desktop should have at least 6GB memory allocated.

### Deployment Questions

**Q: Why can't I access http://todo.local?**
A: Make sure you've added the Minikube IP to your /etc/hosts file:
```bash
echo "$(minikube ip) todo.local" | sudo tee -a /etc/hosts
```

**Q: Pods are stuck in Pending state. What should I do?**
A: Check if Minikube has enough resources:
```bash
kubectl describe pod <pod-name>
minikube stop
minikube start --cpus=4 --memory=6144
```

**Q: Images not found error?**
A: Load images to Minikube:
```bash
minikube image load todo-frontend:v1.0.0
minikube image load todo-backend:v1.0.0
```

**Q: How do I update the application?**
A: Build new images and upgrade the Helm release:
```bash
docker build -t todo-frontend:v1.0.1 -f infra/docker/frontend/Dockerfile .
minikube image load todo-frontend:v1.0.1
helm upgrade todo-app infra/helm/todo-app --set frontend.image.tag=v1.0.1
```

### AI DevOps Questions

**Q: Do I need Gordon, kubectl-ai, and kagent?**
A: No, they're optional. The application works without them. They provide enhanced DevOps capabilities:
- Gordon: AI-powered Docker builds
- kubectl-ai: Natural language Kubernetes operations
- kagent: Cluster analysis and optimization

**Q: How do I install the AI tools?**
A: See the documentation:
- [Gordon Integration](docs/gordon-integration.md)
- [kubectl-ai Examples](docs/kubectl-ai-examples.md)
- [kagent Examples](docs/kagent-examples.md)

**Q: Are there costs for AI tools?**
A: kubectl-ai and kagent require API keys (OpenAI, Google AI) which have associated costs. Gordon is included in Docker Desktop Beta (free).

### Troubleshooting Questions

**Q: Backend pod keeps crashing?**
A: Check the logs and verify secrets:
```bash
kubectl logs deployment/todo-app-backend
kubectl describe secret todo-app-secrets
```
Common causes: incorrect DATABASE_URL, missing COHERE_API_KEY

**Q: How do I view logs?**
A: Use kubectl:
```bash
kubectl logs -f deployment/todo-app-frontend
kubectl logs -f deployment/todo-app-backend
```

**Q: How do I restart a deployment?**
A: Use kubectl rollout:
```bash
kubectl rollout restart deployment/todo-app-backend
```

**Q: Where can I find more troubleshooting help?**
A: See the comprehensive [Troubleshooting Guide](docs/troubleshooting.md)

### Feature Questions

**Q: How does the AI chatbot work?**
A: The backend integrates with Cohere API to process natural language. You can chat with the AI to create tasks, get suggestions, and manage your todo list conversationally.

**Q: Is my data secure?**
A: Yes. The application uses:
- JWT authentication
- Kubernetes Secrets for sensitive data
- Non-root containers
- External managed database (Neon PostgreSQL)
- No sensitive data in logs

**Q: Can I scale the application?**
A: Yes, horizontally:
```bash
kubectl scale deployment/todo-app-backend --replicas=3
```

**Q: Does it support multiple users?**
A: Yes, each user has their own account with isolated data.

### Development Questions

**Q: How do I modify the application?**
A:
1. Make changes to frontend/ or backend/ code
2. Rebuild images
3. Load to Minikube
4. Upgrade Helm release

**Q: Can I use a different database?**
A: Yes, update the DATABASE_URL in secrets to point to your PostgreSQL instance.

**Q: How do I add new environment variables?**
A: Update the Helm chart templates and values.yaml, then upgrade the release.

**Q: Where is the source code?**
A:
- Frontend: `frontend/` directory
- Backend: `backend/` directory
- Infrastructure: `infra/` directory
- Documentation: `docs/` directory

## 🧹 Cleanup

### Remove Deployment

```bash
# Interactive cleanup (recommended)
./infra/scripts/cleanup.sh

# Manual cleanup
helm uninstall todo-app
kubectl delete secret todo-app-secrets
```

### Stop Minikube

```bash
# Stop cluster (preserves data)
minikube stop

# Delete cluster (removes all data)
minikube delete
```

## 🐛 Troubleshooting

### Minikube won't start

**Issue**: `minikube start` fails with resource errors

**Solution**:
```bash
# Check Docker is running
docker ps

# Delete and recreate cluster
minikube delete
./infra/scripts/setup-minikube.sh
```

### Pods stuck in Pending state

**Issue**: Pods show `Pending` status

**Solution**:
```bash
# Check pod events
kubectl describe pod <pod-name>

# Check node resources
kubectl top nodes

# Common causes:
# - Insufficient resources (increase Minikube memory)
# - Image pull errors (check image exists)
# - Secret not found (create todo-app-secrets)
```

### Ingress not working

**Issue**: Cannot access http://todo.local

**Solution**:
```bash
# Verify ingress addon enabled
minikube addons list | grep ingress

# Check ingress controller
kubectl get pods -n ingress-nginx

# Verify /etc/hosts entry
cat /etc/hosts | grep todo.local

# Get Minikube IP
minikube ip
```

### Image not found

**Issue**: `ImagePullBackOff` or `ErrImagePull`

**Solution**:
```bash
# Load images to Minikube
minikube image load todo-frontend:v1.0.0
minikube image load todo-backend:v1.0.0

# Verify images in Minikube
minikube ssh docker images | grep todo
```

### Secrets not injected

**Issue**: Pods crash with environment variable errors

**Solution**:
```bash
# Verify secret exists
kubectl get secret todo-app-secrets

# Check secret data
kubectl describe secret todo-app-secrets

# Recreate secret if needed
kubectl delete secret todo-app-secrets
kubectl create secret generic todo-app-secrets \
  --from-literal=BETTER_AUTH_SECRET=... \
  --from-literal=COHERE_API_KEY=... \
  --from-literal=DATABASE_URL=...
```

### Database connection fails

**Issue**: Backend logs show database connection errors

**Solution**:
```bash
# Verify DATABASE_URL is correct
kubectl get secret todo-app-secrets -o jsonpath='{.data.DATABASE_URL}' | base64 -d

# Test connection from pod
kubectl exec -it deployment/todo-app-backend -- python -c "import psycopg2; print('OK')"

# Check Neon database is accessible
# - Verify IP whitelist includes Minikube IP
# - Check database credentials
```

## 📚 Project Structure

```
.
├── infra/                          # Infrastructure layer (Phase IV)
│   ├── docker/                     # Container definitions
│   │   ├── frontend/
│   │   │   ├── Dockerfile          # Multi-stage Next.js build
│   │   │   └── .dockerignore
│   │   └── backend/
│   │       ├── Dockerfile          # Python FastAPI image
│   │       └── .dockerignore
│   ├── helm/                       # Kubernetes deployment
│   │   └── todo-app/
│   │       ├── Chart.yaml          # Helm chart metadata
│   │       ├── values.yaml         # Configuration values
│   │       └── templates/          # K8s resource templates
│   │           ├── deployment-frontend.yaml
│   │           ├── deployment-backend.yaml
│   │           ├── service-frontend.yaml
│   │           ├── service-backend.yaml
│   │           ├── ingress.yaml
│   │           ├── secret.yaml
│   │           ├── configmap.yaml
│   │           └── _helpers.tpl
│   └── scripts/                    # Automation scripts
│       ├── setup-minikube.sh       # Cluster initialization
│       ├── deploy.sh               # One-command deployment
│       └── cleanup.sh              # Resource cleanup
├── frontend/                       # Next.js application (Phase I-III)
├── backend/                        # FastAPI application (Phase II-III)
└── specs/                          # Specification documents
    └── 001-cloud-native-k8s/
        ├── spec.md                 # Feature requirements
        ├── plan.md                 # Implementation plan
        └── tasks.md                # Task breakdown
```

## 🎓 Learning Resources

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Helm Documentation](https://helm.sh/docs/)
- [Minikube Documentation](https://minikube.sigs.k8s.io/docs/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

## 📝 License

This project is part of a hackathon submission demonstrating cloud-native architecture and AI-powered DevOps automation.

## 🤝 Contributing

This is a hackathon project. For questions or issues, please refer to the project documentation in the `specs/` directory.

---

**Built with ❤️ using Claude Code + Spec-Kit for intelligent, spec-driven development**
