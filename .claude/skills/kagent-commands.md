# kagent Commands Skill

A comprehensive AI-powered Kubernetes agent system using kagent for intelligent cluster analysis, resource optimization, and automated troubleshooting.

## Functions

### `analyze-health(scope: string)`
Performs comprehensive cluster health analysis using AI-powered diagnostics.

**Parameters:**
- `scope` (string): Analysis scope (cluster, namespace, deployment, or specific resource)

**Command:**
```bash
kagent "analyze the cluster health"
```

**Alternative Natural Language Commands:**
```bash
kagent "check overall cluster health"
kagent "analyze health of production namespace"
kagent "assess todo-app deployment health"
kagent "evaluate cluster stability and performance"
kagent "run health diagnostics on all nodes"
```

**Analysis Coverage:**
- **Node Health**: CPU, memory, disk usage, node conditions
- **Pod Health**: Running/failed pods, restart counts, crash loops
- **Resource Utilization**: CPU/memory usage vs limits/requests
- **Network Health**: Service connectivity, DNS resolution
- **Storage Health**: PersistentVolume status, storage capacity
- **Control Plane**: API server, etcd, scheduler, controller-manager status
- **Security**: Pod security policies, RBAC configuration
- **Performance**: Response times, throughput, bottlenecks

**Implementation:**
- Collects metrics from all cluster components
- Analyzes pod events and logs for patterns
- Identifies resource constraints and bottlenecks
- Detects configuration issues and misconfigurations
- Evaluates cluster capacity and scaling needs
- Checks for security vulnerabilities
- Provides health score and risk assessment

**Response:**
```
Cluster Health Report
=====================
Overall Health Score: 85/100

✅ Healthy Components:
  - Control Plane: All components operational
  - Nodes: 3/3 nodes ready
  - Storage: 75% capacity available

⚠️  Warnings:
  - High memory usage on node-1 (85%)
  - 2 pods with high restart counts
  - Backend deployment has 1 pending pod

❌ Critical Issues:
  - Database pod in CrashLoopBackOff
  - Node-2 disk pressure detected

Recommendations:
1. Investigate database pod logs for crash cause
2. Scale down workloads on node-1 or add node capacity
3. Clean up disk space on node-2
4. Review resource requests for backend deployment
```

### `optimize-resources(target: string, strategy: string)`
Optimizes resource allocation using AI-powered recommendations.

**Parameters:**
- `target` (string): Target for optimization (pods, deployments, namespace, cluster)
- `strategy` (string): Optimization strategy (cost, performance, balanced)

**Command:**
```bash
kagent "optimize resource allocation for todo pods"
```

**Alternative Natural Language Commands:**
```bash
kagent "optimize resources for todo-app deployment"
kagent "suggest resource improvements for production namespace"
kagent "reduce costs by optimizing pod resources"
kagent "improve performance through better resource allocation"
kagent "balance resource usage across all deployments"
kagent "right-size containers in backend deployment"
```

**Optimization Strategies:**
- **Cost Optimization**: Minimize resource usage while maintaining performance
- **Performance Optimization**: Maximize performance with optimal resource allocation
- **Balanced**: Balance cost and performance
- **High Availability**: Ensure redundancy and fault tolerance
- **Auto-scaling**: Configure HPA based on usage patterns

**Analysis Process:**
1. Collects historical resource usage data
2. Analyzes CPU and memory utilization patterns
3. Identifies over-provisioned and under-provisioned resources
4. Evaluates scaling behavior and patterns
5. Considers application requirements and SLAs
6. Generates optimized resource configurations

**Implementation:**
- Analyzes actual vs requested vs limit resources
- Identifies idle or underutilized pods
- Detects resource contention and throttling
- Recommends optimal requests and limits
- Suggests horizontal and vertical scaling strategies
- Provides cost impact analysis

**Response:**
```
Resource Optimization Report for todo-app
==========================================

Current Configuration:
  - Frontend: 2 replicas, 500m CPU / 512Mi memory
  - Backend: 2 replicas, 1000m CPU / 1Gi memory
  - Database: 1 replica, 2000m CPU / 2Gi memory

Usage Analysis (7-day average):
  - Frontend: 150m CPU (30%), 200Mi memory (39%)
  - Backend: 400m CPU (40%), 600Mi memory (60%)
  - Database: 800m CPU (40%), 1.2Gi memory (60%)

Recommendations:
✅ Frontend: Reduce to 250m CPU / 256Mi memory
   - Savings: 50% CPU, 50% memory
   - Impact: No performance degradation expected

✅ Backend: Reduce to 500m CPU / 768Mi memory
   - Savings: 50% CPU, 25% memory
   - Impact: Maintains 20% headroom for spikes

⚠️  Database: Keep current allocation
   - Usage is appropriate for workload
   - Consider vertical scaling for growth

💰 Estimated Cost Savings: $45/month (30% reduction)

Apply Changes:
  kagent "apply optimization recommendations for todo-app"
```

### `suggest-fixes(issue: string, context: string)`
Provides AI-powered recommendations for fixing cluster issues.

**Parameters:**
- `issue` (string): Issue description or error message
- `context` (string): Additional context (pod name, namespace, etc.)

**Command:**
```bash
kagent "recommend fixes for failing pods"
```

**Alternative Natural Language Commands:**
```bash
kagent "suggest fixes for backend CrashLoopBackOff"
kagent "how to fix ImagePullBackOff error"
kagent "resolve pending pod issues"
kagent "fix OOMKilled pods in production"
kagent "troubleshoot service connectivity problems"
kagent "resolve PersistentVolume mounting errors"
```

**Issue Categories:**
- **Pod Failures**: CrashLoopBackOff, Error, OOMKilled
- **Scheduling Issues**: Pending pods, insufficient resources
- **Image Issues**: ImagePullBackOff, ErrImagePull
- **Network Issues**: Service unreachable, DNS failures
- **Storage Issues**: Volume mount failures, disk pressure
- **Configuration Issues**: Invalid manifests, missing secrets
- **Performance Issues**: High latency, resource throttling

**Analysis Process:**
1. Identifies root cause from logs and events
2. Analyzes related resources and dependencies
3. Checks configuration and environment
4. Reviews recent changes and deployments
5. Considers best practices and patterns
6. Generates step-by-step fix recommendations

**Implementation:**
- Parses error messages and stack traces
- Correlates events across related resources
- Identifies configuration mismatches
- Detects resource constraints
- Suggests immediate fixes and long-term solutions
- Provides commands to implement fixes

**Response:**
```
Fix Recommendations for backend-7d9f8c-xyz (CrashLoopBackOff)
================================================================

Root Cause Analysis:
❌ Application failing to start due to missing DATABASE_URL environment variable

Evidence:
  - Container logs show: "Error: DATABASE_URL is not defined"
  - Pod restarted 15 times in last 10 minutes
  - No database secret mounted

Immediate Fix:
1. Create database secret:
   kubectl create secret generic db-credentials \
     --from-literal=DATABASE_URL="postgresql://user:pass@db:5432/todo"

2. Update deployment to use secret:
   kubectl set env deployment/backend \
     --from=secret/db-credentials

3. Verify fix:
   kagent "check if backend pods are now healthy"

Long-term Recommendations:
✅ Use external secret management (e.g., Vault, AWS Secrets Manager)
✅ Add validation for required environment variables at startup
✅ Implement health checks with proper error messages
✅ Add deployment pre-checks in CI/CD pipeline

Prevention:
- Add required environment variables to deployment template
- Document all required configuration in README
- Use init containers to validate dependencies before app start
```

### `predict-issues(timeframe: string, scope: string)`
Predicts potential issues before they occur using AI analysis.

**Command:**
```bash
kagent "predict potential issues in the next 24 hours"
kagent "forecast resource exhaustion for production namespace"
kagent "identify pods likely to fail soon"
```

**Prediction Categories:**
- Resource exhaustion (CPU, memory, disk)
- Pod failures based on error patterns
- Scaling issues during traffic spikes
- Certificate expirations
- Storage capacity limits
- Node failures or degradation

**Response:**
```
Issue Predictions (Next 24 Hours)
==================================

⚠️  High Risk:
  - Node-2 disk will reach 90% in ~6 hours
  - Backend pods may OOMKill during peak traffic (18:00-20:00)
  - TLS certificate for ingress expires in 18 hours

⚠️  Medium Risk:
  - Database connection pool may saturate at 500+ concurrent users
  - Frontend pods may need scaling during expected traffic spike

Preventive Actions:
1. Clean up logs on node-2 or expand disk
2. Increase backend memory limits to 1.5Gi
3. Renew TLS certificate immediately
4. Configure HPA for frontend (2-10 replicas)
```

### `auto-remediate(issue: string, approval: boolean)`
Automatically fixes common issues with optional approval.

**Command:**
```bash
kagent "auto-fix failing pods with approval"
kagent "automatically remediate resource issues"
kagent "fix all ImagePullBackOff errors"
```

**Remediation Actions:**
- Restart failed pods
- Scale deployments based on load
- Clean up completed jobs
- Evict pods from pressure nodes
- Update resource limits
- Recreate failed PersistentVolumes

**Safety Features:**
- Requires approval for destructive actions
- Dry-run mode available
- Rollback capability
- Audit logging of all actions

### `generate-report(report_type: string, format: string)`
Generates comprehensive reports on cluster state and operations.

**Command:**
```bash
kagent "generate cluster health report"
kagent "create cost analysis report for last month"
kagent "generate security audit report"
kagent "create capacity planning report"
```

**Report Types:**
- Health and status reports
- Cost analysis and optimization
- Security audit and compliance
- Capacity planning and forecasting
- Performance analysis
- Incident post-mortems

**Output Formats:**
- Markdown
- PDF
- JSON
- HTML dashboard

### `compare-configurations(source: string, target: string)`
Compares configurations across environments or versions.

**Command:**
```bash
kagent "compare production and staging configurations"
kagent "diff current deployment with previous version"
kagent "compare resource allocations across namespaces"
```

**Comparison Areas:**
- Resource requests and limits
- Environment variables
- Image versions
- Replica counts
- Service configurations
- Security policies

### `benchmark-performance(workload: string, duration: string)`
Runs performance benchmarks and provides optimization recommendations.

**Command:**
```bash
kagent "benchmark todo-app performance"
kagent "run load test on backend service"
kagent "measure response times under load"
```

**Metrics Collected:**
- Request latency (p50, p95, p99)
- Throughput (requests per second)
- Error rates
- Resource utilization during load
- Scaling behavior

## Usage Examples

### Cluster Health Monitoring

**Daily Health Check:**
```bash
# Comprehensive cluster analysis
kagent "analyze the cluster health"

# Namespace-specific health
kagent "check health of production namespace"

# Component-specific health
kagent "analyze control plane health"
kagent "check node health and capacity"
```

**Continuous Monitoring:**
```bash
# Set up automated health checks
kagent "monitor cluster health every 5 minutes"

# Alert on critical issues
kagent "alert me when cluster health score drops below 80"

# Track health trends
kagent "show cluster health trends for last 7 days"
```

### Resource Optimization

**Cost Optimization:**
```bash
# Identify cost savings opportunities
kagent "find overprovisioned resources"

# Optimize specific deployment
kagent "optimize todo-app for cost savings"

# Cluster-wide optimization
kagent "optimize all deployments for cost"

# Show cost impact
kagent "calculate cost savings from optimization recommendations"
```

**Performance Optimization:**
```bash
# Optimize for performance
kagent "optimize backend for maximum performance"

# Balance cost and performance
kagent "optimize resources with balanced strategy"

# Auto-scaling recommendations
kagent "suggest HPA configuration for frontend"
```

### Troubleshooting and Fixes

**Automated Diagnostics:**
```bash
# Diagnose specific issue
kagent "why is backend pod failing"

# Comprehensive troubleshooting
kagent "troubleshoot all failing pods in production"

# Network diagnostics
kagent "diagnose service connectivity issues"
```

**Fix Recommendations:**
```bash
# Get fix suggestions
kagent "recommend fixes for CrashLoopBackOff pods"

# Step-by-step remediation
kagent "provide detailed fix steps for ImagePullBackOff"

# Auto-remediation
kagent "automatically fix all pending pods"
```

### Predictive Analysis

**Capacity Planning:**
```bash
# Predict resource needs
kagent "predict resource requirements for next month"

# Forecast scaling needs
kagent "when will we need to add more nodes"

# Growth analysis
kagent "analyze growth trends and capacity needs"
```

**Issue Prevention:**
```bash
# Predict failures
kagent "predict potential pod failures in next 24 hours"

# Resource exhaustion warnings
kagent "warn me before disk space runs out"

# Certificate expiration
kagent "check for expiring certificates"
```

### Security and Compliance

**Security Audits:**
```bash
# Security assessment
kagent "audit cluster security configuration"

# Vulnerability scanning
kagent "scan for security vulnerabilities"

# Compliance check
kagent "check compliance with security best practices"
```

**Policy Enforcement:**
```bash
# Check policy violations
kagent "identify pods violating security policies"

# RBAC analysis
kagent "analyze RBAC permissions and suggest improvements"
```

## Best Practices

### Regular Health Checks
- Run daily cluster health analysis
- Monitor health score trends
- Set up alerts for critical issues
- Review recommendations weekly
- Track remediation progress

### Resource Optimization
- Review resource usage monthly
- Apply optimization recommendations gradually
- Test changes in staging first
- Monitor impact after optimization
- Maintain 20-30% resource headroom

### Proactive Monitoring
- Enable predictive issue detection
- Set up automated remediation for common issues
- Review predictions daily
- Act on high-risk predictions immediately
- Track prediction accuracy

### Documentation
- Document all kagent recommendations
- Track applied optimizations
- Maintain runbooks for common issues
- Share insights with team
- Review and update procedures regularly

### Safety and Validation
- Always review recommendations before applying
- Use dry-run mode for testing
- Apply changes during maintenance windows
- Have rollback plans ready
- Monitor closely after changes

## Integration with Monitoring Tools

### Prometheus Integration
```bash
# Export metrics to Prometheus
kagent "export cluster health metrics to Prometheus"

# Create custom alerts
kagent "generate Prometheus alerts for critical issues"
```

### Grafana Dashboards
```bash
# Generate dashboard
kagent "create Grafana dashboard for cluster health"

# Update existing dashboard
kagent "add resource optimization metrics to dashboard"
```

### Slack Notifications
```bash
# Configure alerts
kagent "send health alerts to Slack channel #ops"

# Daily reports
kagent "send daily health summary to Slack"
```

## Advanced Features

### Machine Learning Models
- Learns from historical data
- Improves predictions over time
- Adapts to workload patterns
- Identifies anomalies automatically

### Custom Policies
```bash
# Define custom policies
kagent "create policy: alert when pod restarts exceed 5 in 10 minutes"

# Enforce policies
kagent "enforce resource limit policies across all namespaces"
```

### Multi-Cluster Management
```bash
# Analyze multiple clusters
kagent "compare health across all clusters"

# Cross-cluster optimization
kagent "optimize resources across dev, staging, and prod clusters"
```

### Automated Workflows
```bash
# Create workflow
kagent "create workflow: analyze health → optimize → apply → verify"

# Schedule workflows
kagent "run optimization workflow every Sunday at 2 AM"
```

## Error Handling

### kagent Not Available
- Install kagent: `curl -LO https://kagent.io/install.sh && bash install.sh`
- Verify installation: `kagent --version`
- Configure API credentials if required

### Insufficient Permissions
- Check RBAC permissions
- Request cluster-admin or necessary roles
- Use read-only mode for analysis

### API Rate Limits
- Reduce analysis frequency
- Use caching for repeated queries
- Upgrade to higher tier if available

### Inaccurate Recommendations
- Provide more context in queries
- Review historical data quality
- Update kagent to latest version
- Report issues to kagent support

## Troubleshooting Commands

```bash
# Verify kagent installation
kagent --version
kagent "test connection to cluster"

# Check permissions
kagent "verify my cluster permissions"

# Debug mode
kagent --debug "analyze cluster health"

# Verbose output
kagent --verbose "optimize resources for todo-app"

# Export raw data
kagent "export cluster metrics to JSON"
```

## CI/CD Integration

### GitHub Actions
```yaml
name: Cluster Health Check
on:
  schedule:
    - cron: '0 */6 * * *'  # Every 6 hours

jobs:
  health-check:
    runs-on: ubuntu-latest
    steps:
      - name: Install kagent
        run: curl -LO https://kagent.io/install.sh && bash install.sh

      - name: Analyze Cluster Health
        run: |
          kagent "analyze the cluster health" > health-report.txt

      - name: Check for Critical Issues
        run: |
          if kagent "check for critical issues" | grep -q "Critical"; then
            echo "Critical issues found!"
            exit 1
          fi

      - name: Optimize Resources
        run: kagent "optimize resource allocation for all deployments"
```

### GitLab CI
```yaml
cluster-optimization:
  stage: optimize
  image: kagent/cli:latest
  script:
    - kagent "analyze cluster health"
    - kagent "optimize resources for production namespace"
    - kagent "generate optimization report"
  artifacts:
    reports:
      - optimization-report.json
  only:
    - schedules
```

## Quick Reference

### Health Analysis
```bash
kagent "analyze the cluster health"
kagent "check namespace health"
kagent "assess deployment health"
```

### Resource Optimization
```bash
kagent "optimize resource allocation for <app>"
kagent "reduce costs by optimizing resources"
kagent "improve performance through optimization"
```

### Troubleshooting
```bash
kagent "recommend fixes for failing pods"
kagent "diagnose <issue>"
kagent "troubleshoot <component>"
```

### Predictions
```bash
kagent "predict issues in next 24 hours"
kagent "forecast resource needs"
kagent "identify potential failures"
```

### Reports
```bash
kagent "generate health report"
kagent "create cost analysis"
kagent "generate security audit"
```

## Comparison with Other Tools

### kagent vs kubectl-ai
- **kagent**: Focuses on analysis, optimization, and predictions
- **kubectl-ai**: Focuses on command execution and resource management
- **Use Together**: kagent for insights, kubectl-ai for actions

### kagent vs Traditional Monitoring
- **kagent**: AI-powered, predictive, automated recommendations
- **Traditional**: Reactive, manual analysis, threshold-based alerts
- **Advantage**: Proactive issue prevention and intelligent optimization

## Cost Considerations

### Free Tier
- Basic health analysis
- Limited optimization recommendations
- Manual remediation only

### Pro Tier
- Advanced analytics and predictions
- Automated remediation
- Custom policies and workflows
- Multi-cluster support

### Enterprise Tier
- Unlimited analysis and optimization
- 24/7 automated monitoring
- Custom ML models
- Dedicated support
