# 🧾 Day 7 — Complete Command Log (with Explanations)

This file lists **all the commands you ran**, in **rough chronological order**, with **short, practical comments** explaining *what each command does and why you ran it*.

---

## 🔄 System & Package Management

```bash
sudo apt update
```

* Refreshes Ubuntu package index from configured repositories.
* Required before installing any new packages.

```bash
docker --version
```

* Checks whether Docker is installed and available in PATH.

```bash
sudo apt install docker.io
```

* Installs Docker Engine and dependencies (containerd, runc, bridge-utils).

```bash
sudo usermod -aG docker ubuntu
```

* Adds `ubuntu` user to `docker` group.
* Allows running `docker` without `sudo` (after re-login).

```bash
exit
```

* Logs out so group membership changes take effect.

---

## 🔐 SSH & Re-login

```bash
ssh -i "day7.pem" ubuntu@<ec2-public-dns>
```

* SSH into EC2 using PEM key authentication.

---

## 🐳 Docker Basics & Verification

```bash
docker --version
```

* Confirms Docker installed correctly.

```bash
docker run hello-world
```

* Tests Docker daemon + image pull + container execution.

---

## 📁 File System & Shell Navigation

```bash
ls
```

* Lists files in current directory.

```bash
mkdir day7
```

* Creates project directory.

```bash
cd day7
```

* Moves into project directory.

```bash
pwd
```

* Prints current working directory.

```bash
nano app.sh
```

* Creates/edits shell script using Nano editor.

```bash
nano Dockerfile
```

* Creates/edits Dockerfile.

```bash
cat app.sh
```

* Displays contents of shell script.

```bash
cat Dockerfile
```

* Displays contents of Dockerfile.

---

## 🏗️ Docker Image Build & Run

```bash
docker build -t day7 .
```

* Builds Docker image from Dockerfile in current directory.
* Tags image as `day7`.

```bash
./app.sh
```

* Attempts to execute script locally.
* Failed due to missing execute permission.

```bash
docker ps -a
```

* Lists all containers (running + stopped).

```bash
docker images
```

* Lists all local Docker images.

```bash
docker rmi <image-id>
```

* Removes Docker image by ID.

```bash
docker run --name day7 day7
```

* Runs container from `day7` image.

```bash
docker run -d --name day7 day7
```

* Runs container in detached mode.

```bash
docker logs day7
```

* Shows logs produced by container.

---

## 🛠️ Fixing Permission & Path Issues

```bash
chmod +x app.sh
```

* Makes shell script executable.

```dockerfile
WORKDIR /app
```

* Sets working directory inside container.

```dockerfile
CMD ["./app.sh"]
```

* Executes script relative to WORKDIR.

---

## 🧹 Container Cleanup

```bash
docker stop day7
```

* Gracefully stops running container.

```bash
docker rm day7
```

* Deletes stopped container.

```bash
docker rmi day7
```

* Deletes Docker image.

---

## 🔁 Restart Policies & Failure Testing

```bash
docker run -d --name day7 --restart on-failure day7
```

* Restarts container only if exit code != 0.

```bash
docker run -d --name day7 --restart unless-stopped day7
```

* Restarts container across daemon restarts unless manually stopped.

```bash
docker inspect day7 --format "{{.RestartCount}}"
```

* Displays how many times container restarted.

```bash
sudo systemctl restart docker
```

* Restarts Docker daemon (simulates host-level failure).

```bash
sudo reboot
```

* Reboots EC2 instance.
* Tests restart policy persistence.

---

## 🧬 Git & GitHub Setup

```bash
sudo apt install -y git
```

* Installs Git CLI.

```bash
git config --global user.name "saiusesgithub"
```

* Sets Git username globally.

```bash
git config --global user.email "saisrujanpunati@gmail.com"
```

* Sets Git email globally.

```bash
git clone https://github.com/saiusesgithub/day7.git
```

* Clones GitHub repository using HTTPS.

```bash
git add .
```

* Stages all changes.

```bash
git commit -m "push"
```

* Commits staged files with message.

```bash
git push
```

* Pushes commits to remote repository.

---

## 🔑 SSH Key & GitHub Auth

```bash
ssh-keygen -t rsa -b 4096 -C "saisrujanpunati@gmail.com"
```

* Generates SSH key pair for GitHub authentication.

```bash
cat ~/.ssh/id_rsa.pub
```

* Displays public SSH key (to add to GitHub).

```bash
git remote set-url origin git@github.com:saiusesgithub/day7.git
```

* Switches Git remote from HTTPS to SSH.

```bash
ssh -T git@github.com
```

* Tests SSH authentication with GitHub.

---

## 🤖 GitHub Actions (CI)

```bash
mkdir .github
mkdir .github/workflows
```

* Creates GitHub Actions workflow directory.

```bash
nano .github/workflows/ci.yml
```

* Creates CI pipeline YAML.

```bash
cat .github/workflows/ci.yml
```

* Verifies CI config.

---

## ✅ Final State

* Docker image builds cleanly
* Container restarts automatically on failure
* Restart behavior validated across daemon + VM reboot
* CI pipeline created
* GitHub authentication switched to SSH

---

🧠 **Key Learning:** Docker failures are *mechanical*, restart policies are *predictable*, and GitHub auth is *protocol-driven (HTTPS vs SSH)*.
