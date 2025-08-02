# Fabric AI Workflows

This document outlines various workflows for leveraging Fabric AI within the CloudJourneyBlog project. It covers how to discover available models and patterns, and provides examples of how to use specific AI agent patterns.

## 1. Discovering Models and Patterns

Before utilizing Fabric AI, it's useful to know what models and patterns are available on your self-hosted instance.

### List Available Models

To see all AI models accessible via your Fabric AI instance:

```bash
fabric-ai --listmodels
```

### List Available Patterns

To see all predefined patterns (prompts) that Fabric AI can execute:

```bash
basic-ai --listpatterns
```

## 2. AI Agent Workflows

Fabric AI can be used to power various AI agent workflows, especially for content creation and analysis. These examples demonstrate how to use specific patterns with the `gemini-2.0-flash-exp` model.

### Workflow 1: Content Summarization (General Purpose)

**Note**: As of now, the generic `summarize` pattern in Fabric AI may return meta-responses or unexpected content rather than a direct summary of arbitrary text files. For general content summarization of documents like `buddy-instructions.md`, direct interaction with a large language model (like Gemini) or a custom-designed Fabric AI pattern specifically for document summarization might be more effective.

```bash
# Example of attempting to summarize a document
# Replace /path/to/your/document.md with the actual path
fabric-ai --pattern "summarize" --model "gemini-2.0-flash-exp" "/path/to/your/document.md"
```

### Workflow 2: Publisher Agent (Content Strategy)

Use the Publisher Agent pattern for evaluating blog post drafts and getting content strategy recommendations.

```bash
# Example: Evaluate a blog post draft
# Replace [CONTENT HERE] with the actual content of your draft
fabric-ai --pattern "Publisher Agent" --model "gemini-2.0-flash-exp" "Evaluate this blog post draft: [CONTENT HERE]"
```

### Workflow 3: Researcher Agent (Fact Checking)

Utilize the Researcher Agent pattern for fact-checking claims and gathering research.

```bash
# Example: Research and fact-check a claim
# Replace [TOPIC OR CLAIM HERE] with the actual topic or claim
fabric-ai --pattern "Researcher Agent" --model "gemini-2.0-flash-exp" "Research and fact-check: [TOPIC OR CLAIM HERE]"
```

### Workflow 4: Editor Agent (Content Refinement)

Apply the Editor Agent pattern for linguistic improvements and content refinement.

```bash
# Example: Edit and improve content
# Replace [CONTENT HERE] with the actual content to be refined
fabric-ai --pattern "Editor Agent" --model "gemini-2.0-flash-exp" "Edit and improve this content: [CONTENT HERE]"
```

### Workflow 5: SEO Optimizer Agent

Use the SEO Optimizer Agent pattern to optimize content for search engines.

```bash
# Example: Optimize content for SEO
# Replace [CONTENT HERE] with the actual content to be optimized
fabric-ai --pattern "SEO Optimizer Agent" --model "gemini-2.0-flash-exp" "Optimize for SEO: [CONTENT HERE]"
```

## 3. Troubleshooting Fabric AI

If you encounter unexpected outputs or errors when using Fabric AI patterns, consider the following:

*   **Pattern Specificity**: Fabric AI patterns are highly specialized. Ensure the pattern you are using is designed for the specific type of input and output you expect.
*   **Input Format**: Verify that the input provided to the pattern matches its expected format.
*   **Service Health**: Confirm that the underlying Fabric AI Docker service is running and accessible. A "Bad Gateway" error often indicates a service-level issue.
*   **Model Compatibility**: While `gemini-2.0-flash-exp` is generally versatile, some patterns might perform better with other models.

For more detailed troubleshooting, refer to `projects/buddy-ai/tools/fabric-ai.rohi.life/README.md`.
