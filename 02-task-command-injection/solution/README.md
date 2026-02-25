# Exercise 02 – Solution: Command Injection

## The Flaw

```python
# VULNERABLE
command = "ping -c 1 " + host
os.system(command)
```

`os.system()` passes the string to `/bin/sh -c`, which interprets shell metacharacters.
An attacker supplying `127.0.0.1; cat /etc/passwd` causes the shell to run two commands.

## The Fix

```python
# SECURE
subprocess.run(["ping", "-c", "1", host])
```

By passing a **list** to `subprocess.run()`, Python calls `execvp()` directly — no shell is spawned.
The OS treats every list element as a literal argument.
Even if `host` contains `;`, `&&`, or backticks, they reach `ping` as data, not shell syntax.

## Key Principle

> **Never concatenate user input into a shell command string.**
> Always use list-based subprocess calls, or dedicated libraries that avoid shell invocation.

## Related Vulnerabilities

- [CWE-78: Improper Neutralization of Special Elements used in an OS Command](https://cwe.mitre.org/data/definitions/78.html)
- [OWASP A05:2025 – Injection](https://owasp.org/Top10/2025/A05_2025-Injection/)
