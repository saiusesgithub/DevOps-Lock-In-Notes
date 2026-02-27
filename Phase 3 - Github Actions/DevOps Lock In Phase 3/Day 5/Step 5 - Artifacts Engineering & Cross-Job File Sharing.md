# DAY 5 — Artifacts Engineering & Cross-Job File Sharing

#### Date: 27th February 2026

--------------------------------------------------
## Objective

Understand artifacts.
Transfer files between jobs safely.
Control retention.
Avoid abusing cache for file sharing.

Artifacts solve job isolation.

--------------------------------------------------
## 1. Why Artifacts Exist

Jobs run on different runners.
File system is isolated.

You cannot share files directly.

Artifacts allow:
Upload in one job
Download in another job

--------------------------------------------------
## 2. Uploading Artifact

Use:
```yml
actions/upload-artifact
```
Example:
```yml
- name: Upload build output
  uses: actions/upload-artifact@<pinned-sha>
  with:
    name: build-files
    path: ./dist
```
name:
Artifact identifier.

path:
File or directory to upload.

--------------------------------------------------
## 3. Downloading Artifact

Use:
```yml
actions/download-artifact
```
Example:
```yml
- name: Download build output
  uses: actions/download-artifact@<pinned-sha>
  with:
    name: build-files
```
Files restored into working directory.

--------------------------------------------------
## 4. Basic Cross-Job Example

Job 1 (build):
- Create file: output.txt
- Upload artifact

Job 2 (deploy):
- needs: build
- Download artifact
- Read output.txt

This is proper cross-job file transfer.

--------------------------------------------------
## 5. Artifact vs Cache (Critical Difference)

Cache:
- Used for dependencies
- Key-based
- Restored automatically
- Optimizes speed

Artifact:
- Used for outputs
- Explicit upload/download
- Used for file transfer
- Part of workflow result

Never use cache to pass build artifacts.

--------------------------------------------------
## 6. Retention Period

Default retention:
90 days (depends on repo settings)

Can specify:

retention-days: 7

Example:
```yml
with:
  name: build-files
  path: ./dist
  retention-days: 5
```
--------------------------------------------------
## 7. Artifact Visibility

Artifacts visible in:
Workflow run page → Artifacts section.

Anyone with repo access can download.

Do NOT upload secrets.

--------------------------------------------------
## 8. Upload Multiple Paths

Example:
```yml
with:
  name: build-files
  path: |
    ./dist
    ./logs/output.log
```
--------------------------------------------------
## 9. Overwriting Behavior

Artifact names must be unique per run.

If same name used twice in same job:
It merges content.

--------------------------------------------------
## 10. Matrix + Artifacts

When using matrix:

Each matrix job must use unique artifact name.

Example:
```yml
name: build-${{ matrix.os }}
```
Otherwise collisions occur.

--------------------------------------------------
## 11. Large File Considerations

Artifacts have size limits.
Very large files slow upload.

Avoid:
Uploading entire workspace.
Upload only necessary output.

--------------------------------------------------
## 12. Practical Experiment

1. Job A: Create file.
2. Upload artifact.
3. Job B: Download artifact.
4. Confirm file exists.
5. Change artifact name.
6. Try downloading wrong name.
7. Add retention-days.
8. Use matrix and unique artifact names.

--------------------------------------------------
## 13. Advanced Pattern

Common CI structure:

build → upload artifact
test → download artifact
package → upload final artifact
deploy → download final artifact

Clean pipeline separation.

--------------------------------------------------
## 14. Mental Model Upgrade

Job isolation = Safety.

Artifacts = Controlled file bridge.

Cache = Performance optimization.

Do not mix purposes.

--------------------------------------------------
## 15. Checkpoint Questions

1. Why can’t jobs share files directly?
2. What is difference between cache and artifact?
3. Where are artifacts stored?
4. What is retention-days?
5. Why use unique artifact names in matrix?

If unsure, redo experiments.