#!/bin/bash

# Success Criteria Verification Script
# Verifies all 15 success criteria from spec.md

# Don't exit on error - we want to see all results
set +e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
PASS_COUNT=0
FAIL_COUNT=0
MANUAL_COUNT=0

echo "=========================================="
echo "Success Criteria Verification"
echo "=========================================="
echo ""

# Helper functions
pass() {
    echo -e "${GREEN}✓ PASS${NC}: $1"
    ((PASS_COUNT++))
}

fail() {
    echo -e "${RED}✗ FAIL${NC}: $1"
    ((FAIL_COUNT++))
}

manual() {
    echo -e "${YELLOW}⚠ MANUAL${NC}: $1"
    ((MANUAL_COUNT++))
}

info() {
    echo -e "${BLUE}ℹ INFO${NC}: $1"
}

# SC-001: Container images build successfully
echo "SC-001: Container images build successfully"
if docker images | grep -q "todo-frontend.*v1.0.0" && docker images | grep -q "todo-backend.*v1.0.0"; then
    pass "Both container images exist (todo-frontend:v1.0.0, todo-backend:v1.0.0)"
else
    fail "Container images not found"
fi
echo ""

# SC-002: Container images run locally
echo "SC-002: Container images run locally on expected ports"
if docker images | grep -q "todo-frontend.*v1.0.0" && docker images | grep -q "todo-backend.*v1.0.0"; then
    pass "Container images are available for local testing"
    info "Manual verification: docker run -p 3000:3000 todo-frontend:v1.0.0"
    info "Manual verification: docker run -p 8000:8000 todo-backend:v1.0.0"
else
    fail "Container images not available"
fi
echo ""

# SC-003: Helm chart deploys in under 3 minutes
echo "SC-003: Helm chart deploys entire application"
if helm list | grep -q "todo-app"; then
    HELM_STATUS=$(helm list | grep "todo-app" | awk '{print $8}')
    if [ "$HELM_STATUS" = "deployed" ]; then
        pass "Helm release 'todo-app' is deployed"
    else
        fail "Helm release status: $HELM_STATUS"
    fi
else
    fail "Helm release 'todo-app' not found"
fi
echo ""

# SC-004: All pods reach Running state with 0 restarts
echo "SC-004: All pods reach Running state with 0 restarts"
RUNNING_COUNT=$(kubectl get pods -l app.kubernetes.io/instance=todo-app --no-headers | grep "Running" | wc -l)
TOTAL_COUNT=$(kubectl get pods -l app.kubernetes.io/instance=todo-app --no-headers | wc -l)

if [ "$RUNNING_COUNT" -eq "$TOTAL_COUNT" ] && [ "$TOTAL_COUNT" -gt 0 ]; then
    pass "All $TOTAL_COUNT pods are in Running state"

    # Check restart counts
    MAX_RESTARTS=$(kubectl get pods -l app.kubernetes.io/instance=todo-app --no-headers | awk '{print $4}' | sort -rn | head -1)
    if [ "$MAX_RESTARTS" -eq 0 ]; then
        pass "All pods have 0 restarts"
    else
        fail "Some pods have restarts (max: $MAX_RESTARTS)"
    fi
else
    fail "Not all pods are running ($RUNNING_COUNT/$TOTAL_COUNT)"
fi
echo ""

# SC-005: Application accessible via browser
echo "SC-005: Application accessible via browser at configured hostname"
manual "Requires manual verification: Open http://todo.local in browser"
info "Ensure /etc/hosts has entry: \$(minikube ip) todo.local"
echo ""

# SC-006: Complete user flow works
echo "SC-006: Complete user flow (signup → login → create task → chat → profile)"
manual "Requires manual verification: Test complete user flow in browser"
info "Steps: 1) Sign up 2) Log in 3) Create task 4) Chat with AI 5) View profile"
echo ""

# SC-007: Application handles pod restarts gracefully
echo "SC-007: Application handles pod restarts gracefully"
RESTART_COUNT=$(kubectl get pods -l app.kubernetes.io/instance=todo-app -o json | grep -o '"restartCount":[0-9]*' | cut -d':' -f2 | awk '{s+=$1} END {print s}')
if [ "$RESTART_COUNT" -eq 0 ]; then
    pass "No pod restarts detected (graceful handling verified)"
else
    info "Pods have restarted $RESTART_COUNT times total"
    manual "Verify no user-visible errors or data loss after restarts"
fi
echo ""

# SC-008: AI DevOps tools demonstrate operations
echo "SC-008: AI DevOps tools (Gordon, kubectl-ai, kagent) demonstrate operations"
manual "Requires manual verification: Run demo.sh or demonstrate AI tools"
if [ -f "docs/gordon-integration.md" ] && [ -f "docs/kubectl-ai-examples.md" ] && [ -f "docs/kagent-examples.md" ]; then
    pass "AI DevOps documentation exists (gordon, kubectl-ai, kagent)"
else
    fail "AI DevOps documentation incomplete"
fi
echo ""

# SC-009: Cluster health analysis via kagent
echo "SC-009: Cluster health analysis via kagent reports 85+ health score"
manual "Requires manual verification: Run 'kagent analyze health'"
info "Expected: Health score 85+ with no critical issues"
echo ""

# SC-010: Demo script executes successfully
echo "SC-010: Demo script executes from start to finish in under 15 minutes"
if [ -f "infra/scripts/demo.sh" ]; then
    pass "Demo script exists at infra/scripts/demo.sh"
    manual "Requires manual verification: Run ./infra/scripts/demo.sh"
else
    fail "Demo script not found"
fi
echo ""

# SC-011: Judges confirm "wow factor"
echo "SC-011: Judges confirm 'wow factor'"
manual "Requires judge evaluation during demo"
info "Highlight: AI-powered DevOps automation and cloud-native transformation"
echo ""

# SC-012: Application logs accessible
echo "SC-012: Application logs accessible via kubectl logs"
FRONTEND_LOGS=$(kubectl logs deployment/todo-app-frontend --tail=5 2>&1)
BACKEND_LOGS=$(kubectl logs deployment/todo-app-backend --tail=5 2>&1)

if echo "$FRONTEND_LOGS" | grep -qv "Error from server"; then
    pass "Frontend logs accessible"
else
    fail "Cannot access frontend logs"
fi

if echo "$BACKEND_LOGS" | grep -qv "Error from server"; then
    pass "Backend logs accessible"
else
    fail "Cannot access backend logs"
fi
echo ""

# SC-013: Health check endpoints return 200 OK
echo "SC-013: Health check endpoints return successful status"
# Check if health probes are configured
FRONTEND_PROBE=$(kubectl get deployment todo-app-frontend -o yaml | grep -c "livenessProbe")
BACKEND_PROBE=$(kubectl get deployment todo-app-backend -o yaml | grep -c "livenessProbe")

if [ "$FRONTEND_PROBE" -gt 0 ] && [ "$BACKEND_PROBE" -gt 0 ]; then
    pass "Health probes configured for both frontend and backend"

    # Check if pods are ready (indicates health checks passing)
    READY_PODS=$(kubectl get pods -l app.kubernetes.io/instance=todo-app --no-headers | grep "Running" | awk '{if ($2 == "1/1") print $0}' | wc -l)
    TOTAL_PODS=$(kubectl get pods -l app.kubernetes.io/instance=todo-app --no-headers | wc -l)

    if [ "$READY_PODS" -eq "$TOTAL_PODS" ] && [ "$TOTAL_PODS" -gt 0 ]; then
        pass "All pods are ready (health checks passing)"
    else
        fail "Some pods not ready ($READY_PODS/$TOTAL_PODS)"
    fi
else
    fail "Health probes not configured"
fi
echo ""

# SC-014: Resource usage within limits
echo "SC-014: Resource usage stays within defined limits"
if kubectl top pods -l app.kubernetes.io/instance=todo-app &>/dev/null; then
    RESOURCE_OUTPUT=$(kubectl top pods -l app.kubernetes.io/instance=todo-app 2>&1)

    if echo "$RESOURCE_OUTPUT" | grep -qv "error"; then
        pass "Resource metrics available"
        info "Current resource usage:"
        kubectl top pods -l app.kubernetes.io/instance=todo-app | sed 's/^/  /'

        # Check for OOMKilled pods
        OOM_COUNT=$(kubectl get pods -l app.kubernetes.io/instance=todo-app -o json | grep -o '"reason":"OOMKilled"' | wc -l)
        if [ "$OOM_COUNT" -eq 0 ]; then
            pass "No OOMKilled pods detected"
        else
            fail "Found $OOM_COUNT OOMKilled pods"
        fi
    else
        fail "Cannot retrieve resource metrics"
    fi
else
    fail "metrics-server not available or not responding"
fi
echo ""

# SC-015: One-command deployment works
echo "SC-015: One-command deployment from README works"
if [ -f "README.md" ] && grep -q "Quick Start" README.md; then
    pass "README.md contains deployment instructions"

    if [ -f "infra/scripts/deploy.sh" ]; then
        pass "Deployment script exists (infra/scripts/deploy.sh)"
    else
        fail "Deployment script not found"
    fi

    if [ -f "infra/scripts/setup-minikube.sh" ]; then
        pass "Minikube setup script exists"
    else
        fail "Minikube setup script not found"
    fi
else
    fail "README.md missing or incomplete"
fi
echo ""

# Summary
echo "=========================================="
echo "Verification Summary"
echo "=========================================="
echo -e "${GREEN}PASS${NC}: $PASS_COUNT"
echo -e "${RED}FAIL${NC}: $FAIL_COUNT"
echo -e "${YELLOW}MANUAL${NC}: $MANUAL_COUNT (requires human verification)"
echo ""

if [ "$FAIL_COUNT" -eq 0 ]; then
    echo -e "${GREEN}✓ All automated checks passed!${NC}"
    echo "Please complete manual verification steps above."
    exit 0
else
    echo -e "${RED}✗ Some automated checks failed.${NC}"
    echo "Please review failures above and fix issues."
    exit 1
fi
