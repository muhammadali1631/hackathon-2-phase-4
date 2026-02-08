# kubectl-ai Commands Skill

A comprehensive AI-powered Kubernetes management system using kubectl-ai for natural language cluster operations, deployments, scaling, and debugging.

## Functions

### `generate-deployment(app_name: string, replicas: number, port: number, image: string)`
Creates a Kubernetes deployment using natural language commands.

**Parameters:**
- `app_name` (string): Application name (e.g., `todo-frontend`)
- `replicas` (number): Number of pod replicas (e.g., `2`)
- `port` (number): Container port (e.g., `3000`)
- `image` (string): Container image (optional, can be inferred)

**Command:**
```bash
kubectl-ai "deploy todo-frontend with 2 replicas and port 3000"
```

**Alternative Natural Language Commands:**
```bash
kubectl-ai "create a deployment for todo-frontend with 2 pods on port 3000"
kubectl-ai "deploy todo-frontend image todo-frontend:latest with 2 replicas exposing port 3000"
kubectl-ai "create deployment todo-frontend, 2 replicas, container port 3000"
```

**Traditional kubectl Equivalent:**
```bash
kubectl create deployment todo-frontend \
  --image=todo-frontend:latest \
  --replicas=2 \
  --port=3000
```

**Implementation:**
- Creates Deployment resource with specified replicas
- Configures container port mapping
- Sets resource labels and selectors
- Applies default resource limits if not specified
- Creates in current namespace or specified namespace

**Response:**
- Deployment created successfully
- Pods scheduled and running
- Deployment status available via `kubectl get deployments`

### `scale-backend(deployment_name: string, replicas: number)`
Scales a deployment to the specified number of replicas.

**Parameters:**
- `deployment_name` (string): Name of deployment to scale (e.g., `backend`)
- `replicas` (number): Target replica count (e.g., `3`)

**Command:**
```bash
kubectl-ai "scale backend to 3 replicas"
```

**Alternative Natural Language Commands:**
```bash
kubectl-ai "scale the backend deployment to 3 pods"
kubectl-ai "increase backend replicas to 3"
kubectl-ai "set backend replica count to 3"
kubectl-ai "scale up backend to 3 instances"
```

**Traditional kubectl Equivalent:**
```bash
kubectl scale deployment backend --replicas=3
```

**Implementation:**
- Updates deployment replica count
- Kubernetes performs rolling update
- New pods scheduled if scaling up
- Pods terminated gracefully if scaling down
- Maintains service availability during scaling

**Response:**
- Deployment scaled successfully
- New replica count reflected in deployment status
- Pods created or terminated as needed

### `debug-pod(pod_name: string, issue: string)`
Diagnoses and troubleshoots pod issues using AI-powered analysis.

**Parameters:**
- `pod_name` (string): Pod name or pattern (e.g., `backend`)
- `issue` (string): Issue description (e.g., `CrashLoopBackOff`)

**Command:**
```bash
kubectl-ai "check why backend pod is CrashLoopBackOff"
```

**Alternative Natural Language Commands:**
```bash
kubectl-ai "debug backend pod that keeps crashing"
kubectl-ai "why is my frontend pod not starting"
kubectl-ai "troubleshoot backend-7d9f8c-xyz pod errors"
kubectl-ai "analyze logs for failing backend pod"
kubectl-ai "what's wrong with the database pod"
```

**Traditional kubectl Equivalent:**
```bash
# Check pod status
kubectl get pods | grep backend

# Describe pod for events
kubectl describe pod <pod-name>

# Check logs
kubectl logs <pod-name>

# Check previous container logs if crashed
kubectl logs <pod-name> --previous
```

**Implementation:**
- Retrieves pod status and events
- Analyzes container logs for errors
- Checks resource constraints (CPU, memory)
- Examines liveness/readiness probe failures
- Reviews image pull issues
- Identifies configuration problems
- Provides actionable recommendations

**Response:**
- Root cause analysis of the issue
- Specific error messages and events
- Recommended fixes and next steps
- Relevant logs and diagnostic information

### `create-service(app_name: string, port: number, target_port: number, service_type: string)`
Creates a Kubernetes service to expose an application.

**Parameters:**
- `app_name` (string): Application name
- `port` (number): Service port
- `target_port` (number): Container target port
- `service_type` (string): Service type (ClusterIP, NodePort, LoadBalancer)

**Command:**
```bash
kubectl-ai "create a service for todo-frontend on port 80 targeting port 3000"
```

**Alternative Natural Language Commands:**
```bash
kubectl-ai "expose todo-frontend deployment on port 80"
kubectl-ai "create LoadBalancer service for backend on port 8000"
kubectl-ai "expose frontend with NodePort service on port 3000"
```

**Traditional kubectl Equivalent:**
```bash
kubectl expose deployment todo-frontend \
  --port=80 \
  --target-port=3000 \
  --type=ClusterIP
```

### `view-logs(pod_name: string, follow: boolean, tail: number)`
Retrieves and streams pod logs.

**Command:**
```bash
kubectl-ai "show logs for backend pod"
kubectl-ai "tail logs from frontend pod"
kubectl-ai "stream logs from backend with last 100 lines"
```

**Traditional kubectl Equivalent:**
```bash
kubectl logs backend-7d9f8c-xyz
kubectl logs -f backend-7d9f8c-xyz --tail=100
```

### `get-resources(resource_type: string, namespace: string)`
Lists Kubernetes resources with AI-powered filtering and formatting.

**Command:**
```bash
kubectl-ai "show all pods in production namespace"
kubectl-ai "list deployments with their replica counts"
kubectl-ai "get services and their endpoints"
kubectl-ai "show all resources in default namespace"
```

**Traditional kubectl Equivalent:**
```bash
kubectl get pods -n production
kubectl get deployments -o wide
kubectl get services
kubectl get all
```

### `update-image(deployment_name: string, image: string)`
Updates a deployment with a new container image.

**Command:**
```bash
kubectl-ai "update todo-frontend to use image todo-frontend:v1.1.0"
kubectl-ai "set backend image to backend:latest"
kubectl-ai "deploy new version v2.0.0 for frontend"
```

**Traditional kubectl Equivalent:**
```bash
kubectl set image deployment/todo-frontend \
  todo-frontend=todo-frontend:v1.1.0
```

### `rollback-deployment(deployment_name: string, revision: number)`
Rolls back a deployment to a previous revision.

**Command:**
```bash
kubectl-ai "rollback todo-frontend to previous version"
kubectl-ai "undo last deployment for backend"
kubectl-ai "rollback frontend to revision 3"
```

**Traditional kubectl Equivalent:**
```bash
kubectl rollout undo deployment/todo-frontend
kubectl rollout undo deployment/todo-frontend --to-revision=3
```

### `check-health(app_name: string)`
Checks the health status of an application and its components.

**Command:**
```bash
kubectl-ai "check health of todo-frontend"
kubectl-ai "is backend healthy and running"
kubectl-ai "show status of all frontend pods"
```

**Traditional kubectl Equivalent:**
```bash
kubectl get deployment todo-frontend
kubectl get pods -l app=todo-frontend
kubectl describe deployment todo-frontend
```

### `apply-manifest(file_path: string)`
Applies Kubernetes manifests using natural language.

**Command:**
```bash
kubectl-ai "apply the deployment manifest from deployment.yaml"
kubectl-ai "create resources from k8s/manifests/"
```

**Traditional kubectl Equivalent:**
```bash
kubectl apply -f deployment.yaml
kubectl apply -f k8s/manifests/
```

### `delete-resources(resource_type: string, name: string)`
Deletes Kubernetes resources safely.

**Command:**
```bash
kubectl-ai "delete the old-backend deployment"
kubectl-ai "remove frontend service"
kubectl-ai "delete all pods with label app=test"
```

**Traditional kubectl Equivalent:**
```bash
kubectl delete deployment old-backend
kubectl delete service frontend
kubectl delete pods -l app=test
```

### `exec-into-pod(pod_name: string, command: string)`
Executes commands inside a running pod.

**Command:**
```bash
kubectl-ai "exec into backend pod and run bash"
kubectl-ai "run 'npm run migrate' in frontend pod"
kubectl-ai "open shell in database pod"
```

**Traditional kubectl Equivalent:**
```bash
kubectl exec -it backend-7d9f8c-xyz -- /bin/bash
kubectl exec backend-7d9f8c-xyz -- npm run migrate
```

### `port-forward(pod_name: string, local_port: number, remote_port: number)`
Forwards local port to a pod for debugging.

**Command:**
```bash
kubectl-ai "forward port 8080 to backend pod port 8000"
kubectl-ai "port forward frontend pod 3000 to local 3000"
```

**Traditional kubectl Equivalent:**
```bash
kubectl port-forward pod/backend-7d9f8c-xyz 8080:8000
kubectl port-forward deployment/frontend 3000:3000
```

## Usage Examples

### Deployment Management

**Create and Deploy Application:**
```bash
# Deploy frontend
kubectl-ai "deploy todo-frontend with 3 replicas on port 3000 using image todo-frontend:v1.0.0"

# Deploy backend with resource limits
kubectl-ai "create backend deployment with 2 replicas, port 8000, 500m CPU limit, 512Mi memory limit"

# Deploy with environment variables
kubectl-ai "deploy backend with env DATABASE_URL and JWT_SECRET from secret"
```

**Update Deployments:**
```bash
# Update image version
kubectl-ai "update frontend deployment to version v1.2.0"

# Change replica count
kubectl-ai "scale frontend to 5 replicas"

# Update resource limits
kubectl-ai "set backend memory limit to 1Gi"
```

**Rollback Deployments:**
```bash
# Rollback to previous version
kubectl-ai "rollback frontend deployment"

# Rollback to specific revision
kubectl-ai "rollback backend to revision 5"

# Check rollout history
kubectl-ai "show deployment history for frontend"
```

### Service Management

**Create Services:**
```bash
# ClusterIP service (internal)
kubectl-ai "create ClusterIP service for backend on port 8000"

# LoadBalancer service (external)
kubectl-ai "expose frontend with LoadBalancer on port 80"

# NodePort service
kubectl-ai "create NodePort service for api on port 3000"
```

**Service Discovery:**
```bash
# List services
kubectl-ai "show all services and their endpoints"

# Get service details
kubectl-ai "describe frontend service"

# Check service connectivity
kubectl-ai "test connection to backend service"
```

### Debugging and Troubleshooting

**Pod Issues:**
```bash
# Diagnose crash loops
kubectl-ai "why is backend pod crashing"

# Check pending pods
kubectl-ai "why is frontend pod stuck in Pending state"

# Analyze OOMKilled pods
kubectl-ai "check if backend pod ran out of memory"

# Image pull errors
kubectl-ai "debug ImagePullBackOff error for frontend"
```

**Log Analysis:**
```bash
# View recent logs
kubectl-ai "show last 50 lines of backend logs"

# Stream logs in real-time
kubectl-ai "tail frontend logs"

# Check logs from crashed container
kubectl-ai "show logs from previous backend container"

# Filter logs by pattern
kubectl-ai "search for 'ERROR' in backend logs"
```

**Resource Inspection:**
```bash
# Check resource usage
kubectl-ai "show CPU and memory usage for all pods"

# Describe pod details
kubectl-ai "describe backend pod with all events"

# Check node resources
kubectl-ai "show node resource allocation"

# View pod events
kubectl-ai "show events for failing frontend pod"
```

### Configuration Management

**ConfigMaps:**
```bash
# Create ConfigMap
kubectl-ai "create configmap app-config from file config.json"

# Update ConfigMap
kubectl-ai "update app-config configmap with new values"

# Use ConfigMap in deployment
kubectl-ai "mount app-config configmap to backend deployment"
```

**Secrets:**
```bash
# Create secret
kubectl-ai "create secret db-credentials with username and password"

# Use secret in deployment
kubectl-ai "add db-credentials secret to backend as environment variables"

# Update secret
kubectl-ai "update jwt-secret with new value"
```

### Namespace Management

**Working with Namespaces:**
```bash
# Create namespace
kubectl-ai "create namespace production"

# Switch namespace
kubectl-ai "use production namespace"

# List resources in namespace
kubectl-ai "show all pods in staging namespace"

# Delete namespace
kubectl-ai "delete development namespace"
```

### Advanced Operations

**Rolling Updates:**
```bash
# Perform rolling update
kubectl-ai "update frontend to v2.0.0 with rolling update strategy"

# Pause rollout
kubectl-ai "pause frontend deployment rollout"

# Resume rollout
kubectl-ai "resume frontend deployment rollout"

# Check rollout status
kubectl-ai "show rollout status for backend"
```

**Autoscaling:**
```bash
# Create HPA
kubectl-ai "autoscale frontend from 2 to 10 replicas based on 80% CPU"

# Update HPA
kubectl-ai "change frontend autoscaling to target 70% CPU"

# Check HPA status
kubectl-ai "show autoscaling status for backend"
```

**Resource Quotas:**
```bash
# Create resource quota
kubectl-ai "create resource quota in production with 10 CPU and 20Gi memory limit"

# Check quota usage
kubectl-ai "show resource quota usage in production namespace"
```

## Best Practices

### Natural Language Commands
- Be specific and clear in your requests
- Include all necessary parameters (replicas, ports, images)
- Use consistent naming conventions
- Specify namespace when working with multiple environments
- Provide context for debugging requests

### Deployment Strategy
- Always specify image tags (avoid `latest` in production)
- Set resource requests and limits
- Configure health probes (liveness and readiness)
- Use rolling update strategy for zero-downtime deployments
- Test in development namespace before production

### Debugging Workflow
1. Check pod status: `kubectl-ai "show pod status"`
2. View events: `kubectl-ai "describe pod with events"`
3. Check logs: `kubectl-ai "show pod logs"`
4. Inspect configuration: `kubectl-ai "describe deployment"`
5. Verify resources: `kubectl-ai "check resource usage"`

### Security
- Use RBAC to control access
- Store sensitive data in Secrets, not ConfigMaps
- Scan images for vulnerabilities
- Use network policies to restrict traffic
- Enable pod security policies
- Regularly update and patch containers

### Resource Management
- Set appropriate resource requests and limits
- Monitor resource usage regularly
- Use horizontal pod autoscaling for variable loads
- Implement pod disruption budgets
- Configure node affinity and anti-affinity rules

### Monitoring and Observability
- Enable logging for all applications
- Use labels consistently for filtering
- Implement health check endpoints
- Monitor pod restarts and failures
- Set up alerts for critical issues

## Common Debugging Scenarios

### CrashLoopBackOff
```bash
# Diagnose the issue
kubectl-ai "why is backend pod in CrashLoopBackOff"

# Check logs from crashed container
kubectl-ai "show logs from previous backend container"

# Common causes:
# - Application error on startup
# - Missing environment variables
# - Failed health checks
# - Insufficient resources
```

### ImagePullBackOff
```bash
# Debug image pull issues
kubectl-ai "check why frontend can't pull image"

# Common causes:
# - Image doesn't exist
# - Wrong image tag
# - Authentication required
# - Registry unreachable
```

### Pending Pods
```bash
# Check why pod is pending
kubectl-ai "why is backend pod stuck in Pending"

# Common causes:
# - Insufficient cluster resources
# - Node selector mismatch
# - PersistentVolume not available
# - Pod affinity/anti-affinity rules
```

### OOMKilled
```bash
# Check memory issues
kubectl-ai "did backend pod run out of memory"

# Solutions:
# - Increase memory limits
# - Optimize application memory usage
# - Check for memory leaks
```

### Service Not Reachable
```bash
# Debug service connectivity
kubectl-ai "why can't I reach frontend service"

# Check service endpoints
kubectl-ai "show endpoints for frontend service"

# Common causes:
# - Pod selector mismatch
# - Pods not ready
# - Network policy blocking traffic
# - Wrong port configuration
```

## Integration with CI/CD

### GitHub Actions Example
```yaml
name: Deploy with kubectl-ai
on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Install kubectl-ai
        run: |
          # Install kubectl-ai
          curl -LO https://kubectl-ai.io/install.sh
          bash install.sh

      - name: Deploy Application
        run: |
          kubectl-ai "deploy todo-frontend with 3 replicas on port 3000 using image todo-frontend:${{ github.sha }}"
          kubectl-ai "update frontend service to use new deployment"

      - name: Verify Deployment
        run: |
          kubectl-ai "check if frontend deployment is healthy"
          kubectl-ai "show frontend pod status"
```

### GitLab CI Example
```yaml
deploy:
  stage: deploy
  image: kubectl-ai/cli:latest
  script:
    - kubectl-ai "deploy backend with 2 replicas on port 8000 using image backend:$CI_COMMIT_SHA"
    - kubectl-ai "scale backend to 3 replicas"
    - kubectl-ai "check backend health"
  only:
    - main
```

## Fallback to Traditional kubectl

When kubectl-ai is not available, use traditional kubectl commands:

```bash
# Deployment
kubectl create deployment todo-frontend --image=todo-frontend:latest --replicas=2
kubectl expose deployment todo-frontend --port=80 --target-port=3000

# Scaling
kubectl scale deployment backend --replicas=3

# Debugging
kubectl get pods
kubectl describe pod <pod-name>
kubectl logs <pod-name>
kubectl logs <pod-name> --previous

# Updates
kubectl set image deployment/frontend frontend=frontend:v1.1.0
kubectl rollout status deployment/frontend
kubectl rollout undo deployment/frontend

# Execution
kubectl exec -it <pod-name> -- /bin/bash

# Port forwarding
kubectl port-forward pod/<pod-name> 8080:8000
```

## Error Handling

### kubectl-ai Not Found
- Install kubectl-ai: `curl -LO https://kubectl-ai.io/install.sh && bash install.sh`
- Verify installation: `kubectl-ai --version`
- Fall back to traditional kubectl commands

### Authentication Errors
- Check kubeconfig: `kubectl config view`
- Verify cluster connection: `kubectl cluster-info`
- Update credentials: `kubectl config use-context <context-name>`

### Permission Denied
- Check RBAC permissions: `kubectl auth can-i <verb> <resource>`
- Request necessary permissions from cluster admin
- Verify service account has required roles

### Resource Not Found
- Verify resource exists: `kubectl get <resource-type>`
- Check namespace: `kubectl get <resource> -n <namespace>`
- List all namespaces: `kubectl get namespaces`

### Timeout Errors
- Check cluster connectivity
- Verify API server is responsive
- Increase timeout: `kubectl --request-timeout=30s`

## Troubleshooting Commands

```bash
# Cluster information
kubectl-ai "show cluster info"
kubectl-ai "list all nodes and their status"

# Resource usage
kubectl-ai "show resource usage across all namespaces"
kubectl-ai "which pods are using the most memory"

# Network debugging
kubectl-ai "test connectivity between frontend and backend"
kubectl-ai "show network policies affecting backend"

# Configuration validation
kubectl-ai "validate deployment manifest"
kubectl-ai "check if service selector matches pods"

# Performance analysis
kubectl-ai "show slow-starting pods"
kubectl-ai "identify pods with high restart counts"
```

## Quick Reference

### Common Commands
```bash
# Deploy
kubectl-ai "deploy <app> with <N> replicas on port <port>"

# Scale
kubectl-ai "scale <app> to <N> replicas"

# Update
kubectl-ai "update <app> to image <image:tag>"

# Debug
kubectl-ai "why is <app> pod failing"

# Logs
kubectl-ai "show logs for <app>"

# Rollback
kubectl-ai "rollback <app> deployment"

# Health
kubectl-ai "check health of <app>"

# Delete
kubectl-ai "delete <app> deployment"
```

### Status Checks
```bash
kubectl-ai "show all pods"
kubectl-ai "list deployments"
kubectl-ai "get services"
kubectl-ai "show events"
kubectl-ai "describe <resource> <name>"
```
