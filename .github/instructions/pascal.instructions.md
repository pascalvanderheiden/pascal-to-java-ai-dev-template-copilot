---
description: 'Guidelines for analyzing, understanding, and maintaining Turbo Pascal legacy code'
applyTo: '**/*.pas'
---

# Turbo Pascal Development and Analysis

## Overview

This project involves legacy Turbo Pascal code analysis and migration to modern Java. The focus is on understanding existing code patterns, documenting functionality, and preparing for modernization. The project includes a text adventure game example that demonstrates typical Pascal programming patterns.

## General Instructions

- Prioritize code comprehension and documentation over modification
- Preserve original program logic and behavior during analysis
- Focus on identifying modernization opportunities and technical debt
- Use clear, descriptive comments when documenting Pascal code functionality
- Consider performance implications when suggesting modernization approaches

## Pascal Code Analysis Best Practices

### Code Structure Understanding

- **Program Structure**: Identify main program blocks, procedures, functions, and data structures
- **Dependencies**: Map external unit dependencies and their purposes (e.g., `USES dayio`)
- **Data Flow**: Trace variable usage, parameter passing, and global state management
- **Control Flow**: Document complex conditional logic, loops, and procedure call chains

### Legacy Code Patterns

- **Constants**: Document magic numbers and string constants for migration planning
- **Type Definitions**: Understand custom types, especially arrays and records
- **Global Variables**: Identify shared state that may need refactoring
- **Error Handling**: Note error conditions and validation patterns

### Documentation Standards

- **Function Headers**: Document each procedure/function with:
  - Purpose and functionality
  - Parameter descriptions and constraints
  - Return value meanings
  - Side effects and global state changes
  - Error conditions and handling

```pascal
{****************************************************************
 * Function that validates input parameters for scheduling.
 *  Precondition: StartDay and EndDay are valid DayType values.
 *  Postcondition: Returns true if date range is valid, false otherwise.
 *  Side Effects: None - pure validation function.
 ****************************************************************}
```

- **Complex Logic**: Add inline comments for non-obvious algorithms
- **Data Structures**: Document array indices, string constraints, and type relationships

### Code Quality Assessment

#### Identify Technical Debt

| Pattern | Description | Modernization Opportunity |
|---------|-------------|---------------------------|
| Magic Numbers | Hardcoded values like `8..17` for hours | Extract to named constants or enums |
| String Length Limits | `string[EmployeeMaxLen]` | Use dynamic strings or validation |
| Global State | Shared variables between procedures | Encapsulate in classes/objects |
| Mixed Responsibilities | UI, logic, and data mixed in procedures | Separate concerns with layers |
| Manual Memory Management | Static arrays and fixed sizes | Use collections and dynamic allocation |

#### Performance Considerations

- **O(n²) Operations**: Nested loops that could be optimized
- **String Concatenation**: Multiple string building operations
- **File I/O**: Unbuffered or inefficient file operations
- **Memory Usage**: Large static arrays or excessive copying

### Migration Planning

#### Data Structure Mapping

```pascal
(* Pascal Type *)
EmployeeType = string[EmployeeMaxLen];
ScheduleType = ARRAY [HourType, DayType] OF EmployeeType;

(* Java Equivalent Planning *)
// String (with validation)
// Map<LocalTime, Map<DayOfWeek, String>> or custom Schedule class
```

#### Procedure to Method Conversion

- **Identify State Dependencies**: Which procedures need access to what data
- **Parameter Analysis**: Understand VAR vs value parameters for reference handling
- **Return Value Patterns**: How procedures communicate results and errors

#### Modern Equivalents

| Pascal Feature | Java/Modern Equivalent |
|----------------|------------------------|
| `CONST` blocks | `public static final` constants or enums |
| `TYPE` definitions | Classes, enums, or type aliases |
| `VAR` parameters | Method parameters, return objects |
| `ARRAY` types | Collections (List, Map, Set) |
| String handling | String class with proper escaping |
| File I/O | Stream APIs with try-with-resources |

## Code Analysis Workflow

### Phase 1: Initial Assessment
1. **Program Structure**: Map all procedures, functions, and data types
2. **Dependency Analysis**: Identify external units and their roles
3. **Data Flow Mapping**: Trace how data moves through the system
4. **UI/Logic Separation**: Identify mixed concerns for refactoring

### Phase 2: Detailed Documentation
1. **Algorithm Documentation**: Explain complex business logic
2. **Edge Case Identification**: Find error conditions and validations
3. **Performance Bottlenecks**: Identify inefficient operations
4. **Security Concerns**: Note input validation and data handling issues

### Phase 3: Migration Preparation
1. **Modern Architecture Design**: Plan object-oriented structure
2. **Test Case Extraction**: Identify testable behaviors and edge cases
3. **API Design**: Plan modern interfaces for existing functionality
4. **Migration Strategy**: Define incremental conversion approach

## Pascal-Specific Guidelines

### Syntax Understanding

- **Case Sensitivity**: Pascal is case-insensitive, Java is case-sensitive
- **Block Structure**: `BEGIN`/`END` vs. `{}`
- **Variable Declarations**: `VAR` sections vs. inline declarations
- **String Indexing**: 1-based in Pascal vs. 0-based in Java

### Common Patterns

- **Input Validation**: Look for manual parsing and validation logic
- **Error Reporting**: User-friendly error messages and recovery
- **State Management**: How the program maintains and updates state
- **Command Processing**: Menu-driven or command-line interface patterns

### Legacy Compatibility

- **Preserve Behavior**: Maintain exact same user-visible behavior
- **Data Format Compatibility**: Ensure file formats remain compatible
- **Performance Characteristics**: Don't introduce regressions
- **Error Handling**: Maintain same error conditions and messages

## Testing Legacy Code

### Black Box Testing
- **Input/Output Validation**: Test all command variations
- **Boundary Conditions**: Test edge cases and limits
- **Error Conditions**: Verify error handling and recovery
- **Performance Baselines**: Establish current performance metrics

### Behavioral Documentation
- **Use Case Scenarios**: Document typical user workflows
- **State Transitions**: Map how data changes through operations
- **Integration Points**: Identify external dependencies and interfaces

## Migration Best Practices

### Incremental Approach
1. **Start with Data Models**: Convert types and structures first
2. **Pure Functions**: Migrate calculation and validation logic
3. **Business Logic**: Convert core algorithms and rules
4. **UI/Interface**: Modernize user interaction last

### Quality Assurance
- **Behavior Preservation**: Ensure identical functionality
- **Performance Monitoring**: Track and improve performance
- **Security Hardening**: Add modern security practices
- **Error Handling**: Improve error reporting and recovery

### Documentation Output
- **Architecture Diagrams**: Mermaid diagrams of system structure
- **API Specifications**: Modern interface definitions
- **Migration Mapping**: Pascal-to-Java conversion guide
- **Test Cases**: Comprehensive test scenarios for validation