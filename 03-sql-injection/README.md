# Exercise 03 – SQL Injection

**Language:** Python (SQLite) | **Level:** Beginner | **Category:** Input Validation & Injection

---

## The Scenario

You have been given a login function for a small application.
It checks a username and password against a local SQLite database.
The query is built using an f-string:

```python
query = f"SELECT * FROM users WHERE name='{username}' AND password='{password}'"
```

## Directory Contents

| File | Purpose |
|------|---------|
| `vuln_code.py` | The vulnerable script — **edit this to fix it** |
| `exploit.sh` | Validates the vulnerability (Validate step) |
| `verify_fix.sh` | Tests your fix (Test step) |
| `Dockerfile` | Container environment |
| `solution/` | Reference solution (try yourself first!) |

## Running the Exercise

1. Open up a console and terminal to run Docker commands.
   This can be a Linux or macOS terminal or a Windows Command Prompt or PowerShell or WSL terminal.

1. Enter the current directory of the exercise.

1. Build the container image:

   ```console
   docker build -t 03-sql-injection .
   ```

1. Start the container:

   ```console
   docker run --rm --name 03-sql-inject-cont -it 03-sql-injection /bin/bash
   ```

   You will get an interactive prompt inside the container:

   ```console
   root@45df6e3bc5da:/app#
   ```

1. Run the Python code:

   ```console
   root@45df6e3bc5da:/app# ls
   vuln_code.py

   root@45df6e3bc5da:/app# python vuln_code.py
   === Simple Login ===
   Username: ana
   Password: wrong
   [*] Running query: SELECT * FROM users WHERE name='ana' AND password='wrong'

   [-] Login failed. Invalid credentials.
   ```

1. Exit (and stop, and remove) the container:

   ```console
   root@45df6e3bc5da:/app#
   exit
   ```

   You will get your initial host console.

## Validating and Testing the Vulnerability

To validate and test the vulnerability, follow the steps below.
You will also follow the steps after you do the fix (see also the `Your Tasks` section below):

1. Start the container:

   ```console
   docker run --rm --name 03-sql-inject-cont -it 03-sql-injection /bin/bash
   ```

   You will get an interactive prompt inside the container:

   ```console
   root@45df6e3bc5da:/app#
   ```

1. Validate the issue using the `exploit.sh` script inside the container:

   ```console
   root@2a4db176d366:/app# ./exploit.sh
   ============================================================
    Exercise 03: SQL Injection - Exploit
   ============================================================


   [*] Normal login attempt (wrong password — should fail):
   === Simple Login ===
   Username: Password: [*] Running query: SELECT * FROM users WHERE name='alice' AND password='wrongpassword'

   [-] Login failed. Invalid credentials.

   ------------------------------------------------------------
   [*] SQL Injection — username: admin'--
   [*] The ' closes the string, -- comments out the password check!

   === Simple Login ===
   Username: Password: [*] Running query: SELECT * FROM users WHERE name='admin'--' AND password='wrongpassword'

   [+] Login successful! Welcome, admin'--.

   [!] Logged in as admin WITHOUT knowing the password!

   ------------------------------------------------------------
   [*] Another vector — OR-based bypass:
   === Simple Login ===
   Username: Password: [*] Running query: SELECT * FROM users WHERE name='admin' OR '1'='1' AND password='wrongpassword'

   [+] Login successful! Welcome, admin' OR '1'='1.

   [!] ' OR '1'='1 makes the WHERE clause always true!
   ```

1. Test the vulnerability.
   At this point, it will fail:

   ```console
   root@2a4db176d366:/app# ./verify_fix.sh
   ============================================================
    Exercise 03: SQL Injection - Verify Fix
   ============================================================


   [TEST 1] Correct credentials must still work...
     PASS: Correct credentials accepted.

   [TEST 2] Wrong password must be rejected...
     PASS: Wrong password rejected.

   [TEST 3] Classic injection (admin'--) must not bypass login...
     FAIL: SQL injection still bypasses login!

   [TEST 4] OR-based injection must be blocked...
     FAIL: OR-injection still works!

   ============================================================
    Results: 2 passed, 2 failed
   ============================================================
    Fix is incomplete. Keep trying!
    ```

1. Exit (and stop, and remove) the container:

   ```console
   root@45df6e3bc5da:/app#
   exit
   ```

   You will get your initial host console.

## Your Tasks

Follow the **Audit → Identify → Validate → Fix → Test** cycle:

1. **Audit** – Read `vuln_code.py`.
   Understand what it does.
2. **Identify** – Find the security flaw.
   What makes the query dangerous?
1. **Validate** – Build the container image.
   Start the container.
   Inside the container run the `exploit.sh` script to confirm the vulnerability exists.
   Exit the container.
1. **Fix** – Edit `vuln_code.py` to eliminate the flaw.
1. **Test** – Start the container.
   Build the container image.
   Inside the container run the `verify_fix.sh` script to confirm the vulnerability is now removed.
   Exit the container.

## Hints

<details>
<summary>Hint 1 – What is the flaw?</summary>

User-controlled strings are embedded directly inside SQL syntax:

```python
query = f"SELECT * FROM users WHERE name='{username}' AND password='{password}'"
```

If `username` is `admin'--`, the resulting SQL becomes:

```sql
SELECT * FROM users WHERE name='admin'--' AND password='anything'
```

The `--` comments out the rest of the query — the password check disappears!
</details>

<details>
<summary>Hint 2 – How to fix it?</summary>

Use **parameterized queries** (also called prepared statements). Pass user data as
parameters, separate from the SQL structure:

```python
cursor = conn.execute(
    "SELECT * FROM users WHERE name=? AND password=?",
    (username, password)
)
```

The database driver handles escaping — user input can never alter the query structure.
</details>
