---
title: Agent Collaboration and Migration Flow
description: This document outlines the simplified agent-based collaboration model for Spec-Driven Development, detailing responsibilities, handovers, and the migration process from Turbo Pascal to Java.
---

# 🧠 Agent-Based Spec-Driven Development Flow

This model uses five specialized agents to manage the migration of a legacy Turbo Pascal application to Java. Each agent owns a distinct phase and collaborates through structured handoffs and shared artifacts.

## 📌 Agent Collaboration Flow

```mermaid
flowchart TD
    A[🧠 Analyzer Agent] --> B[✍️ Spec Agent]
    B --> C[🧪 Test Agent]
    C -->|Path A: IDE Route<br/>04-01| D[🧑‍💻 Developer Agent]
    C -->|Path B: Direct<br/>04-02| F[👨‍💻 GitHub Copilot Coding Agent]
    D -->|GitHub Issues| F
    F --> E[📚 Documentation Agent]
```

## Handoff Points and Artifacts

| Agent | Receives From | Produces | Hands Off To | Communication Format |
|-------|---------------|----------|--------------|---------------------|
| 🧠 Analyzer Agent | Raw Pascal code | analysis.md, code-structure.mmd | ✍️ Spec Agent | Markdown, Mermaid |
| ✍️ Spec Agent | Analyzer Agent | user-stories.md, architecture.md, architecture.mmd | 🧪 Test Agent | Markdown |
| 🧪 Test Agent | Spec Agent | testplan.md, performance-baseline.md, test-data.json | 🧑‍💻 Developer Agent (Path A) OR 👨‍💻 Coding Agent (Path B) | Markdown |
| 🧑‍💻 Developer Agent | Spec Agent, Test Agent | development-plan.md, GitHub Issues & Epics | 👨‍💻 GitHub Copilot Coding Agent | Markdown, GitHub |
| 👨‍💻 GitHub Copilot Coding Agent | Developer Agent (Path A) OR Test Agent (Path B) | Java code, PRs, commits, development-plan.md (Path B) | 📚 Documentation Agent | GitHub Issues & PRs |
| 📚 Documentation Agent | All agents | mapping.md, changelog.md | Everyone | Markdown |

## 📋 Example Prompts

Simple prompts for each agent chatmode to execute the migration workflow. Each file has YAML front matter with the mode and a minimal prompt.

| File | Agent | Purpose |
|------|-------|---------|  
| [`01-analyzer-agent.prompt.md`](../.github/prompts/01-analyzer-agent.prompt.md) | `analyzer-agent` | Analyze Pascal code |
| [`02-spec-agent.prompt.md`](../.github/prompts/02-spec-agent.prompt.md) | `spec-agent` | Create Java specifications |
| [`03-test-agent.prompt.md`](../.github/prompts/03-test-agent.prompt.md) | `test-agent` | Design test strategy |
| [`04-01-developer-agent-IDE.prompt.md`](../.github/prompts/04-01-developer-agent-IDE.prompt.md) | `developer-agent` | Create plan & GitHub Issues (IDE) |
| [`04-02-coding-agent-GH.prompt.md`](../.github/prompts/04-02-coding-agent-GH.prompt.md) | `agent` | Create plan & execute (Agent HQ) |
| [`05-documentation-agent.prompt.md`](../.github/prompts/05-documentation-agent.prompt.md) | `documentation-agent` | Create migration docs |

**Two execution paths after Test Agent:**
- **Path A - IDE Route (04-01)**: Use Developer Agent to create development plan and GitHub Issues, then assign to GitHub Copilot Coding Agent via GitHub Issues (recommended for VS Code)
- **Path B - Direct Route (04-02)**: Skip Developer Agent and use Coding Agent directly to create development plan AND execute implementation (recommended for Agent HQ/direct execution)

### 🚀 Execution Workflow
Execute sequentially for optimal results:

1. **Analyzer Agent** → Analyzes Pascal code structure and logic
2. **Spec Agent** → Creates Java specifications and architecture  
3. **Test Agent** → Designs comprehensive test strategy
4. **Choose your path:**
   - **Path A - IDE Route (04-01)**: 
     - **Developer Agent** → Creates development plan and GitHub Issues
     - **GitHub Copilot Coding Agent** → Implements Java solution from assigned Issues
   - **Path B - Direct Route (04-02)**:
     - **GitHub Copilot Coding Agent** → Creates development plan AND executes implementation
5. **Documentation Agent** → Maintains migration traceability

## 📁 Expected Artifacts

Following this workflow will produce:

```
specs/
├── docs/
│   ├── analysis.md                 # Pascal code analysis
│   ├── user-stories.md            # Functional requirements
│   ├── architecture.md            # Java design specifications
│   ├── performance-baseline.md    # Performance requirements
│   ├── mapping.md                 # Pascal→Java translation guide
│   └── changelog.md               # Migration timeline
├── diagrams/
│   ├── code-structure.mmd         # Pascal code structure
│   └── architecture.mmd           # Java architecture
├── plans/
│   ├── testplan.md                # Testing strategy
│   └── development-plan.md        # Implementation roadmap
└── tests/
    └── test-data.json             # Test scenarios and data
```

## 🎨 Customization

To adapt this workflow for your own Pascal projects:

1. **Replace file paths**: Update `/legacy/source/` with your Pascal file locations
2. **Adjust scope**: Modify analysis focus based on code complexity
3. **Update requirements**: Customize functional and non-functional requirements
4. **Adapt architecture**: Adjust Java architecture for your application needs
5. **Modify test strategy**: Update testing approach for your validation requirements

## 💡 Best Practices

- **Sequential Execution**: Follow the numbered order for optimal results
- **Iterative Refinement**: Use agent outputs to refine subsequent prompts
- **Cross-Reference**: Each agent should review outputs from previous agents
- **Validation**: Ensure each output meets acceptance criteria before proceeding
- **Documentation**: Keep all artifacts for traceability and future reference

## 🔄 Agent Collaboration Details

The workflow creates seamless handoffs between agents, with each building upon previous work to create a comprehensive migration pipeline from legacy Pascal to modern Java.
