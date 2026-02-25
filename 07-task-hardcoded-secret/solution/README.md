# Exercise 07 – Solution: Hardcoded Secret

## The Flaw

```python
# VULNERABLE
API_KEY = "sk_live_SUPER_SECRET_12345ABCDE"
```

The secret is a string literal in source code.
It is visible to:
- Anyone with read access to the file or repository
- Git history scanners (even after the line is deleted in a later commit)
- CI/CD build logs that echo source files
- Code search engines that index public repositories

## The Fix

```python
# SECURE
import os
API_KEY = os.getenv("API_KEY")
if not API_KEY:
    raise EnvironmentError("API_KEY environment variable is not set!")
```

The key is injected at runtime via the environment:

```console
export API_KEY="sk_live_SUPER_SECRET_12345ABCDE"
python3 fixed_code.py
```

## Key Principles

> **Secrets must never appear in source code.**
> Use environment variables for development; use a secrets manager in production.
> If a secret is ever committed, rotate it immediately — deletion is not enough.

## Related Vulnerabilities

- [CWE-798: Use of Hard-coded Credentials](https://cwe.mitre.org/data/definitions/798.html)
- [OWASP A04:2025 – Cryptographic Failures](https://owasp.org/Top10/2025/A04_2025-Cryptographic_Failures/)
