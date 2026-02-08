# Containerization Skill (Docker + Gordon)

A comprehensive containerization system using Docker and Gordon AI for building, testing, and deploying frontend and backend applications in containers.

## Functions

### `build-frontend-image(tag: string, context: string)`
Builds a Docker image for the frontend application using Gordon AI or a Claude-generated Dockerfile.

**Parameters:**
- `tag` (string): Image tag (e.g., `todo-frontend:latest`)
- `context` (string): Build context path (e.g., `./frontend`)

**Command:**
```bash
docker ai build --tag todo-frontend:latest ./frontend
```

**Implementation:**
- Multi-stage build: Node.js build stage → Nginx serve stage
- Stage 1: Install dependencies and build the Next.js/React application
- Stage 2: Copy build artifacts to lightweight Nginx container
- Optimized for production with minimal image size
- Includes environment variable configuration

**Response:**
- Successfully built Docker image with specified tag
- Image available in local Docker registry
- Build logs showing each layer and optimization steps

### `build-backend-image(tag: string, context: string)`
Builds a Docker image for the backend application using Gordon AI or a Claude-generated Dockerfile.

**Parameters:**
- `tag` (string): Image tag (e.g., `todo-backend:latest`)
- `context` (string): Build context path (e.g., `./backend`)

**Command:**
```bash
docker ai build --tag todo-backend:latest ./backend
```

**Implementation:**
- Based on slim Python base image (python:3.11-slim)
- Installs FastAPI, Uvicorn, and required dependencies
- Copies application code and configuration
- Exposes appropriate port (typically 8000)
- Configures Uvicorn as the ASGI server
- Includes health check endpoint

**Response:**
- Successfully built Docker image with specified tag
- Image available in local Docker registry
- Optimized for production deployment

### `test-image-locally(image: string, port: number)`
Runs a Docker container locally to verify the image works correctly.

**Parameters:**
- `image` (string): Image name and tag (e.g., `todo-frontend:latest`)
- `port` (number): Port mapping (e.g., `3000:3000` for frontend, `8000:8000` for backend)

**Commands:**
```bash
# Test frontend
docker run -p 3000:3000 todo-frontend:latest

# Test backend
docker run -p 8000:8000 todo-backend:latest
```

**Verification Steps:**
- Container starts without errors
- Application responds to HTTP requests
- Health check endpoints return 200 OK
- Logs show successful initialization
- Can access application at `http://localhost:<port>`

**Response:**
- Container running successfully
- Application accessible and functional
- Logs available via `docker logs <container-id>`

### `build-with-dockerfile(dockerfile: string, tag: string, context: string)`
Builds a Docker image using a custom Dockerfile when Gordon AI is not available.

**Parameters:**
- `dockerfile` (string): Path to Dockerfile (e.g., `./frontend/Dockerfile`)
- `tag` (string): Image tag
- `context` (string): Build context path

**Command:**
```bash
docker build -f ./frontend/Dockerfile -t todo-frontend:latest ./frontend
```

**Use Cases:**
- Custom build requirements not supported by Gordon
- Specific base image requirements
- Complex multi-stage builds with custom logic
- Integration with existing CI/CD pipelines

### `run-with-env(image: string, env_file: string, port: number)`
Runs a container with environment variables from a file.

**Parameters:**
- `image` (string): Image name and tag
- `env_file` (string): Path to environment file (e.g., `.env`)
- `port` (number): Port mapping

**Command:**
```bash
docker run -p 8000:8000 --env-file .env todo-backend:latest
```

**Use Cases:**
- Running with database connection strings
- API keys and secrets management
- Environment-specific configuration
- Development vs production settings

### `docker-compose-up(compose_file: string)`
Starts all services defined in docker-compose.yml.

**Parameters:**
- `compose_file` (string): Path to docker-compose.yml (optional, defaults to `./docker-compose.yml`)

**Command:**
```bash
docker-compose up -d
```

**Functionality:**
- Starts frontend, backend, and database containers
- Creates network for inter-container communication
- Mounts volumes for persistent data
- Applies environment variables
- Runs in detached mode (-d flag)

### `docker-compose-down()`
Stops and removes all containers, networks, and volumes.

**Command:**
```bash
docker-compose down -v
```

**Functionality:**
- Stops all running containers
- Removes containers and networks
- Removes volumes (-v flag) for clean state
- Useful for resetting development environment

## Implementation Details

### Frontend Dockerfile Structure (Multi-stage)
```dockerfile
# Stage 1: Build
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 2: Serve
FROM nginx:alpine
COPY --from=builder /app/out /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 3000
CMD ["nginx", "-g", "daemon off;"]
```

### Backend Dockerfile Structure
```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

### Docker Compose Configuration
```yaml
version: '3.8'
services:
  frontend:
    build: ./frontend
    ports:
      - "3000:3000"
    depends_on:
      - backend

  backend:
    build: ./backend
    ports:
      - "8000:8000"
    env_file:
      - .env
    depends_on:
      - db

  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: todoapp
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

## Usage Examples

### Building Frontend Image with Gordon
```bash
# Using Gordon AI to generate and build Dockerfile
docker ai build --tag todo-frontend:latest ./frontend

# Gordon analyzes the codebase and creates optimized Dockerfile
# Multi-stage build automatically configured
```

### Building Backend Image with Gordon
```bash
# Using Gordon AI for backend
docker ai build --tag todo-backend:latest ./backend

# Gordon detects FastAPI/Uvicorn and configures appropriately
```

### Testing Images Locally
```bash
# Test frontend
docker run -p 3000:3000 todo-frontend:latest
# Visit http://localhost:3000

# Test backend
docker run -p 8000:8000 todo-backend:latest
# Visit http://localhost:8000/docs for API documentation
```

### Running with Environment Variables
```bash
# Backend with database connection
docker run -p 8000:8000 \
  -e DATABASE_URL="postgresql://user:pass@db:5432/todoapp" \
  -e JWT_SECRET="your-secret-key" \
  todo-backend:latest
```

### Using Docker Compose for Full Stack
```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop all services
docker-compose down
```

### Inspecting Running Containers
```bash
# List running containers
docker ps

# View container logs
docker logs <container-id>

# Execute commands in container
docker exec -it <container-id> /bin/sh

# Inspect container details
docker inspect <container-id>
```

## Best Practices

### Image Optimization
- Use multi-stage builds to reduce final image size
- Leverage .dockerignore to exclude unnecessary files
- Use slim or alpine base images when possible
- Combine RUN commands to reduce layers
- Order Dockerfile commands from least to most frequently changing

### Security
- Don't include secrets in Dockerfile or images
- Use environment variables or secrets management
- Run containers as non-root user when possible
- Scan images for vulnerabilities (`docker scan <image>`)
- Keep base images updated

### Development Workflow
- Use volume mounts for hot-reloading during development
- Separate development and production Dockerfiles
- Use docker-compose for local development
- Tag images with version numbers for production

### Production Deployment
- Use specific version tags, not `latest`
- Implement health checks in Dockerfile
- Configure resource limits (CPU, memory)
- Use orchestration platforms (Kubernetes, ECS, etc.)
- Implement logging and monitoring

## Error Handling

### Build Failures
- **Dependency installation fails**: Check network connectivity, verify package names
- **Build context too large**: Add files to .dockerignore
- **Out of disk space**: Clean up unused images with `docker system prune`

### Runtime Errors
- **Port already in use**: Change port mapping or stop conflicting service
- **Container exits immediately**: Check logs with `docker logs <container-id>`
- **Cannot connect to database**: Verify network configuration and environment variables
- **Permission denied**: Check file permissions and user configuration

### Gordon-Specific Issues
- **Gordon not available**: Fall back to manual Dockerfile creation
- **Gordon generates incorrect Dockerfile**: Review and modify generated file
- **Build optimization needed**: Manually tune Dockerfile for specific requirements

## Troubleshooting Commands

```bash
# View all images
docker images

# Remove unused images
docker image prune -a

# View container logs
docker logs -f <container-id>

# Stop all running containers
docker stop $(docker ps -q)

# Remove all stopped containers
docker container prune

# View disk usage
docker system df

# Clean up everything
docker system prune -a --volumes
```
