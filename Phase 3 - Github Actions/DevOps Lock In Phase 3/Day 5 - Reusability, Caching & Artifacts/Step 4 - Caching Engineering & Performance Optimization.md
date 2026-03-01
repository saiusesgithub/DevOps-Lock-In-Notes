# DAY 5 — Caching Engineering & Performance Optimization

#### Date: 27th February 2026

--------------------------------------------------
## Objective

Understand how caching works internally.
Design safe cache keys.
Avoid cache poisoning.
Control cache invalidation.

Fast pipelines are engineered, not accidental.

--------------------------------------------------
## 1. Why Caching Exists

CI runners are ephemeral.
Every job starts fresh.

Without caching:
Dependencies reinstall every run.

Caching reduces:
- Network calls
- Install time
- Build time

--------------------------------------------------
## 2. actions/cache Overview

Common usage:
```yml
- uses: actions/cache@<pinned-sha>
  with:
    path: ~/.npm
    key: ${{ runner.os }}-npm-${{ hashFiles('**/package-lock.json') }}
```
path:
Directory to cache.

key:
Unique identifier.

--------------------------------------------------
## 3. How Cache Actually Works

When job runs:

1. GitHub checks if cache key exists.
2. If match found → restore cache.
3. If not found → job runs normally.
4. After job → cache saved (if new key).

Cache tied to repository.

--------------------------------------------------
## 4. Cache Key Design (Critical)

Key must uniquely represent dependency state.

Good key example:
```yml
${{ runner.os }}-npm-${{ hashFiles('**/package-lock.json') }}
```
Why:
- OS matters
- Dependency file hash matters

If lock file changes → new key.

--------------------------------------------------
## 5. hashFiles Function
```
hashFiles('path')
```
Generates hash of file contents.

Used to:
Invalidate cache automatically
when dependencies change.

--------------------------------------------------
## 6. Restore Keys (Fallback Strategy)

Example:
```yml
restore-keys: |
  ${{ runner.os }}-npm-
```
If exact key not found:
GitHub looks for prefix match.

Useful for partial cache restore.

--------------------------------------------------
## 7. Cache Scope Rules

Cache is scoped by:

- Repository
- Branch
- Key

Pull requests can read cache
but behavior differs slightly.

--------------------------------------------------
## 8. Cache Poisoning Risk

If key too generic:
```yml
key: build-cache
```
All branches share same cache.

Danger:
One branch corrupts cache for others.

Always include:
Branch or hash-based uniqueness.

--------------------------------------------------
## 9. Matrix + Cache

When using matrix:
```yml
key: ${{ runner.os }}-${{ matrix.version }}-${{ hashFiles('**/lockfile') }}
```
Ensures each matrix variant gets proper cache.

--------------------------------------------------
## 10. Cache Limits

GitHub cache size limit:
10GB per repository (subject to plan).

Old caches evicted automatically.

--------------------------------------------------
## 11. When Cache is Saved

Cache saved only if:
Job completes successfully.

If job fails:
Cache may not update.

--------------------------------------------------
## 12. Common Mistakes

❌ Caching entire workspace
❌ Not including OS in key
❌ Not using hashFiles
❌ Using static key
❌ Forgetting restore-keys

--------------------------------------------------
## 13. Example Full Cache Pattern
```yml
steps:
  - uses: actions/checkout@<sha>

  - uses: actions/cache@<sha>
    with:
      path: ~/.npm
      key: ${{ runner.os }}-npm-${{ hashFiles('**/package-lock.json') }}
      restore-keys: |
        ${{ runner.os }}-npm-

  - run: npm install
```
--------------------------------------------------
## 14. Performance Measurement Experiment

1. Run pipeline without cache.
2. Measure install time.
3. Add cache.
4. Run again.
5. Compare time.
6. Modify lock file.
7. Observe cache invalidation.
8. Remove restore-keys.
9. Observe strict matching.

--------------------------------------------------
## 15. Mental Model Upgrade

Cache = Remote storage tied to key.

Key = Fingerprint of dependency state.

hashFiles = Automatic invalidation engine.

Good cache design:
Fast + Correct + Isolated.

--------------------------------------------------
## 16. Checkpoint Questions

1. When is cache restored?
2. When is cache saved?
3. Why include OS in key?
4. What does hashFiles prevent?
5. What is restore-keys for?

If unsure, redo experiments.