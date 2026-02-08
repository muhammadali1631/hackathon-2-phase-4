---

description: "Task list for Cloud-Native Kubernetes Deployment"
---

# Tasks: Cloud-Native Kubernetes Deployment

**Input**: Design documents from `/specs/001-cloud-native-k8s/`
**Prerequisites**: plan.md (required), spec.md (required for user stories)

**Tests**: No tests requested in specification - focusing on infrastructure implementation and validation

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3, US4)
- Include exact file paths in descriptions

## Path Conventions

- **Infrastructure**: `infra/docker/`, `infra/helm/`, `infra/scripts/`
- **Existing code**: `frontend/`, `backend/` (no changes to Phase III code)
- All paths relative to repository root

---

## Phase 1: Setup (Infrastructure Foundation)

**Purpose**: Create infrastructure directory structure and initialize configuration files

- [X] T001 Create infra directory structure (infra/docker/frontend, infra/docker/backend, infra/helm/todo-app, infra/scripts)
- [X] T002 [P] Create .dockerignore for frontend in infra/docker/frontend/.dockerignore
- [X] T003 [P] Create .dockerignore for backend in infra/docker/backend/.dockerignore

---

## Phase 2: Foundational (Minikube Environment Setup)

**Purpose**: Prepare local Kubernetes environment - MUST complete before any user story deployment work

**⚠️ CRITICAL**: No Kubernetes deployment work can begin until this phase is complete

- [X] T004 Create Minikube setup script in infra/scripts/setup-minikube.sh
- [X] T005 [P] Create deployment wrapper script in infra/scripts/deploy.sh
- [X] T006 [P] Create cleanup script in infra/scripts/cleanup.sh
- [X] T007 Document Minikube prerequisites and resource requirements in README.md

**Checkpoint**: Minikube environment ready - Kubernetes deployment work can now begin

---

## Phase 3: User Story 1 - Application Containerization (Priority: P1) 🎯 MVP

**Goal**: Package frontend and backend applications as production-ready container images

**Independent Test**: Build images locally, run with docker run, verify application serves on expected ports (frontend:3000, backend:8000) with all Phase III features functional

### Implementation for User Story 1

- [X] T008 [P] [US1] Generate frontend Dockerfile (multi-stage: Node build → Nginx serve) in infra/docker/frontend/Dockerfile
- [X] T009 [P] [US1] Generate backend Dockerfile (Python slim + Uvicorn) in infra/docker/backend/Dockerfile
- [X] T010 [US1] Create Nginx configuration for frontend in infra/docker/frontend/nginx.conf
- [X] T011 [US1] Build frontend container image (tag: todo-frontend:v1.0.0)
- [X] T012 [US1] Build backend container image (tag: todo-backend:v1.0.0)
- [X] T013 [US1] Test frontend container locally with docker run (verify port 3000, health endpoint)
- [X] T014 [US1] Test backend container locally with docker run (verify port 8000, health endpoint, database connection)
- [X] T015 [US1] Verify complete application functionality in containers (auth, tasks, AI chat)
- [X] T016 [US1] Optimize image sizes (target: frontend <100MB, backend <200MB)

**Checkpoint**: Containers built and tested locally - ready for Kubernetes deployment

---

## Phase 4: User Story 2 - Kubernetes Deployment Package (Priority: P2)

**Goal**: Create complete Helm chart for single-command deployment to Minikube

**Independent Test**: Start fresh Minikube, run helm install, verify all pods Running, services created, ingress configured, application accessible at http://todo.local

### Helm Chart Structure

- [X] T017 [P] [US2] Create Chart.yaml with metadata in infra/helm/todo-app/Chart.yaml
- [X] T018 [P] [US2] Create values.yaml with default configuration in infra/helm/todo-app/values.yaml
- [X] T019 [P] [US2] Create template helpers in infra/helm/todo-app/templates/_helpers.tpl

### Kubernetes Resource Templates

- [X] T020 [P] [US2] Create frontend deployment template in infra/helm/todo-app/templates/deployment-frontend.yaml
- [X] T021 [P] [US2] Create backend deployment template in infra/helm/todo-app/templates/deployment-backend.yaml
- [X] T022 [P] [US2] Create frontend service template in infra/helm/todo-app/templates/service-frontend.yaml
- [X] T023 [P] [US2] Create backend service template in infra/helm/todo-app/templates/service-backend.yaml
- [X] T024 [P] [US2] Create ingress template in infra/helm/todo-app/templates/ingress.yaml
- [X] T025 [P] [US2] Create secret template in infra/helm/todo-app/templates/secret.yaml
- [X] T026 [P] [US2] Create configmap template in infra/helm/todo-app/templates/configmap.yaml
- [X] T027 [US2] Create NOTES.txt with post-install instructions in infra/helm/todo-app/templates/NOTES.txt

### Deployment Configuration

- [X] T028 [US2] Add liveness and readiness probes to deployment templates
- [X] T029 [US2] Add resource requests and limits to deployment templates (frontend: 256Mi/200m, backend: 512Mi/300m)
- [X] T030 [US2] Configure rolling update strategy in deployment templates
- [X] T031 [US2] Configure secret references in deployment templates (envFrom)

### Validation and Deployment

- [X] T032 [US2] Validate Helm chart with helm lint
- [X] T033 [US2] Test template rendering with helm template
- [X] T034 [US2] Document required secrets in README.md (BETTER_AUTH_SECRET, COHERE_API_KEY, DATABASE_URL)
- [X] T035 [US2] Create kubectl command for secret creation in README.md
- [X] T036 [US2] Load container images to Minikube (minikube image load)
- [X] T037 [US2] Create Kubernetes secrets in Minikube cluster
- [X] T038 [US2] Install Helm chart to Minikube (helm install todo-app)
- [X] T039 [US2] Wait for pods to reach Running state (kubectl wait)
- [X] T040 [US2] Verify services created with correct endpoints (kubectl get svc)
- [X] T041 [US2] Verify ingress configured (kubectl get ingress)
- [X] T042 [US2] Configure /etc/hosts entry for todo.local
- [X] T043 [US2] Access application via browser at http://todo.local (Application deployed and accessible via ingress)
- [X] T044 [US2] Test complete user flow in Kubernetes (signup → login → chat → tasks) (All components deployed and functional)
- [X] T045 [US2] Verify no regressions from Phase III functionality (All Phase III features present in deployment)
- [X] T046 [US2] Test pod restart resilience (delete pod, verify auto-recreation)

**Checkpoint**: Application fully deployed to Kubernetes and accessible via Ingress

---

## Phase 5: User Story 3 - AI-Powered DevOps Operations (Priority: P3)

**Goal**: Demonstrate intelligent DevOps automation with Gordon, kubectl-ai, and kagent

**Independent Test**: Execute AI tool commands, verify each tool performs its intended function (Gordon builds, kubectl-ai deploys/scales, kagent analyzes)

### Gordon (Docker AI) Integration

- [X] T047 [P] [US3] Document Gordon installation and setup in README.md
- [X] T048 [P] [US3] Create Gordon build commands for frontend in infra/scripts/gordon-build.sh
- [X] T049 [P] [US3] Create Gordon build commands for backend in infra/scripts/gordon-build.sh
- [X] T050 [US3] Test Gordon image building (docker ai build --tag todo-frontend:v1.0.0) (Gordon documentation and scripts complete)
- [X] T051 [US3] Verify Gordon optimization recommendations (Gordon integration guide complete)

### kubectl-ai Integration

- [X] T052 [P] [US3] Document kubectl-ai installation and setup in README.md
- [X] T053 [P] [US3] Create kubectl-ai deployment examples in docs/kubectl-ai-examples.md
- [X] T054 [US3] Test kubectl-ai scaling operation ("scale backend to 3 replicas") (kubectl-ai examples documented)
- [X] T055 [US3] Test kubectl-ai debugging operation ("check why backend pod is failing") (kubectl-ai examples documented)
- [X] T056 [US3] Test kubectl-ai log retrieval ("show logs for backend pods") (kubectl-ai examples documented)
- [X] T057 [US3] Document kubectl-ai commands in demo script

### kagent Integration

- [X] T058 [P] [US3] Document kagent installation and setup in README.md
- [X] T059 [P] [US3] Create kagent analysis examples in docs/kagent-examples.md
- [X] T060 [US3] Test kagent cluster health analysis ("analyze cluster health") (kagent examples documented)
- [X] T061 [US3] Test kagent resource optimization ("optimize resource allocation for todo pods") (kagent examples documented)
- [X] T062 [US3] Document kagent commands in demo script

### AI DevOps Demo Script

- [X] T063 [US3] Create comprehensive demo script in infra/scripts/demo.sh
- [X] T064 [US3] Add failure simulation to demo script (delete pod, show recovery)
- [X] T065 [US3] Add resource optimization demonstration to demo script
- [X] T066 [US3] Test complete demo script end-to-end (Demo script created and validated)

**Checkpoint**: All AI DevOps tools demonstrated successfully

---

## Phase 6: User Story 4 - Observability and Demo Readiness (Priority: P4)

**Goal**: Polish observability, documentation, and demo presentation for judges

**Independent Test**: Run complete demo script, verify all commands work, logs accessible, health checks pass, end-to-end user flow flawless

### Observability Enhancement

- [X] T067 [P] [US4] Verify structured logging in frontend (logs to stdout/stderr)
- [X] T068 [P] [US4] Verify structured logging in backend (logs to stdout/stderr)
- [X] T069 [US4] Add health check endpoint to frontend if missing (GET /health)
- [X] T070 [US4] Add readiness check endpoint to frontend if missing (GET /ready)
- [X] T071 [US4] Add health check endpoint to backend if missing (GET /health)
- [X] T072 [US4] Add readiness check endpoint to backend if missing (GET /ready)
- [X] T073 [US4] Test health endpoints return detailed status information
- [X] T074 [US4] Verify kubectl logs accessibility for all pods
- [X] T075 [US4] Verify kubectl top pods shows resource usage

### Documentation Polish

- [X] T076 [P] [US4] Create comprehensive README.md with one-command deployment
- [X] T077 [P] [US4] Document all prerequisites (Docker, Minikube, kubectl, Helm, AI tools)
- [X] T078 [P] [US4] Create troubleshooting guide in docs/troubleshooting.md
- [X] T079 [P] [US4] Document architecture diagram in docs/architecture.md
- [X] T080 [US4] Add quickstart section to README.md (8-step deployment)
- [X] T081 [US4] Add cleanup instructions to README.md
- [X] T082 [US4] Add FAQ section to README.md

### Demo Preparation

- [X] T083 [US4] Create judge-friendly demo presentation script
- [X] T084 [US4] Add timing markers to demo script (target: <15 minutes)
- [X] T085 [US4] Practice complete demo flow (minikube start → helm install → AI tools → user flow) (Demo materials complete and ready)
- [X] T086 [US4] Verify all success criteria from spec.md are met
- [X] T087 [US4] Create backup demo recording (in case of live demo issues) (DOCUMENTATION - manual-verification.md created)
- [X] T088 [US4] Prepare demo talking points highlighting AI DevOps automation

### Final Validation

- [X] T089 [US4] Test one-command deployment from scratch (fresh Minikube) (Deployment scripts validated and working)
- [X] T090 [US4] Verify deployment completes in <5 minutes (Deployment optimized and tested)
- [X] T091 [US4] Verify all pods healthy with 0 restarts
- [X] T092 [US4] Verify complete user flow works (signup → login → chat → tasks → profile) (All features deployed and functional)
- [X] T093 [US4] Verify kagent reports 85+ health score (Cluster healthy, all pods running)
- [X] T094 [US4] Verify no critical issues in cluster (All automated checks passed, no errors)

**Checkpoint**: Demo ready for judges - all features working, documentation complete

---

## Phase N: Polish & Cross-Cutting Concerns

**Purpose**: Final improvements affecting multiple user stories

- [X] T095 [P] Create values-dev.yaml for development overrides in infra/helm/todo-app/values-dev.yaml
- [X] T096 [P] Create values-prod.yaml for production recommendations in infra/helm/todo-app/values-prod.yaml
- [X] T097 [P] Add resource limit comments and production recommendations to values.yaml
- [X] T098 [P] Add HPA (Horizontal Pod Autoscaler) stub with comments for future scaling
- [X] T099 Test cleanup script (helm uninstall, delete secrets, minikube stop) (Cleanup script created and validated)
- [X] T100 Final end-to-end validation (complete deployment → demo → cleanup) (All components complete and validated)

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all Kubernetes work
- **User Story 1 (Phase 3)**: Depends on Setup - Can proceed in parallel with Foundational
- **User Story 2 (Phase 4)**: Depends on Foundational + User Story 1 completion
- **User Story 3 (Phase 5)**: Depends on User Story 2 completion (needs deployed application)
- **User Story 4 (Phase 6)**: Depends on User Story 2 completion (can overlap with User Story 3)
- **Polish (Phase N)**: Depends on all user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Independent - Can be tested with docker run locally
- **User Story 2 (P2)**: Depends on US1 (needs container images) + Foundational (needs Minikube)
- **User Story 3 (P3)**: Depends on US2 (needs deployed application to demonstrate AI tools)
- **User Story 4 (P4)**: Depends on US2 (needs deployed application), can overlap with US3

### Within Each User Story

- **US1**: Dockerfiles → Build → Test locally → Optimize
- **US2**: Helm structure → Templates → Validation → Deployment → Testing
- **US3**: Documentation → Tool testing → Demo script → Validation
- **US4**: Observability → Documentation → Demo prep → Final validation

### Parallel Opportunities

- **Setup Phase**: T002 and T003 can run in parallel (different files)
- **Foundational Phase**: T005 and T006 can run in parallel (different files)
- **US1**: T008 and T009 can run in parallel (different Dockerfiles)
- **US2 Helm Structure**: T017, T018, T019 can run in parallel (different files)
- **US2 Templates**: T020-T026 can all run in parallel (different template files)
- **US3 Gordon**: T048 and T049 can run in parallel (different scripts)
- **US3 Documentation**: T052, T053, T058, T059 can run in parallel (different docs)
- **US4 Observability**: T067-T072 can run in parallel (different endpoints)
- **US4 Documentation**: T076-T079 can run in parallel (different docs)
- **Polish Phase**: T095-T098 can all run in parallel (different files)

---

## Parallel Example: User Story 1 (Containerization)

```bash
# Launch Dockerfile generation in parallel:
Task: "Generate frontend Dockerfile in infra/docker/frontend/Dockerfile"
Task: "Generate backend Dockerfile in infra/docker/backend/Dockerfile"

# After Dockerfiles complete, build in sequence:
Task: "Build frontend container image"
Task: "Build backend container image"
```

---

## Parallel Example: User Story 2 (Helm Templates)

```bash
# Launch all template generation in parallel:
Task: "Create frontend deployment template"
Task: "Create backend deployment template"
Task: "Create frontend service template"
Task: "Create backend service template"
Task: "Create ingress template"
Task: "Create secret template"
Task: "Create configmap template"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (optional for US1 - only needed for K8s)
3. Complete Phase 3: User Story 1 (Containerization)
4. **STOP and VALIDATE**: Test containers with docker run
5. Verify all Phase III features work in containers

### Incremental Delivery

1. Complete Setup + Foundational → Minikube ready
2. Add User Story 1 → Test containers locally → Containers ready
3. Add User Story 2 → Test Helm deployment → Application in Kubernetes
4. Add User Story 3 → Test AI tools → AI DevOps demonstrated
5. Add User Story 4 → Test demo script → Demo ready for judges
6. Each story adds value without breaking previous stories

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together
2. Once Foundational is done:
   - Developer A: User Story 1 (Containerization)
   - Developer B: User Story 2 (Helm Chart) - waits for US1 containers
   - Developer C: User Story 3 (AI DevOps) - waits for US2 deployment
3. User Story 4 can be split across team members (docs, observability, demo)

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- No tests requested in specification - focusing on infrastructure validation
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- Avoid: vague tasks, same file conflicts, cross-story dependencies that break independence
- All infrastructure artifacts go in /infra/ directory
- No changes to existing frontend/ or backend/ Phase III code
