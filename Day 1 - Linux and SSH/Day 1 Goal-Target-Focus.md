08/01/2026

Linux & SSH Foundations (DevOps Lock-In)
Focus: Building real server confidence using Linux (terminal-only).

Today was entirely hands-on and executed on a real Ubuntu EC2 instance via SSH (key-based authentication) — no GUI tools, no browser SSH, no shortcuts.

## 🔧 What I Did

Launched and connected to a live Linux server using SSH
Navigated the filesystem confidently using pwd, ls, cd, /, ~, ..
Created a structured workspace and managed files/directories end-to-end
Read files and logs using cat, less, tail, tail -f
Understood file creation and redirection using touch, >, >>
Deleted files and directories safely using rm, rm -r, rmdir

## 🔐 Permissions (Deep Dive)
Built a clear mental model of Linux permissions (r / w / x) for files vs directories
Inspected permissions using ls -l and ls -al
Intentionally broke permissions (chmod -x, chmod -r) and fixed them
Understood why execute permission is required to enter directories
Used both symbolic and numeric chmod (+x, 755, 777) with awareness of security risks

## ⚙️ Processes & Services
Understood the difference between processes and system services
Monitored processes using ps, ps aux, top
Created foreground and background processes (sleep &)
Identified processes via PID and terminated them using kill
Managed system services using systemctl (status, start, stop)
Intentionally stopped and restarted the ssh service and recovered cleanly

## 📜 Logs
Learned the difference between service status and system logs
Read real system logs using journalctl, journalctl -u ssh, tail -f
Understood why elevated permissions are required to access system logs
Interpreted real SSH authentication and restart events

## 💣 Break & Rebuild
Intentionally broke services and file permissions

Rebuilt everything from memory without notes, including:

Files
Permissions
Processes
Services
Logs

## ✅ Outcome
I can now confidently say:

# “I can SSH into a Linux server, navigate without fear, manage files and permissions, control processes, handle services, and read system logs.”

Status: Day 1 completed successfully 
Approach: Slow, deep, and correct — focused on understanding, not speed.