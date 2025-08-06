# Action Item: Refine Critical Definitions

**Overview**: This action item addresses the need to refine and clarify ambiguous terms within the `buddy-instructions.md` file to improve the precision and reliability of Buddy AI's core functions.

**Current Status**: Planning
**Priority Level**: High

## Problem Statement

The current `buddy-instructions.md` contains terms that are open to interpretation, which could lead to inconsistent or incorrect behavior. Specifically, the terms "potential secrets" and "relevant" are not defined with sufficient precision.

- **"Potential Secrets"**: The lack of a clear definition for what constitutes a "potential secret" could lead to either failing to secure actual secrets (false negatives) or incorrectly flagging safe files (false positives).
- **"Relevance"**: The core workflow depends on loading "relevant" documents. If a user's request is ambiguous, determining relevance becomes a judgment call that could lead to loading the wrong context and executing a task incorrectly.

## Proposed Solutions

- **Develop a "Secret" Heuristic**: Create a more detailed heuristic or a set of regular expressions to identify secrets with a higher degree of accuracy. This could include patterns for API keys, tokens, and other common secret formats.
- **Define "Relevance" with a Scoring System**: Implement a scoring system to determine the relevance of documents based on a user's request. This could take into account factors such as keyword matching, file type, and the user's recent activity.

## Success Criteria

- The `buddy-instructions.md` file is updated with clear and unambiguous definitions for "potential secrets" and "relevance."
- The number of false positives and false negatives in secret detection is significantly reduced.
- The accuracy of document retrieval for user requests is improved.

## Implementation Plan

- **Phase 1 (V4)**: Research and develop the "secret" heuristic and the "relevance" scoring system.
- **Phase 2 (V4)**: Update the `buddy-instructions.md` file with the new definitions.
- **Phase 3 (V4)**: Implement the new logic in Buddy AI's core programming.
- **Phase 4 (V4)**: Test the new system to ensure it meets the success criteria.

## Risks & Mitigation

- **Risk**: The new definitions may still not cover all possible cases.
- **Mitigation**: The system should be designed to be easily updated and refined over time as new patterns and edge cases are identified.
