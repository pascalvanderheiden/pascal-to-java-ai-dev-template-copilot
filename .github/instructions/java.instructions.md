---
description: 'Guidelines for building modern Java applications'
applyTo: '**/*.java'
---

# Java Development for Pascal Migration

## Overview

This project involves migrating legacy applications to modern Java. Focus on creating maintainable, testable, and performant Java code that preserves the original functionality while embracing modern practices.

## General Instructions

- Prioritize behavior preservation during migration
- Write comprehensive tests to validate functionality against legacy system
- Focus on clean, maintainable code that improves upon the original
- Use modern Java features (Java 17+) while maintaining readability
- Document migration decisions and architectural changes

## Java Version and Features

- **Target Version**: Java 17+ (LTS)
- **Modern Features**: Records, pattern matching, switch expressions, text blocks
- **Collections**: Use modern Collection APIs and Stream processing
- **Optional**: Prefer `Optional<T>` over null for optional values
- **Time API**: Use `java.time` for date/time operations

## Migration-Specific Best Practices

### Data Structure Migration

#### From Pascal Arrays to Java Collections

```java
// Pascal: ARRAY [HourType, DayType] OF EmployeeType
// Java: Modern approach with proper encapsulation

public class Schedule {
    private final Map<LocalTime, Map<DayOfWeek, String>> schedule;
    
    public Optional<String> getEmployee(LocalTime hour, DayOfWeek day) {
        return Optional.ofNullable(schedule.get(hour))
                      .map(dayMap -> dayMap.get(day));
    }
}
```

#### Type Safety and Validation

```java
// Pascal: EmployeeType = string[EmployeeMaxLen]
// Java: Proper validation and constraints

public record Employee(String name) {
    public Employee {
        Objects.requireNonNull(name, "Employee name cannot be null");
        if (name.isBlank()) {
            throw new IllegalArgumentException("Employee name cannot be blank");
        }
        if (name.length() > 8) {
            throw new IllegalArgumentException("Employee name too long: " + name.length());
        }
    }
}
```

### Error Handling Migration

#### From Pascal Error Flags to Java Exceptions

```java
// Pascal: VAR Error: boolean parameter
// Java: Use exceptions for exceptional conditions

public void scheduleEmployee(Employee employee, LocalTime startHour, 
                           LocalTime endHour, DayOfWeek startDay, DayOfWeek endDay) 
                           throws ScheduleConflictException, InvalidTimeRangeException {
    validateTimeRange(startHour, endHour);
    
    if (!isScheduleLegal(startHour, endHour, startDay, endDay)) {
        throw new ScheduleConflictException(
            "Conflicts with existing schedule for time range");
    }
    
    // Proceed with scheduling
}
```

### Business Logic Preservation

#### Command Pattern for Operations

```java
// Pascal: Main loop with IF/ELSE command processing
// Java: Command pattern for extensibility

public interface ScheduleCommand {
    void execute(Schedule schedule, String[] args) throws CommandException;
    String getCommandName();
    String getUsage();
}

public class ScheduleProcessor {
    private final Map<String, ScheduleCommand> commands;
    
    public void processCommand(String commandLine) {
        String[] parts = parseCommand(commandLine);
        String commandName = parts[0];
        
        ScheduleCommand command = commands.get(commandName);
        if (command == null) {
            throw new UnknownCommandException("Command not recognized: " + commandName);
        }
        
        command.execute(schedule, Arrays.copyOfRange(parts, 1, parts.length));
    }
}
```

## Modern Java Patterns

### Builder Pattern for Complex Objects

```java
public class ScheduleEntry {
    private final Employee employee;
    private final LocalTime startTime;
    private final LocalTime endTime;
    private final Set<DayOfWeek> days;
    
    public static class Builder {
        // Builder implementation
    }
}
```

### Repository Pattern for Data Access

```java
public interface ScheduleRepository {
    void save(Schedule schedule);
    Optional<Schedule> findById(String id);
    List<ScheduleEntry> findByEmployee(Employee employee);
    List<ScheduleEntry> findByTimeRange(LocalTime start, LocalTime end);
}
```

### Service Layer for Business Logic

```java
@Service
public class SchedulingService {
    private final ScheduleRepository repository;
    private final ScheduleValidator validator;
    
    public SchedulingService(ScheduleRepository repository, ScheduleValidator validator) {
        this.repository = Objects.requireNonNull(repository);
        this.validator = Objects.requireNonNull(validator);
    }
    
    @Transactional
    public void scheduleEmployee(ScheduleRequest request) throws SchedulingException {
        validator.validate(request);
        
        Schedule schedule = repository.findById(request.scheduleId())
            .orElseThrow(() -> new ScheduleNotFoundException(request.scheduleId()));
            
        schedule.addEmployee(request.employee(), request.timeSlot());
        repository.save(schedule);
    }
}
```

## Testing Strategy

### Unit Testing with JUnit 5

```java
@ExtendWith(MockitoExtension.class)
class SchedulingServiceTest {
    
    @Mock
    private ScheduleRepository repository;
    
    @Mock
    private ScheduleValidator validator;
    
    @InjectMocks
    private SchedulingService service;
    
    @Test
    @DisplayName("Should schedule employee when no conflicts exist")
    void shouldScheduleEmployeeWhenNoConflicts() {
        // Arrange
        var request = new ScheduleRequest("schedule-1", 
                                        new Employee("John"),
                                        new TimeSlot(LocalTime.of(9, 0), LocalTime.of(17, 0)));
        var schedule = new Schedule("schedule-1");
        
        when(repository.findById("schedule-1")).thenReturn(Optional.of(schedule));
        doNothing().when(validator).validate(request);
        
        // Act & Assert
        assertDoesNotThrow(() -> service.scheduleEmployee(request));
        verify(repository).save(schedule);
    }
    
    @Test
    @DisplayName("Should throw exception when schedule conflicts exist")
    void shouldThrowExceptionWhenScheduleConflicts() {
        // Test implementation
    }
}
```

### Integration Testing

```java
@SpringBootTest
@TestPropertySource(properties = {
    "spring.datasource.url=jdbc:h2:mem:testdb",
    "spring.jpa.hibernate.ddl-auto=create-drop"
})
class SchedulingIntegrationTest {
    
    @Autowired
    private SchedulingService service;
    
    @Test
    @DisplayName("Should preserve Pascal application behavior")
    void shouldPreservePascalBehavior() {
        // Test scenarios that match Pascal program behavior
    }
}
```

### Property-Based Testing for Migration Validation

```java
@Property
void schedulingOperationsShouldBeIdempotent(@ForAll ScheduleRequest request) {
    // Property-based test to ensure operations behave consistently
}
```

## Code Quality Standards

### Naming Conventions

- **Classes**: `PascalCase` - `ScheduleManager`, `EmployeeService`
- **Methods**: `camelCase` - `scheduleEmployee()`, `validateTimeRange()`
- **Constants**: `UPPER_SNAKE_CASE` - `MAX_EMPLOYEE_NAME_LENGTH`
- **Packages**: `lowercase.separated` - `com.company.scheduling.service`

### Documentation Standards

```java
/**
 * Manages employee scheduling operations.
 * 
 * <p>This class provides methods to schedule, unschedule, and query
 * employee work assignments. It maintains business rules about scheduling
 * conflicts and validates all operations.
 * 
 * <p><strong>Migration Note:</strong> This class replaces the Pascal 
 * procedures DoSched, DoUnsched, and related functionality while adding
 * proper error handling and validation.
 * 
 * @author Migration Team
 * @since 1.0
 * @see Schedule
 * @see Employee
 */
@Service
public class ScheduleManager {
    
    /**
     * Schedules an employee for the specified time period.
     * 
     * @param employee the employee to schedule (must not be null)
     * @param timeSlot the time period for scheduling (must not be null)
     * @param days the days of the week (must not be empty)
     * @throws ScheduleConflictException if the time slot conflicts with existing schedules
     * @throws IllegalArgumentException if any parameter is invalid
     */
    public void scheduleEmployee(Employee employee, TimeSlot timeSlot, Set<DayOfWeek> days) {
        // Implementation
    }
}
```

### Error Handling

```java
// Custom exceptions for business logic
public class SchedulingException extends Exception {
    public SchedulingException(String message) {
        super(message);
    }
    
    public SchedulingException(String message, Throwable cause) {
        super(message, cause);
    }
}

public class ScheduleConflictException extends SchedulingException {
    private final List<ScheduleEntry> conflictingEntries;
    
    public ScheduleConflictException(String message, List<ScheduleEntry> conflicts) {
        super(message);
        this.conflictingEntries = List.copyOf(conflicts);
    }
    
    public List<ScheduleEntry> getConflictingEntries() {
        return conflictingEntries;
    }
}
```

## Performance Considerations

### Efficient Collections Usage

```java
// Use appropriate collection types
public class Schedule {
    // For frequent lookups
    private final Map<TimeSlot, Employee> assignments = new HashMap<>();
    
    // For ordered iteration
    private final SortedSet<TimeSlot> timeSlots = new TreeSet<>();
    
    // For fast employee lookups
    private final Map<Employee, Set<TimeSlot>> employeeSchedules = new HashMap<>();
}
```

### Lazy Loading and Caching

```java
@Service
public class ScheduleService {
    private final LoadingCache<String, Schedule> scheduleCache = 
        Caffeine.newBuilder()
                .maximumSize(100)
                .expireAfterAccess(Duration.ofMinutes(30))
                .build(this::loadSchedule);
}
```

## Migration Validation

### Behavior Comparison Tests

```java
@Test
@DisplayName("Java implementation should match Pascal behavior")
void shouldMatchPascalBehavior() {
    // Test cases that verify exact behavioral compatibility
    var javaResult = javaScheduler.processCommand("sched John Mon Fri 9 17");
    var expectedResult = loadPascalTestResult("sched_john_mon_fri_9_17.txt");
    
    assertEquals(expectedResult, javaResult);
}
```

### Performance Benchmarks

```java
@BenchmarkMode(Mode.AverageTime)
@OutputTimeUnit(TimeUnit.MICROSECONDS)
public class SchedulingBenchmark {
    
    @Benchmark
    public void scheduleEmployee(Blackhole bh) {
        // Benchmark scheduling operations
    }
}
```

## Build and Deployment

### Maven Configuration

```xml
<properties>
    <maven.compiler.source>17</maven.compiler.source>
    <maven.compiler.target>17</maven.compiler.target>
    <junit.version>5.9.0</junit.version>
    <mockito.version>4.6.1</mockito.version>
</properties>
```

### Code Quality Tools

- **SpotBugs**: Static analysis for bug detection
- **Checkstyle**: Code style enforcement
- **PMD**: Code quality rules
- **JaCoCo**: Test coverage reporting

## Migration Documentation

### Mapping Documentation

```java
/**
 * MIGRATION MAPPING:
 * 
 * Pascal Procedure: DoSched
 * Java Class: ScheduleManager.scheduleEmployee()
 * 
 * Changes:
 * - Added type safety with Employee record
 * - Replaced VAR Error with exceptions
 * - Added comprehensive validation
 * - Improved error messages
 * 
 * Behavior: Identical to Pascal version
 * Performance: Improved O(1) conflict detection vs O(n) Pascal
 */
```

### Architecture Decisions

- **Domain-Driven Design**: Organize code around business concepts
- **Dependency Injection**: Use Spring for component management
- **Event-Driven Architecture**: Consider events for audit and notifications
- **API-First Design**: Prepare for future integrations

## Verification Checklist

- [ ] All Pascal functionality reproduced in Java
- [ ] Test coverage >= 90%
- [ ] Performance equals or exceeds Pascal version
- [ ] Error handling improved while preserving behavior
- [ ] Documentation complete with migration notes
- [ ] Code passes all quality checks
- [ ] Integration tests verify end-to-end functionality