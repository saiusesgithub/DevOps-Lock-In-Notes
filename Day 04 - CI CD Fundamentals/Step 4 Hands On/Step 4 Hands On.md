# 🧪 DevOps Day 4 — Hands‑on Commands & Notes (Step 4 → Step 6)

> This document captures **only what you actually DID**, not theory.
> Purpose: quick revision + proof of hands‑on CI understanding.

---

## STEP 4 — CI PIPELINE CREATION (HANDS‑ON)

### 1️⃣ Create GitHub Actions directory structure

```powershell
mkdir .github
mkdir .github\workflows
```

**Why:**
GitHub Actions only reads workflows from `.github/workflows/`.
Anything outside this path is ignored.

---

### 2️⃣ Create the CI workflow file

```powershell
New-Item .github\workflows\ci.yml
```

**Why:**
This file defines the CI pipeline. No file → no CI.

---

### 3️⃣ Write the CI workflow (incrementally)

```yaml
name: day 4 CI pipeline

on:
  push:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Build Docker image
        run: docker build -t day4image .
```

**What this means:**

* `on: push` → every push triggers CI
* `build` job → one Ubuntu VM
* `checkout` → repo copied into VM
* `docker build` → CI enforces Dockerfile correctness

---

### 4️⃣ Commit and push CI workflow

```powershell
git add .github/workflows/ci.yml
git commit -m "Add basic CI pipeline to build Docker image"
git push
```

**Result:**

* CI triggered automatically
* Pipeline ran on GitHub runner
* Docker image built successfully (green ✅)

---

## STEP 6 — BREAK & FIX THE PIPELINE (MANDATORY FAILURE)

### 5️⃣ Intentionally break Dockerfile

Changed Dockerfile:

```dockerfile
COPY app.sh /app.sh
```

⬇️ to

```dockerfile
COPY app1.sh /app.sh
```

**Why:**
`app1.sh` does not exist → Docker build must fail.

---

### 6️⃣ Commit and push the broken change

```powershell
git add Dockerfile
git commit -m "Intentionally break Docker build to test CI failure"
git push
```

**CI Result:**

* ❌ Pipeline failed
* Error from Docker:

  ```
  COPY failed: file not found
  Process completed with exit code 1
  ```

**Key lesson:**
CI fails because Docker returned a non‑zero exit code.

---

### 7️⃣ Fix the Dockerfile

Restored correct line:

```dockerfile
COPY app.sh /app.sh
```

---

### 8️⃣ Commit and push the fix

```powershell
git add Dockerfile
git commit -m "Fix Dockerfile copy path to restore CI build"
git push
```

**Result:**

* New CI run triggered
* Docker build succeeded
* Pipeline turned green again ✅

---

## 🔒 FINAL LOCKED LEARNINGS (FROM HANDS‑ON)

* CI runs on a **fresh Ubuntu VM** every push
* Repo contents are the **only source of truth**
* Docker build failure → CI failure
* CI failures are just **logs + exit codes**
* Red ❌ → fix → green ✅ is the core CI loop

---

## ✅ End of Step 4–6 Hands‑on Notes

This document is a **practical reference**, not theory.
Use it to rebuild CI from memory later.
