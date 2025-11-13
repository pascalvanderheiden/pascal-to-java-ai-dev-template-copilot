#!/bin/bash

# Turbo Pascal Setup Verification Script
# This script checks if all required components are installed and configured

echo "🔍 Verifying Turbo Pascal Development Environment Setup"
echo "======================================================"
echo

# Check if Free Pascal Compiler is installed
echo "1. Checking Free Pascal Compiler..."
if command -v fpc &> /dev/null; then
    echo "✅ Free Pascal Compiler is installed"
    echo "   Version: $(fpc -h | head -1)"
else
    echo "❌ Free Pascal Compiler not found"
    echo "   Please install with: brew install fpc"
    exit 1
fi
echo

# Check if we're in the right directory
echo "2. Checking project structure..."
if [ -f "legacy/source/text-adventure-heist-of-thermmirekeep.pas" ]; then
    echo "✅ Found Pascal source files"
else
    echo "❌ Pascal source files not found"
    echo "   Make sure you're in the project root directory"
    exit 1
fi
echo

# Check if example program exists
echo "3. Checking example program..."
if [ -f "legacy/source/text-adventure-heist-of-thermmirekeep.pas" ]; then
    echo "✅ text-adventure-heist-of-thermmirekeep.pas is available"
else
    echo "❌ text-adventure-heist-of-thermmirekeep.pas not found"
    echo "   This is the main example program for testing"
    exit 1
fi
echo

# Test compilation
echo "4. Testing Pascal compilation..."
cd legacy/source

# Compile the text adventure example
if fpc -Mtp text-adventure-heist-of-thermmirekeep.pas &> /dev/null; then
    echo "✅ Text adventure heist-of-thermmirekeep compiles successfully"
    rm -f text-adventure-heist-of-thermmirekeep.o text-adventure-heist-of-thermmirekeep.ppu text-adventure-heist-of-thermmirekeep
else
    echo "❌ Text adventure heist-of-thermmirekeep compilation failed"
    echo "   Check Free Pascal installation and crt unit availability"
    exit 1
fi
echo

# Check VSCode configuration
echo "5. Checking VSCode configuration..."
cd ../..
if [ -f ".vscode/settings.json" ] && [ -f ".vscode/tasks.json" ]; then
    echo "✅ VSCode configuration files are present"
else
    echo "⚠️  VSCode configuration files may be missing"
    echo "   Some features may not work as expected"
fi
echo

echo "🎉 Setup verification completed!"
echo
echo "Next steps:"
echo "1. Open VSCode in this directory"
echo "2. Install the Pascal extension"
echo "3. Open legacy/source/text-adventure-heist-of-thermmirekeep.pas"
echo "4. Press Cmd+Shift+P and run 'Tasks: Run Task' > 'Compile Pascal'"
echo "5. Or use Code Runner (Ctrl+Alt+N) to compile and run"
echo "6. Try playing the text adventure game!"
echo
echo "For detailed instructions, see: docs/turbo-pascal-setup.md"