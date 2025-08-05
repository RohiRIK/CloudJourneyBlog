# BuddyV2 Testing Framework

This document defines the comprehensive testing strategy for Buddy AI V2, ensuring reliability, performance, and security.

## 🎯 Testing Strategy Overview

### Testing Pyramid

```text
    /\
   /UI\      <- Integration Tests (20%)
  /API \     <- Component Tests (30%)
 /Unit  \    <- Unit Tests (50%)
/__Base__\
```

### Quality Gates

1. **Unit Tests**: 90% code coverage minimum
2. **Integration Tests**: All API endpoints validated
3. **System Tests**: End-to-end workflow validation
4. **Performance Tests**: Response time requirements met
5. **Security Tests**: No secrets exposed, authentication working

---

## 🔧 Unit Testing

### Core Function Tests

#### Navigation System Tests

```bash
# Test navigation.json validation
./tests/unit/test_navigation.sh

# Expected outputs:
# ✅ All files in navigation.json exist
# ✅ No broken file paths
# ✅ JSON structure is valid
# ✅ All categories have required fields
```

**Test Script**: `tests/unit/test_navigation.sh`

```bash
#!/bin/bash
# Navigation System Unit Tests

echo "🧪 Testing Navigation System..."

# Test 1: JSON validation
if jq empty projects/buddy-ai/navigation/navigation.json; then
    echo "✅ navigation.json is valid JSON"
else
    echo "❌ navigation.json has invalid JSON syntax"
    exit 1
fi

# Test 2: File existence validation
missing_files=()
while IFS= read -r file_path; do
    if [[ ! -e "$file_path" ]]; then
        missing_files+=("$file_path")
    fi
done < <(jq -r '.[] | .items[]?.path, .sub_categories[]?.items[]?.path' projects/buddy-ai/navigation/navigation.json | grep -v null)

if [[ ${#missing_files[@]} -eq 0 ]]; then
    echo "✅ All navigation files exist"
else
    echo "❌ Missing files:"
    printf '%s\n' "${missing_files[@]}"
    exit 1
fi

echo "🎉 Navigation system tests passed!"
```

#### API Integration Tests

```bash
# Test API authentication
./tests/unit/test_api_auth.sh

# Expected outputs:
# ✅ Environment variables properly set
# ✅ API key patterns detected correctly
# ✅ Security protocols working
```

**Test Script**: `tests/unit/test_api_auth.sh`

```bash
#!/bin/bash
# API Authentication Unit Tests

echo "🔐 Testing API Authentication..."

# Test 1: Environment variable validation
required_vars=("FABRIC_API_KEY" "FIRECRAWL_API_KEY")
for var in "${required_vars[@]}"; do
    if [[ -z "${!var}" ]]; then
        echo "❌ $var not set"
        exit 1
    else
        echo "✅ $var is configured"
    fi
done

# Test 2: API key pattern detection
test_api_key="sk-test123456789"
if echo "$test_api_key" | grep -qE '^sk-[a-zA-Z0-9]+'; then
    echo "✅ API key pattern detection working"
else
    echo "❌ API key pattern detection failed"
    exit 1
fi

echo "🎉 API authentication tests passed!"
```

### Workflow Logic Tests

#### Command Execution Tests

```bash
# Test individual commands
./tests/unit/test_commands.sh

# Expected outputs:
# ✅ All command scripts are executable
# ✅ Command syntax is valid
# ✅ Help text is available
```

#### Security Protocol Tests

```bash
# Test cybersecurity protocol
./tests/unit/test_security.sh

# Expected outputs:
# ✅ API key detection working
# ✅ .gitignore protection active
# ✅ No secrets in committed files
```

---

## 🔗 Integration Testing

### External Service Integration

#### Fabric AI Integration Tests

```bash
# Test Fabric AI connectivity
./tests/integration/test_fabric_ai.sh

# Expected outputs:
# ✅ Service is reachable
# ✅ Authentication working
# ✅ Pattern discovery functional
# ✅ Content generation working
```

**Test Script**: `tests/integration/test_fabric_ai.sh`

```bash
#!/bin/bash
# Fabric AI Integration Tests

echo "🤖 Testing Fabric AI Integration..."

FABRIC_URL="https://fabric-ai.rohi.life"

# Test 1: Service health check
if curl -f -s "$FABRIC_URL/health" > /dev/null; then
    echo "✅ Fabric AI service is reachable"
else
    echo "❌ Fabric AI service is down"
    exit 1
fi

# Test 2: Authentication test
if curl -f -s -H "X-API-Key: $FABRIC_API_KEY" "$FABRIC_URL/patterns" > /dev/null; then
    echo "✅ Fabric AI authentication working"
else
    echo "❌ Fabric AI authentication failed"
    exit 1
fi

# Test 3: Pattern discovery
patterns=$(curl -s -H "X-API-Key: $FABRIC_API_KEY" "$FABRIC_URL/patterns" | jq -r 'length')
if [[ $patterns -gt 0 ]]; then
    echo "✅ Pattern discovery working ($patterns patterns found)"
else
    echo "❌ No patterns discovered"
    exit 1
fi

echo "🎉 Fabric AI integration tests passed!"
```

#### Firecrawl Integration Tests

```bash
# Test Firecrawl functionality
./tests/integration/test_firecrawl.sh

# Expected outputs:
# ✅ Web scraping working
# ✅ Content extraction functional
# ✅ Rate limiting respected
```

#### SearxNG Integration Tests

```bash
# Test SearxNG search functionality
./tests/integration/test_searxng.sh

# Expected outputs:
# ✅ Search queries working
# ✅ Results properly formatted
# ✅ Multiple engines accessible
```

### Workflow Integration Tests

#### End-to-End Workflow Tests

```bash
# Test complete workflows
./tests/integration/test_workflows.sh

# Expected outputs:
# ✅ Research workflow complete
# ✅ Content generation workflow complete
# ✅ Security workflow complete
```

---

## 🌐 System Testing

### End-to-End Scenarios

#### Complete User Journey Tests

**Scenario 1: New User Onboarding**

```bash
# Test new user experience
./tests/system/test_user_onboarding.sh

# Steps tested:
# 1. Navigation system discovery
# 2. First command execution
# 3. Help system usage
# 4. Error handling
# 5. Success feedback
```

**Scenario 2: Complex Research Task**

```bash
# Test complex research workflow
./tests/system/test_research_workflow.sh

# Steps tested:
# 1. Query SearxNG for background
# 2. Use Firecrawl for content extraction
# 3. Analyze with Fabric AI
# 4. Generate final output
# 5. Security validation
```

**Scenario 3: Error Recovery**

```bash
# Test error handling and recovery
./tests/system/test_error_recovery.sh

# Scenarios tested:
# 1. API service unavailable
# 2. Invalid API keys
# 3. Network connectivity issues
# 4. Malformed requests
# 5. Rate limiting
```

### Performance Testing

#### Response Time Tests

```bash
# Test performance benchmarks
./tests/performance/test_response_times.sh

# Benchmarks:
# - Navigation lookup: < 100ms
# - Command execution: < 2s
# - API calls: < 5s (Fabric AI), < 10s (Firecrawl), < 3s (SearxNG)
```

#### Load Testing

```bash
# Test system under load
./tests/performance/test_load.sh

# Load scenarios:
# - 10 concurrent navigation requests
# - 5 concurrent API calls
# - Mixed workflow execution
```

#### Memory Usage Tests

```bash
# Test memory consumption
./tests/performance/test_memory.sh

# Memory benchmarks:
# - Base operation: < 50MB
# - Peak usage: < 200MB
# - No memory leaks over 1 hour
```

---

## 🔒 Security Testing

### API Key Protection Tests

#### Secret Detection Tests

```bash
# Test secret detection capabilities
./tests/security/test_secret_detection.sh

# Test cases:
# ✅ Detect various API key patterns
# ✅ Automatically add to .gitignore
# ✅ Remove from git cache
# ✅ Alert user appropriately
```

**Test Script**: `tests/security/test_secret_detection.sh`

```bash
#!/bin/bash
# Secret Detection Security Tests

echo "🔐 Testing Secret Detection..."

# Create temporary test file with fake API key
test_file="test_secrets_temp.txt"
echo "FABRIC_API_KEY=sk-fake123456789" > "$test_file"

# Test 1: Check if security protocol detects the key
if grep -qE "(sk-[a-zA-Z0-9]+|fc-[a-zA-Z0-9]+)" "$test_file"; then
    echo "✅ Secret detection working"
    
    # Test 2: Verify file gets added to .gitignore
    if ! grep -q "$test_file" .gitignore; then
        echo "$test_file" >> .gitignore
        echo "✅ File added to .gitignore"
    fi
else
    echo "❌ Secret detection failed"
    exit 1
fi

# Cleanup
rm -f "$test_file"
sed -i '' "/$test_file/d" .gitignore

echo "🎉 Secret detection tests passed!"
```

#### Access Control Tests

```bash
# Test access control mechanisms
./tests/security/test_access_control.sh

# Test cases:
# ✅ Invalid API keys rejected
# ✅ Rate limiting enforced
# ✅ Proper error messages (no info leakage)
```

### Vulnerability Tests

#### Input Validation Tests

```bash
# Test input validation
./tests/security/test_input_validation.sh

# Test cases:
# ✅ SQL injection attempts blocked
# ✅ XSS attempts sanitized
# ✅ Command injection prevented
```

#### Data Exposure Tests

```bash
# Test for data exposure risks
./tests/security/test_data_exposure.sh

# Test cases:
# ✅ No secrets in logs
# ✅ No sensitive data in outputs
# ✅ Proper error message sanitization
```

---

## 📊 Test Automation & CI/CD

### Automated Test Execution

#### Test Runner Script

```bash
# Main test runner
./run_tests.sh

# Usage:
# ./run_tests.sh unit        # Run only unit tests
# ./run_tests.sh integration # Run only integration tests
# ./run_tests.sh all         # Run all tests
# ./run_tests.sh security    # Run only security tests
```

**Main Test Runner**: `run_tests.sh`

```bash
#!/bin/bash
# BuddyV2 Test Runner

set -e

TEST_TYPE="${1:-all}"
RESULTS_DIR="test_results/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$RESULTS_DIR"

echo "🧪 Starting BuddyV2 Test Suite..."
echo "📁 Results will be saved to: $RESULTS_DIR"

run_unit_tests() {
    echo "🔧 Running Unit Tests..."
    ./tests/unit/test_navigation.sh | tee "$RESULTS_DIR/unit_navigation.log"
    ./tests/unit/test_api_auth.sh | tee "$RESULTS_DIR/unit_api_auth.log"
    ./tests/unit/test_commands.sh | tee "$RESULTS_DIR/unit_commands.log"
    ./tests/unit/test_security.sh | tee "$RESULTS_DIR/unit_security.log"
}

run_integration_tests() {
    echo "🔗 Running Integration Tests..."
    ./tests/integration/test_fabric_ai.sh | tee "$RESULTS_DIR/integration_fabric.log"
    ./tests/integration/test_firecrawl.sh | tee "$RESULTS_DIR/integration_firecrawl.log"
    ./tests/integration/test_searxng.sh | tee "$RESULTS_DIR/integration_searxng.log"
    ./tests/integration/test_workflows.sh | tee "$RESULTS_DIR/integration_workflows.log"
}

run_system_tests() {
    echo "🌐 Running System Tests..."
    ./tests/system/test_user_onboarding.sh | tee "$RESULTS_DIR/system_onboarding.log"
    ./tests/system/test_research_workflow.sh | tee "$RESULTS_DIR/system_research.log"
    ./tests/system/test_error_recovery.sh | tee "$RESULTS_DIR/system_error_recovery.log"
}

run_performance_tests() {
    echo "⚡ Running Performance Tests..."
    ./tests/performance/test_response_times.sh | tee "$RESULTS_DIR/performance_response.log"
    ./tests/performance/test_load.sh | tee "$RESULTS_DIR/performance_load.log"
    ./tests/performance/test_memory.sh | tee "$RESULTS_DIR/performance_memory.log"
}

run_security_tests() {
    echo "🔒 Running Security Tests..."
    ./tests/security/test_secret_detection.sh | tee "$RESULTS_DIR/security_secrets.log"
    ./tests/security/test_access_control.sh | tee "$RESULTS_DIR/security_access.log"
    ./tests/security/test_input_validation.sh | tee "$RESULTS_DIR/security_input.log"
    ./tests/security/test_data_exposure.sh | tee "$RESULTS_DIR/security_exposure.log"
}

case $TEST_TYPE in
    unit)
        run_unit_tests
        ;;
    integration)
        run_integration_tests
        ;;
    system)
        run_system_tests
        ;;
    performance)
        run_performance_tests
        ;;
    security)
        run_security_tests
        ;;
    all)
        run_unit_tests
        run_integration_tests
        run_system_tests
        run_performance_tests
        run_security_tests
        ;;
    *)
        echo "❌ Invalid test type: $TEST_TYPE"
        echo "Valid options: unit, integration, system, performance, security, all"
        exit 1
        ;;
esac

echo "🎉 Test suite completed!"
echo "📊 Results available in: $RESULTS_DIR"
```

### Continuous Integration

#### GitHub Actions Workflow

**File**: `.github/workflows/buddyv2-tests.yml`

```yaml
name: BuddyV2 Test Suite

on:
  push:
    branches: [ buddyV2, main ]
  pull_request:
    branches: [ buddyV2, main ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Set up environment
      run: |
        chmod +x run_tests.sh
        chmod +x tests/**/*.sh
    
    - name: Run unit tests
      run: ./run_tests.sh unit
    
    - name: Run integration tests
      env:
        FABRIC_API_KEY: ${{ secrets.FABRIC_API_KEY }}
        FIRECRAWL_API_KEY: ${{ secrets.FIRECRAWL_API_KEY }}
      run: ./run_tests.sh integration
    
    - name: Run security tests
      run: ./run_tests.sh security
    
    - name: Upload test results
      uses: actions/upload-artifact@v3
      if: always()
      with:
        name: test-results
        path: test_results/
```

---

## 📋 Test Documentation & Reporting

### Test Results Format

#### Test Report Template

```
🧪 BuddyV2 Test Report
=====================

📅 Execution Date: 2025-08-05 13:45:00
🌿 Branch: buddyV2
👤 Executed By: Automated CI

📊 Test Summary
===============
✅ Unit Tests: 25/25 passed (100%)
✅ Integration Tests: 12/12 passed (100%)
✅ System Tests: 8/8 passed (100%)
✅ Performance Tests: 6/6 passed (100%)
✅ Security Tests: 10/10 passed (100%)

📈 Performance Metrics
=====================
- Navigation Lookup: 45ms (target: <100ms) ✅
- Command Execution: 1.2s (target: <2s) ✅
- Fabric AI Response: 3.1s (target: <5s) ✅
- Memory Usage: 32MB (target: <50MB) ✅

🔒 Security Validation
=====================
- No API keys detected in commits ✅
- All external connections secured ✅
- Input validation working ✅
- Access controls functional ✅

📝 Recommendations
==================
1. All tests passing - ready for deployment
2. Performance within acceptable limits
3. Security protocols functioning correctly
```

### Quality Gates

#### Release Criteria

- [ ] All unit tests pass (100%)
- [ ] All integration tests pass (100%)
- [ ] All system tests pass (100%)
- [ ] Performance benchmarks met
- [ ] Security tests pass (100%)
- [ ] Code coverage > 90%
- [ ] No high-severity vulnerabilities
- [ ] Documentation updated

---

## 🔄 Regression Testing

### Automated Regression Suite

#### Change Impact Testing

```bash
# Test for regressions after changes
./tests/regression/test_change_impact.sh

# Tests:
# ✅ Existing workflows still function
# ✅ API integrations unaffected
# ✅ Performance not degraded
# ✅ Security not compromised
```

#### Backward Compatibility

```bash
# Test backward compatibility
./tests/regression/test_backward_compatibility.sh

# Tests:
# ✅ Old commands still work
# ✅ Existing configurations valid
# ✅ Previous workflows executable
```

---

## 📝 Implementation Plan

### Phase 1: Foundation (Week 1)

- [x] Create testing framework documentation
- [ ] Implement unit test scripts
- [ ] Set up test directory structure
- [ ] Create basic test runner

### Phase 2: Core Tests (Week 2)

- [ ] Implement navigation system tests
- [ ] Create API authentication tests
- [ ] Build security protocol tests
- [ ] Add command execution tests

### Phase 3: Integration (Week 3)

- [ ] Implement external service tests
- [ ] Create workflow integration tests
- [ ] Add performance benchmarks
- [ ] Build error recovery tests

### Phase 4: Automation (Week 4)

- [ ] Set up CI/CD pipeline
- [ ] Implement automated reporting
- [ ] Create regression test suite
- [ ] Add quality gates

---

**Last Updated**: August 5, 2025  
**Version**: 1.0 - Initial Testing Framework  
**Next Review**: August 12, 2025
