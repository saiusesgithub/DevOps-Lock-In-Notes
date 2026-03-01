# DAY 3 — runs-on Variations & Environment Engineering

#### Date: 25th February 2026

--------------------------------------------------
## Objective

Understand execution environments.
Learn cross-OS differences.
Control runner behavior intentionally.

Today you stop assuming "Linux only".

--------------------------------------------------
## 1. What is runs-on?

runs-on defines which runner environment the job executes on.

Example:
```yml
runs-on: ubuntu-latest
runs-on: windows-latest
runs-on: macos-latest
```
Each represents a different VM image.


--------------------------------------------------
## 2. GitHub-Hosted Runner Images

Common options:

ubuntu-latest

windows-latest

macos-latest

These are:

- Pre-configured VM images
- Maintained by GitHub
- Updated regularly
- Ephemeral


--------------------------------------------------
## 3. Differences Between OS Environments

Ubuntu:
- Default shell: bash
- File system: case-sensitive
- Path separator: /

Windows:
- Default shell: PowerShell
- File system: case-insensitive
- Path separator: \

macOS:
- Similar to Linux
- Useful for iOS/mac-specific builds


--------------------------------------------------
## 4. Shell Behavior Differences

On Ubuntu:
```yml
run: echo "Hello"
```
Runs in bash.

On Windows:
```yml
run: echo "Hello"
```
Runs in PowerShell by default.

PowerShell syntax differs from bash.

Example difference:
```
Bash:
echo $VAR

PowerShell:
echo $env:VAR
```

--------------------------------------------------
## 5. Overriding Shell

You can explicitly define shell:
```yml
steps:
  - name: Use Bash on Windows
    shell: bash
    run: echo "Hello from bash"
```
This ensures consistent execution.


--------------------------------------------------
## 6. Testing Environment Differences

Create 3 jobs:
```yml
jobs:
  linux:
    runs-on: ubuntu-latest

  windows:
    runs-on: windows-latest

  mac:
    runs-on: macos-latest
```
Add step:
```yml
- run: |
    echo "OS: ${{ runner.os }}"
    echo "Arch: ${{ runner.arch }}"
    pwd
```

--------------------------------------------------
## 7. File System Case Sensitivity

Linux:

File.txt ≠ file.txt

Windows:

File.txt == file.txt

This can cause hidden bugs.


--------------------------------------------------
## 8. Preinstalled Tools

GitHub-hosted runners include:

- git
- docker
- node
- python
- java
- build tools

But versions may differ between OS.


--------------------------------------------------
## 9. Cross-Platform Strategy

Instead of writing 3 separate jobs,
use matrix:
```yml
strategy:
  matrix:
    os: [ubuntu-latest, windows-latest, macos-latest]

runs-on: ${{ matrix.os }}
```
This creates 3 parallel jobs automatically.


--------------------------------------------------
## 10. Why Cross-OS Testing Matters

Real-world example:

Your script works on Linux,
but fails on Windows due to path or shell differences.

Cross-platform pipelines:
- Increase reliability
- Catch environment-specific bugs


--------------------------------------------------
## 11. Resource Differences

Ubuntu runner:
~2 cores, ~7GB RAM (approx, may change)

Windows/mac runners:
Different specs and startup time.

macOS runners:
Slower to provision.


--------------------------------------------------
## 12. Mandatory Experiments

1. Create 3 jobs for Linux, Windows, macOS.
2. Print runner.os and runner.arch.
3. Try using Linux-specific command on Windows.
4. Observe failure.
5. Override shell on Windows to bash.
6. Use matrix to replace separate jobs.
7. Measure total execution time.


--------------------------------------------------
## 13. Mental Model Upgrade

runs-on selects machine image.

Different OS = different shell + filesystem behavior.

Workflow portability depends on environment awareness.

You are not writing YAML.

You are defining infrastructure execution.


--------------------------------------------------
## Checkpoint Questions

Answer clearly:

1. What is default shell on Windows runner?
2. Why might script work on Ubuntu but fail on Windows?
3. How do you override shell?
4. What does matrix.os represent?
5. Why are macOS runners slower?

If unsure,
redo experiments.