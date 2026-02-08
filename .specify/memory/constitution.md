<!--
SYNC IMPACT REPORT:
Version change: 2.0.0 → 3.0.0 (major update for cloud-native Kubernetes deployment with AI-powered DevOps)
Modified principles: I, II, III (expanded for infrastructure automation)
Added sections:
  - XI. Cloud-Native Architecture and Containerization
  - XII. AI-Powered DevOps Automation
  - XIII. Kubernetes Deployment Standards
  - XIV. Infrastructure as Code and Traceability
  - XV. Local Development with Minikube
  - XVI. Observability and Monitoring
Removed sections: None
Templates requiring updates:
- .specify/templates/plan-template.md: ⚠ pending (add infrastructure planning sections)
- .specify/templates/spec-template.md: ⚠ pending (add infrastructure requirements sections)
- .specify/templates/tasks-template.md: ⚠ pending (add infrastructure task categories)
- .specify/templates/commands/*.md: ⚠ pending (verify alignment with new principles)
Follow-up TODOs:
  - Create @specs/infra/ directory structure
  - Generate infrastructure specification templates
  - Update demo script requirements
-->
# Hackathon Phase IV – Cloud-Native Todo AI Chatbot Constitution

## Core Principles

### I. Full Agentic, Spec-Driven Development with Infrastructure Automation
All development must follow spec-driven methodology where every feature is defined in specifications before implementation. No manual coding allowed – all implementation must be generated via Claude Code using Spec-Kit references. Development follows the strict sequence: Spec → Plan → Tasks → Implementation. This principle extends to infrastructure: all containerization, Helm charts, Kubernetes manifests, and deployment configurations must be generated through AI agents (Gordon, kubectl-ai, kagent) or Claude Code with full traceability to infrastructure specifications in @specs/infra/*.

### II. Zero Manual Operations Mandate
No code or infrastructure configuration may be written manually by humans. All implementation must be generated through Claude Code agents using /sp.implement and related skills. All infrastructure operations must use AI-powered tools where available: Gordon for Docker builds, kubectl-ai for Kubernetes operations, kagent for cluster analysis and optimization. Manual kubectl, helm, or docker commands are prohibited when AI alternatives exist. Every artifact must be traceable to a specification requirement.

### III. Modular Architecture Through Agents and Cloud-Native Services
System architecture must be modular with dedicated agents for different concerns: Main Agent, Task Agent, Auth Agent, UI Agent, and AI Chatbot Agent. Each agent has defined skills and responsibilities with clear interfaces and contracts. Infrastructure must follow cloud-native patterns: containerized microservices, declarative configuration, service discovery, health checks, and horizontal scaling. MCP (Model Context Protocol) tools serve as standardized interfaces for agent-tool interaction.

### IV. Complete User Isolation and Data Ownership
Every user must have complete isolation of their data. All database queries must be filtered by authenticated user_id. Users can only access, modify, or delete their own tasks. No cross-user data access is permitted under any circumstances. AI chatbot operations must enforce the same strict user isolation principles. This isolation must be maintained across all deployment environments including Kubernetes pods.

### V. Strict Technology Stack Adherence
Implementation must use exactly the specified technology stack:
- **Frontend**: Next.js 16+ (App Router), React, Tailwind CSS, Better Auth, Lucide React icons
- **Backend**: Python 3.11+, FastAPI, SQLModel, Uvicorn, Cohere Python SDK
- **Database**: Neon PostgreSQL (external) or local PostgreSQL in Kubernetes
- **AI/LLM**: Cohere API (command-r-plus or command-r models)
- **Containerization**: Docker with Gordon AI agent (fallback: Claude-generated Dockerfiles)
- **Orchestration**: Kubernetes (Minikube for local), Helm 3.x
- **AI DevOps Tools**: Gordon (Docker AI), kubectl-ai (natural language K8s), kagent (cluster intelligence)

No external libraries beyond the specified stack are permitted without explicit specification approval.

### VI. Stateless Authentication with JWT
Authentication must be completely stateless using JWT tokens only. No session storage on backend. Better Auth configured with JWT plugin. JWT tokens issued on login and automatically attached to all API requests from frontend. AI chat endpoints must verify JWT and enforce user_id ownership for all operations. JWT secrets must be managed via Kubernetes Secrets in production deployments.

## AI-Specific Requirements

### VII. AI Agent Architecture
- AI chatbot must fully control task management operations (add, list, complete, delete, update) through natural language processing
- Natural language understanding must interpret intents like "Add task buy milk", "Show pending tasks", "Mark task 4 complete", "Delete the old one"
- AI responses must be contextual, multilingual (English + Urdu support), and provide action confirmations
- Agent behavior must be stateful through database persistence while maintaining stateless server architecture
- AI chatbot must function identically in local development and Kubernetes deployment

### VIII. Cohere LLM Integration
- Use Cohere API as the primary LLM backend for agent reasoning, tool calling, and response generation
- Adapt OpenAI Agents SDK patterns to work with Cohere API using Cohere's tool-calling capabilities
- Use Cohere models (command-r-plus or command-r) with tool calling enabled
- Implement proper API key management via COHERE_API_KEY environment variable (injected via Kubernetes Secret)
- Cohere integration must be secured and properly validated with error handling
- API keys must never be hardcoded or committed to version control

### IX. MCP Tools Standardization
- MCP (Model Context Protocol) tools remain the standardized interface for agent-tool interaction
- Expose all task and user operations as MCP-compatible tools: add_task, list_tasks, complete_task, delete_task, update_task, get_user_profile
- All tools must require user_id (from JWT) and enforce ownership
- Tool calls must be logged and tracked for audit and debugging purposes
- Tools must follow consistent interface patterns with proper error handling
- MCP tools must work seamlessly in containerized environments

### X. Stateless Conversation Architecture
- Implement stateless architecture for scalability with conversation state persisted only in database
- Maintain conversations and messages tables for preserving chat history across requests
- Conversation context must be fetched from DB on every request and user/assistant messages stored after processing
- Support optional conversation_id parameter for continuing existing conversations
- System must resume conversation state after server restart or pod recreation
- Database connections must be resilient to pod restarts and network interruptions

## Cloud-Native and Infrastructure Requirements

### XI. Cloud-Native Architecture and Containerization
- Both frontend (Next.js) and backend (FastAPI) must be containerized using Docker
- Use Gordon (Docker AI Agent) for intelligent Dockerfile generation when available (Docker Desktop 4.53+ Beta)
- Fallback: Claude Code must generate production-ready, multi-stage Dockerfiles
- Frontend: Multi-stage build (Node.js build → Nginx serve) optimized for size and security
- Backend: Python slim base image with Uvicorn ASGI server
- All containers must include health check endpoints (/health, /ready)
- Images must be tagged with semantic versions, never use 'latest' in production
- Containers must run as non-root users for security
- Environment variables must be injected via Kubernetes ConfigMaps and Secrets

### XII. AI-Powered DevOps Automation
- **Gordon (Docker AI)**: Primary tool for building container images with intelligent optimization
- **kubectl-ai**: Natural language interface for all Kubernetes operations (deploy, scale, update, debug)
- **kagent**: AI-powered cluster analysis, resource optimization, and predictive issue detection
- Zero manual kubectl/helm/docker commands in deployment workflows
- All infrastructure operations must be demonstrable via AI tools in demo
- AI DevOps tools must be used for: deployment, scaling, health checks, log analysis, resource optimization
- Fallback to traditional commands only when AI tools unavailable, with clear documentation

### XIII. Kubernetes Deployment Standards
- **Target Environment**: Local Minikube single-node cluster (no cloud deployments)
- **Helm Charts**: Production-ready charts generated by Claude Code or kubectl-ai
  - Chart structure: Chart.yaml, values.yaml, templates/ (deployment, service, ingress, secret, configmap)
  - Values must be environment-specific with clear defaults
  - Templates must include liveness/readiness probes, resource limits, labels, annotations
- **Deployments**:
  - Frontend: 2+ replicas with rolling update strategy
  - Backend: 2+ replicas with rolling update strategy
  - Database: 1 replica (StatefulSet if local) or external Neon connection
- **Services**: ClusterIP for internal, LoadBalancer/Ingress for external access
- **Ingress**: Configure host-based routing (e.g., http://todo.local) with proper DNS/hosts mapping
- **Secrets**: JWT_SECRET, COHERE_API_KEY, DATABASE_URL managed via Kubernetes Secrets
- **ConfigMaps**: Non-sensitive configuration (API URLs, feature flags)
- **Resource Limits**: All pods must define CPU/memory requests and limits
- **Health Probes**: Liveness and readiness probes required for all application pods

### XIV. Infrastructure as Code and Traceability
- All infrastructure artifacts must be version controlled in /infra/ directory:
  - /infra/docker/ - Dockerfiles for frontend and backend
  - /infra/helm/todo-app/ - Complete Helm chart
  - /infra/k8s/ - Raw Kubernetes manifests (if generated)
  - /infra/scripts/ - Setup and deployment scripts
- All infrastructure changes must be traceable to specifications in @specs/infra/:
  - @specs/infra/architecture.md - Overall cloud-native architecture
  - @specs/infra/helm-chart.md - Helm chart requirements and structure
  - @specs/infra/deployment-pipeline.md - Deployment workflow and procedures
- Infrastructure specifications must follow same rigor as application specifications
- All AI-generated infrastructure must be reviewed and committed to repository

### XV. Local Development with Minikube
- Minikube must be the exclusive Kubernetes environment (no cloud clusters)
- Minikube configuration: Docker driver, sufficient resources (4GB+ RAM, 2+ CPUs)
- Enable required addons: ingress, metrics-server, dashboard (optional)
- Local Docker registry or direct image loading (minikube image load)
- Host file configuration for custom domain (todo.local → Minikube IP)
- One-command deployment: `minikube start && helm install todo-app ./infra/helm/todo-app`
- Support for rapid iteration: rebuild image → load to Minikube → helm upgrade
- Database options: External Neon (preferred for demo) or local PostgreSQL StatefulSet

### XVI. Observability and Monitoring
- All pods must emit structured logs to stdout/stderr
- Logs must be accessible via kubectl logs and kubectl-ai log analysis
- Health endpoints must return detailed status information
- Kubernetes events must be monitored for pod failures, scheduling issues
- Resource usage must be trackable via kubectl top and kagent analysis
- Demo must showcase: pod status, service endpoints, log inspection, health checks
- kagent must be used to demonstrate cluster health analysis and optimization recommendations

## Security and Data Requirements

### Authentication and Authorization
- Every API endpoint must require valid JWT token for access
- FastAPI middleware must verify JWT and extract user_id on every protected route
- All CRUD operations must enforce task ownership (user can only access their own tasks)
- Database schema must match specifications exactly with user_id foreign keys
- AI chat endpoints must enforce identical security requirements as traditional API endpoints
- JWT secrets must be stored in Kubernetes Secrets, never in code or ConfigMaps
- Secrets must be mounted as environment variables or files, never exposed in logs

### Data Isolation
- All database queries must be filtered by authenticated user_id
- Zero data leakage between users is permitted
- Users table managed by Better Auth, tasks table with user_id foreign key relationship
- No direct database access from frontend – all operations via protected FastAPI endpoints
- AI operations must enforce the same data isolation principles as traditional operations
- Database connections must use secure credentials from Kubernetes Secrets

## Development Workflow

### Implementation Process
- All features must be implemented exactly as defined in /specs folder
- Infrastructure must be implemented exactly as defined in @specs/infra/ folder
- Every reference in prompts must use @specs/path/to/file.md format
- Code structure must follow guidelines in root CLAUDE.md, frontend/CLAUDE.md, and backend/CLAUDE.md
- Frontend uses server components by default with responsive UI using Tailwind CSS
- AI chatbot implementation must follow same rigorous specification and testing standards
- Infrastructure changes must be tested locally in Minikube before considering production-ready

### Quality Standards
- All CRUD operations must be fully implemented with proper error handling
- Responsive frontend with task list, create/edit forms, authentication pages, and AI chat interface
- AI chatbot must handle natural language intents correctly with appropriate tool calls
- All code must pass validation and testing requirements
- Application must run in Kubernetes with all pods healthy and services reachable
- Full end-to-end flow must work: login → chat with AI → tasks managed → everything in K8s
- Demo must be impressive: Gordon containerization, kubectl-ai operations, kagent analysis

### Success Criteria (Demo Requirements)
The Phase IV implementation must achieve "wow factor" for judges:
- ✅ Minikube cluster running with frontend, backend, and database (local or external)
- ✅ Helm release successfully deployed and all pods healthy
- ✅ Application accessible via http://todo.local (or similar) using Ingress
- ✅ AI Chatbot fully functional inside Kubernetes (natural language task management)
- ✅ Gordon/kubectl-ai/kagent demonstrated in live demo (scale, analyze, fix)
- ✅ All services reachable, logs clean, no errors
- ✅ Complete user flow: signup → login → chat → tasks → profile
- ✅ Spec-driven process clearly visible (all infra specs, prompts, iterations documented)
- ✅ One-command deployment from README instructions
- ✅ Demo script showing AI DevOps tools in action

## Governance

This constitution supersedes all other development practices and standards for this project. All development activities must comply with these principles. Amendments to this constitution require explicit documentation, approval from project stakeholders, and a migration plan for existing codebase. All pull requests and code reviews must verify compliance with these principles. Use CLAUDE.md files for runtime development guidance and best practices.

**Version Bump Rationale**: Major version increment (2.0.0 → 3.0.0) due to addition of entire cloud-native infrastructure layer, new AI-powered DevOps tools (Gordon, kubectl-ai, kagent), Kubernetes deployment requirements, and infrastructure-as-code principles. This represents a fundamental architectural evolution from Phase III (full-stack application) to Phase IV (cloud-native deployment).

**Version**: 3.0.0 | **Ratified**: 2026-01-05 | **Last Amended**: 2026-02-08
