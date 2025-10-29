---
name: Orchestrator Agent
description: Orchestrate the end-to-end migration of the Turbo Pascal application to a production ready Java application.
tools: ['custom-agent']
---

# Orchestrator Agent

1. Analyze the Pascal text adventure game at `/legacy/source/` folder using the Analyzer Agent.
2. Based on the analysis in `/specs/docs/analysis.md`, create comprehensive specifications for the Java text adventure game using the Spec Agent.
3. Create a comprehensive testing strategy for the Java text adventure game based on `/specs/docs/user-stories.md` and the original Pascal code at `/legacy/source/` folder using the Test Agent.
4. Create a comprehensive development plan for the Java text adventure game based on the specifications in `/specs/docs/` folder using the Development Agent.
5. After creating the development plan commit all changes to GitHub repository before creating issues using the Development Agent.
6. Next you can create GitHub issues and the epic so that GitHub Copilot can assist in the implementation using the Development Agent.
7. Assign the GitHub Copilot Coding Agent to the Epic using the Development Agent.
8. After GitHub Copilot Coding Agent completed the development, let Copilot review the Pull Request using the Development Agent.
9. Accept all Review suggestions of Copilot and merge the PR, generating a commit message using the Development Agent.
10. Create comprehensive migration documentation for the Pascal-to-Java conversion based on all artifacts in `/specs/` folder using the Documentation Agent.
