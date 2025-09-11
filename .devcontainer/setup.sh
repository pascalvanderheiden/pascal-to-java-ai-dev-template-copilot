#!/bin/bash

# Pascal to Java Migration Environment Setup Script
# This script installs and configures all necessary tools for the development environment

set -e

echo "🚀 Starting Pascal to Java Migration Environment Setup..."

# Update package lists
echo "📦 Updating package lists..."
sudo apt-get update

# Install Free Pascal Compiler
echo "🔧 Installing Free Pascal Compiler..."
sudo apt-get install -y fpc

# Install additional Pascal development tools
echo "🛠️ Installing Pascal development dependencies..."
sudo apt-get install -y \
    build-essential \
    gdb \
    valgrind \
    git \
    curl \
    wget \
    unzip

# Install Maven (additional to the feature)
echo "☕ Configuring Maven..."
sudo apt-get install -y maven

# Install Gradle (additional to the feature)
echo "🐘 Configuring Gradle..."
sudo apt-get install -y gradle

# Create useful aliases
echo "⚡ Setting up aliases..."
cat >> ~/.bashrc << 'EOF'

# Pascal Development Aliases
alias pascalc='fpc -Mtp'
alias pascalrun='fpc -Mtp $1 && ./${1%.*}'
alias pascalclean='rm -f *.o *.ppu'

# Java Development Aliases
alias javac17='javac --release 17'
alias javarun='java'
alias mvnclean='mvn clean'
alias mvncompile='mvn compile'
alias mvntest='mvn test'
alias mvnpackage='mvn package'

# Git Aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'

EOF

# Set up Pascal development environment
echo "🎯 Configuring Pascal environment..."
mkdir -p /workspaces/${PWD##*/}/legacy/bin
mkdir -p /workspaces/${PWD##*/}/legacy/output

# Create Pascal compilation script
cat > /workspaces/${PWD##*/}/scripts/compile-pascal.sh << 'EOF'
#!/bin/bash
# Pascal Compilation Script

if [ $# -eq 0 ]; then
    echo "Usage: $0 <pascal_file.pas>"
    exit 1
fi

PASCAL_FILE="$1"
BASENAME="${PASCAL_FILE%.*}"

echo "🔨 Compiling $PASCAL_FILE..."

# Compile with Turbo Pascal mode
fpc -Mtp -O2 -gl -gh "$PASCAL_FILE"

if [ $? -eq 0 ]; then
    echo "✅ Compilation successful!"
    echo "📁 Executable: $BASENAME"
    echo "🏃 Run with: ./$BASENAME"
else
    echo "❌ Compilation failed!"
    exit 1
fi
EOF

chmod +x /workspaces/${PWD##*/}/scripts/compile-pascal.sh

# Create Java project structure
echo "☕ Setting up Java project structure..."
mkdir -p /workspaces/${PWD##*/}/src/main/java/com/migration
mkdir -p /workspaces/${PWD##*/}/src/main/resources
mkdir -p /workspaces/${PWD##*/}/src/test/java/com/migration
mkdir -p /workspaces/${PWD##*/}/src/test/resources

# Create a sample pom.xml for Maven projects
cat > /workspaces/${PWD##*/}/pom.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    
    <groupId>com.migration</groupId>
    <artifactId>pascal-to-java-migration</artifactId>
    <version>1.0.0-SNAPSHOT</version>
    <packaging>jar</packaging>
    
    <name>Pascal to Java Migration</name>
    <description>Migration project from Turbo Pascal to modern Java</description>
    
    <properties>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <junit.version>5.9.2</junit.version>
        <mockito.version>5.1.1</mockito.version>
    </properties>
    
    <dependencies>
        <!-- JUnit 5 for testing -->
        <dependency>
            <groupId>org.junit.jupiter</groupId>
            <artifactId>junit-jupiter</artifactId>
            <version>${junit.version}</version>
            <scope>test</scope>
        </dependency>
        
        <!-- Mockito for mocking -->
        <dependency>
            <groupId>org.mockito</groupId>
            <artifactId>mockito-core</artifactId>
            <version>${mockito.version}</version>
            <scope>test</scope>
        </dependency>
        
        <!-- AssertJ for fluent assertions -->
        <dependency>
            <groupId>org.assertj</groupId>
            <artifactId>assertj-core</artifactId>
            <version>3.24.2</version>
            <scope>test</scope>
        </dependency>
    </dependencies>
    
    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.11.0</version>
                <configuration>
                    <source>17</source>
                    <target>17</target>
                    <compilerArgs>
                        <arg>--enable-preview</arg>
                    </compilerArgs>
                </configuration>
            </plugin>
            
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-surefire-plugin</artifactId>
                <version>3.0.0-M9</version>
                <configuration>
                    <argLine>--enable-preview</argLine>
                </configuration>
            </plugin>
            
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-failsafe-plugin</artifactId>
                <version>3.0.0-M9</version>
                <configuration>
                    <argLine>--enable-preview</argLine>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
EOF

# Verify installations
echo "🔍 Verifying installations..."

echo "Pascal Compiler:"
fpc -h | head -3

echo "Java Version:"
java -version

echo "Maven Version:"
mvn -version

echo "Gradle Version:"
gradle --version

# Test Pascal compilation with the existing example
echo "🧪 Testing Pascal compilation..."
cd /workspaces/${PWD##*/}/legacy/source
if [ -f "text-adventure-example.pas" ]; then
    fpc -Mtp text-adventure-example.pas
    if [ $? -eq 0 ]; then
        echo "✅ Pascal compilation test successful!"
        rm -f text-adventure-example text-adventure-example.o
    else
        echo "⚠️ Pascal compilation test failed"
    fi
else
    echo "⚠️ text-adventure-example.pas not found"
fi

# Return to workspace root
cd /workspaces/${PWD##*/}

# Create a welcome script
cat > welcome.sh << 'EOF'
#!/bin/bash
echo "🎉 Welcome to the Pascal to Java Migration Environment!"
echo ""
echo "📁 Project Structure:"
echo "  legacy/source/     - Turbo Pascal source files"
echo "  src/main/java/     - Java source files"
echo "  src/test/java/     - Java test files"
echo "  docs/              - Documentation"
echo ""
echo "🔧 Available Commands:"
echo "  pascalc <file>     - Compile Pascal file"
echo "  mvn compile        - Compile Java project"
echo "  mvn test           - Run Java tests"
echo "  mvn package        - Build JAR file"
echo ""
echo "🚀 Quick Start:"
echo "  1. Open a Pascal file in legacy/source/"
echo "  2. Use Ctrl+Alt+N to run with Code Runner"
echo "  3. Or use 'pascalc filename.pas' in terminal"
echo ""
echo "📚 Documentation:"
echo "  - Pascal instructions: .github/instructions/pascal.instructions.md"
echo "  - Java instructions: .github/instructions/java.instructions.md"
echo "  - Setup guide: docs/turbo-pascal-setup.md"
echo ""
EOF

chmod +x welcome.sh

echo ""
echo "✅ Setup completed successfully!"
echo "🎯 Environment ready for Pascal to Java migration development"
echo ""
echo "Run './welcome.sh' for a quick overview of available tools and commands."
echo ""