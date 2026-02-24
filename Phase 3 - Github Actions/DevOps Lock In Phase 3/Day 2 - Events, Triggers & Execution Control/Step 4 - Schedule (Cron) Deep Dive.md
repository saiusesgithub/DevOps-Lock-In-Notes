# DAY 2 — Schedule (Cron) Deep Dive

#### Date: 24th February 2026

--------------------------------------------------
## Objective

Understand time-based workflow execution.
Master cron syntax.
Learn real-world edge cases.
Remove confusion about timezones.

--------------------------------------------------
## 1. What is schedule?

schedule allows workflows to run automatically at specific times.

It uses cron syntax.

Basic example:
```yml
on:
  schedule:
    - cron: '0 0 * * *'
```
This runs daily at midnight (UTC).


--------------------------------------------------
## 2. Cron Syntax Explained

Cron format:
```
* * * * *
│ │ │ │ │
│ │ │ │ └ Day of Week (0-7) (Sun = 0 or 7)
│ │ │ └ Month (1-12)
│ │ └ Day of Month (1-31)
│ └ Hour (0-23)
└ Minute (0-59)
```
Example:

'30 5 * * 1'

Means:
Every Monday at 05:30 UTC


--------------------------------------------------
## 3. Common Cron Examples
```
Every 5 minutes:
*/5 * * * *

Every day at 6 AM UTC:
0 6 * * *

Every Sunday at midnight:
0 0 * * 0

Every 1st of month at midnight:
0 0 1 * *
```

--------------------------------------------------
## 4. Important: Timezone

GitHub schedule uses:
UTC timezone only.

Not your local time.

If you are in India (UTC+5:30),
you must adjust manually.

Example:
To run at 6 AM IST,
cron should be 0 0 * * *
because 6 AM IST = 00:30 UTC (approx adjust carefully).

Always convert to UTC.


--------------------------------------------------
## 5. When Does Scheduled Workflow Run?

Important behavior:

- It runs only if workflow file exists in default branch.
- If you disable repo or no recent activity, schedule may pause.
- It does not run instantly — slight delays possible.


--------------------------------------------------
## 6. Scheduled Workflow Context

When triggered by schedule:
```yml
${{ github.event_name }} → schedule

${{ github.ref }} → default branch ref
```
No commit triggered.
No branch-specific push.


--------------------------------------------------
## 7. Combining schedule with Other Events

Example:
```yml
on:
  push:
    branches:
      - main
  schedule:
    - cron: '0 0 * * *'
```
Workflow runs:
- On push to main
- Daily at midnight UTC


--------------------------------------------------
## 8. Real-World Use Cases

schedule is used for:

- Nightly builds
- Dependency updates
- Security scans
- Cleanup tasks
- Backup automation
- Health checks
- Metrics generation


--------------------------------------------------
## 9. Edge Cases & Pitfalls

1. If workflow file is removed from default branch,
   schedule stops.

2. If repo inactive for long time,
   schedule may be disabled.

3. Cron runs in UTC only.

4. If multiple schedules defined,
   workflow runs for each matching time.


--------------------------------------------------
## 10. Advanced Pattern Example
```yml
on:
  schedule:
    - cron: '0 2 * * *'   # Nightly job
    - cron: '0 14 * * *'  # Afternoon job
```
You can detect which schedule triggered run by checking:
```
${{ github.event.schedule }}
```

--------------------------------------------------
## 11. Mandatory Experiments

1. Create workflow with schedule every 5 minutes.
2. Print ${{ github.event_name }}.
3. Print ${{ github.event.schedule }}.
4. Combine push + schedule.
5. Observe behavior differences.
6. Remove cron after testing.


--------------------------------------------------
## 12. Mental Model Upgrade

push = code-based automation

workflow_dispatch = manual automation

schedule = time-based automation

All are just different triggers
for the same execution engine.


--------------------------------------------------
## Checkpoint Questions

Answer clearly:

1. What timezone does GitHub use for cron?
2. Does schedule run on non-default branches?
3. What happens if repo is inactive?
4. Can you define multiple cron entries?
5. How do you detect that workflow was triggered by schedule?

If unsure,
repeat experiments.