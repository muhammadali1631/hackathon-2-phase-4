# Implementation Plan: Cloud-Native Kubernetes Deployment

**Branch**: `001-cloud-native-k8s` | **Date**: 2026-02-08 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/001-cloud-native-k8s/spec.md`

**Note**: This template is filled in by the `/sp.plan` command. See `.specify/templates/commands/plan.md` for the execution workflow.

## Summary

Transform the existing Phase III full-stack Todo AI Chatbot into a production-grade, cloud-native application deployed on local Minikube using AI-powered DevOps automation. The implementation will containerize both frontend (Next.js) and backend (FastAPI) applications, package them with a complete Helm chart, and deploy to a local Kubernetes cluster with full observability and AI-assisted operations (Gordon for containerization, kubectl-ai for deployment/scaling, kagent for cluster analysis).

Primary requirement: Enable single-command deployment (`helm install`) of the entire Todo AI Chatbot to Minikube while maintaining 100% feature parity with Phase III and showcasing intelligent DevOps automation that impresses hackathon judges.

## Technical Context

**Language/Version**:
- Frontend: Node.js 18+ (for Next.js 16 build), Nginx (for serving)
- Backend: Python 3.11+
- Infrastructure: Bash/Shell scripting for automation

**Primary Dependencies**:
- **Containerization**: Docker 24+, Gordon AI (Docker Desktop 4.53+ Beta with AI features enabled)
- **Orchestration**: Kubernetes 1.28+, Helm 3.12+, Minikube 1.32+
- **AI DevOps Tools**: kubectl-ai, kagent (cluster intelligence agent)
- **Existing Stack**: Next.js 16+, FastAPI, SQLModel, Uvicorn, Cohere SDK, Better Auth

**Storage**:
- External Neon PostgreSQL (from Phase III, no changes required)
- Kubernetes Secrets for sensitive configuration
- No persistent volumes needed (stateless application architecture)

**Testing**:
- Container validation: `docker run` local testing
- Kubernetes validation: `kubectl get pods`, health check endpoints
- End-to-end: Browser testing via Ingress (http://todo.local)
- AI tools validation: Demonstrate Gordon, kubectl-ai, kagent operations

**Target Platform**:
- Local Minikube cluster (single-node Kubernetes)
- Host OS: Windows/macOS/Linux with Docker Desktop
- Minimum resources: 4GB RAM, 2 CPUs for Minikube

**Project Type**: Infrastructure (adds deployment layer to existing web application)

**Performance Goals**:
- Container build time: <5 minutes per image
- Helm deployment time: <3 minutes from install to ready
- Pod startup time: <2 minutes to Running state
- Application response: <30 seconds from deployment to browser access
- Zero downtime during pod restarts

**Constraints**:
- Local Minikube only (no cloud deployments)
- No changes to Phase III application code
- Resource limits suitable for local development (frontend: 256Mi/200m CPU, backend: 512Mi/300m CPU)
- External Neon database (no local PostgreSQL StatefulSet)
- Ingress via Minikube addon (no LoadBalancer)
- Secrets via Kubernetes Secrets (no external secret managers)

**Scale/Scope**:
- 2 frontend replicas, 2 backend replicas (minimum for HA demonstration)
- Single Minikube node (local development)
- Support for 10+ concurrent demo users
- Complete Helm chart with 5+ templates (deployment, service, ingress, secret, configmap)

### Infrastructure Context

**Containerization**: Docker with Gordon AI agent (fallback: Claude-generated multi-stage Dockerfiles)

**Orchestration**: Kubernetes (Minikube local cluster), Helm 3.x for package management

**AI DevOps Tools**:
- Gordon (Docker AI): Intelligent Dockerfile generation and optimization
- kubectl-ai: Natural language Kubernetes operations
- kagent: Cluster health analysis and resource optimization

**Deployment Target**: Local Minikube single-node cluster

**Resource Requirements**: Minikube with 4GB+ RAM, 2+ CPUs

**Observability**: kubectl logs, kubectl top, health check endpoints, Kubernetes events

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### ✅ Principle I: Spec-Driven Development with Infrastructure Automation
- **Status**: PASS
- **Evidence**: Complete specification exists at specs/001-cloud-native-k8s/spec.md with 36 functional requirements
- **Infrastructure Traceability**: All Dockerfiles, Helm charts, and K8s manifests will be generated via AI agents (Gordon, kubectl-ai) or Claude Code with full traceability to spec requirements

### ✅ Principle II: Zero Manual Operations Mandate
- **Status**: PASS
- **Evidence**: Plan mandates use of Gordon for Docker builds, kubectl-ai for K8s operations, kagent for cluster analysis
- **Fallback Strategy**: If AI tools unavailable, Claude Code generates artifacts (still automated, not manual)

### ✅ Principle III: Modular Architecture with Cloud-Native Services
- **Status**: PASS
- **Evidence**: Infrastructure follows cloud-native patterns (containerized services, declarative config, service discovery, health checks)
- **Existing Architecture**: Phase III modular architecture (Main Agent, Task Agent, Auth Agent, UI Agent, AI Chatbot Agent) remains unchanged

### ✅ Principle IV: Complete User Isolation
- **Status**: PASS
- **Evidence**: No changes to application code; user isolation enforced at application layer (unchanged from Phase III)
- **Kubernetes Impact**: User isolation maintained across pod restarts via stateless architecture + database persistence

### ✅ Principle V: Technology Stack Adherence
- **Status**: PASS
- **Evidence**: Using specified stack (Docker + Gordon, Kubernetes + Minikube, Helm 3.x, kubectl-ai, kagent)
- **No New Dependencies**: Only infrastructure tools added, no application-level dependencies

### ✅ Principle VI: Stateless Authentication with JWT
- **Status**: PASS
- **Evidence**: JWT secrets managed via Kubernetes Secrets (FR-012, FR-019)
- **No Changes**: Authentication mechanism unchanged from Phase III

### ✅ Principle XI: Cloud-Native Architecture and Containerization
- **Status**: PASS
- **Evidence**: Multi-stage Dockerfiles planned (Node build → Nginx serve for frontend, Python slim for backend)
- **Health Checks**: /health and /ready endpoints required (FR-003, FR-029)
- **Security**: Non-root users, semantic versioning, env var injection (FR-005, FR-006)

### ✅ Principle XII: AI-Powered DevOps Automation
- **Status**: PASS
- **Evidence**: Gordon, kubectl-ai, kagent integrated as primary tools (FR-024, FR-025, FR-026)
- **Demo Requirement**: AI tools must demonstrate 3+ operations each (SC-008)

### ✅ Principle XIII: Kubernetes Deployment Standards
- **Status**: PASS
- **Evidence**: Helm chart with all required templates (deployment, service, ingress, secret)
- **Minikube Target**: Local single-node cluster with ingress addon (FR-032, FR-034)
- **Probes**: Liveness and readiness probes required (FR-014)

### ✅ Principle XIV: Infrastructure as Code and Traceability
- **Status**: PASS
- **Evidence**: All artifacts version controlled in /infra/ directory
- **Traceability**: All infrastructure changes traceable to specs/001-cloud-native-k8s/

### ✅ Principle XV: Local Development with Minikube
- **Status**: PASS
- **Evidence**: Minikube exclusive target, one-command deployment required (FR-035)
- **Configuration**: 4GB RAM, 2 CPUs, ingress addon enabled

### ✅ Principle XVI: Observability and Monitoring
- **Status**: PASS
- **Evidence**: Structured logs to stdout/stderr, health endpoints, kubectl logs access (FR-028, FR-029)
- **Demo Requirement**: Logs accessible, health checks pass, kagent analysis (SC-012, SC-013)

**Overall Gate Status**: ✅ PASS - All constitution principles satisfied. No violations requiring justification.

## Project Structure

### Documentation (this feature)

```text
specs/001-cloud-native-k8s/
├── spec.md                  # Feature specification (complete)
├── plan.md                  # This file (/sp.plan command output)
├── research.md              # Phase 0 output (containerization, Helm, AI tools research)
├── infrastructure-model.md  # Phase 1 output (infrastructure entities and relationships)
├── quickstart.md            # Phase 1 output (deployment quickstart guide)
├── contracts/               # Phase 1 output (Dockerfile specs, Helm values schema)
│   ├── dockerfile-frontend.md
│   ├── dockerfile-backend.md
│   ├── helm-values-schema.yaml
│   └── kubernetes-resources.md
├── checklists/
│   └── requirements.md      # Specification quality checklist (complete)
└── tasks.md                 # Phase 2 output (/sp.tasks command - NOT created by /sp.plan)
```

### Infrastructure Code (repository root)

```text
infra/
├── docker/
│   ├── frontend/
│   │   ├── Dockerfile           # Multi-stage: Node build → Nginx serve
│   │   ├── .dockerignore
│   │   └── nginx.conf           # Custom Nginx configuration
│   └── backend/
│       ├── Dockerfile           # Python slim + Uvicorn
│       └── .dockerignore
├── helm/
│   └── todo-app/
│       ├── Chart.yaml           # Helm chart metadata
│       ├── values.yaml          # Default configuration values
│       ├── values-dev.yaml      # Development overrides (optional)
│       ├── values-prod.yaml     # Production overrides (optional)
│       └── templates/
│           ├── _helpers.tpl     # Template helpers
│           ├── deployment-frontend.yaml
│           ├── deployment-backend.yaml
│           ├── service-frontend.yaml
│           ├── service-backend.yaml
│           ├── ingress.yaml
│           ├── secret.yaml
│           ├── configmap.yaml
│           └── NOTES.txt        # Post-install instructions
├── k8s/
│   └── raw-manifests/           # Optional: raw K8s YAML (if generated separately)
└── scripts/
    ├── setup-minikube.sh        # Minikube initialization script
    ├── deploy.sh                # One-command deployment wrapper
    ├── cleanup.sh               # Cleanup script
    └── demo.sh                  # Demo walkthrough script

frontend/                        # Existing Phase III code (no changes)
backend/                         # Existing Phase III code (no changes)
```

**Structure Decision**: Infrastructure-focused layout with /infra/ directory containing all deployment artifacts. Existing frontend/ and backend/ directories remain unchanged per constitution requirement (no application code modifications). Helm chart is the primary deployment mechanism, with optional raw manifests for reference.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

No violations detected. All constitution principles satisfied.

## Phase 0: Research & Technology Decisions

### Research Areas

1. **Containerization Strategy**
   - **Decision**: Use Gordon (Docker AI) as primary tool, fallback to Claude-generated Dockerfiles
   - **Rationale**: Gordon provides intelligent optimization and best practices; fallback ensures reliability
   - **Alternatives Considered**:
     - Manual Dockerfile writing (rejected: violates zero manual operations mandate)
     - Buildpacks (rejected: less control over optimization, not in tech stack)
   - **Implementation**: Check for Gordon availability; if unavailable, generate multi-stage Dockerfiles via Claude Code

2. **Database Strategy**
   - **Decision**: Keep external Neon PostgreSQL from Phase III
   - **Rationale**: Simpler, no data migration, consistent with Phase III, reduces Minikube resource usage
   - **Alternatives Considered**:
     - Local PostgreSQL StatefulSet (rejected: adds complexity, requires data migration, higher resource usage)
     - SQLite in containers (rejected: not production-like, data loss on pod restart)
   - **Implementation**: Database URL injected via Kubernetes Secret, pods connect to external Neon

3. **Helm Chart Complexity**
   - **Decision**: Basic chart with deployment, service, ingress, secret, configmap + liveness/readiness probes
   - **Rationale**: Sufficient for demo, shows best practices, keeps complexity manageable
   - **Alternatives Considered**:
     - Minimal chart without probes (rejected: doesn't demonstrate production readiness)
     - Advanced chart with HPA, PDB, NetworkPolicy (rejected: over-engineering for local Minikube)
   - **Implementation**: Include probes and resource limits; add comments for future HPA/autoscaling

4. **Ingress Configuration**
   - **Decision**: Use todo.local hostname with /etc/hosts mapping + Minikube ingress addon
   - **Rationale**: Production-like setup, demonstrates proper ingress usage, better than localhost:port
   - **Alternatives Considered**:
     - NodePort service (rejected: less production-like, requires port management)
     - LoadBalancer with minikube tunnel (rejected: more complex, unnecessary for demo)
   - **Implementation**: Minikube ingress addon enabled, /etc/hosts entry added (127.0.0.1 todo.local)

5. **Resource Requests/Limits**
   - **Decision**: Conservative for Minikube (frontend: 256Mi/200m CPU, backend: 512Mi/300m CPU)
   - **Rationale**: Balances local performance with realistic resource management demonstration
   - **Alternatives Considered**:
     - No limits (rejected: doesn't show best practices, risk of resource exhaustion)
     - Production-like limits (rejected: may not fit in 4GB Minikube, slower local performance)
   - **Implementation**: Document tradeoffs in values.yaml comments; provide production recommendations

6. **Secrets Management**
   - **Decision**: Kubernetes Secrets (not direct env vars in values.yaml)
   - **Rationale**: Secure, demonstrates best practices, prevents accidental secret exposure
   - **Alternatives Considered**:
     - Plain env vars in values.yaml (rejected: insecure, bad practice)
     - External secret manager (rejected: over-engineering for local demo)
   - **Implementation**: kubectl create secret, reference in deployment via envFrom

7. **AI Tool Integration Strategy**
   - **Decision**: Gordon for containerization → kubectl-ai for deployment/operations → kagent for analysis
   - **Rationale**: Logical workflow progression, each tool used for its strength
   - **Alternatives Considered**:
     - kubectl-ai for everything (rejected: Gordon better for Docker, kagent better for analysis)
     - Manual commands (rejected: violates constitution, misses demo opportunity)
   - **Implementation**: Document exact commands for each tool; create demo script showing all three

### Technology Stack Validation

**Containerization**:
- Docker 24+ with BuildKit (multi-stage build support)
- Gordon AI (Docker Desktop 4.53+ Beta) - optional but preferred
- Multi-stage builds: Node 18 → Nginx alpine (frontend), Python 3.11-slim (backend)

**Orchestration**:
- Minikube 1.32+ (local Kubernetes cluster)
- Kubernetes 1.28+ (Minikube default)
- Helm 3.12+ (package manager)

**AI DevOps Tools**:
- Gordon: `docker ai build --tag <image>:<tag> <context>`
- kubectl-ai: Natural language commands (e.g., "deploy backend with 3 replicas")
- kagent: Cluster analysis (e.g., "analyze cluster health", "optimize resources")

**Existing Application Stack** (unchanged):
- Frontend: Next.js 16+, React, Tailwind CSS, Better Auth
- Backend: Python 3.11+, FastAPI, SQLModel, Uvicorn, Cohere SDK
- Database: Neon PostgreSQL (external)

### Best Practices Research

**Docker Multi-Stage Builds**:
- Frontend: Node build stage (npm install, npm run build) → Nginx serve stage (copy build output)
- Backend: Single stage with Python slim base (smaller than full Python image)
- Benefits: Smaller final images, faster pulls, better security (no build tools in production image)

**Kubernetes Health Probes**:
- Liveness probe: Detects if container is alive (restart if fails)
- Readiness probe: Detects if container is ready to serve traffic (remove from service if fails)
- Implementation: HTTP GET to /health (liveness) and /ready (readiness) endpoints

**Helm Chart Structure**:
- Chart.yaml: Metadata (name, version, description)
- values.yaml: Default configuration (image tags, replicas, resources, ingress)
- templates/: Kubernetes resource templates with Go templating
- _helpers.tpl: Reusable template functions (labels, selectors, names)

**Minikube Configuration**:
- Driver: Docker (most compatible, no VM overhead)
- Resources: 4GB RAM minimum, 2 CPUs minimum
- Addons: ingress (nginx ingress controller), metrics-server (kubectl top)
- Image loading: `minikube image load` or direct build in Minikube Docker

**Secrets Management**:
- Create: `kubectl create secret generic todo-secrets --from-literal=KEY=value`
- Reference: `envFrom: - secretRef: name: todo-secrets`
- Never commit secrets to Git; document required secrets in README

## Phase 1: Infrastructure Design & Contracts

### Infrastructure Model

**Container Images**:
- **todo-frontend:v1.0.0**: Next.js application served by Nginx
  - Base: node:18-alpine (build), nginx:alpine (serve)
  - Ports: 3000 (internal), 80 (nginx)
  - Health: /health endpoint
  - Size target: <100MB (after multi-stage optimization)

- **todo-backend:v1.0.0**: FastAPI application with Uvicorn
  - Base: python:3.11-slim
  - Ports: 8000
  - Health: /health, /ready endpoints
  - Size target: <200MB

**Helm Chart** (todo-app):
- **Chart.yaml**: name=todo-app, version=0.1.0, appVersion=1.0.0
- **values.yaml**: Configuration parameters
  - images: repository, tag, pullPolicy
  - replicas: frontend=2, backend=2
  - resources: requests/limits for CPU/memory
  - ingress: enabled=true, host=todo.local
  - secrets: references to Kubernetes Secrets

**Kubernetes Resources**:
- **Deployments**: todo-frontend, todo-backend
  - Replicas: 2 each (minimum for HA)
  - Strategy: RollingUpdate (maxSurge=1, maxUnavailable=0)
  - Probes: liveness (HTTP /health), readiness (HTTP /ready)
  - Resources: requests and limits defined

- **Services**: todo-frontend-svc, todo-backend-svc
  - Type: ClusterIP (internal)
  - Ports: frontend=80, backend=8000
  - Selectors: app labels

- **Ingress**: todo-ingress
  - Host: todo.local
  - Path: / → todo-frontend-svc:80
  - Backend API: /api → todo-backend-svc:8000 (if needed)

- **Secrets**: todo-secrets
  - BETTER_AUTH_SECRET: JWT signing key
  - COHERE_API_KEY: Cohere API key
  - DATABASE_URL: Neon PostgreSQL connection string

- **ConfigMap**: todo-config (optional)
  - Non-sensitive configuration
  - Feature flags, API URLs, etc.

**Minikube Cluster**:
- **Nodes**: 1 (single-node local cluster)
- **Resources**: 4GB RAM, 2 CPUs
- **Addons**: ingress, metrics-server
- **Network**: Host network with /etc/hosts mapping

### Contracts

**Dockerfile Specifications**:

**Frontend Dockerfile Contract**:
```dockerfile
# Stage 1: Build
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run build

# Stage 2: Serve
FROM nginx:alpine
COPY --from=builder /app/out /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/health || exit 1
USER nginx
CMD ["nginx", "-g", "daemon off;"]
```

**Backend Dockerfile Contract**:
```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 8000
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD python -c "import requests; requests.get('http://localhost:8000/health')" || exit 1
USER nobody
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

**Helm Values Schema**:
```yaml
# values.yaml structure
frontend:
  image:
    repository: todo-frontend
    tag: v1.0.0
    pullPolicy: IfNotPresent
  replicaCount: 2
  resources:
    requests:
      memory: "256Mi"
      cpu: "200m"
    limits:
      memory: "512Mi"
      cpu: "500m"
  service:
    type: ClusterIP
    port: 80
    targetPort: 3000

backend:
  image:
    repository: todo-backend
    tag: v1.0.0
    pullPolicy: IfNotPresent
  replicaCount: 2
  resources:
    requests:
      memory: "512Mi"
      cpu: "300m"
    limits:
      memory: "1Gi"
      cpu: "1000m"
  service:
    type: ClusterIP
    port: 8000
    targetPort: 8000

ingress:
  enabled: true
  className: nginx
  host: todo.local
  tls: false

secrets:
  betterAuthSecret: ""  # Injected via Kubernetes Secret
  cohereApiKey: ""      # Injected via Kubernetes Secret
  databaseUrl: ""       # Injected via Kubernetes Secret
```

**Kubernetes Resource Requirements**:
- All deployments MUST have resource requests and limits
- All deployments MUST have liveness and readiness probes
- All services MUST use ClusterIP type (internal)
- Ingress MUST route to frontend service
- Secrets MUST be created before Helm install
- ConfigMaps MUST be created if non-sensitive config needed

### Quickstart Guide

**Prerequisites**:
1. Docker Desktop 4.53+ installed (with Gordon AI Beta enabled if available)
2. Minikube 1.32+ installed
3. kubectl 1.28+ installed
4. Helm 3.12+ installed
5. kubectl-ai and kagent installed (optional but recommended for demo)

**One-Command Deployment**:
```bash
# 1. Start Minikube
minikube start --cpus=4 --memory=8192 --driver=docker

# 2. Enable addons
minikube addons enable ingress
minikube addons enable metrics-server

# 3. Add /etc/hosts entry (requires sudo)
echo "$(minikube ip) todo.local" | sudo tee -a /etc/hosts

# 4. Create secrets
kubectl create secret generic todo-secrets \
  --from-literal=BETTER_AUTH_SECRET="your-jwt-secret" \
  --from-literal=COHERE_API_KEY="your-cohere-key" \
  --from-literal=DATABASE_URL="your-neon-db-url"

# 5. Build and load images (if not using registry)
cd infra/docker/frontend && docker build -t todo-frontend:v1.0.0 .
cd ../backend && docker build -t todo-backend:v1.0.0 .
minikube image load todo-frontend:v1.0.0
minikube image load todo-backend:v1.0.0

# 6. Install Helm chart
helm install todo-app ./infra/helm/todo-app

# 7. Wait for pods to be ready
kubectl wait --for=condition=ready pod -l app=todo-frontend --timeout=120s
kubectl wait --for=condition=ready pod -l app=todo-backend --timeout=120s

# 8. Access application
open http://todo.local
```

**Verification**:
```bash
# Check pods
kubectl get pods

# Check services
kubectl get svc

# Check ingress
kubectl get ingress

# Check logs
kubectl logs -l app=todo-frontend
kubectl logs -l app=todo-backend

# Check resource usage
kubectl top pods
```

**AI DevOps Demo**:
```bash
# Gordon: Build optimized images
docker ai build --tag todo-frontend:v1.0.0 ./infra/docker/frontend

# kubectl-ai: Scale deployment
kubectl-ai "scale todo-backend to 3 replicas"

# kubectl-ai: Debug issues
kubectl-ai "why is todo-backend pod crashing"

# kagent: Analyze cluster
kagent "analyze cluster health"
kagent "optimize resource allocation for todo pods"
```

**Cleanup**:
```bash
# Uninstall Helm release
helm uninstall todo-app

# Delete secrets
kubectl delete secret todo-secrets

# Stop Minikube
minikube stop

# Delete Minikube cluster (optional)
minikube delete
```

## Implementation Phases

### Phase 1: Foundation - Containerization
**Goal**: Create production-ready container images for frontend and backend

**Tasks**:
1. Generate frontend Dockerfile (multi-stage: Node build → Nginx serve)
2. Generate backend Dockerfile (Python slim + Uvicorn)
3. Create .dockerignore files
4. Create nginx.conf for frontend
5. Build images locally
6. Test images with docker run
7. Verify health endpoints work
8. Optimize image sizes

**Success Criteria**:
- Images build without errors in <5 minutes each
- Frontend image <100MB, backend image <200MB
- Containers run locally and serve application
- Health endpoints return 200 OK

### Phase 2: Minikube Setup
**Goal**: Prepare local Kubernetes environment

**Tasks**:
1. Create setup-minikube.sh script
2. Start Minikube with appropriate resources
3. Enable ingress addon
4. Enable metrics-server addon
5. Configure /etc/hosts for todo.local
6. Verify Minikube cluster health

**Success Criteria**:
- Minikube starts successfully
- Addons enabled and running
- kubectl can connect to cluster
- Ingress controller pods running

### Phase 3: Helm Chart Generation
**Goal**: Create complete Helm chart for deployment

**Tasks**:
1. Create Chart.yaml with metadata
2. Create values.yaml with configuration
3. Generate deployment templates (frontend, backend)
4. Generate service templates
5. Generate ingress template
6. Generate secret template
7. Generate configmap template (if needed)
8. Create _helpers.tpl with template functions
9. Create NOTES.txt with post-install instructions

**Success Criteria**:
- Helm chart validates (`helm lint`)
- Templates render correctly (`helm template`)
- All required resources defined
- Values schema documented

### Phase 4: Secrets & Config Injection
**Goal**: Securely manage sensitive configuration

**Tasks**:
1. Document required secrets in README
2. Create kubectl command for secret creation
3. Update deployment templates to reference secrets
4. Test secret injection locally
5. Verify secrets not exposed in logs

**Success Criteria**:
- Secrets created successfully
- Pods can access secret values
- No secrets visible in kubectl describe
- Application connects to database

### Phase 5: Deployment & Verification
**Goal**: Deploy application to Minikube and verify functionality

**Tasks**:
1. Load images to Minikube
2. Install Helm chart
3. Wait for pods to reach Running state
4. Verify services created
5. Verify ingress configured
6. Access application via browser
7. Test complete user flow (signup → login → chat → tasks)
8. Verify no regressions from Phase III

**Success Criteria**:
- All pods Running with 0 restarts
- Services have endpoints
- Ingress routes traffic correctly
- Application accessible at http://todo.local
- All Phase III features work identically

### Phase 6: AI DevOps Showcase
**Goal**: Demonstrate AI-powered operations

**Tasks**:
1. Document Gordon commands for image building
2. Document kubectl-ai commands for deployment/scaling
3. Document kagent commands for analysis
4. Create demo script showing all three tools
5. Simulate failure and demonstrate debugging
6. Show resource optimization recommendations
7. Record demo walkthrough

**Success Criteria**:
- Gordon builds optimized images
- kubectl-ai executes 3+ operations successfully
- kagent provides health analysis and recommendations
- Demo script runs end-to-end
- All AI tools demonstrate value

### Phase 7: Polish & Final Review
**Goal**: Finalize documentation and ensure demo readiness

**Tasks**:
1. Add comprehensive README with one-command deploy
2. Document all prerequisites
3. Create troubleshooting guide
4. Add health check endpoints if missing
5. Verify resource limits appropriate
6. Test cleanup scripts
7. Final end-to-end test
8. Prepare demo presentation

**Success Criteria**:
- README complete and accurate
- One-command deployment works from scratch
- All documentation up to date
- Demo script polished
- No critical issues remaining

## Risk Analysis

**High Risk**:
- **Gordon unavailable**: Mitigation: Fallback to Claude-generated Dockerfiles
- **Minikube resource exhaustion**: Mitigation: Document minimum requirements, provide resource tuning guide
- **Ingress not working**: Mitigation: Test ingress addon thoroughly, provide NodePort fallback

**Medium Risk**:
- **Image build failures**: Mitigation: Test builds early, have fallback Dockerfiles ready
- **Pod CrashLoopBackOff**: Mitigation: Comprehensive health checks, detailed logging
- **Secrets not injected**: Mitigation: Test secret creation and mounting early

**Low Risk**:
- **kubectl-ai/kagent not installed**: Mitigation: Document installation, provide manual command alternatives
- **Slow pod startup**: Mitigation: Optimize images, adjust probe timings
- **Demo timing issues**: Mitigation: Practice demo multiple times, have backup recordings

## Next Steps

1. **Execute Phase 0 Research**: Document all technology decisions (complete - see above)
2. **Execute Phase 1 Design**: Create infrastructure model and contracts (complete - see above)
3. **Generate Tasks**: Run `/sp.tasks` to create actionable task list
4. **Begin Implementation**: Run `/sp.implement` to execute tasks
5. **Validate Against Success Criteria**: Test each success criterion from spec.md
6. **Prepare Demo**: Create polished demo script for judges

**Ready for**: `/sp.tasks` command to generate detailed task breakdown
