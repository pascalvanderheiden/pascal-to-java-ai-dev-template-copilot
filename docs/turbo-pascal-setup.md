# Running Turbo Pascal Files in VSCode

This guide provides step-by-step instructions for setting up a Turbo Pascal development environment in Visual Studio Code on macOS.

## Overview

Since Turbo Pascal is a legacy DOS-based development environment, we'll use modern alternatives that provide Pascal compilation and execution capabilities while maintaining compatibility with legacy code. We'll use a simple text adventure game as our example Pascal program.

## Prerequisites

- macOS (this guide is macOS-specific)
- Visual Studio Code
- Homebrew (package manager for macOS)
- Terminal access

## Step-by-Step Setup

### Step 1: Install Free Pascal Compiler (FPC)

Free Pascal is a modern, cross-platform Pascal compiler that maintains compatibility with Turbo Pascal syntax.

1. **Install via Homebrew:**
   ```bash
   # Install Homebrew if not already installed
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   
   # Install Free Pascal Compiler
   brew install fpc
   ```

2. **Verify Installation:**
   ```bash
   fpc -h
   ```
   You should see the Free Pascal Compiler help output.

### Step 2: Install Pascal Language Support for VSCode

1. **Open VSCode**

2. **Install Pascal Extensions:**
   - Open Extensions panel (`Cmd+Shift+X`)
   - Search for and install these extensions:
     - **"Pascal"** by Alessandro Fragnani (syntax highlighting, IntelliSense)
     - **"Pascal Language Server"** by Ryan Joseph (advanced language features)
     - **"Code Runner"** by Jun Han (for quick execution)

3. **Alternative Extension:**
   - **"OmniPascal"** by Wirth Research (comprehensive Pascal support)

### Step 3: Configure VSCode for Pascal Development

1. **Create VSCode Workspace Settings:**
   
   Create `.vscode/settings.json` in your project root:
   ```json
   {
     "pascal.compiler.path": "/opt/homebrew/bin/fpc",
     "pascal.formatter.engine": "ptop",
     "code-runner.executorMap": {
       "pascal": "cd $dir && fpc $fileName && ./$fileNameWithoutExt"
     },
     "code-runner.runInTerminal": true,
     "code-runner.saveFileBeforeRun": true
   }
   ```

2. **Create Tasks Configuration:**
   
   Create `.vscode/tasks.json`:
   ```json
   {
     "version": "2.0.0",
     "tasks": [
       {
         "label": "Compile Pascal",
         "type": "shell",
         "command": "fpc",
         "args": ["${file}"],
         "group": {
           "kind": "build",
           "isDefault": true
         },
         "presentation": {
           "echo": true,
           "reveal": "always",
           "focus": false,
           "panel": "shared"
         },
         "options": {
           "cwd": "${fileDirname}"
         },
         "problemMatcher": {
           "owner": "pascal",
           "fileLocation": ["relative", "${workspaceFolder}"],
           "pattern": {
             "regexp": "^(.*)\\((\\d+),(\\d+)\\)\\s+(Error|Warning|Note):\\s+(.*)$",
             "file": 1,
             "line": 2,
             "column": 3,
             "severity": 4,
             "message": 5
           }
         }
       },
       {
         "label": "Run Pascal",
         "type": "shell",
         "command": "./${fileBasenameNoExtension}",
         "group": "test",
         "presentation": {
           "echo": true,
           "reveal": "always",
           "focus": true,
           "panel": "shared"
         },
         "options": {
           "cwd": "${fileDirname}"
         },
         "dependsOn": "Compile Pascal"
       }
     ]
   }
   ```

3. **Create Launch Configuration:**
   
   Create `.vscode/launch.json` for debugging:
   ```json
   {
     "version": "0.2.0",
     "configurations": [
       {
         "name": "Debug Pascal",
         "type": "gdb",
         "request": "launch",
         "program": "${fileDirname}/${fileBasenameNoExtension}",
         "args": [],
         "stopAtEntry": false,
         "cwd": "${fileDirname}",
         "environment": [],
         "externalConsole": false,
         "MIMode": "gdb",
         "preLaunchTask": "Compile Pascal"
       }
     ]
   }
   ```

### Step 4: Understanding the Example Program

The project includes `text-adventure-example.pas`, a simple interactive text adventure game that demonstrates:

- **Basic I/O**: Reading user input and displaying output
- **Conditional Logic**: Using if-then-else statements
- **String Handling**: Processing user text input
- **Screen Control**: Using the `crt` unit for screen clearing

This example is perfect for testing your Pascal development environment without complex dependencies.

### Step 5: Running Pascal Files

#### Method 1: Using Code Runner Extension

1. **Open the Pascal file** (`legacy/source/text-adventure-example.pas`)
2. **Run the file:**
   - Press `Ctrl+Alt+N` (or `Cmd+Alt+N` on Mac)
   - Or right-click and select "Run Code"
   - Or click the ▶️ button in the top-right corner

#### Method 2: Using VSCode Tasks

1. **Open a Pascal file**
2. **Compile:**
   - Press `Cmd+Shift+P` and type "Tasks: Run Task"
   - Select "Compile Pascal"
3. **Run:**
   - Press `Cmd+Shift+P` and type "Tasks: Run Task"
   - Select "Run Pascal"

#### Method 3: Using Terminal

1. **Navigate to the source directory:**
   ```bash
   cd legacy/source
   ```

2. **Compile the Pascal file:**
   ```bash
   fpc -Mtp text-adventure-example.pas
   ```

3. **Run the compiled executable:**
   ```bash
   ./text-adventure-example
   ```

### Step 6: Verify Your Setup

Before testing manually, you can run the automated verification script:

```bash
# Make sure you're in the project root directory
cd /path/to/pascal-to-java-ai-dev-template-copilot

# Run the verification script
./scripts/verify-pascal-setup.sh
```

This script will check:
- ✅ Free Pascal Compiler installation
- ✅ Project structure and required files
- ✅ Pascal compilation functionality
- ✅ VSCode configuration files

## Step 7: Testing the Setup

1. **Test with a simple Pascal program:**
   
   Create `test.pas`:
   ```pascal
   program test;
   begin
     writeln('Hello from Pascal in VSCode!');
     readln;
   end.
   ```

2. **Compile and run using any of the methods above**

3. **Test the text adventure example:**
   ```bash
   cd legacy/source
   fpc -Mtp text-adventure-example.pas
   ./text-adventure-example
   ```
   
   You should see:
   ```
   Welcome to the Adventure Game!
   You find yourself in a dark forest. There are two paths ahead.
   Do you want to go left or right? (type "left" or "right")
   ```

### Step 8: Debugging Setup (Optional)

1. **Install GDB debugger:**
   ```bash
   brew install gdb
   ```

2. **Code signing for GDB on macOS:**
   ```bash
   # Create certificate and sign gdb (required for macOS security)
   # Follow Apple's code signing documentation
   ```

3. **Use VSCode debugging:**
   - Set breakpoints in your Pascal code
   - Press `F5` to start debugging

## Troubleshooting

### Common Issues and Solutions

1. **"fpc: command not found"**
   - Ensure Free Pascal is installed: `brew install fpc`
   - Check PATH: `echo $PATH` should include `/opt/homebrew/bin`

2. **"Unit not found: crt"**
   - The `crt` unit should be included with Free Pascal
   - If missing, remove the `uses crt;` line and `clrscr;` call from the program

3. **Permission denied when running executable**
   - Make executable: `chmod +x filename`

4. **Compilation errors with legacy code**
   - Use compatibility mode: `fpc -Mtp filename.pas` (Turbo Pascal mode)
   - Check syntax differences between Turbo Pascal and Free Pascal

### Free Pascal vs Turbo Pascal Compatibility

Most Turbo Pascal code will compile with Free Pascal using the `-Mtp` (Turbo Pascal mode) flag:

```bash
fpc -Mtp sched.pas
```

## Alternative: DOSBox Approach

If you need 100% Turbo Pascal compatibility, you can run the original Turbo Pascal IDE in DOSBox:

1. **Install DOSBox:**
   ```bash
   brew install dosbox
   ```

2. **Download Turbo Pascal 7.0** (legally available as freeware)

3. **Configure DOSBox** to mount your project directory

4. **Run Turbo Pascal IDE** within DOSBox

## Useful Resources

- [Free Pascal Documentation](https://www.freepascal.org/docs.html)
- [Pascal Language Server](https://github.com/genericptr/pascal-language-server)
- [VSCode Pascal Extension](https://marketplace.visualstudio.com/items?itemName=alefragnani.pascal)

## Project-Specific Notes

For this Pascal-to-Java migration project:

- **Example code location:** `legacy/source/text-adventure-example.pas`
- **Dependencies:** Uses the `crt` unit for screen control
- **Testing:** Verify the text adventure game runs and accepts user input correctly
- **Documentation:** Use this setup to analyze and understand Pascal code patterns before migration

## Next Steps

Once you have Pascal running locally:

1. **Analyze the legacy code** using the Pascal instructions
2. **Document the functionality** for migration planning
3. **Create test cases** based on Pascal program behavior
4. **Begin Java implementation** using the Java instructions

This setup provides a solid foundation for understanding and working with the legacy Turbo Pascal code while preparing for migration to Java.