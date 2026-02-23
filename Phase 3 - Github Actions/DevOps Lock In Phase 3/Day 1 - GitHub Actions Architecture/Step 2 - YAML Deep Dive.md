# DAY 1 — YAML Deep Dive

##### Date: 23rd February 2026

--------------------------------------------------
## What is YAML?

YAML stands for:
YAML Ain’t Markup Language

It is a human-readable data serialization format.
GitHub Actions workflows are written in YAML.

YAML is:
- Indentation sensitive
- Structure-driven
- Whitespace critical

One wrong space = entire workflow fails.


--------------------------------------------------
## 1. YAML Syntax Rules

YAML uses:

- Indentation instead of brackets
- Key: value structure
- Hyphens (-) for lists
- No tabs (only spaces)

Example:
```yaml
name: CI Pipeline
on: push
```

Important:
Tabs are invalid in YAML.
Only spaces are allowed.

--------------------------------------------------
## 2. Indentation Rules

Indentation defines hierarchy.

Correct:

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Say Hello
        run: echo "Hello"
```

Incorrect (bad indentation):

```yaml
jobs:
 build:
    runs-on: ubuntu-latest
```

YAML does not forgive indentation mistakes.


--------------------------------------------------
## 3. Mapping vs Sequence

Mapping = key-value pairs

Example:
```yaml
name: CI
on: push
```

Sequence = list of items

Example:
```yaml
branches:
  - main
  - dev
```

You can combine both:
```yaml
on:
  push:
    branches:
      - main
      - dev
```


--------------------------------------------------
## 4. Strings vs Booleans

YAML automatically interprets:
```
true → Boolean
false → Boolean
"true" → String
```

Be careful.

Example:
```yaml
flag: true      # Boolean
flag: "true"    # String
```

GitHub Actions expressions may behave differently depending on type.


--------------------------------------------------
## 5. Quoting Rules

Use quotes when:

- String contains special characters
- String contains colon
- String contains leading/trailing spaces

Example:
```yaml
run: "echo: hello"
```
Single vs Double quotes:
```yaml
'text' → literal
"text" → supports escape characters
```
Example:
```yaml
"Line\nBreak" → newline
'Line\nBreak' → prints literally
```


--------------------------------------------------
## 6. Multi-line Syntax

YAML supports two types:

```| - (Literal block)```
Preserves line breaks.

```> - (Folded block)```
Converts line breaks into spaces.

Example:

```yaml
run: |
  echo "Line 1"
  echo "Line 2"
```

This keeps both lines separate.
```yaml
run: >
  echo "Line 1"
  echo "Line 2"
```
This becomes one long command.


--------------------------------------------------
## 7. Common YAML Errors

1. Invalid indentation
2. Mixing tabs and spaces
3. Duplicate keys
4. Wrong structure (mapping vs list confusion)
5. Missing colon

Example of duplicate key error:

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    runs-on: windows-latest   # ❌ Duplicate key
```

--------------------------------------------------
## 8. Why YAML is Dangerous in CI/CD

Because:
- One indentation error stops pipeline
- Errors may not be obvious
- Complex nesting increases risk

Professional habit:
- Always align indentation
- Never use tabs
- Validate structure carefully


--------------------------------------------------
## 9. Mental Model for GitHub Actions YAML

Structure looks like:
```yaml
name:
on:
jobs:
  job_name:
    runs-on:
    steps:
      - name:
        run:
```

Everything is hierarchy.
Hierarchy = indentation.


--------------------------------------------------
## Practical Exercise (Mandatory)

You must now:

1. Create a workflow with wrong indentation.
2. Push it.
3. Observe the error message.
4. Fix it.
5. Create duplicate key error.
6. Fix it.

Do not skip this.
Breaking YAML is how you learn YAML.