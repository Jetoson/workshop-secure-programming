# Exercise 03 – Solution: SQL Injection

## The Flaw

```python
# VULNERABLE — user data embedded in SQL string
query = f"SELECT * FROM users WHERE name='{username}' AND password='{password}'"
conn.execute(query)
```

When `username = "admin'--"`, the query becomes:

```sql
SELECT * FROM users WHERE name='admin'--' AND password='irrelevant'
```

The `--` starts a SQL comment.
Everything after it is ignored — the password check is gone.

## The Fix

```python
# SECURE — parameterized query
cursor = conn.execute(
    "SELECT * FROM users WHERE name=? AND password=?",
    (username, password)
)
```

SQLite (and every modern database driver) handles binding: it sends the query structure and the data separately to the database engine.
The engine never interprets data as SQL.

## Key Principle

> **Never build SQL queries by concatenating or formatting user input.**
> Always use parameterized queries / prepared statements.

## Related Vulnerabilities

- [CWE-89: Improper Neutralization of Special Elements in SQL Commands](https://cwe.mitre.org/data/definitions/89.html)
- [OWASP A05:2025 – Injection](https://owasp.org/Top10/2025/A05_2025-Injection/)
