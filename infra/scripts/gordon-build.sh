# Gordon (Docker AI) - Build Script

# Gordon is Docker's AI-powered build assistant that helps optimize container images
# Available in Docker Desktop 4.53+ Beta

echo "🤖 Gordon - Docker AI Build Assistant"
echo "======================================"
echo ""

# Check if Gordon is available
if ! docker ai --help &> /dev/null; then
    echo "❌ Gordon (docker ai) is not available"
    echo ""
    echo "To enable Gordon:"
    echo "1. Install Docker Desktop 4.53+ Beta"
    echo "2. Enable Beta features in Docker Desktop settings"
    echo "3. Restart Docker Desktop"
    echo ""
    echo "Falling back to standard docker build..."
    exit 1
fi

echo "✅ Gordon is available"
echo ""

# Build frontend with Gordon
echo "🏗️  Building frontend with Gordon AI..."
echo "Command: docker ai build --tag todo-frontend:v1.0.0 --file infra/docker/frontend/Dockerfile ."
echo ""

docker ai build \
    --tag todo-frontend:v1.0.0 \
    --file infra/docker/frontend/Dockerfile \
    .

echo ""
echo "✅ Frontend image built with Gordon"
echo ""

# Build backend with Gordon
echo "🏗️  Building backend with Gordon AI..."
echo "Command: docker ai build --tag todo-backend:v1.0.0 --file infra/docker/backend/Dockerfile ."
echo ""

docker ai build \
    --tag todo-backend:v1.0.0 \
    --file infra/docker/backend/Dockerfile \
    .

echo ""
echo "✅ Backend image built with Gordon"
echo ""

# Get optimization recommendations from Gordon
echo "💡 Getting optimization recommendations from Gordon..."
echo ""

echo "Analyzing frontend image..."
docker ai analyze todo-frontend:v1.0.0 || echo "Analysis not available"

echo ""
echo "Analyzing backend image..."
docker ai analyze todo-backend:v1.0.0 || echo "Analysis not available"

echo ""
echo "🎉 Gordon build complete!"
echo ""
echo "Next steps:"
echo "  - Load images to Minikube: minikube image load todo-frontend:v1.0.0"
echo "  - Deploy with Helm: helm upgrade todo-app infra/helm/todo-app"
