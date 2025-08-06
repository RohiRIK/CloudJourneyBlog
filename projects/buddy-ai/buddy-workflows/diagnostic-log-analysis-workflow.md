# Diagnostic Log Analysis Workflow

**Purpose:** Systematic workflow for analyzing diagnostic logs to identify root causes and create comprehensive troubleshooting documentation.

**Use Cases:** 
- Intune device management issues
- Windows authentication problems
- Service/application failures
- Any complex technical problem requiring log analysis

---

## **Phase 1: Initial Assessment & Document Creation**

### **Step 1.1: Understand the Problem**
```bash
# Document the problem statement
echo "Problem: [Describe user-reported issue]" > analysis_notes.md
echo "Device/System: [Identify affected system]" >> analysis_notes.md
echo "Date: $(date)" >> analysis_notes.md
```

### **Step 1.2: Examine Available Data**
```bash
# List all available diagnostic files/folders
find . -type f -name "*.log" -o -name "*.xml" -o -name "*.reg" -o -name "*.txt" | head -20
find . -type d | grep -i "log\|diag\|debug" | head -10
```

### **Step 1.3: Create Initial Analysis Document**
```markdown
# [Problem Type] - Root Cause Analysis

**Analysis Date:** [Current Date]
**System:** [Affected System]
**Diagnostic Collection:** [Collection Name/ID]

## 1. Problem Summary
[Initial problem description]

## 2. Potential Root Causes
[To be filled during analysis]

## 3. Recommended Solutions
[To be filled after root cause identification]
```

---

## **Phase 2: High-Level Data Discovery**

### **Step 2.1: Search for Primary Evidence Files**
```bash
# Look for key configuration/status files
find . -name "results.xml" -o -name "status.txt" -o -name "dsregcmd*" -o -name "summary*"

# Search for error patterns across all files
grep -r -i "error\|fail\|exception\|critical" . | head -20
grep -r -i "authentication\|token\|certificate" . | head -10
```

### **Step 2.2: Identify Service/Component Status**
```bash
# Look for service-related information
find . -name "*service*" -o -name "*daemon*" -o -name "*agent*"
grep -r -i "service.*running\|service.*stopped\|service.*failed" .
```

### **Step 2.3: Document Initial Findings**
```markdown
## Initial Discovery Results:
- Primary evidence files found: [list key files]
- Error patterns detected: [summarize error types]
- Service status indicators: [note service states]
```

---

## **Phase 3: Detailed Evidence Analysis**

### **Step 3.1: Analyze Primary Status Files**
```bash
# Read main status/results files
head -50 ./results.xml  # or primary status file
tail -50 ./results.xml

# Extract key status indicators
grep -i "status\|state\|result" ./results.xml
```

### **Step 3.2: Registry/Configuration Analysis**
```bash
# Find registry exports or config files
find . -name "*.reg" | head -10
find . -name "*.ini" -o -name "*.conf" -o -name "*.cfg"

# Look for missing components (error indicators)
grep -r "0x80070001\|Error.*Result\|No Results" .
```

### **Step 3.3: Create Preliminary Root Cause Assessment**
```markdown
## Preliminary Root Cause Analysis:
### Critical Issues Found:
- [List confirmed problems with evidence]

### Secondary Issues:
- [List contributing factors]

### Evidence Sources:
- [Document where each finding came from]
```

---

## **Phase 4: Deep Dive - Service Log Analysis**

### **Step 4.1: Locate Service Logs**
```bash
# Find actual service log directories
find . -type d -name "*logs*" -o -name "*log*" | grep -i service
ls -la ./*logs*/

# Identify primary service logs
find . -name "*.log" | xargs wc -l | sort -nr | head -10
```

### **Step 4.2: Analyze Main Service Logs**
```bash
# Read service logs for patterns
head -100 ./path/to/main_service.log
tail -100 ./path/to/main_service.log

# Search for critical errors
grep -i "exception\|error\|fail\|null" ./path/to/main_service.log
grep -i "authentication\|user.*context\|session" ./path/to/main_service.log
```

### **Step 4.3: Cross-Reference Findings**
```bash
# Compare initial assessment with actual service logs
# Look for contradictions in your initial analysis
grep -i "service.*running\|initialized\|started" ./path/to/service.log
```

**🚨 CRITICAL CHECKPOINT:** 
- Does the service log evidence contradict your initial assessment?
- If yes, you must revise your root cause analysis!

---

## **Phase 5: Root Cause Validation & Correction**

### **Step 5.1: Validate Initial Assessment**
```markdown
## Root Cause Validation Checklist:
- [ ] Does service log evidence support initial findings?
- [ ] Are there contradictory pieces of evidence?
- [ ] What does the PRIMARY error source actually show?
- [ ] Is the service/component actually missing or just failing?
```

### **Step 5.2: Correct Analysis if Needed**
```bash
# If initial assessment was wrong, document the correction
echo "## Analysis Correction Required" >> analysis_notes.md
echo "Initial Assessment: [Wrong conclusion]" >> analysis_notes.md
echo "Actual Finding: [Correct conclusion from logs]" >> analysis_notes.md
echo "Evidence Source: [Specific log file and lines]" >> analysis_notes.md
```

### **Step 5.3: Identify TRUE Root Cause**
```markdown
## Confirmed Root Cause:
**Primary Issue:** [The actual technical problem]
**Evidence:** [Specific log entries, error messages, file contents]
**Impact:** [Why this causes the user-visible problem]
```

---

## **Phase 6: Solution Development**

### **Step 6.1: Map Root Cause to Solutions**
```markdown
## Solution Mapping:
**Root Cause:** [Confirmed technical issue]
**Primary Solutions:** [Direct fixes for the root cause]
**Secondary Solutions:** [Supporting fixes and workarounds]
**Verification Steps:** [How to confirm the fix worked]
```

### **Step 6.2: Prioritize Solutions**
```markdown
## Solution Priority:
1. **🔴 Critical (Fix root cause directly)**
2. **🟡 Secondary (Supporting fixes)**
3. **🟢 Prevention (Avoid recurrence)**
```

### **Step 6.3: Create Step-by-Step Procedures**
```powershell
# For each solution, provide exact commands
# Solution 1: [Description]
# Step 1: [Command/Action]
# Step 2: [Command/Action]
# Verification: [How to check if it worked]
```

---

## **Phase 7: Documentation & Knowledge Capture**

### **Step 7.1: Create Final Analysis Document**
```markdown
# [Problem Type] - Root Cause Analysis

## 1. Problem Summary
[Clear description of the issue and impact]

## 2. Root Cause Analysis
[Confirmed root cause with evidence]

## 3. Solutions (In Priority Order)
[Step-by-step solutions with commands]

## 4. Verification Procedures
[How to confirm resolution]

## 5. Prevention Recommendations
[How to avoid this in the future]

## 6. Technical Evidence
[Key findings from log analysis with sources]
```

### **Step 7.2: Create Reusable Commands**
```bash
# Save useful commands for future similar issues
echo "# Useful commands for [Problem Type]" > useful_commands.sh
echo "find . -name '*.log' | xargs grep -l 'error pattern'" >> useful_commands.sh
echo "grep -i 'specific error pattern' ./path/to/logs/" >> useful_commands.sh
```

---

## **Phase 8: Quality Assurance**

### **Step 8.1: Evidence Verification Checklist**
```markdown
## QA Checklist:
- [ ] All claims in analysis are backed by specific evidence
- [ ] Log file sources are documented for each finding
- [ ] Solutions directly address the confirmed root cause
- [ ] No contradictory evidence was ignored
- [ ] Analysis was corrected if initial assessment was wrong
```

### **Step 8.2: Peer Review Questions**
```markdown
## Self-Review Questions:
1. If someone challenges my findings, can I show them the exact evidence?
2. Do my solutions fix the actual problem or just symptoms?
3. Would this analysis help someone else solve a similar problem?
4. Did I document my mistakes and corrections clearly?
```

---

## **Common Pitfalls to Avoid**

### **❌ Analysis Mistakes:**
1. **Assuming based on limited evidence** - Always check service logs
2. **Not validating initial findings** - Cross-reference multiple sources
3. **Ignoring contradictory evidence** - If logs contradict registry status, investigate deeper
4. **Focusing on symptoms vs root cause** - Find WHY the problem occurs

### **✅ Best Practices:**
1. **Question your own findings** - Look for evidence that contradicts your theory
2. **Document your thought process** - Show how you reached conclusions
3. **Prioritize primary evidence** - Service logs > registry status > secondary indicators
4. **Validate solutions** - Ensure fixes address root cause, not just symptoms

---

## **Templates & Examples**

### **Quick Commands Template:**
```bash
# Problem: [Brief description]
# System: [Affected system]

# Phase 1: Discovery
find . -name "*.log" -o -name "*.xml" | head -10
grep -r -i "error\|fail" . | head -5

# Phase 2: Service Analysis
find . -type d -name "*logs*"
ls -la ./*logs*/
head -50 ./main_service.log

# Phase 3: Root Cause Search
grep -i "exception\|nullreference\|authentication" ./service.log
grep -i "user.*context\|session.*count" ./service.log

# Phase 4: Evidence Documentation
echo "Root Cause: [Finding]" >> analysis.md
echo "Evidence: [Log file, line numbers]" >> analysis.md
```

### **Analysis Document Template:**
```markdown
# [System] [Problem Type] - Root Cause Analysis

**Date:** [Current Date]
**System:** [Affected System]  
**Collection:** [Diagnostic Collection ID]

## Problem Summary
[User-reported issue and impact]

## Root Cause Analysis
**Confirmed Root Cause:** [Technical issue]
**Evidence:** [Specific log entries with file/line references]

## Solutions (Priority Order)
### 🔴 Primary Solutions
1. [Solution that directly fixes root cause]

### 🟡 Secondary Solutions  
2. [Supporting fixes]

## Verification Steps
[How to confirm resolution]

## Technical Evidence
[Detailed findings with sources]
```

---

**This workflow transforms any complex diagnostic analysis into a systematic, repeatable process that avoids common mistakes and ensures thorough root cause identification.**
