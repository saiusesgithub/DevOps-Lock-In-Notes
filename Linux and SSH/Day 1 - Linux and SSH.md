Example of SSH client - **Git bash** (or even Terminal and PowerShell works but different commands)

Run this command before SSH to ensure your private key is not publicly viewable

```bash
chmod 400 "private key name.pem"
```

```bash
ssh -i "private key name.pem" ubuntu@public ip of EC2 instance
```

Example - 

```bash
chmod 400 "day 1 ssh and linux practice vm key.pem"

ssh -i "day 1 ssh and linux practice vm key.pem" ubuntu@ec2-18-60-44-189.ap-south-2.compute.amazonaws.com
```

```bash
pwd

cd /
cd ~
cd ..

mkdir logs scripts flags

ls
# → lists files and directories in the current folder
# → NO hidden files
# → NO details

ls -l
# ls -l
# → long listing
# → shows permissions, owner, group, size, date, name
# → still NO hidden files

ls -a
# ls -a
# → lists ALL files including hidden files
# → hidden files start with a dot (.)
# → NO detailed info

ls -al
# → combines -a + -l
# → shows ALL files WITH full details
# → this is what engineers use most

# NOTE:
# `ls -la` and `ls -al` are the SAME
# order of flags does not matter
```

> / = filesystem root
> ~ = your home
> .. = parent

```bash
# Create files
touch notes.txt
touch logs/app.log

# IMPORTANT:
# If you run `touch` on a file that ALREADY EXISTS and HAS DATA:
# → Nothing is deleted
# → Content stays exactly the same
# → Only the timestamp (modified time) is updated

# Add content to files
echo "Day 1 Linux practice" > notes.txt
echo "first log line" > logs/app.log
echo "second log line" >> logs/app.log

# View file contents
cat notes.txt
cat logs/app.log

# View file using pager
less logs/app.log
# Press 'q' to exit less

# View last lines of a file
tail logs/app.log

# Follow mode (live log monitoring)
tail -f logs/app.log
# -f = follow
# It keeps the command running and shows NEW lines
# added to the file in real time (used heavily in servers)
# Press Ctrl + C to stop following
```

```bash
# Copy file
cp notes.txt files/notes_copy.txt

# Move file
mv notes.txt files/

# Rename file
mv files/notes.txt files/notes_renamed.txt

# List files (files inside files folder)
ls files

# Remove a file
rm files/data.txt

# Try removing a directory (this will FAIL)
rm logs

# Correct way to remove a directory with contents
rm -r logs
# -r = recursive (deletes directory AND everything inside it)
# VERY DANGEROUS if used carelessly

# About rmdir:
# rmdir ONLY works if the directory is EMPTY
# Example (this works only if directory has no files inside):
# rmdir empty_folder

# This will FAIL if directory is NOT empty:
# rmdir files
```

> '>' overwrites , '>>' appends

#### PERMISSIONS + CHMOD NOTES

```bash
# Example permission line explained -

-rw-rw-r-- 1 ubuntu ubuntu 0 Jan  7 09:10 test.sh

# Break it down:

# -             → file type
#               -  = regular file
#               d  = directory
#               l  = symlink

# rw-         → OWNER permissions
#               r = read
#               w = write
#               x = execute (missing here)

# rw-         → GROUP permissions

# r--         → OTHERS permissions

# 1           → number of hard links (not important for now)

# ubuntu      → owner of the file
# ubuntu      → group of the file

# 0           → file size in bytes

# Jan 7 09:10 → last modified date & time

# test.sh     → file name
```

```bash
# chmod basics

touch test.sh
ls -l test.sh

# Try executing without execute permission
./test.sh
# → Permission denied
# WHY?
# Because execute (x) permission is missing

# Add execute permission
chmod +x test.sh
ls -l test.sh

# chmod +x
# → adds execute permission
# → default adds it for owner, group, and others

# Remove execute permission
chmod -x test.sh

# Remove read permission
chmod -r test.sh

# Add read permission back
chmod +r test.sh

# -------------------------------
# Numeric chmod (IMPORTANT)
# -------------------------------

chmod 777 test.sh
# 7 = rwx
# 7 = rwx
# 7 = rwx
# OWNER | GROUP | OTHERS
# This means EVERYONE can do EVERYTHING
# Almost NEVER correct in real systems

chmod 755 test.sh
# 7 = rwx (owner)
# 5 = r-x (group)
# 5 = r-x (others)
# Common for scripts and executables
```

```bash
# Directory permissions

ls -ld files
# -ld
# → shows directory permissions (not contents)

chmod -x files
# Remove execute permission from directory

cd files
# → Permission denied

# WHY THIS HAPPENS (IMPORTANT):
# For directories:
# r = can list files (ls)
# w = can create/delete files
# x = can ENTER the directory (cd)

# Even if you have READ permission:
# WITHOUT execute (x),
# you CANNOT enter the directory

# Read allows seeing names,
# Execute allows ACCESSING them

# Fix it:
chmod +x files

cd files
# Now it works
```

#### PROCESSES & SERVICES

```bash
# Files  → things at rest (on disk)
# Processes → programs currently running (in memory)
# Services → important long-running processes managed by the system

# Think like this:
# File    = recipe
# Process = recipe being cooked
# Service = kitchen machine kept running by the system

# -----------------------------------------
# WHAT IS A PROCESS?
# -----------------------------------------
# A process is a running program
# Every process has:
# - PID  → Process ID (unique number)
# - USER → who started/owns it
# - CPU / MEM usage

# -----------------------------------------
# VIEW PROCESSES (BASIC)
# -----------------------------------------

ps
# Shows processes attached to THIS terminal only
# Very limited view
# Useful to see what your shell is running

# -----------------------------------------
# VIEW ALL PROCESSES (REAL VIEW)
# -----------------------------------------

ps aux
# a → processes from all users
# u → user-oriented format (shows USER, CPU, MEM)
# x → processes not attached to a terminal (background/system)

# This command shows MOST processes on the system

# Important columns:
# USER    → owner of the process
# PID     → process ID (used to kill)
# %CPU    → CPU usage
# %MEM    → memory usage
# COMMAND → what program is running

# -----------------------------------------
# REAL-TIME PROCESS MONITORING
# -----------------------------------------

top
# Live, continuously updating process list
# Shows:
# - CPU usage
# - Memory usage
# - System load
# This is a LIVE VIEW of the system

# Mental model:
# ps   = photo
# top  = live video

# Press 'q' to exit top

# -----------------------------------------
# FILTERING PROCESSES
# -----------------------------------------

ps aux | grep ssh
# grep filters output
# Shows only lines containing "ssh"

# -----------------------------------------
# CREATING A PROCESS (FOREGROUND)
# -----------------------------------------

sleep 300
# Runs a process that sleeps for 300 seconds
# Foreground process → terminal is blocked
# Stop it with Ctrl + C

# -----------------------------------------
# CREATING A PROCESS (BACKGROUND)
# -----------------------------------------

sleep 300 &
# & means run in background
# Terminal is free
# Process continues running

ps aux | grep sleep
# Find the sleep process and note its PID

# -----------------------------------------
# KILLING A PROCESS
# -----------------------------------------

kill <PID>
# Sends SIGTERM (polite request to stop)
# Most processes shut down cleanly

# Check if it is gone
ps aux | grep sleep

# -----------------------------------------
# FORCE KILL (UNDERSTAND, DON'T ABUSE)
# -----------------------------------------

kill -9 <PID>
# SIGKILL
# Immediate termination
# No cleanup, no grace
# Use ONLY if normal kill does not work
```

```bash
# -----------------------------------------
# WHAT IS A SERVICE?
# -----------------------------------------
# A service is a long-running process:
# - Managed by the system
# - Usually starts at boot
# - Controlled via systemctl (systemd)

# Examples:
# ssh, cron, networking, docker, nginx

# -----------------------------------------
# CHECK SERVICE STATUS
# -----------------------------------------

systemctl status ssh
# Shows:
# - active (running) → service is healthy
# - inactive / failed → service is down
# Also shows recent logs and PID

# -----------------------------------------
# STOP A SERVICE
# -----------------------------------------

sudo systemctl stop ssh
# Stops the SSH service
# New SSH connections will fail
# Existing connection may drop

# -----------------------------------------
# START A SERVICE
# -----------------------------------------

sudo systemctl start ssh
# Starts the SSH service again
```

#### LOGS, BREAKING & REBUILDING

```bash
# -----------------------------------------
# SERVICE LOGS (INTRODUCTION)
# -----------------------------------------

sudo journalctl -u ssh --no-pager | tail
# journalctl → system log viewer
# -u ssh     → only logs for ssh service
# tail       → last few log entries
# --no-pager → avoids interactive pager

# -----------------------------------------
# FINAL MENTAL MODEL
# -----------------------------------------

# Services:
# - systemctl status → inspect
# - systemctl stop/start → control
# - journalctl → debug

# Logs answer the question:
# "WHAT happened and WHY did it happen?"

# Status tells you:
# - Is something running?

# Logs tell you:
# - Why it failed
# - What errors occurred
# - Who tried to access the system

# -----------------------------------------
# CHECK SERVICE STATUS
# -----------------------------------------

systemctl status ssh
# Shows:
# - active (running) / inactive / failed
# - Main PID of the service
# - Recent log snippets

# Status answers:
# "Is the service alive right now?"

# -----------------------------------------
# SYSTEM LOGS WITH journalctl
# -----------------------------------------

journalctl
# Shows ALL system logs (very noisy)
# Usually not used without filters

# -----------------------------------------
# WHY journalctl NEEDS sudo
# -----------------------------------------
# System logs contain sensitive data:
# - Login attempts
# - Authentication failures
# - Service crashes
# - Security events

# Normal users are NOT allowed to read them fully.
# sudo = "I know what I’m doing, give me admin access"

# Without sudo:
# - Logs may be empty or incomplete

# With sudo:
# - Full, trusted system logs are shown

# -----------------------------------------
# VIEW LOGS FOR A SPECIFIC SERVICE
# -----------------------------------------

sudo journalctl -u ssh
# -u ssh → only logs related to SSH service
# Shows historical logs (past events)

# Exit log view with:
# q

# -----------------------------------------
# VIEW RECENT LOGS ONLY
# -----------------------------------------

sudo journalctl -u ssh | tail
# Shows only the most recent entries
# Useful when debugging something that JUST happened

# -----------------------------------------
# FOLLOW LOGS LIVE (CRITICAL SKILL)
# -----------------------------------------

sudo journalctl -u ssh -f
# -f = follow (live updates)
# Similar to tail -f
# Used when:
# - Restarting services
# - Debugging connection issues
# - Watching real-time failures

# Stop following logs:
# Ctrl + C

# -----------------------------------------
# BREAKING A SERVICE (INTENTIONALLY)
# -----------------------------------------

sudo systemctl stop ssh
# Stops the SSH service
# New SSH connections will fail
# Existing connection may drop

systemctl status ssh
# Confirms service is stopped

# -----------------------------------------
# FIXING (REBUILDING) THE SERVICE
# -----------------------------------------

sudo systemctl start ssh
# Starts the SSH service again

systemctl status ssh
# Should now show active (running)

# -----------------------------------------
# REBUILD MENTAL MODEL
# -----------------------------------------
# When something breaks in real life:
#
# 1. Check service status
#    systemctl status <service>
#
# 2. Read recent logs
#    sudo journalctl -u <service> | tail
#
# 3. Restart service if needed
#    sudo systemctl restart <service>
#
# 4. Follow logs if issue persists
#    sudo journalctl -u <service> -f
```