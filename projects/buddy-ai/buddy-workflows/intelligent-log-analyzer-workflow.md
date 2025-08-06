# Intelligent Log Analyzer Workflow

**Purpose:** Automated, AI-powered analysis of ANY logs, folders, or text files to extract meaningful insights and identify problems.

**Granularity:** Extremely detailed - analyzes individual files, patterns, errors, timelines, and correlations.

**Use Cases:**
- Server logs analysis
- Application error investigation  
- System diagnostic analysis
- Security incident investigation
- Performance troubleshooting
- Any complex log analysis scenario

---

## **Phase 1: Intelligent Discovery & Cataloging**

### **Step 1.1: Smart File Discovery**
```bash
#!/bin/bash
# Auto-discover all relevant files with intelligence

ANALYSIS_DIR="$1"
OUTPUT_DIR="./log_analysis_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$OUTPUT_DIR"

echo "🔍 INTELLIGENT FILE DISCOVERY" | tee "$OUTPUT_DIR/analysis.log"
echo "=================================================" | tee -a "$OUTPUT_DIR/analysis.log"

# Discover and categorize ALL files
find "$ANALYSIS_DIR" -type f | while read file; do
    size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)
    ext="${file##*.}"
    echo "$size|$ext|$file" >> "$OUTPUT_DIR/file_inventory.csv"
done

# Sort by size and categorize
echo "📊 FILE INVENTORY BY SIZE:" | tee -a "$OUTPUT_DIR/analysis.log"
sort -nr "$OUTPUT_DIR/file_inventory.csv" | head -20 | while IFS='|' read size ext file; do
    size_mb=$((size / 1024 / 1024))
    echo "  ${size_mb}MB - $ext - $(basename "$file")" | tee -a "$OUTPUT_DIR/analysis.log"
done

# Categorize by type
echo -e "\n📁 FILE TYPES DISCOVERED:" | tee -a "$OUTPUT_DIR/analysis.log"
cut -d'|' -f2 "$OUTPUT_DIR/file_inventory.csv" | sort | uniq -c | sort -nr | tee -a "$OUTPUT_DIR/analysis.log"
```

### **Step 1.2: Smart Content Sampling**
```bash
# Extract samples from each significant file for AI analysis
echo -e "\n🧠 EXTRACTING CONTENT SAMPLES FOR AI ANALYSIS" | tee -a "$OUTPUT_DIR/analysis.log"

# Sample large files intelligently
sort -nr "$OUTPUT_DIR/file_inventory.csv" | head -10 | while IFS='|' read size ext file; do
    filename=$(basename "$file")
    sample_file="$OUTPUT_DIR/samples/${filename}_sample.txt"
    mkdir -p "$OUTPUT_DIR/samples"
    
    echo "Sampling: $filename (${size} bytes)" | tee -a "$OUTPUT_DIR/analysis.log"
    
    # Smart sampling based on file type
    case "$ext" in
        log|txt)
            # Get first 100, middle 100, and last 100 lines
            echo "=== FIRST 100 LINES ===" > "$sample_file"
            head -100 "$file" >> "$sample_file"
            echo -e "\n=== MIDDLE 100 LINES ===" >> "$sample_file"
            total_lines=$(wc -l < "$file")
            middle_start=$((total_lines / 2 - 50))
            sed -n "${middle_start},$((middle_start + 100))p" "$file" >> "$sample_file"
            echo -e "\n=== LAST 100 LINES ===" >> "$sample_file"
            tail -100 "$file" >> "$sample_file"
            ;;
        xml|json|yml|yaml)
            # Get structure + any error sections
            head -50 "$file" > "$sample_file"
            grep -i "error\|fail\|exception" "$file" | head -20 >> "$sample_file"
            ;;
        reg)
            # Registry exports - get key sections
            grep -E "^\[|ERROR|FAIL" "$file" | head -50 > "$sample_file"
            ;;
        *)
            # Unknown files - safe sample
            head -200 "$file" > "$sample_file"
            ;;
    esac
done
```

---

## **Phase 2: Pattern Recognition & Error Detection**

### **Step 2.1: Automated Error Pattern Detection**
```bash
# Use AI-powered pattern recognition
echo -e "\n🚨 AUTOMATED ERROR DETECTION" | tee -a "$OUTPUT_DIR/analysis.log"
echo "=================================================" | tee -a "$OUTPUT_DIR/analysis.log"

# Create comprehensive error pattern search
cat > "$OUTPUT_DIR/error_patterns.txt" << 'EOF'
# Critical Errors
System\..*Exception
NullReferenceException
AccessDeniedException
AuthenticationException
TimeoutException
ConnectionException
OutOfMemoryException

# Service/Process Issues
service.*failed
service.*stopped
process.*terminated
daemon.*died
agent.*error

# Authentication & Security
authentication.*failed
login.*failed
access.*denied
permission.*denied
certificate.*invalid
token.*expired
unauthorized.*access

# Network & Connectivity
connection.*refused
network.*unreachable
dns.*resolution.*failed
timeout.*exceeded
socket.*error

# File System & Resources
file.*not.*found
disk.*full
permission.*denied
access.*violation
resource.*unavailable

# Application Specific
fatal.*error
critical.*error
severe.*error
panic.*error
crash.*detected
EOF

# Search for error patterns across all files
echo "🔍 SCANNING FOR ERROR PATTERNS:" | tee -a "$OUTPUT_DIR/analysis.log"
while read pattern; do
    [[ "$pattern" =~ ^#.*$ ]] && continue  # Skip comments
    [[ -z "$pattern" ]] && continue        # Skip empty lines
    
    echo "  Searching for: $pattern" | tee -a "$OUTPUT_DIR/analysis.log"
    
    # Search across all files
    find "$ANALYSIS_DIR" -type f -exec grep -l -i -E "$pattern" {} \; 2>/dev/null | while read file; do
        echo "    FOUND IN: $(basename "$file")" | tee -a "$OUTPUT_DIR/analysis.log"
        grep -n -i -E "$pattern" "$file" | head -5 >> "$OUTPUT_DIR/error_findings.txt"
        echo "---" >> "$OUTPUT_DIR/error_findings.txt"
    done
done < "$OUTPUT_DIR/error_patterns.txt"
```

### **Step 2.2: Temporal Analysis**
```bash
# Extract timestamps and create timeline
echo -e "\n⏰ TEMPORAL ANALYSIS" | tee -a "$OUTPUT_DIR/analysis.log"
echo "=================================================" | tee -a "$OUTPUT_DIR/analysis.log"

# Extract timestamps from various formats
find "$ANALYSIS_DIR" -name "*.log" -o -name "*.txt" | while read file; do
    filename=$(basename "$file")
    
    # Multiple timestamp patterns
    grep -E '[0-9]{4}-[0-9]{2}-[0-9]{2}[T ][0-9]{2}:[0-9]{2}:[0-9]{2}' "$file" | head -10 >> "$OUTPUT_DIR/timestamps_${filename}.txt"
    grep -E '[0-9]{2}/[0-9]{2}/[0-9]{4}.*[0-9]{2}:[0-9]{2}:[0-9]{2}' "$file" | head -10 >> "$OUTPUT_DIR/timestamps_${filename}.txt"
    grep -E '[A-Z][a-z]{2} [0-9]{1,2} [0-9]{2}:[0-9]{2}:[0-9]{2}' "$file" | head -10 >> "$OUTPUT_DIR/timestamps_${filename}.txt"
done

# Sort all timestamps to create master timeline
find "$OUTPUT_DIR" -name "timestamps_*.txt" -exec cat {} \; | sort > "$OUTPUT_DIR/master_timeline.txt"
echo "📅 Timeline created with $(wc -l < "$OUTPUT_DIR/master_timeline.txt") entries" | tee -a "$OUTPUT_DIR/analysis.log"
```

---

## **Phase 3: AI-Powered Content Analysis**

### **Step 3.1: Prepare Content for AI Analysis**
```bash
# Create AI analysis prompts for different content types
echo -e "\n🤖 PREPARING AI ANALYSIS" | tee -a "$OUTPUT_DIR/analysis.log"
echo "=================================================" | tee -a "$OUTPUT_DIR/analysis.log"

# Create master context file for AI
cat > "$OUTPUT_DIR/ai_analysis_context.md" << EOF
# Log Analysis Context

## File Inventory
$(cat "$OUTPUT_DIR/file_inventory.csv" | head -20)

## Error Patterns Found
$(head -50 "$OUTPUT_DIR/error_findings.txt")

## Timeline Summary
First event: $(head -1 "$OUTPUT_DIR/master_timeline.txt")
Last event: $(tail -1 "$OUTPUT_DIR/master_timeline.txt")
Total events: $(wc -l < "$OUTPUT_DIR/master_timeline.txt")

## Content Samples
EOF

# Add content samples to context
find "$OUTPUT_DIR/samples" -name "*.txt" | while read sample; do
    echo -e "\n### $(basename "$sample")" >> "$OUTPUT_DIR/ai_analysis_context.md"
    echo '```' >> "$OUTPUT_DIR/ai_analysis_context.md"
    head -100 "$sample" >> "$OUTPUT_DIR/ai_analysis_context.md"
    echo '```' >> "$OUTPUT_DIR/ai_analysis_context.md"
done
```

### **Step 3.2: Fabric AI Analysis Commands**
```bash
# Use Fabric AI for intelligent analysis
echo -e "\n🧠 RUNNING AI ANALYSIS WITH FABRIC" | tee -a "$OUTPUT_DIR/analysis.log"

# Error Analysis
echo "Analyzing errors with Fabric AI..." | tee -a "$OUTPUT_DIR/analysis.log"
fabric --pattern analyze_logs < "$OUTPUT_DIR/error_findings.txt" > "$OUTPUT_DIR/ai_error_analysis.md" 2>/dev/null || echo "Fabric not available - manual analysis required"

# Timeline Analysis  
echo "Analyzing timeline with Fabric AI..." | tee -a "$OUTPUT_DIR/analysis.log"
fabric --pattern analyze_incident < "$OUTPUT_DIR/master_timeline.txt" > "$OUTPUT_DIR/ai_timeline_analysis.md" 2>/dev/null || echo "Fabric not available - manual analysis required"

# Full Context Analysis
echo "Running comprehensive analysis..." | tee -a "$OUTPUT_DIR/analysis.log"
fabric --pattern create_investigation_report < "$OUTPUT_DIR/ai_analysis_context.md" > "$OUTPUT_DIR/ai_comprehensive_analysis.md" 2>/dev/null || echo "Fabric not available - manual analysis required"

# Extract Wisdom
echo "Extracting key insights..." | tee -a "$OUTPUT_DIR/analysis.log"
fabric --pattern extract_wisdom < "$OUTPUT_DIR/ai_analysis_context.md" > "$OUTPUT_DIR/ai_insights.md" 2>/dev/null || echo "Fabric not available - manual analysis required"
```

---

## **Phase 4: Correlation & Root Cause Analysis**

### **Step 4.1: Service Correlation Matrix**
```bash
# Find correlations between services, errors, and timeframes
echo -e "\n🔗 CORRELATION ANALYSIS" | tee -a "$OUTPUT_DIR/analysis.log"
echo "=================================================" | tee -a "$OUTPUT_DIR/analysis.log"

# Extract service names and correlate with errors
grep -i "service\|daemon\|agent\|process" "$OUTPUT_DIR/error_findings.txt" | \
    sed 's/.*\(service\|daemon\|agent\|process\)[^a-zA-Z]*\([a-zA-Z0-9_-]*\).*/\2/' | \
    sort | uniq -c | sort -nr > "$OUTPUT_DIR/service_error_correlation.txt"

echo "🔧 SERVICES WITH MOST ERRORS:" | tee -a "$OUTPUT_DIR/analysis.log"
head -10 "$OUTPUT_DIR/service_error_correlation.txt" | tee -a "$OUTPUT_DIR/analysis.log"

# Time-based correlation
echo -e "\n⏰ TIME-BASED ERROR CLUSTERING:" | tee -a "$OUTPUT_DIR/analysis.log"
grep -E '[0-9]{2}:[0-9]{2}:[0-9]{2}' "$OUTPUT_DIR/error_findings.txt" | \
    cut -d':' -f1-2 | sort | uniq -c | sort -nr | head -10 | tee -a "$OUTPUT_DIR/analysis.log"
```

### **Step 4.2: Automated Root Cause Identification**
```bash
# Use pattern matching to identify likely root causes
echo -e "\n🎯 ROOT CAUSE ANALYSIS" | tee -a "$OUTPUT_DIR/analysis.log"
echo "=================================================" | tee -a "$OUTPUT_DIR/analysis.log"

# Create root cause analysis script
cat > "$OUTPUT_DIR/root_cause_analyzer.sh" << 'EOF'
#!/bin/bash

echo "🔍 AUTOMATED ROOT CAUSE IDENTIFICATION"
echo "======================================"

# Check for cascading failures
if grep -q "authentication.*failed" error_findings.txt && grep -q "service.*stopped" error_findings.txt; then
    echo "🚨 LIKELY ROOT CAUSE: Authentication failure leading to service failures"
    echo "  Evidence: Authentication errors followed by service stops"
fi

# Check for resource exhaustion
if grep -q -i "memory\|disk.*full\|resource.*unavailable" error_findings.txt; then
    echo "🚨 LIKELY ROOT CAUSE: Resource exhaustion"
    echo "  Evidence: Memory/disk/resource errors detected"
fi

# Check for network issues
if grep -q -i "connection.*refused\|network.*unreachable\|timeout" error_findings.txt; then
    echo "🚨 LIKELY ROOT CAUSE: Network connectivity issues"
    echo "  Evidence: Connection/network errors detected"
fi

# Check for permission issues
if grep -q -i "permission.*denied\|access.*denied\|unauthorized" error_findings.txt; then
    echo "🚨 LIKELY ROOT CAUSE: Permission/access control issues"
    echo "  Evidence: Permission errors detected"
fi

# Check for configuration issues
if grep -q -i "config.*error\|invalid.*config\|missing.*config" error_findings.txt; then
    echo "🚨 LIKELY ROOT CAUSE: Configuration problems"
    echo "  Evidence: Configuration errors detected"
fi

echo -e "\n💡 AUTOMATED RECOMMENDATIONS:"
echo "1. Review the highest-frequency errors in service_error_correlation.txt"
echo "2. Check time-clustered errors for incident timeline"
echo "3. Review AI analysis outputs for detailed insights"
echo "4. Correlate errors with service logs during identified time windows"
EOF

chmod +x "$OUTPUT_DIR/root_cause_analyzer.sh"
cd "$OUTPUT_DIR" && ./root_cause_analyzer.sh | tee -a analysis.log
```

---

## **Phase 5: Solution Generation**

### **Step 5.1: AI-Powered Solution Recommendations**
```bash
# Generate solutions based on identified patterns
echo -e "\n💡 SOLUTION GENERATION" | tee -a "$OUTPUT_DIR/analysis.log"
echo "=================================================" | tee -a "$OUTPUT_DIR/analysis.log"

# Create solution prompt for AI
cat > "$OUTPUT_DIR/solution_prompt.md" << EOF
# Solution Request

## Problem Summary
Based on the analysis, here are the key findings:

### Top Errors Found:
$(head -20 "$OUTPUT_DIR/error_findings.txt")

### Service Correlations:
$(head -10 "$OUTPUT_DIR/service_error_correlation.txt")

### Root Cause Indicators:
$(cd "$OUTPUT_DIR" && ./root_cause_analyzer.sh)

## Request:
Please provide specific, actionable solutions for these issues. Include:
1. Step-by-step commands to fix identified problems
2. Verification steps to confirm resolution
3. Prevention measures to avoid recurrence
4. Priority order for implementing fixes
EOF

# Use Fabric AI to generate solutions
echo "🤖 Generating AI-powered solutions..." | tee -a "$OUTPUT_DIR/analysis.log"
fabric --pattern create_fix_as_code < "$OUTPUT_DIR/solution_prompt.md" > "$OUTPUT_DIR/ai_solutions.md" 2>/dev/null || echo "Fabric not available - manual solution creation required"
```

### **Step 5.2: Create Executable Fix Scripts**
```bash
# Generate ready-to-run fix scripts
echo -e "\n🔧 CREATING EXECUTABLE SOLUTIONS" | tee -a "$OUTPUT_DIR/analysis.log"

# Parse AI solutions and create scripts (if available)
if [ -f "$OUTPUT_DIR/ai_solutions.md" ]; then
    # Extract bash commands from AI solutions
    sed -n '/```bash/,/```/p' "$OUTPUT_DIR/ai_solutions.md" | grep -v '```' > "$OUTPUT_DIR/auto_fix_commands.sh"
    chmod +x "$OUTPUT_DIR/auto_fix_commands.sh"
    echo "✅ Executable fix script created: auto_fix_commands.sh" | tee -a "$OUTPUT_DIR/analysis.log"
fi

# Create manual fix template
cat > "$OUTPUT_DIR/manual_fixes.md" << EOF
# Manual Fix Procedures

## Based on Pattern Analysis

### High-Priority Issues (Fix First):
$(head -5 "$OUTPUT_DIR/service_error_correlation.txt")

### Recommended Actions:
1. **Address Top Service Errors:**
   - Review logs for the most frequent error-generating services
   - Check service status and restart if needed
   - Verify service configurations

2. **Time-Based Investigation:**
   - Focus on error clusters from time analysis
   - Check what changed during high-error periods
   - Review system events during those timeframes

3. **Root Cause Mitigation:**
   - See root_cause_analyzer.sh output for specific issues
   - Address authentication, resource, or network issues as identified

### Verification Steps:
1. Re-run this analysis after fixes to confirm error reduction
2. Monitor services during normal operation
3. Check error patterns have changed or disappeared

### Prevention Measures:
1. Set up monitoring for identified error patterns
2. Create alerts for service failures
3. Regular health checks for problem services
EOF
```

---

## **Phase 6: Comprehensive Reporting**

### **Step 6.1: Generate Executive Summary**
```bash
# Create final comprehensive report
echo -e "\n📊 GENERATING COMPREHENSIVE REPORT" | tee -a "$OUTPUT_DIR/analysis.log"
echo "=================================================" | tee -a "$OUTPUT_DIR/analysis.log"

cat > "$OUTPUT_DIR/ANALYSIS_REPORT.md" << EOF
# Comprehensive Log Analysis Report

**Analysis Date:** $(date)
**Source Directory:** $ANALYSIS_DIR
**Analysis Duration:** $(echo "scale=2; ($(date +%s) - $START_TIME) / 60" | bc 2>/dev/null || echo "N/A") minutes

## Executive Summary

### Files Analyzed:
- **Total Files:** $(wc -l < "$OUTPUT_DIR/file_inventory.csv")
- **Largest File:** $(head -1 "$OUTPUT_DIR/file_inventory.csv" | cut -d'|' -f3 | xargs basename)
- **File Types:** $(cut -d'|' -f2 "$OUTPUT_DIR/file_inventory.csv" | sort -u | wc -l) different types

### Key Findings:
- **Error Patterns Found:** $(wc -l < "$OUTPUT_DIR/error_findings.txt") instances
- **Timeline Span:** $(head -1 "$OUTPUT_DIR/master_timeline.txt" | cut -c1-19) to $(tail -1 "$OUTPUT_DIR/master_timeline.txt" | cut -c1-19)
- **Top Problem Service:** $(head -1 "$OUTPUT_DIR/service_error_correlation.txt" | awk '{print $2}')

## Detailed Analysis

### Error Distribution:
\`\`\`
$(head -10 "$OUTPUT_DIR/service_error_correlation.txt")
\`\`\`

### Time-Based Patterns:
\`\`\`
$(grep -E '[0-9]{2}:[0-9]{2}:[0-9]{2}' "$OUTPUT_DIR/error_findings.txt" | cut -d':' -f1-2 | sort | uniq -c | sort -nr | head -5)
\`\`\`

### Root Cause Analysis:
$(cd "$OUTPUT_DIR" && ./root_cause_analyzer.sh)

## AI Analysis Results:
EOF

# Add AI analysis if available
if [ -f "$OUTPUT_DIR/ai_comprehensive_analysis.md" ]; then
    echo -e "\n### AI Comprehensive Analysis:" >> "$OUTPUT_DIR/ANALYSIS_REPORT.md"
    cat "$OUTPUT_DIR/ai_comprehensive_analysis.md" >> "$OUTPUT_DIR/ANALYSIS_REPORT.md"
fi

if [ -f "$OUTPUT_DIR/ai_insights.md" ]; then
    echo -e "\n### AI-Extracted Insights:" >> "$OUTPUT_DIR/ANALYSIS_REPORT.md"
    cat "$OUTPUT_DIR/ai_insights.md" >> "$OUTPUT_DIR/ANALYSIS_REPORT.md"
fi

cat >> "$OUTPUT_DIR/ANALYSIS_REPORT.md" << EOF

## Recommended Actions

### Immediate Actions (Priority 1):
1. Address errors from top services in correlation analysis
2. Investigate time-clustered errors for incident patterns
3. Review AI solutions (if available) in ai_solutions.md

### Follow-up Actions (Priority 2):
1. Implement monitoring for identified patterns
2. Set up alerts for recurring issues
3. Create preventive measures as outlined in manual_fixes.md

## Files Generated:
- \`ANALYSIS_REPORT.md\` - This comprehensive report
- \`analysis.log\` - Detailed analysis log
- \`error_findings.txt\` - All error patterns found
- \`service_error_correlation.txt\` - Service-error correlations
- \`master_timeline.txt\` - Complete timeline of events
- \`ai_*.md\` - AI-powered analysis results (if available)
- \`manual_fixes.md\` - Manual fix procedures
- \`auto_fix_commands.sh\` - Executable fix commands (if generated)

EOF

echo "✅ Comprehensive analysis complete!" | tee -a "$OUTPUT_DIR/analysis.log"
echo "📁 Results saved in: $OUTPUT_DIR" | tee -a "$OUTPUT_DIR/analysis.log"
echo "📊 Main report: $OUTPUT_DIR/ANALYSIS_REPORT.md" | tee -a "$OUTPUT_DIR/analysis.log"
```

---

## **Phase 7: Usage Examples & Templates**

### **Quick Start Command:**
```bash
# Save this as analyze_logs.sh and make executable
#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <directory_to_analyze>"
    echo "Example: $0 /path/to/diagnostic/logs"
    exit 1
fi

START_TIME=$(date +%s)
ANALYSIS_DIR="$1"

# Source the workflow steps above
# [Include all the bash code from phases 1-6]

echo "🎉 ANALYSIS COMPLETE!"
echo "Check the generated ANALYSIS_REPORT.md for comprehensive findings"
```

### **Integration with Fabric AI:**
```bash
# Enhanced AI integration
fabric_analyze() {
    local input_file="$1"
    local pattern="$2"
    local output_file="$3"
    
    if command -v fabric >/dev/null 2>&1; then
        echo "🤖 Running Fabric AI analysis with pattern: $pattern"
        fabric --pattern "$pattern" < "$input_file" > "$output_file"
        echo "✅ AI analysis saved to: $output_file"
    else
        echo "⚠️ Fabric AI not available - install from: https://github.com/danielmiessler/fabric"
        echo "Manual analysis required for: $input_file"
    fi
}
```

### **Quick One-Liner for Any Directory:**
```bash
# Ultimate one-liner for instant analysis
analyze_logs() {
    local dir="${1:-.}"
    local output="analysis_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$output"
    
    echo "🔍 Quick Analysis of: $dir"
    find "$dir" -name "*.log" -o -name "*.txt" | head -10 | while read f; do
        echo "📄 $(basename "$f"): $(wc -l < "$f") lines"
        grep -i "error\|fail\|exception" "$f" | head -5 >> "$output/quick_errors.txt"
    done
    
    echo "❌ Top Errors Found:"
    sort "$output/quick_errors.txt" | uniq -c | sort -nr | head -10
    
    # AI analysis if available
    if command -v fabric >/dev/null 2>&1; then
        fabric --pattern analyze_logs < "$output/quick_errors.txt"
    fi
}
```

---

## **Advanced Features**

### **Real-time Monitoring Mode:**
```bash
# Watch logs in real-time and analyze patterns
monitor_logs() {
    local logdir="$1"
    local output="realtime_analysis"
    
    echo "👁️ REAL-TIME LOG MONITORING: $logdir"
    
    # Monitor all log files simultaneously
    find "$logdir" -name "*.log" | while read logfile; do
        echo "Monitoring: $(basename "$logfile")"
        tail -f "$logfile" | while read line; do
            # Check for error patterns
            if echo "$line" | grep -qi "error\|fail\|exception\|critical"; then
                echo "🚨 $(date): $(basename "$logfile"): $line" | tee -a "${output}_alerts.log"
                
                # AI analysis of error in real-time
                echo "$line" | fabric --pattern analyze_error 2>/dev/null || echo "Manual review needed: $line"
            fi
        done &
    done
    
    wait
}
```

### **Comparative Analysis:**
```bash
# Compare logs from different time periods
compare_logs() {
    local before_dir="$1"
    local after_dir="$2"
    
    echo "📊 COMPARATIVE ANALYSIS"
    echo "Before: $before_dir"
    echo "After: $after_dir"
    
    # Generate patterns for both
    grep -r "error\|fail" "$before_dir" | wc -l > before_errors.count
    grep -r "error\|fail" "$after_dir" | wc -l > after_errors.count
    
    echo "Error count before: $(cat before_errors.count)"
    echo "Error count after: $(cat after_errors.count)"
    
    if [ "$(cat after_errors.count)" -lt "$(cat before_errors.count)" ]; then
        echo "✅ Improvement detected!"
    else
        echo "❌ Issues may persist or worsened"
    fi
}
```

---

**This workflow is the ultimate granular log analyzer - it can take ANY logs/folders/text and give you intelligent insights about what happened, why it happened, and how to fix it!** 🚀
