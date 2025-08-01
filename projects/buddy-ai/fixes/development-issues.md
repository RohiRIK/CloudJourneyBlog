# Development Issues - Development Environment Problems

Solutions for development setup, coding, and local testing issues.

## Development Environment Setup

### Local Development Stack Not Starting

**Problem**: Docker development environment fails to start properly.

**Diagnostic Commands**:
```bash
# Check Docker daemon status
docker info
systemctl status docker  # Linux
brew services list | grep docker  # macOS

# Verify Docker Compose version
docker-compose version
docker compose version

# Check available disk space
df -h
docker system df

# Clean up Docker resources
docker system prune -a
```

**Solutions**:

#### 1. Docker Desktop Issues (macOS)
```bash
# Restart Docker Desktop
killall Docker\ Desktop
open -a Docker\ Desktop

# Reset Docker Desktop settings
rm -rf ~/Library/Group\ Containers/group.com.docker
open -a Docker\ Desktop

# Increase resource allocation
# Go to Docker Desktop > Settings > Resources
# CPU: 4+ cores, Memory: 8+ GB, Disk: 64+ GB
```

#### 2. Port Conflicts in Development
```bash
# Find processes using common ports
lsof -i :3000  # Node.js development server
lsof -i :8080  # Common web server port
lsof -i :5432  # PostgreSQL
lsof -i :6379  # Redis

# Kill conflicting processes
sudo kill -9 $(lsof -t -i:3000)

# Use different ports in development
# docker-compose.override.yml
version: '3.8'
services:
  app:
    ports:
      - "3001:3000"  # Use different external port
```

#### 3. Volume Mount Issues
```bash
# Fix volume permissions
sudo chown -R $USER:$USER ./data
chmod -R 755 ./data

# For SELinux systems
sudo chcon -Rt svirt_sandbox_file_t ./data

# Use named volumes instead of bind mounts
```

```yaml
# docker-compose.yml
services:
  app:
    volumes:
      - app_data:/app/data  # Named volume
      # - ./data:/app/data  # Instead of bind mount

volumes:
  app_data:
```

#### 4. Environment Variable Loading
```bash
# Check .env file format
cat -A .env  # Show hidden characters

# Verify no trailing spaces or tabs
sed 's/[[:space:]]*$//' .env > .env.clean
mv .env.clean .env

# Test environment loading
docker-compose config
```

### Code Editor Integration Issues

**Problem**: VS Code not working properly with the development environment.

**Diagnostic Commands**:
```bash
# Check VS Code extensions
code --list-extensions | grep -E "(docker|remote)"

# Verify workspace settings
cat .vscode/settings.json

# Check for conflicting extensions
code --disable-extensions

# Test remote development
docker ps
code --folder-uri vscode-remote://attached-container+<container-id>/workspace
```

**Solutions**:

#### 1. Install Required Extensions
```bash
# Install essential extensions
code --install-extension ms-vscode-remote.remote-containers
code --install-extension ms-azuretools.vscode-docker
code --install-extension ms-python.python
code --install-extension ms-vscode.vscode-typescript-next
code --install-extension bradlc.vscode-tailwindcss
```

#### 2. Configure Workspace Settings
```json
// .vscode/settings.json
{
  "remote.containers.defaultExtensions": [
    "ms-python.python",
    "ms-vscode.vscode-typescript-next"
  ],
  "python.defaultInterpreterPath": "/usr/local/bin/python",
  "editor.formatOnSave": true,
  "files.exclude": {
    "**/.git": true,
    "**/node_modules": true,
    "**/__pycache__": true
  }
}
```

#### 3. Dev Container Configuration
```json
// .devcontainer/devcontainer.json
{
  "name": "CloudJourneyBlog Dev",
  "dockerComposeFile": "../docker-compose.yml",
  "service": "app",
  "workspaceFolder": "/workspace",
  "extensions": [
    "ms-python.python",
    "ms-vscode.vscode-typescript-next"
  ],
  "settings": {
    "python.defaultInterpreterPath": "/usr/local/bin/python"
  },
  "forwardPorts": [3000, 8080],
  "postCreateCommand": "npm install && pip install -r requirements.txt"
}
```

### Git Integration Problems

**Problem**: Git operations failing or not working as expected.

**Diagnostic Commands**:
```bash
# Check Git configuration
git config --list
git config user.name
git config user.email

# Verify repository status
git status
git log --oneline -10

# Check remote configuration
git remote -v

# Test authentication
ssh -T git@github.com
gh auth status
```

**Solutions**:

#### 1. Git Authentication Setup
```bash
# Set up SSH key
ssh-keygen -t ed25519 -C "your-email@example.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Add to GitHub
cat ~/.ssh/id_ed25519.pub
# Copy and add to GitHub Settings > SSH Keys

# Or use GitHub CLI
gh auth login
```

#### 2. Fix Git Configuration
```bash
# Set global configuration
git config --global user.name "Your Name"
git config --global user.email "your-email@example.com"
git config --global init.defaultBranch main

# Set up aliases
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
```

#### 3. Repository Issues
```bash
# Reset corrupted repository
git fsck --full
git gc --aggressive --prune=now

# Fix detached HEAD
git checkout main
git branch -D detached-branch

# Sync with remote
git fetch origin
git reset --hard origin/main
```

## Code Quality and Testing Issues

### Linting and Formatting Problems

**Problem**: Code linting and formatting tools not working properly.

**Diagnostic Commands**:
```bash
# Check installed linters
npm list -g | grep -E "(eslint|prettier)"
pip list | grep -E "(black|flake8|pylint)"

# Run linters manually
eslint src/
prettier --check src/
black --check .
flake8 .

# Check configuration files
ls -la .eslintrc* .prettierrc* pyproject.toml setup.cfg
```

**Solutions**:

#### 1. JavaScript/TypeScript Setup
```json
// package.json
{
  "scripts": {
    "lint": "eslint src/",
    "lint:fix": "eslint src/ --fix",
    "format": "prettier --write src/",
    "format:check": "prettier --check src/"
  },
  "devDependencies": {
    "@typescript-eslint/eslint-plugin": "^6.0.0",
    "@typescript-eslint/parser": "^6.0.0",
    "eslint": "^8.0.0",
    "prettier": "^3.0.0"
  }
}
```

```json
// .eslintrc.json
{
  "extends": [
    "eslint:recommended",
    "@typescript-eslint/recommended"
  ],
  "parser": "@typescript-eslint/parser",
  "plugins": ["@typescript-eslint"],
  "rules": {
    "semi": ["error", "always"],
    "quotes": ["error", "single"]
  }
}
```

```json
// .prettierrc
{
  "semi": true,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "es5"
}
```

#### 2. Python Setup
```toml
# pyproject.toml
[tool.black]
line-length = 88
target-version = ['py39']
include = '\.pyi?$'

[tool.flake8]
max-line-length = 88
extend-ignore = ["E203", "W503"]

[tool.pylint]
max-line-length = 88
```

```bash
# requirements-dev.txt
black==23.7.0
flake8==6.0.0
pylint==2.17.5
mypy==1.5.1
```

#### 3. Pre-commit Hooks
```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.4.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files

  - repo: https://github.com/psf/black
    rev: 23.7.0
    hooks:
      - id: black

  - repo: https://github.com/pycqa/flake8
    rev: 6.0.0
    hooks:
      - id: flake8
```

```bash
# Install and setup pre-commit
pip install pre-commit
pre-commit install
pre-commit run --all-files
```

### Testing Environment Issues

**Problem**: Tests failing or not running properly.

**Diagnostic Commands**:
```bash
# Check test framework installation
npm list jest
pip list | grep pytest

# Run tests with verbose output
npm test -- --verbose
pytest -v

# Check test configuration
cat jest.config.js
cat pytest.ini
cat pyproject.toml | grep -A 10 "\[tool.pytest"
```

**Solutions**:

#### 1. Jest Configuration (JavaScript/TypeScript)
```json
// jest.config.js
module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'node',
  roots: ['<rootDir>/src'],
  testMatch: [
    '**/__tests__/**/*.+(ts|tsx|js)',
    '**/*.(test|spec).+(ts|tsx|js)'
  ],
  transform: {
    '^.+\\.(ts|tsx)$': 'ts-jest'
  },
  collectCoverageFrom: [
    'src/**/*.{ts,tsx}',
    '!src/**/*.d.ts'
  ],
  coverageDirectory: 'coverage',
  coverageReporters: ['text', 'lcov', 'html']
};
```

#### 2. Pytest Configuration (Python)
```ini
# pytest.ini
[tool:pytest]
testpaths = tests
python_files = test_*.py
python_classes = Test*
python_functions = test_*
addopts = 
    -v
    --tb=short
    --strict-markers
    --cov=src
    --cov-report=term-missing
    --cov-report=html
```

#### 3. Test Database Setup
```yaml
# docker-compose.test.yml
version: '3.8'
services:
  test-db:
    image: postgres:15
    environment:
      POSTGRES_DB: test_db
      POSTGRES_USER: test_user
      POSTGRES_PASSWORD: test_pass
    ports:
      - "5433:5432"
    tmpfs:
      - /var/lib/postgresql/data  # Use tmpfs for faster tests
```

```bash
# Test script
#!/bin/bash
# run-tests.sh

echo "Starting test database..."
docker-compose -f docker-compose.test.yml up -d test-db

echo "Waiting for database..."
sleep 5

echo "Running tests..."
TEST_DATABASE_URL="postgresql://test_user:test_pass@localhost:5433/test_db" \
  pytest tests/ -v

echo "Cleaning up..."
docker-compose -f docker-compose.test.yml down
```

### Debugging and Development Tools

#### VS Code Debug Configuration
```json
// .vscode/launch.json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Debug Node.js",
      "type": "node",
      "request": "launch",
      "program": "${workspaceFolder}/src/index.js",
      "env": {
        "NODE_ENV": "development"
      },
      "console": "integratedTerminal"
    },
    {
      "name": "Debug Python",
      "type": "python",
      "request": "launch",
      "program": "${workspaceFolder}/src/main.py",
      "env": {
        "PYTHONPATH": "${workspaceFolder}/src"
      },
      "console": "integratedTerminal"
    },
    {
      "name": "Attach to Docker",
      "type": "node",
      "request": "attach",
      "port": 9229,
      "address": "localhost",
      "localRoot": "${workspaceFolder}",
      "remoteRoot": "/app"
    }
  ]
}
```

#### Development Health Check Script
```bash
#!/bin/bash
# dev-health-check.sh - Check development environment

echo "=== Development Environment Health Check ==="

# Check Docker
if command -v docker &> /dev/null; then
    echo "✓ Docker is installed"
    if docker info &> /dev/null; then
        echo "✓ Docker is running"
    else
        echo "✗ Docker is not running"
    fi
else
    echo "✗ Docker is not installed"
fi

# Check Node.js
if command -v node &> /dev/null; then
    echo "✓ Node.js $(node --version) is installed"
else
    echo "✗ Node.js is not installed"
fi

# Check Python
if command -v python3 &> /dev/null; then
    echo "✓ Python $(python3 --version) is installed"
else
    echo "✗ Python is not installed"
fi

# Check Git
if command -v git &> /dev/null; then
    echo "✓ Git $(git --version) is installed"
    if git config user.name &> /dev/null; then
        echo "✓ Git is configured"
    else
        echo "⚠ Git user not configured"
    fi
else
    echo "✗ Git is not installed"
fi

# Check VS Code
if command -v code &> /dev/null; then
    echo "✓ VS Code is installed"
else
    echo "⚠ VS Code is not in PATH"
fi

# Check project structure
if [ -f "docker-compose.yml" ]; then
    echo "✓ docker-compose.yml found"
else
    echo "✗ docker-compose.yml not found"
fi

if [ -f "package.json" ] || [ -f "requirements.txt" ]; then
    echo "✓ Project dependencies file found"
else
    echo "⚠ No package.json or requirements.txt found"
fi

# Check environment files
if [ -f ".env" ]; then
    echo "✓ .env file found"
else
    echo "⚠ .env file not found"
fi

echo ""
echo "=== Port Check ==="
ports=(3000 8080 5432 6379)
for port in "${ports[@]}"; do
    if lsof -i :$port &> /dev/null; then
        echo "⚠ Port $port is in use"
    else
        echo "✓ Port $port is available"
    fi
done

echo ""
echo "=== Development Server Test ==="
if docker-compose ps | grep -q "Up"; then
    echo "✓ Development services are running"
else
    echo "⚠ Development services are not running"
    echo "Run: docker-compose up -d"
fi
```

Save as `tools/scripts/dev-health-check.sh` and run before starting development!
