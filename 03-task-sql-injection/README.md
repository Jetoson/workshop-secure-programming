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

1. Run the `vuln_code.py` Python script:

   ```console
   root@45df6e3bc5da:/app# python vuln_code.py
   ```

1. Use `admin' -- dontcare` as username (to the `Username:` prompt).
   And any string as password (to the `Password:` prompt), e.g. `aaa`.
   This weird username string injects a exploit payload to the SQL intepreter used by the Python script.

   ```console
   === Simple Login ===
   Username: admin' -- dontcare
   Password: aaa
   [*] Running query: SELECT * FROM users WHERE name='admin' -- dontcare' AND password='aaa'

   [+] Login successful! Welcome, admin' -- dontcare.
   ```

   This is an SQL injection attack.
   We are able to abuse an insecure program and cause the login to happen even though we didn't provide the correct password.
   We did this by injecting the `--` string which is a comment in SQL.
   This means that everything after this string is ignored;
   this includes the checking of the password;
   so, irrespective of the password we provide, we will always be able to log in.

1. Try another approach.
   Run the Python script and use `admin' OR '1'='1` as username (to the `Username:` prompt).
   And any string as password (to the `Password:` prompt), e.g. `aaa`.
   This weird username string injects a exploit payload to the SQL intepreter used by the Python script.

   ```console
   root@45df6e3bc5da:/app# python vuln_code.py
   === Simple Login ===
   Username: admin' OR '1'='1
   Password: aaa
   [*] Running query: SELECT * FROM users WHERE name='admin' OR '1'='1' AND password='aaa'

   [+] Login successful! Welcome, admin' OR '1'='1.
   ```

   Yet again we did an SQL injection attack and we are able to abuse an insecure program and cause the login to happen even though we didn't provide the correct password.
   We did this by injecting an `OR '1'='1'` string to the `select` SQL command.
   This evaluates always to true;
   so, irrespective of the password we provide, we will always be able to log in.

Keep the container running for the automation steps below.

## Automate the Validating and Testing of the Vulnerability

To automate the process of validating and testing the vulnerability, we have two scripts to use: `exploit.sh` and `verify_fix.sh`.

1. Inside the container, use the `exploit.sh` script to validate the issue:

   ```console
   root@45df6e3bc5da:/app# ./expoit.sh
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

   As you can see, the `exploit.sh` script automates the passing the exploit payloads.
   Both types of SQL payloads shown above are passed: the `--` comment string and the `'1'='1'` "always true" expression.
   With these payloads, the script is able to log in successfully, without supplying the correct password.

1. Inside the container, use the `verify_fix.sh` script to test the issue:

   ```console
   root@45df6e3bc5da:/app# ./verify_fix.sh
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

   As we can see, two tests failed.
   That means we were able to inject parts SQL query to the vulnerable Python script and cause of a successful login without providing a correct password.
   We need to fix the script to remove the vulnerability and pass all three tests.

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
1. **Identify** – Find the security flaw.
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

If everything is OK (and you fixed the program and removed the vulnerability), all 4 tests in the `verify_fix.sh` script will pass:

```console
root@45df6e3bc5da:/app# ./verify_fix.sh
============================================================
 Exercise 03: SQL Injection - Verify Fix
============================================================


[TEST 1] Correct credentials must still work...
  PASS: Correct credentials accepted.

[TEST 2] Wrong password must be rejected...
  PASS: Wrong password rejected.

[TEST 3] Classic injection (admin'--) must not bypass login...
  PASS: SQL injection rejected.

[TEST 4] OR-based injection must be blocked...
  PASS: OR-injection blocked.

============================================================
 Results: 4 passed, 0 failed
============================================================
 All tests passed! Great work.
```

## Hints

<details>
<summary>Hint 1 - What is the flaw?</summary>

User-controlled strings are embedded directly inside SQL syntax:

```python
query = f"SELECT * FROM users WHERE name='{username}' AND password='{password}'"
```

If `username` is `admin'--`, the resulting SQL becomes:

```sql
SELECT * FROM users WHERE name='admin'--' AND password='anything'
```

The `--` comments out the rest of the query - the password check disappears!
</details>

<details>
<summary>Hint 2 - How to fix it?</summary>

Use **parameterized queries** (also called prepared statements).
Pass user data as parameters, separate from the SQL structure:

```python
cursor = conn.execute(
    "SELECT * FROM users WHERE name=? AND password=?",
    (username, password)
)
```

The database driver handles escaping - user input can never alter the query structure.
</details>
