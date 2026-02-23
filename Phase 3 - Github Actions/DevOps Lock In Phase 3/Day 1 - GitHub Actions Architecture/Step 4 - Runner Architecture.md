# DAY 1 — Runner Architecture Deep Dive

#### Date: 23rd February 2026

--------------------------------------------------
## Objective

Understand where your workflow actually runs.
Remove the "magic" feeling.
Understand infrastructure layer behind GitHub Actions.

--------------------------------------------------
## 1. What is a Runner?

A Runner is a machine that executes your workflow jobs.

When you define:
```yml
runs-on: ubuntu-latest
```
You are requesting a machine environment.

This machine:
- Executes your steps
- Runs shell commands
- Installs dependencies
- Produces logs

Runner = Execution Engine


--------------------------------------------------
## 2. Types of Runners

There are two major types:

1. GitHub-Hosted Runner
2. Self-Hosted Runner

### GitHub-Hosted Runner

- Managed by GitHub
- Automatically provisioned
- Pre-installed with common tools
- Ephemeral (temporary)
- Runs in GitHub’s cloud infrastructure

Examples:
- ubuntu-latest
- windows-latest
- macos-latest


### Self-Hosted Runner

- Installed by you
- Runs on your own machine/server
- You manage updates
- You control environment

Used in:
- Enterprises
- Internal networks
- Secure systems


--------------------------------------------------
## 3. What is ubuntu-latest?

ubuntu-latest is a GitHub-hosted virtual machine image.

It is:
- A fresh Linux VM
- Provisioned on demand
- Has pre-installed tools (git, docker, python, node, etc.)
- Destroyed after job completes

Important:
It is NOT persistent.
It is NOT your laptop.
It is NOT a shared server.

Each job = new VM.


--------------------------------------------------
## 4. What Does "Ephemeral" Mean?

Ephemeral means temporary.

When a workflow starts:
- A VM is created.
- Your job runs.
- After job finishes, VM is destroyed.

No state is saved.
No memory persists.
Filesystem is wiped.

This ensures:
- Clean environment every run
- No cross-run contamination


--------------------------------------------------
## 5. Does State Persist?

Within same job:
- YES
- Files created in Step 1 exist in Step 2.

Across different jobs:
- NO
- Each job runs on separate VM.
- Filesystem is isolated.

Across different workflow runs:
- NEVER
- Everything is destroyed.


--------------------------------------------------
## 6. How Long Does Runner Live?

Runner lives only during job execution.

Lifecycle:

1. Workflow triggered
2. GitHub allocates VM
3. Job runs
4. Steps execute
5. Job completes
6. VM destroyed

Duration:
Only as long as job runs.


--------------------------------------------------
## 7. What Happens Internally When You Push?
```
Push to main branch
→ GitHub detects push event
→ Checks workflow YAML
→ Determines jobs
→ Allocates runner VM
→ Clones repo (checkout step)
→ Executes steps sequentially
→ Streams logs back to GitHub UI
→ Marks job status
→ Destroys VM
```

--------------------------------------------------
## 8. Why actions/checkout Is Required

By default:
Runner VM does NOT have your repository code.

It is an empty machine.

actions/checkout:
- Clones your repo into runner
- Makes files available
- Required for most CI tasks

If removed:
- ls will show empty directory
- Code won’t exist


--------------------------------------------------
## 9. Why Runner Isolation Is Important

Isolation ensures:

- Security between jobs
- No data leaks
- Reproducibility
- Clean state every time

If runners were persistent:
- Bugs could depend on leftover files
- Security risk increases


--------------------------------------------------
## 10. Professional Insight

Most beginners think:
"GitHub is running my code somewhere."

Correct thinking:
"GitHub dynamically provisions a cloud VM per job, executes YAML-defined instructions, then destroys infrastructure."

That is Infrastructure as Automation.


--------------------------------------------------
## Mandatory Experiment (Do This)

Create 2 jobs:

```yaml
jobs:
  job1:
    runs-on: ubuntu-latest
    steps:
      - run: echo "hello" > file.txt

  job2:
    runs-on: ubuntu-latest
    needs: job1
    steps:
      - run: cat file.txt
```
Push.

Observe:
job2 fails.

Reason:
Separate runner.
Separate filesystem.


--------------------------------------------------
## Mental Model Upgrade

Workflow = Blueprint
Runner = Temporary Machine
Job = Isolated Execution Unit
Step = Command inside machine

Push Event = Trigger Signal


--------------------------------------------------
## Checkpoint Questions

Answer these without guessing:

1. Does ubuntu-latest persist after job?
2. Can Job A access Job B’s files?
3. Why is checkout needed?
4. What guarantees clean environment every run?
5. What is difference between hosted and self-hosted runner?

If you cannot answer clearly,
you still think GitHub Actions is magic.