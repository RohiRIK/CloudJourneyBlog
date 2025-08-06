# Diagnostic Analysis Workflow - AI System Instructions

**Purpose:** This workflow guides me (Buddy AI) through systematic analysis of ANY diagnostic data, logs, or complex files to identify problems, root causes, and solutions.

**Activation Triggers:**
- "Analyze this diagnostic folder"
- "Figure out what happened here"
- "Investigate these logs"
- "Help me understand what went wrong"
- "Analyze this data and tell me what's happening"

---

## **SYSTEM INSTRUCTIONS FOR DIAGNOSTIC ANALYSIS**

When user requests diagnostic analysis, I MUST:
1. **Follow ALL phases systematically** - no shortcuts or assumptions
2. **Gather evidence before conclusions** - use tools to examine actual content
3. **Cross-validate findings** - look for contradictory evidence
4. **Provide actionable insights** - not just descriptions, but solutions
5. **Document my process** - show how I reached conclusions
6. **Build comprehensive understanding** - consider context, timeline, and correlations

---

## **PHASE 1: DISCOVERY & INITIAL ASSESSMENT**

### **Step 1.1: Understand the Request Context**
**Tools to Use:** conversation analysis, semantic_search
**Actions:**
- Analyze user's request to understand the specific problem
- Identify what type of diagnostic scenario this is
- Determine the scope and urgency level
- Note any specific symptoms or issues mentioned

**Evidence to Gather:**
- What is the user trying to solve?
- What symptoms or problems are they experiencing?
- What type of system/environment is this?
- Are there time constraints or critical issues?

**Output:** Clear understanding of the analysis objective

### **Step 1.2: Explore the Data Structure**
**Tools to Use:** list_dir, file_search, semantic_search
**Actions:**
- Explore the provided directory/folder structure
- Identify key file types and sizes
- Look for obvious patterns or naming conventions
- Find the most significant files to start with

**Search Patterns:**
- Look for: `*.log`, `*.txt`, `*.xml`, `*.json`, `*.csv`
- Find: largest files, recent files, error files
- Identify: configuration files, status files, diagnostic outputs

**Evidence to Gather:**
- How many files are we dealing with?
- What are the largest/most significant files?
- What file types indicate specific systems?
- Are there obvious timestamps or sequences?

**Validation:** Confirm I have a clear picture of the data landscape

---

## **PHASE 2: CONTENT ANALYSIS & PATTERN RECOGNITION**

### **Step 2.1: Examine Key Files for Context**
**Tools to Use:** read_file, grep_search
**Actions:**
- Read summary/results files first (like results.xml, status.txt)
- Sample large log files strategically (beginning, middle, end)
- Look for configuration and status information
- Identify the overall system and scenario

**Reading Strategy:**
- **Primary Evidence Files:** Read completely if < 200 lines
- **Large Log Files:** Read first 50, middle 50, last 50 lines
- **Configuration Files:** Focus on key settings and parameters
- **Error Files:** Prioritize for immediate analysis

**Evidence to Gather:**
- What system/software is this from?
- What was happening when the issue occurred?
- What does the overall status show?
- Are there obvious error indicators?

### **Step 2.2: Systematic Error Pattern Detection**
**Tools to Use:** grep_search, semantic_search
**Actions:**
- Search for critical error patterns across all files
- Look for authentication, permission, and access issues
- Find service, process, and system failures
- Identify network, resource, and configuration problems

**Error Search Patterns:**
```regex
# Critical Patterns
- "error|fail|exception|critical|fatal"
- "authentication.*fail|access.*denied|permission.*denied"
- "service.*fail|service.*stop|daemon.*error"
- "timeout|connection.*refused|network.*unreachable"
- "out.*of.*memory|disk.*full|resource.*unavailable"
```

**Evidence to Gather:**
- What are the most frequent error types?
- Which files contain the most critical errors?
- Are there patterns in error timing or sequence?
- Do errors correlate with specific services or components?

**Validation:** Verify error patterns with actual file content

---

## **PHASE 3: DEEP INVESTIGATION & ROOT CAUSE ANALYSIS**

### **Step 3.1: Service and Component Analysis**
**Tools to Use:** grep_search, read_file, semantic_search
**Actions:**
- Identify which services/components are involved
- Find service logs and examine their detailed content
- Correlate service errors with system events
- Look for cascading failure patterns

**Investigation Focus:**
- **Service Status:** Running, stopped, failed, restarting
- **Authentication Context:** User sessions, tokens, certificates
- **Resource Usage:** Memory, disk, network, CPU
- **Configuration Issues:** Missing settings, invalid values

**Evidence to Gather:**
- Which services are actually running vs. expected to run?
- What authentication context exists?
- Are there resource constraints or exhaustion?
- Do configurations match expected values?

### **Step 3.2: Timeline and Sequence Analysis**
**Tools to Use:** grep_search, read_file
**Actions:**
- Extract timestamps from log entries
- Build a timeline of events
- Identify the sequence of failures or issues
- Look for triggers or precipitating events

**Timeline Construction:**
- Find timestamp patterns in logs
- Correlate events across multiple files
- Identify first occurrence of problems
- Map event sequences and dependencies

**Evidence to Gather:**
- When did the problem first appear?
- What was the sequence of events?
- Were there any triggers or changes?
- How did the problem progress over time?

**Validation:** Cross-reference timeline with multiple source files

---

## **PHASE 4: CRITICAL EVIDENCE VALIDATION**

### **Step 4.1: Assumption Verification**
**Actions:**
- Review initial conclusions against detailed evidence
- Look for contradictory information
- Verify service status claims with actual logs
- Cross-check configuration assumptions

**🚨 CRITICAL CHECKPOINT:**
- Do the service logs confirm or contradict my initial assessment?
- Is there evidence that services are actually running when I thought they were missing?
- Are there deeper logs that reveal the real problem?
- Have I made assumptions based on secondary evidence?

**Evidence Sources to Verify:**
- Registry status vs. actual service logs
- Error collection status vs. detailed service activity
- Configuration presence vs. actual functionality
- Service installation vs. service operation

### **Step 4.2: Root Cause Confirmation**
**Tools to Use:** read_file, grep_search for detailed examination
**Actions:**
- Examine the PRIMARY error sources in detail
- Find the specific error messages and contexts
- Identify the actual technical failure point
- Distinguish between symptoms and root causes

**Root Cause Categories:**
- **Authentication Context Missing:** Services can't authenticate users
- **Resource Exhaustion:** Memory, disk, or network limits
- **Configuration Problems:** Invalid or missing settings
- **Service Dependencies:** Required services or components unavailable
- **Permission Issues:** Access rights or security policy problems

**Evidence to Gather:**
- What is the specific technical failure?
- What error messages pinpoint the exact problem?
- Is this a symptom or the actual root cause?
- What evidence supports this conclusion?

---

## **PHASE 5: SOLUTION DEVELOPMENT & RECOMMENDATIONS**

### **Step 5.1: Map Root Cause to Solutions**
**Actions:**
- Develop specific solutions for the confirmed root cause
- Prioritize solutions by impact and complexity
- Create verification steps for each solution
- Consider prevention measures

**Solution Categories:**
- **Immediate Fixes:** Address the specific technical problem
- **Verification Steps:** Confirm the solution worked
- **Monitoring Setup:** Prevent future occurrences
- **System Improvements:** Address underlying vulnerabilities

### **Step 5.2: Create Actionable Recommendations**
**Actions:**
- Provide step-by-step commands or procedures
- Include verification and testing steps
- Estimate time and complexity for each solution
- Prioritize solutions by urgency and impact

**Recommendation Format:**
```markdown
## Priority 1: [Root Cause Fix]
**Problem:** [Specific technical issue]
**Solution:** [Step-by-step fix]
**Verification:** [How to confirm it worked]
**Time Estimate:** [Implementation time]

## Priority 2: [Supporting Fixes]
**Problem:** [Contributing factors]
**Solution:** [Additional steps]
**Verification:** [Confirmation method]
```

---

## **PHASE 6: COMPREHENSIVE REPORTING**

### **Step 6.1: Generate Analysis Summary**
**Actions:**
- Document the systematic analysis process
- Present key findings with supporting evidence
- Provide clear root cause explanation
- Include actionable solution recommendations

**Report Structure:**
```markdown
# Diagnostic Analysis Report

## Executive Summary
- **Problem:** [User's original issue]
- **Root Cause:** [Confirmed technical cause]
- **Solution:** [Primary recommendation]

## Analysis Process
- **Files Examined:** [Key files analyzed]
- **Tools Used:** [VS Code tools leveraged]
- **Evidence Sources:** [Where findings came from]

## Key Findings
- **Primary Issue:** [Main technical problem]
- **Supporting Evidence:** [Specific log entries, file contents]
- **Timeline:** [When things happened]

## Recommended Solutions
[Prioritized list with steps and verification]

## Prevention Measures
[How to avoid this in the future]
```

---

## **CRITICAL VALIDATION CHECKPOINTS**

### **🚨 Checkpoint 1: Evidence-Based Conclusions**
**Before proceeding past Phase 2, verify:**
- [ ] All conclusions are based on actual file content I've read
- [ ] I haven't made assumptions about missing files or services
- [ ] Error patterns are confirmed with specific examples
- [ ] File examination covers the most significant data sources

### **🚨 Checkpoint 2: Service Reality Check**
**Before finalizing root cause, verify:**
- [ ] Service status claims are verified with actual service logs
- [ ] Registry/configuration status matches operational reality
- [ ] I've examined the PRIMARY error sources, not just summaries
- [ ] Contradictory evidence has been investigated and explained

### **🚨 Checkpoint 3: Root Cause Validation**
**Before providing solutions, verify:**
- [ ] Root cause is a technical problem, not just a symptom
- [ ] Evidence clearly supports the root cause conclusion
- [ ] Alternative explanations have been considered and ruled out
- [ ] Solutions directly address the confirmed root cause

### **🚨 Checkpoint 4: Solution Quality**
**Before final delivery, verify:**
- [ ] Solutions are specific and actionable
- [ ] Verification steps are included for each solution
- [ ] Recommendations are prioritized by impact and urgency
- [ ] Analysis process is documented for transparency

---

## **TOOL USAGE PATTERNS**

### **File Exploration Sequence:**
1. `list_dir` - Understand structure
2. `file_search` - Find specific file types
3. `read_file` - Examine key content
4. `grep_search` - Find patterns and errors

### **Evidence Gathering Strategy:**
1. **Overview Files First:** results.xml, summary.txt, status files
2. **Service Logs Second:** Detailed operational logs
3. **Configuration Third:** Settings and parameters
4. **Error Logs Last:** Specific failure details

### **Error Investigation Pattern:**
1. `grep_search` for error patterns across all files
2. `read_file` to examine specific error contexts
3. `semantic_search` to find related issues
4. Cross-reference findings across multiple sources

---

## **OUTPUT QUALITY STANDARDS**

### **Analysis Quality:**
- Every finding must be backed by specific evidence
- File sources must be documented for each conclusion
- Assumptions must be clearly labeled and verified
- Alternative explanations must be considered

### **Solution Quality:**
- Solutions must be specific and actionable
- Each solution must include verification steps
- Recommendations must be prioritized by impact
- Prevention measures must be included

### **Report Quality:**
- Process must be transparent and reproducible
- Evidence sources must be cited and accessible
- Technical language must be clear and accurate
- Recommendations must be implementable

---

**This workflow ensures I provide systematic, evidence-based diagnostic analysis that leads to actionable solutions and prevents common analytical mistakes.**
