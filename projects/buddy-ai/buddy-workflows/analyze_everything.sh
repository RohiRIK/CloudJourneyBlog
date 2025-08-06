#!/bin/bash

# INTELLIGENT LOG ANALYZER - Ultimate One-Command Solution
# Usage: ./analyze_everything.sh <directory_to_analyze>
# Example: ./analyze_everything.sh /path/to/logs

set -e

if [ -z "$1" ]; then
    echo "🚨 Usage: $0 <directory_to_analyze>"
    echo "Example: $0 /Users/user/DiagLogs-WS205-20250804T115152Z"
    exit 1
fi

START_TIME=$(date +%s)
ANALYSIS_DIR="$1"
OUTPUT_DIR="./intelligent_analysis_$(date +%Y%m%d_%H%M%S)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🚀 INTELLIGENT LOG ANALYZER STARTING"
echo "========================================"
echo "📁 Analyzing: $ANALYSIS_DIR"
echo "💾 Output: $OUTPUT_DIR"
echo "⏰ Started: $(date)"
echo ""

mkdir -p "$OUTPUT_DIR"

# Phase 1: Discovery
echo "🔍 Phase 1: Intelligent Discovery"
echo "=================================="

find "$ANALYSIS_DIR" -type f | while read file; do
    size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null || echo "0")
    ext="${file##*.}"
    echo "$size|$ext|$file"
done | sort -nr > "$OUTPUT_DIR/file_inventory.csv"

echo "📊 Discovered $(wc -l < "$OUTPUT_DIR/file_inventory.csv") files"
echo "🗂️ Largest files:"
head -5 "$OUTPUT_DIR/file_inventory.csv" | while IFS='|' read size ext file; do
    size_mb=$((size / 1024 / 1024))
    echo "  ${size_mb}MB - $ext - $(basename "$file")"
done

# Phase 2: Smart Sampling
echo ""
echo "🧠 Phase 2: Smart Content Sampling"
echo "==================================="

mkdir -p "$OUTPUT_DIR/samples"
head -10 "$OUTPUT_DIR/file_inventory.csv" | while IFS='|' read size ext file; do
    if [ "$size" -gt 1000 ]; then  # Only sample files > 1KB
        filename=$(basename "$file")
        sample_file="$OUTPUT_DIR/samples/${filename}_sample.txt"
        
        echo "📄 Sampling: $filename"
        case "$ext" in
            log|txt)
                echo "=== FIRST 50 LINES ===" > "$sample_file"
                head -50 "$file" >> "$sample_file" 2>/dev/null || echo "Error reading file" >> "$sample_file"
                echo -e "\n=== LAST 50 LINES ===" >> "$sample_file"
                tail -50 "$file" >> "$sample_file" 2>/dev/null || echo "Error reading file" >> "$sample_file"
                ;;
            xml|json|yml|yaml)
                head -100 "$file" > "$sample_file" 2>/dev/null || echo "Error reading file" > "$sample_file"
                ;;
            *)
                head -50 "$file" > "$sample_file" 2>/dev/null || echo "Binary or unreadable file" > "$sample_file"
                ;;
        esac
    fi
done

# Phase 3: Error Detection
echo ""
echo "🚨 Phase 3: Error Pattern Detection"
echo "===================================="

# Create comprehensive error search
{
    find "$ANALYSIS_DIR" -type f \( -name "*.log" -o -name "*.txt" -o -name "*.xml" \) -exec grep -l -i -E "(error|fail|exception|critical|fatal|panic)" {} \; 2>/dev/null | while read file; do
        echo "🔍 Scanning: $(basename "$file")"
        grep -n -i -E "(error|fail|exception|critical|fatal|panic)" "$file" 2>/dev/null | head -20
        echo "---"
    done
} > "$OUTPUT_DIR/error_patterns.txt"

error_count=$(grep -c ":" "$OUTPUT_DIR/error_patterns.txt" 2>/dev/null || echo "0")
echo "❌ Found $error_count error instances"

# Phase 4: Service Analysis
echo ""
echo "🔧 Phase 4: Service & Component Analysis"
echo "========================================="

# Extract service names and correlate with errors
grep -i -E "(service|daemon|agent|process)" "$OUTPUT_DIR/error_patterns.txt" 2>/dev/null | \
    sed -E 's/.*(service|daemon|agent|process)[^a-zA-Z]*([a-zA-Z0-9_-]+).*/\2/' | \
    grep -v "^$" | sort | uniq -c | sort -nr > "$OUTPUT_DIR/service_correlations.txt" 2>/dev/null || touch "$OUTPUT_DIR/service_correlations.txt"

if [ -s "$OUTPUT_DIR/service_correlations.txt" ]; then
    echo "🎯 Top problematic services:"
    head -5 "$OUTPUT_DIR/service_correlations.txt"
else
    echo "ℹ️ No clear service patterns detected"
fi

# Phase 5: Timeline Analysis
echo ""
echo "⏰ Phase 5: Timeline Analysis"
echo "=============================="

# Extract timestamps from various formats
{
    find "$ANALYSIS_DIR" -type f \( -name "*.log" -o -name "*.txt" \) -exec grep -h -E '[0-9]{4}-[0-9]{2}-[0-9]{2}[T ][0-9]{2}:[0-9]{2}:[0-9]{2}' {} \; 2>/dev/null
    find "$ANALYSIS_DIR" -type f \( -name "*.log" -o -name "*.txt" \) -exec grep -h -E '[0-9]{2}/[0-9]{2}/[0-9]{4}.*[0-9]{2}:[0-9]{2}:[0-9]{2}' {} \; 2>/dev/null
} | sort | head -100 > "$OUTPUT_DIR/timeline.txt"

timeline_count=$(wc -l < "$OUTPUT_DIR/timeline.txt" 2>/dev/null || echo "0")
if [ "$timeline_count" -gt 0 ]; then
    echo "📅 Timeline entries: $timeline_count"
    echo "🕐 First event: $(head -1 "$OUTPUT_DIR/timeline.txt" 2>/dev/null | cut -c1-19)"
    echo "🕐 Last event: $(tail -1 "$OUTPUT_DIR/timeline.txt" 2>/dev/null | cut -c1-19)"
else
    echo "ℹ️ No clear timestamps detected"
fi

# Phase 6: AI Analysis (if Fabric available)
echo ""
echo "🤖 Phase 6: AI Analysis"
echo "========================"

if command -v fabric >/dev/null 2>&1; then
    echo "✅ Fabric AI detected - running intelligent analysis"
    
    # Create context for AI
    cat > "$OUTPUT_DIR/ai_context.md" << EOF
# Log Analysis Context

## File Summary
Total files: $(wc -l < "$OUTPUT_DIR/file_inventory.csv")
Error instances: $error_count
Timeline entries: $timeline_count

## Top Errors Found
$(head -20 "$OUTPUT_DIR/error_patterns.txt")

## Service Correlations
$(cat "$OUTPUT_DIR/service_correlations.txt")

## Sample Content
$(find "$OUTPUT_DIR/samples" -name "*.txt" -exec echo "### {}" \; -exec head -30 {} \; 2>/dev/null | head -200)
EOF

    # Run AI analysis
    echo "🧠 Analyzing errors..."
    fabric --pattern analyze_logs < "$OUTPUT_DIR/error_patterns.txt" > "$OUTPUT_DIR/ai_error_analysis.md" 2>/dev/null || echo "Error analysis failed"
    
    echo "🔍 Creating investigation report..."
    fabric --pattern create_investigation_report < "$OUTPUT_DIR/ai_context.md" > "$OUTPUT_DIR/ai_investigation.md" 2>/dev/null || echo "Investigation report failed"
    
    echo "💡 Extracting insights..."
    fabric --pattern extract_wisdom < "$OUTPUT_DIR/ai_context.md" > "$OUTPUT_DIR/ai_insights.md" 2>/dev/null || echo "Insight extraction failed"
    
else
    echo "⚠️ Fabric AI not available - install with: go install github.com/danielmiessler/fabric@latest"
    echo "ℹ️ Manual analysis mode activated"
fi

# Phase 7: Root Cause Analysis
echo ""
echo "🎯 Phase 7: Automated Root Cause Analysis"
echo "=========================================="

# Simple automated root cause detection
echo "🔍 Automated pattern analysis:"

# Check for authentication issues
if grep -qi "authentication.*fail\|login.*fail\|access.*denied" "$OUTPUT_DIR/error_patterns.txt" 2>/dev/null; then
    echo "🚨 AUTHENTICATION ISSUES detected"
    echo "  Evidence: Authentication/login failures found"
fi

# Check for resource issues
if grep -qi "memory\|disk.*full\|resource.*unavailable\|out.*of.*memory" "$OUTPUT_DIR/error_patterns.txt" 2>/dev/null; then
    echo "🚨 RESOURCE EXHAUSTION detected"
    echo "  Evidence: Memory/disk/resource errors found"
fi

# Check for network issues
if grep -qi "connection.*refused\|network.*unreachable\|timeout.*exceeded" "$OUTPUT_DIR/error_patterns.txt" 2>/dev/null; then
    echo "🚨 NETWORK CONNECTIVITY ISSUES detected"
    echo "  Evidence: Connection/network errors found"
fi

# Check for permission issues
if grep -qi "permission.*denied\|access.*violation\|unauthorized" "$OUTPUT_DIR/error_patterns.txt" 2>/dev/null; then
    echo "🚨 PERMISSION ISSUES detected"
    echo "  Evidence: Permission/access errors found"
fi

# Check for service issues
if grep -qi "service.*failed\|service.*stopped\|daemon.*died" "$OUTPUT_DIR/error_patterns.txt" 2>/dev/null; then
    echo "🚨 SERVICE FAILURES detected"
    echo "  Evidence: Service failure patterns found"
fi

# Phase 8: Generate Report
echo ""
echo "📊 Phase 8: Generating Comprehensive Report"
echo "============================================"

cat > "$OUTPUT_DIR/COMPREHENSIVE_ANALYSIS_REPORT.md" << EOF
# Comprehensive Log Analysis Report

**Analysis Date:** $(date)
**Source Directory:** $ANALYSIS_DIR
**Analysis Duration:** $(($(date +%s) - START_TIME)) seconds

## Executive Summary

### Files Analyzed
- **Total Files:** $(wc -l < "$OUTPUT_DIR/file_inventory.csv")
- **Largest File:** $(head -1 "$OUTPUT_DIR/file_inventory.csv" | cut -d'|' -f3 | xargs basename)
- **Error Instances:** $error_count
- **Timeline Entries:** $timeline_count

### Key Findings

#### Top 5 Largest Files:
\`\`\`
$(head -5 "$OUTPUT_DIR/file_inventory.csv" | while IFS='|' read size ext file; do
    size_mb=$((size / 1024 / 1024))
    echo "${size_mb}MB - $ext - $(basename "$file")"
done)
\`\`\`

#### Error Patterns Summary:
\`\`\`
$(head -10 "$OUTPUT_DIR/error_patterns.txt")
\`\`\`

#### Service Correlation Analysis:
\`\`\`
$(cat "$OUTPUT_DIR/service_correlations.txt")
\`\`\`

## Detailed Analysis Files Generated

- \`file_inventory.csv\` - Complete file inventory with sizes
- \`error_patterns.txt\` - All error patterns found
- \`service_correlations.txt\` - Service-error correlations
- \`timeline.txt\` - Extracted timeline events
- \`samples/\` - Content samples from key files
- \`ai_*.md\` - AI analysis results (if Fabric available)

## Recommended Next Steps

1. **Review Error Patterns:** Check \`error_patterns.txt\` for specific issues
2. **Service Analysis:** Focus on services in \`service_correlations.txt\`
3. **Timeline Investigation:** Use \`timeline.txt\` for incident correlation
4. **AI Insights:** Review AI analysis files for detailed recommendations

## Quick Commands for Follow-up

\`\`\`bash
# Review top errors
head -20 "$OUTPUT_DIR/error_patterns.txt"

# Check service issues
cat "$OUTPUT_DIR/service_correlations.txt"

# Timeline analysis
head -10 "$OUTPUT_DIR/timeline.txt"
tail -10 "$OUTPUT_DIR/timeline.txt"
\`\`\`

EOF

# Final Summary
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

echo ""
echo "🎉 ANALYSIS COMPLETE!"
echo "============================="
echo "⏱️ Total Duration: ${DURATION} seconds"
echo "📁 Results Location: $OUTPUT_DIR"
echo "📋 Main Report: $OUTPUT_DIR/COMPREHENSIVE_ANALYSIS_REPORT.md"
echo ""
echo "🔍 Quick Summary:"
echo "  Files analyzed: $(wc -l < "$OUTPUT_DIR/file_inventory.csv")"
echo "  Errors found: $error_count"
echo "  Timeline entries: $timeline_count"
echo ""
echo "📖 Next Steps:"
echo "  1. Open: $OUTPUT_DIR/COMPREHENSIVE_ANALYSIS_REPORT.md"
echo "  2. Review: $OUTPUT_DIR/error_patterns.txt"
if command -v fabric >/dev/null 2>&1; then
    echo "  3. Check AI insights: $OUTPUT_DIR/ai_*.md"
fi
echo ""
echo "🚀 Happy analyzing!"
