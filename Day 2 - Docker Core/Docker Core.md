## 🧠 Core Mental Model (Non‑Negotiable)

### Image ≠ Container

- **Image**
    - Read‑only blueprint
    - Built once
    - Does nothing by itself
    
- **Container**
    
    - A running instance of an image
    - Created when you run the image
    - Dies when its main process exits

👉 One image can create **many containers**.

---
### Dockerfile ≠ Image

- **Dockerfile**
    
    - Plain text recipe
    - Instructions on _how_ to build an image
    - Does nothing until `docker build`

- **Image**
    
    - Result of building the Dockerfile
    - Frozen snapshot of filesystem + metadata

👉 Changing a Dockerfile does **nothing** unless you rebuild the image.

---
## ⏱️ Build Time vs Run Time

This distinction separates people who **use Docker** from people who **understand Docker**.

### 🔨 Build Time

Happens during:

```bash
docker build
```

- Commands run **once**
- Results are **baked into the image**
- Output becomes part of the image layers

### ▶️ Run Time

Happens during:

```bash
docker run
```

- Commands run **every time a container starts**
- When the main process exits → container stops

---

## 🧱 Dockerfile Instructions by Time

### RUN → Build Time

```dockerfile
RUN apt update && apt install -y python3
```

- Runs while building the image
- Executed **once per build**
- Result is saved into the image layer

Mental model:

> **RUN = do this once and freeze the result**

---
### CMD → Run Time

```dockerfile
CMD ["python3", "app.py"]
```

- Runs when the container starts
- Runs **every time** you do `docker run`
- Can be overridden from the command line

Mental model:

> **CMD = default behavior when container starts**

---

## CMD vs ENTRYPOINT

### One‑Line Truth

> **ENTRYPOINT defines WHAT the container is**  
> **CMD defines the default command or arguments**

Both run at **container start time**, not build time.

---
### CMD — Default & Overridable

```dockerfile
CMD ["echo", "hello"]
```

- If user runs:
    
    ```bash
    docker run image
    ```
    
    → `echo hello`
    
- If user runs:
    
    ```bash
    docker run image echo bye
    ```
    
    → CMD is replaced

Mental model:

> **CMD = do this unless the user says otherwise**

---
### ENTRYPOINT — Fixed Identity

```dockerfile
ENTRYPOINT ["echo"]
```

- User supplies arguments
- Core command stays fixed

Example:

```bash
docker run image hello
```

→ `echo hello`

Mental model:

> **ENTRYPOINT = this container _is_ this command**

---
### ENTRYPOINT + CMD (Professional Pattern)

```dockerfile
ENTRYPOINT ["python3"]
CMD ["app.py"]
```

Behavior:

- Default run:
    
    ```bash
    docker run image
    ```
    
    → `python3 app.py`
    
- Override argument:
    
    ```bash
    docker run image test.py
    ```
    
    → `python3 test.py`

Mental model:

> ENTRYPOINT = engine  
> CMD = default arguments

---

## 🚫 Common Beginner Mistakes

### ❌ Running apps in RUN

```dockerfile
RUN python3 app.py
```

- App runs during build
- Build hangs or fails
- Image becomes useless

---
### ❌ Installing dependencies in CMD

```dockerfile
CMD apt update && apt install -y python3 && python3 app.py
```

- Installs deps on every run
- Slow
- Breaks caching
- Unpredictable

---

## 🧠 Why This Matters (CI/CD Reality)

- `docker build` → happens in CI
    
- `docker run` → happens in production

If build‑time and run‑time logic are mixed:

- Builds fail unexpectedly
- Containers exit instantly
- Debugging becomes painful
---
## 🔑 Final Lock‑In Summary

> **RUN builds the image**  
> **ENTRYPOINT defines the container**  
> **CMD supplies default behavior**

---

## 🔧 Docker Setup on EC2

### Step 1 — System Update

```bash
sudo apt update
```

- Refreshes package index
- Always done before installing new software

---

### Step 2 — Install Docker Engine

```bash
sudo apt install docker.io -y
```

- Installs Docker Engine from Ubuntu repositories
    
- Includes:
    - `docker` CLI
    - Docker daemon (`dockerd`)

---
### Step 3 — Verify Docker CLI

```
docker --version
```

- Confirms Docker CLI is installed
- Version output verifies successful installation

---
### Step 4 — Verify Docker Daemon

```
sudo systemctl status docker
```

- Docker runs as a background system service
- Must be `active (running)` to run containers

If not running:

```
sudo systemctl start docker
```

---
### Step 5 — First Container (Sanity Check)

```
sudo docker run hello-world
```

What this confirms:

- Docker daemon is working
- Image pulling works
- Container runtime works

---
# 🧱 Dockerfile #1 — Minimal

## 🎯 Objective

Understand Docker at the most basic, mechanical level by:

- Writing a Dockerfile from scratch
- Building an image
- Running a container
- Deleting container and image

---
## 📁 Workspace Setup

```bash
mkdir docker_day2
cd docker_day2
```

- A clean folder ensures build context is controlled
- Everything inside this directory is sent to Docker during build

---
## 📝 Dockerfile (Minimal)

```dockerfile
FROM ubuntu:22.04

CMD ["echo", "Hello from my first Docker container"]
```
### Line-by-line explanation

#### `FROM ubuntu:22.04`

- Specifies the base image
- Docker images are built **on top of other images**
    
- `ubuntu:22.04` provides:
    - Linux filesystem    
    - Core system utilities

Every Dockerfile **must** start with `FROM` (except scratch images).

---
#### `CMD ["echo", "Hello from my first Docker container"]`

- Defines the default command to run when the container starts
- Runs at **container run time**, not build time
- Executed every time `docker run` is called

Important:

- When this command finishes, the container stops
- This is expected behavior

---

## 🏗️ Building the Image

```bash
sudo docker build -t my-first-image .
```

### What happens during build

- Docker reads the Dockerfile **top to bottom**
- Each instruction creates a **layer**
- Layers are cached if unchanged

Explanation:

- `-t my-first-image` → tags (names) the image

- `.` → build context (current directory)

---
## ▶️ Running the Container

```bash
sudo docker run my-first-image
```

What happens:

1. Docker creates a new container from the image
2. Executes the `CMD`
3. Prints output    
4. Process exits
5. Container stops

This is normal and expected.

---
## 📦 Images vs Containers (Observed)

```bash
sudo docker images
sudo docker ps -a
```

Observations:

- Image exists independently of containers
- Container exists even after it stops
- Stopped containers still consume metadata

---

## 🧹 Cleanup (Important Discipline)

```bash
sudo docker rm <container_id>
sudo docker rmi my-first-image
```

Why cleanup matters:

- Prevents clutter
- Avoids confusion during debugging
- Encourages understanding of lifecycle

---
# 🧱 Dockerfile #2 — Slightly Real 

## 🎯 Objective

Move from a toy container to a **realistic Docker workflow** by:

- Creating host files
- Editing files using a terminal editor
- Copying files into an image
- Installing dependencies at build time
- Running a script inside a container

---

## 📁 Workspace Creation (Host)

```bash
cd ~ # move to home directory
mkdir docker_day2_app
cd docker_day2_app
```

Everything inside this directory becomes the **Docker build context**.

---
## 📝 Creating the Application Script (Host File)

### Command used

```bash
nano app.sh
```

### What `nano` is

- `nano` is a **terminal-based text editor**

- Used to create and edit files directly inside the terminal
### How nano works (IMPORTANT)

- You type text normally
    
- Commands are shown at the bottom with `^`

    - `^` means **Ctrl key**


Common nano commands:

- `Ctrl + O` → save (Write Out)

- `Enter` → confirm filename

- `Ctrl + X` → exit nano

---
### Content written in `app.sh`

```bash
#!/bin/bash
echo "App is running inside a Docker container"
```

Explanation:

- `#!/bin/bash` → shebang (tells Linux which interpreter to use)
    
- `echo` → prints a message to stdout

---
## 🔐 Making Script Executable (Host)

```bash
chmod +x app.sh
```

Explanation:

- Adds execute permission
- Required to run the script directly
- Without this, `/app.sh` would fail with `permission denied`

---
## ▶️ Testing Script on Host (Important)

```bash
./app.sh
```

Why this matters:

- Confirms script works **before** Docker is involved
- Avoids confusing Docker errors later

---
## 🧱 Creating Dockerfile #2

### Command used

```bash
nano Dockerfile
```

Same nano editor is used.

---
### Dockerfile content

```dockerfile
FROM ubuntu:22.04

RUN apt update && apt install -y bash

COPY app.sh /app.sh

CMD ["/app.sh"]
```

---
### `RUN apt update && apt install -y bash`

- Executed at **build time**
- Installs required dependency into the image
- Result becomes part of the image layer

Why this is `RUN`:

- Dependencies should be installed once
- Not reinstalled every container run

---
### `COPY app.sh /app.sh`

- Copies file from **build context (host)** into image filesystem

- Source file MUST exist inside the project folder

Important:

- Docker cannot copy files outside the build context

---

### `CMD ["/app.sh"]`

- Runs at **container start time**
- Executes the script inside the container
- When script exits → container stops

---
## 🏗️ Building the Image

### Command used

```bash
sudo docker build -t my-app-image .
```

Explanation:

- `sudo` → required for Docker daemon access
- `docker build` → builds image
- `-t my-app-image` → names the image
- `.` → build context (current directory)

---
## ▶️ Running the Container

### Command used

```bash
sudo docker run my-app-image
```

What happens internally:

1. Docker creates a new container from the image
2. Executes `CMD`
3. Script prints output
4. Script exits
5. Container stops

This behavior is **expected**.

---
## 📦 Inspecting Images and Containers

```bash
sudo docker images
sudo docker ps -a
```

Explanation:

- Images persist until deleted
- Containers remain in stopped state after execution
- Containers are ephemeral by default

---

# 💣 Dockerfile #3 — Intentionally Broken

## 🎯 Objective

Learn Docker by **breaking it on purpose** and fixing it logically.

Key outcomes:

- Understand difference between **build-time success** and **run-time failure**
- Learn to read Docker errors without panic
- Fix issues inside the image, not on the host

---
## 📁 Workspace Setup

```bash
cd ~
mkdir docker_day2_broken
cd docker_day2_broken
```

A fresh directory ensures:

- Clean build context
- No accidental dependency on previous files

---
## 📝 Creating the Broken Script (Host)

### Command used

```bash
nano app.sh
```
### Script content

```bash
#!/bin/bash
echo "This container should fail first, then work"
```

Important details:

- Script was intentionally **NOT** made executable
- No `chmod +x app.sh` on the host

---
## 🧱 Initial (Broken) Dockerfile

```dockerfile
FROM ubuntu:22.04

COPY app.sh /app.sh

CMD ["/app.sh"]
```

---
## 🏗️ Building the Broken Image

```bash
sudo docker build -t broken-image .
```

Observation:

- Build **succeeds**
- No errors at build time

Key insight:

> A successful build does NOT guarantee a working container

---
## ▶️ Runtime Failure (Expected)

```bash
sudo docker run broken-image
```

Observed error (example):

```
exec: "/app.sh": permission denied
```

---
## 🧠 Failure Analysis (Critical Thinking)

Questions answered:

1. Build failed or run failed? → **Run failed**
2. What was Docker trying to do? → Execute `/app.sh`
3. Docker issue or Linux issue? → **Linux permission issue**
4. Did the file have execute permission inside the image? → **No**

Key realization:

- Files copied into images do NOT automatically become executable
- Docker does not bypass Linux permissions

---
## 🔧 Fixing the Issue (Correct Way)

### Updated Dockerfile

```dockerfile
FROM ubuntu:22.04

COPY app.sh /app.sh
RUN chmod +x /app.sh

CMD ["/app.sh"]
```

Why this fix works:

- `chmod` runs at **build time**
- Execute permission is baked into the image  
- Every container created from this image can now run the script

---
## 🔁 Rebuilding After Fix

```bash
sudo docker build -t broken-image .
```

Observations:

- Docker re-runs layers affected by changes
- Cache behavior becomes visible

---
## ✅ Successful Run After Fix

```bash
sudo docker run broken-image
```

Output:

```
This container should fail first, then work
```

---

## 🧠 Key Lessons Locked In

- Most Docker errors are Linux errors

- Runtime failures require fixing the image, not the container

- Permissions must be handled explicitly

- Docker error messages are actionable if read carefully

---