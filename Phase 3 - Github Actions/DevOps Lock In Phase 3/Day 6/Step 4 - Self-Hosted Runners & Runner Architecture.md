# DAY 6 — Self-Hosted Runners & Runner Architecture

#### Date: 28th February 2026

--------------------------------------------------
## Objective

Understand self-hosted runners.
Learn scaling models.
Compare hosted vs self-hosted.
Think infrastructure-level.

This is where CI meets infrastructure.

--------------------------------------------------
## 1. What is a Self-Hosted Runner?

A machine you manage
that executes GitHub Actions jobs.

Instead of:
```yml
runs-on: ubuntu-latest
```
You use:
```yml
runs-on: self-hosted
```
GitHub sends job to your machine.

--------------------------------------------------
## 2. Why Use Self-Hosted Runners?

Reasons:

- Custom hardware requirements
- Access to private network
- Access to internal databases
- GPU workloads
- Large memory requirements
- Compliance constraints
- Cost optimization

--------------------------------------------------
## 3. How Self-Hosted Runner Works

1. You install runner agent on machine.
2. Runner registers with GitHub.
3. GitHub assigns jobs to it.
4. Runner executes steps locally.

Runner pulls jobs from GitHub.

--------------------------------------------------
## 4. Self-Hosted vs GitHub-Hosted

GitHub-hosted:
- Ephemeral
- Clean environment each run
- Fully managed
- No maintenance

Self-hosted:
- Persistent
- You manage updates
- Can retain state
- Must secure manually

--------------------------------------------------
## 5. Security Risks

Self-hosted runner:

- Has access to your infrastructure
- Can access secrets
- Can access internal network

If workflow compromised,
attacker may pivot into infra.

You must isolate carefully.

--------------------------------------------------
## 6. Runner Labels

Self-hosted runners can have labels.

Example:
```yml
runs-on: [self-hosted, linux, gpu]
```
This targets specific machine.

Useful when multiple runners exist.

--------------------------------------------------
## 7. Persistent Environment Risks

Since runner is not ephemeral:

Files from previous job may remain.

You must:

- Clean workspace manually
- Use isolated directories
- Harden environment

--------------------------------------------------
## 8. Autoscaling Self-Hosted Runners

Enterprise setups use:

- Kubernetes-based runners
- Ephemeral containers
- Cloud auto-scaling groups

Pattern:

GitHub job triggers
→ Infra spins up runner
→ Job executes
→ Runner destroyed

This mimics hosted behavior.

--------------------------------------------------
## 9. ARC (Actions Runner Controller)

GitHub provides:

Actions Runner Controller (ARC)

Used in Kubernetes
to manage scalable runner fleets.

Enterprise CI architecture.

--------------------------------------------------
## 10. Network Access Control

Best practice:

Self-hosted runners should:
- Not expose production secrets unnecessarily
- Be isolated in network
- Use firewall rules
- Use least privilege credentials

--------------------------------------------------
## 11. Performance Considerations

Self-hosted runner advantages:

- Larger CPU
- More RAM
- Preinstalled tools
- Faster disk

But:
You must maintain.

--------------------------------------------------
## 12. Concurrency With Self-Hosted

If only 1 runner machine:

Only 1 job can run at a time.

Jobs queue until runner free.

Scaling requires:
Multiple runner instances.

--------------------------------------------------
## 13. Security Best Practices

- ✓ Separate runner for prod vs CI
- ✓ Do not run untrusted PRs on self-hosted
- ✓ Use GitHub-hosted for forks
- ✓ Disable persistent credentials
- ✓ Monitor runner activity

--------------------------------------------------
## 14. Practical Experiment (Conceptual)

1. Register test self-hosted runner (if possible).
2. Create workflow using runs-on: self-hosted.
3. Observe job execution on machine.
4. Print hostname to confirm.
5. Create label and target specific runner.

If not possible physically:
Understand architecture thoroughly.

--------------------------------------------------
## 15. Mental Model Upgrade

GitHub-hosted = Managed VM

Self-hosted = Your infrastructure node

Runner = Execution agent

Scaling = Infrastructure problem

CI now intersects with cloud architecture.

--------------------------------------------------
## 16. Checkpoint Questions

1. Who maintains self-hosted runner?
2. Are self-hosted runners ephemeral?
3. What are risks of persistent state?
4. How do labels work?
5. Why avoid running untrusted PRs on self-hosted?

If unsure, review architecture.

--------------------------------------------------
## End of Day 6 Outcome

You now understand:

- Concurrency control
- Cancellation behavior
- Manual dispatch engineering
- Debugging & observability
- Self-hosted runner architecture

You understand execution at scale.