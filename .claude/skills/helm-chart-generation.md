# Helm Chart Generation Skill

A comprehensive Helm chart generation and deployment system for Kubernetes orchestration of frontend and backend applications.

## Functions

### `generate-helm-chart(app_name: string, chart_path: string)`
Creates a complete Helm chart structure with values, templates, and configuration files.

**Parameters:**
- `app_name` (string): Application name (e.g., `todo-app`)
- `chart_path` (string): Path to create chart (e.g., `./infra/helm/todo-app/`)

**Generated Structure:**
```
infra/helm/todo-app/
├── Chart.yaml
├── values.yaml
├── templates/
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── ingress.yaml
│   ├── secret.yaml
│   ├── configmap.yaml
│   └── _helpers.tpl
└── .helmignore
```

**Implementation:**
- Creates Chart.yaml with metadata (name, version, description)
- Generates values.yaml with configurable parameters
- Creates Kubernetes resource templates
- Includes health probes (liveness, readiness)
- Configures resource limits and requests
- Sets up ingress with TLS support
- Manages secrets and config maps

**Response:**
- Complete Helm chart ready for deployment
- All templates validated and properly structured
- Values file with sensible defaults

### `install-helm-release(release_name: string, chart_path: string, namespace: string)`
Installs a Helm release to a Kubernetes cluster.

**Parameters:**
- `release_name` (string): Name for the Helm release (e.g., `todo-app`)
- `chart_path` (string): Path to Helm chart (e.g., `./infra/helm/todo-app`)
- `namespace` (string): Kubernetes namespace (optional, defaults to `default`)

**Command:**
```bash
helm install todo-app ./infra/helm/todo-app --set image.tag=latest
```

**With Namespace:**
```bash
helm install todo-app ./infra/helm/todo-app \
  --namespace production \
  --create-namespace \
  --set image.tag=v1.0.0
```

**Functionality:**
- Deploys all Kubernetes resources defined in templates
- Applies values from values.yaml
- Allows runtime value overrides with --set
- Creates namespace if it doesn't exist (with --create-namespace)
- Tracks release history for rollbacks

**Response:**
- Release installed successfully
- Kubernetes resources created
- Release status and notes displayed

### `upgrade-helm-release(release_name: string, chart_path: string, values: object)`
Upgrades an existing Helm release with new configuration or image versions.

**Parameters:**
- `release_name` (string): Existing release name
- `chart_path` (string): Path to Helm chart
- `values` (object): Values to override

**Command:**
```bash
helm upgrade todo-app ./infra/helm/todo-app \
  --set image.tag=v1.1.0 \
  --set replicaCount=3
```

**Functionality:**
- Updates existing deployment with zero-downtime rolling update
- Preserves release history for rollback capability
- Validates changes before applying
- Supports atomic upgrades (rollback on failure)

### `uninstall-helm-release(release_name: string, namespace: string)`
Removes a Helm release and all associated Kubernetes resources.

**Parameters:**
- `release_name` (string): Release to uninstall
- `namespace` (string): Namespace (optional)

**Command:**
```bash
helm uninstall todo-app --namespace production
```

**Functionality:**
- Deletes all Kubernetes resources created by the release
- Removes release history
- Optionally keeps history with --keep-history flag

### `helm-template-dry-run(chart_path: string, values_file: string)`
Renders Helm templates locally without installing to cluster.

**Parameters:**
- `chart_path` (string): Path to Helm chart
- `values_file` (string): Values file to use (optional)

**Command:**
```bash
helm template todo-app ./infra/helm/todo-app --values ./custom-values.yaml
```

**Functionality:**
- Validates template syntax
- Shows rendered Kubernetes manifests
- Useful for debugging and CI/CD validation
- No cluster connection required

### `helm-list-releases(namespace: string)`
Lists all Helm releases in a namespace.

**Command:**
```bash
helm list --namespace production --all-namespaces
```

**Functionality:**
- Shows release name, namespace, revision, status
- Filters by namespace or shows all
- Displays chart version and app version

### `helm-rollback(release_name: string, revision: number)`
Rolls back a release to a previous revision.

**Parameters:**
- `release_name` (string): Release to rollback
- `revision` (number): Target revision (optional, defaults to previous)

**Command:**
```bash
helm rollback todo-app 3
```

**Functionality:**
- Reverts to specified revision
- Maintains release history
- Performs rolling update to previous state

## Chart Structure Details

### Chart.yaml
```yaml
apiVersion: v2
name: todo-app
description: A Helm chart for Todo Application
type: application
version: 0.1.0
appVersion: "1.0.0"
maintainers:
  - name: Your Team
    email: team@example.com
```

### values.yaml
```yaml
# Default values for todo-app
replicaCount: 2

image:
  repository: todo-frontend
  pullPolicy: IfNotPresent
  tag: "latest"

service:
  type: ClusterIP
  port: 80
  targetPort: 3000

ingress:
  enabled: true
  className: "nginx"
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
  hosts:
    - host: todo.example.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: todo-tls
      hosts:
        - todo.example.com

resources:
  limits:
    cpu: 500m
    memory: 512Mi
  requests:
    cpu: 250m
    memory: 256Mi

autoscaling:
  enabled: false
  minReplicas: 2
  maxReplicas: 10
  targetCPUUtilizationPercentage: 80

probes:
  liveness:
    httpGet:
      path: /health
      port: 3000
    initialDelaySeconds: 30
    periodSeconds: 10
  readiness:
    httpGet:
      path: /ready
      port: 3000
    initialDelaySeconds: 5
    periodSeconds: 5

env:
  - name: NODE_ENV
    value: "production"
  - name: API_URL
    value: "https://api.example.com"

secrets:
  DATABASE_URL: ""
  JWT_SECRET: ""
```

### templates/deployment.yaml
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "todo-app.fullname" . }}
  labels:
    {{- include "todo-app.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      {{- include "todo-app.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      labels:
        {{- include "todo-app.selectorLabels" . | nindent 8 }}
    spec:
      containers:
      - name: {{ .Chart.Name }}
        image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
        imagePullPolicy: {{ .Values.image.pullPolicy }}
        ports:
        - name: http
          containerPort: {{ .Values.service.targetPort }}
          protocol: TCP
        livenessProbe:
          {{- toYaml .Values.probes.liveness | nindent 10 }}
        readinessProbe:
          {{- toYaml .Values.probes.readiness | nindent 10 }}
        resources:
          {{- toYaml .Values.resources | nindent 10 }}
        env:
          {{- toYaml .Values.env | nindent 10 }}
        envFrom:
        - secretRef:
            name: {{ include "todo-app.fullname" . }}-secret
```

### templates/service.yaml
```yaml
apiVersion: v1
kind: Service
metadata:
  name: {{ include "todo-app.fullname" . }}
  labels:
    {{- include "todo-app.labels" . | nindent 4 }}
spec:
  type: {{ .Values.service.type }}
  ports:
    - port: {{ .Values.service.port }}
      targetPort: http
      protocol: TCP
      name: http
  selector:
    {{- include "todo-app.selectorLabels" . | nindent 4 }}
```

### templates/ingress.yaml
```yaml
{{- if .Values.ingress.enabled -}}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ include "todo-app.fullname" . }}
  labels:
    {{- include "todo-app.labels" . | nindent 4 }}
  {{- with .Values.ingress.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  ingressClassName: {{ .Values.ingress.className }}
  {{- if .Values.ingress.tls }}
  tls:
    {{- range .Values.ingress.tls }}
    - hosts:
        {{- range .hosts }}
        - {{ . | quote }}
        {{- end }}
      secretName: {{ .secretName }}
    {{- end }}
  {{- end }}
  rules:
    {{- range .Values.ingress.hosts }}
    - host: {{ .host | quote }}
      http:
        paths:
          {{- range .paths }}
          - path: {{ .path }}
            pathType: {{ .pathType }}
            backend:
              service:
                name: {{ include "todo-app.fullname" $ }}
                port:
                  number: {{ $.Values.service.port }}
          {{- end }}
    {{- end }}
{{- end }}
```

### templates/secret.yaml
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "todo-app.fullname" . }}-secret
  labels:
    {{- include "todo-app.labels" . | nindent 4 }}
type: Opaque
data:
  {{- range $key, $value := .Values.secrets }}
  {{ $key }}: {{ $value | b64enc | quote }}
  {{- end }}
```

### templates/_helpers.tpl
```yaml
{{/*
Expand the name of the chart.
*/}}
{{- define "todo-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "todo-app.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "todo-app.labels" -}}
helm.sh/chart: {{ include "todo-app.chart" . }}
{{ include "todo-app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "todo-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "todo-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "todo-app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}
```

## Usage Examples

### Generate Complete Helm Chart
```bash
# Create chart structure
mkdir -p infra/helm/todo-app
cd infra/helm/todo-app

# Initialize with helm create (then customize)
helm create todo-app

# Or manually create files as shown in Chart Structure Details
```

### Install Release with Custom Values
```bash
# Basic installation
helm install todo-app ./infra/helm/todo-app

# With custom image tag
helm install todo-app ./infra/helm/todo-app \
  --set image.tag=v1.0.0

# With custom values file
helm install todo-app ./infra/helm/todo-app \
  --values ./values-production.yaml

# With multiple overrides
helm install todo-app ./infra/helm/todo-app \
  --set image.tag=v1.0.0 \
  --set replicaCount=3 \
  --set ingress.hosts[0].host=todo.production.com
```

### Upgrade Existing Release
```bash
# Upgrade with new image
helm upgrade todo-app ./infra/helm/todo-app \
  --set image.tag=v1.1.0

# Upgrade with atomic rollback on failure
helm upgrade todo-app ./infra/helm/todo-app \
  --atomic \
  --timeout 5m

# Upgrade and wait for resources to be ready
helm upgrade todo-app ./infra/helm/todo-app \
  --wait \
  --timeout 10m
```

### Dry Run and Validation
```bash
# Render templates locally
helm template todo-app ./infra/helm/todo-app

# Install with dry-run
helm install todo-app ./infra/helm/todo-app --dry-run --debug

# Lint chart for issues
helm lint ./infra/helm/todo-app

# Validate against Kubernetes API
helm install todo-app ./infra/helm/todo-app --dry-run --validate
```

### Manage Releases
```bash
# List all releases
helm list

# List releases in specific namespace
helm list --namespace production

# Get release status
helm status todo-app

# Get release history
helm history todo-app

# Rollback to previous version
helm rollback todo-app

# Rollback to specific revision
helm rollback todo-app 3

# Uninstall release
helm uninstall todo-app
```

### Multi-Environment Deployment
```bash
# Development environment
helm install todo-app-dev ./infra/helm/todo-app \
  --namespace development \
  --create-namespace \
  --values ./values-dev.yaml

# Staging environment
helm install todo-app-staging ./infra/helm/todo-app \
  --namespace staging \
  --create-namespace \
  --values ./values-staging.yaml

# Production environment
helm install todo-app-prod ./infra/helm/todo-app \
  --namespace production \
  --create-namespace \
  --values ./values-prod.yaml
```

## Best Practices

### Chart Organization
- Use semantic versioning for chart versions
- Keep values.yaml with sensible defaults
- Document all configurable values with comments
- Use _helpers.tpl for reusable template snippets
- Include .helmignore to exclude unnecessary files

### Resource Configuration
- Always define resource limits and requests
- Configure health probes (liveness and readiness)
- Use horizontal pod autoscaling for production
- Set appropriate replica counts per environment
- Configure pod disruption budgets for high availability

### Security
- Never commit secrets to values.yaml
- Use Kubernetes secrets or external secret managers
- Enable RBAC and service accounts
- Use network policies to restrict traffic
- Scan images for vulnerabilities before deployment
- Enable TLS for ingress endpoints

### Values Management
- Create separate values files per environment
- Use values-dev.yaml, values-staging.yaml, values-prod.yaml
- Override sensitive values at deployment time with --set
- Use Helm secrets plugin for encrypted values
- Document required vs optional values

### CI/CD Integration
- Lint charts in CI pipeline (`helm lint`)
- Validate templates (`helm template --validate`)
- Use `--atomic` flag for automatic rollback on failure
- Tag releases with git commit SHA or semantic version
- Implement automated testing with helm test

### Deployment Strategy
- Use rolling updates for zero-downtime deployments
- Configure readiness probes to prevent traffic to unhealthy pods
- Set appropriate terminationGracePeriodSeconds
- Use pod anti-affinity for high availability
- Implement blue-green or canary deployments for critical services

## Advanced Features

### Helm Hooks
```yaml
# Pre-install hook for database migration
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ include "todo-app.fullname" . }}-migration
  annotations:
    "helm.sh/hook": pre-install,pre-upgrade
    "helm.sh/hook-weight": "-5"
    "helm.sh/hook-delete-policy": before-hook-creation
spec:
  template:
    spec:
      containers:
      - name: migration
        image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
        command: ["npm", "run", "migrate"]
      restartPolicy: Never
```

### Conditional Resources
```yaml
# Enable autoscaling conditionally
{{- if .Values.autoscaling.enabled }}
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: {{ include "todo-app.fullname" . }}
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: {{ include "todo-app.fullname" . }}
  minReplicas: {{ .Values.autoscaling.minReplicas }}
  maxReplicas: {{ .Values.autoscaling.maxReplicas }}
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: {{ .Values.autoscaling.targetCPUUtilizationPercentage }}
{{- end }}
```

### Dependencies
```yaml
# Chart.yaml with dependencies
dependencies:
  - name: postgresql
    version: "12.x.x"
    repository: "https://charts.bitnami.com/bitnami"
    condition: postgresql.enabled
  - name: redis
    version: "17.x.x"
    repository: "https://charts.bitnami.com/bitnami"
    condition: redis.enabled
```

## Error Handling

### Common Issues

**Chart not found:**
- Verify chart path is correct
- Ensure Chart.yaml exists in chart directory
- Check file permissions

**Template rendering errors:**
- Use `helm template` to debug locally
- Check for syntax errors in templates
- Verify all required values are provided
- Use `--debug` flag for detailed error messages

**Release installation fails:**
- Check Kubernetes cluster connectivity
- Verify namespace exists or use --create-namespace
- Ensure sufficient cluster resources
- Review pod logs: `kubectl logs <pod-name>`

**Upgrade conflicts:**
- Use `helm upgrade --force` to force resource updates
- Check for resource ownership conflicts
- Verify release exists: `helm list`

**Values not applied:**
- Verify values file syntax (valid YAML)
- Check value path matches template references
- Use `helm get values <release>` to see applied values
- Ensure --set overrides use correct syntax

## Troubleshooting Commands

```bash
# Debug template rendering
helm template todo-app ./infra/helm/todo-app --debug

# Get all values for a release
helm get values todo-app

# Get manifest for deployed release
helm get manifest todo-app

# Show release notes
helm get notes todo-app

# Verify chart structure
helm show chart ./infra/helm/todo-app

# Show all values (including defaults)
helm show values ./infra/helm/todo-app

# Package chart for distribution
helm package ./infra/helm/todo-app

# Test release (runs helm test hooks)
helm test todo-app

# Get release history
helm history todo-app --max 10
```

## Integration with CI/CD

### GitHub Actions Example
```yaml
name: Deploy with Helm
on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Install Helm
        uses: azure/setup-helm@v3
        with:
          version: '3.12.0'

      - name: Lint Helm Chart
        run: helm lint ./infra/helm/todo-app

      - name: Deploy to Kubernetes
        run: |
          helm upgrade --install todo-app ./infra/helm/todo-app \
            --namespace production \
            --create-namespace \
            --set image.tag=${{ github.sha }} \
            --wait \
            --timeout 5m
```

### GitLab CI Example
```yaml
deploy:
  stage: deploy
  image: alpine/helm:latest
  script:
    - helm lint ./infra/helm/todo-app
    - helm upgrade --install todo-app ./infra/helm/todo-app
        --namespace production
        --create-namespace
        --set image.tag=$CI_COMMIT_SHA
        --atomic
  only:
    - main
```
