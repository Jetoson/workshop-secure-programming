# Tutorial 01 – Command Injection

**Language:** Python | **Level:** Beginner | **Category:** Input Validation & Injection

---

## The Scenario

You have been given a simple administrative script used by a sysadmin to get information about a user.
The script asks for a username and shows information about the user.

## Directory Contents

| File | Purpose |
|------|---------|
| `vuln_code.py` | The vulnerable script — **edit this to fix it** |
| `exploit.sh` | Validates the vulnerability (Validate step) |
| `verify_fix.sh` | Tests your fix (Test step) |
| `Dockerfile` | Container environment |
| `solution/` | Reference solution |

## Running the Exercise

1. Open up a console and terminal to run Docker commands.
   This can be a Linux or macOS terminal or a Windows Command Prompt or PowerShell or WSL terminal.

1. Enter the current directory of the exercise.

1. Build the container image:

   ```console
   docker build -t 01-command-injection .
   ```

1. Start the container:

   ```console
   docker run --rm --name 01-command-inject-cont -it 01-command-injection /bin/bash
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
   Enter username: root
   [*] Running: id root
   uid=0(root) gid=0(root) groups=0(root)
   ```

1. Exit (and stop, and remove) the container:

   ```console
   root@45df6e3bc5da:/app#
   exit
   ```

   You will get your initial host console.

## Validating and Testing the Vulnerability

To validate and test the vulnerability, follow the steps below.
You will also follow the steps after you do the fix (see also the `Action Points` section below):

1. Start the container:

   ```console
   docker run --rm --name 01-command-inject-cont -it 01-command-injection /bin/bash
   ```

   You will get an interactive prompt inside the container:

   ```console
   root@45df6e3bc5da:/app#
   ```

1. Run the `vuln_code.py` Python script:

   ```console
   root@45df6e3bc5da:/app# python vuln_code.py
   ```

1. Pass to the Python script an exploit payload: `root ; cat /etc/passwd`.
   This exploit payload is a string that will inject the command `cat /etc/passwd` to the script and cause it to print the contents of the `/etc/passwd` file:

   ```console
   Enter username: root ; cat /etc/passwd
   [*] Running: id root ; cat /etc/passwd
   uid=0(root) gid=0(root) groups=0(root)
   root:x:0:0:root:/root:/bin/bash
   daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
   bin:x:2:2:bin:/bin:/usr/sbin/nologin
   sys:x:3:3:sys:/dev:/usr/sbin/nologin
   sync:x:4:65534:sync:/bin:/bin/sync
   games:x:5:60:games:/usr/games:/usr/sbin/nologin
   man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
   lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
   mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
   news:x:9:9:news:/var/spool/news:/usr/sbin/nologin
   uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin
   proxy:x:13:13:proxy:/bin:/usr/sbin/nologin
   www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
   backup:x:34:34:backup:/var/backups:/usr/sbin/nologin
   list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin
   irc:x:39:39:ircd:/run/ircd:/usr/sbin/nologin
   _apt:x:42:65534::/nonexistent:/usr/sbin/nologin
   nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin
   ```

   This is a command injection attack.
   We are able to abuse an insecure program and cause the `cat /etc/passwd` command to be injected and then run by the vulnerable program.

1. Try another approach.
   Run the Python script and pass another exploit payload to it: `root && cat /etc/passwd`:

   ```console
   root@45df6e3bc5da:/app# python vuln_code.py
   Enter username: root && cat /etc/passwd
   [*] Running: id root && cat /etc/passwd
   uid=0(root) gid=0(root) groups=0(root)
   root:x:0:0:root:/root:/bin/bash
   daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
   bin:x:2:2:bin:/bin:/usr/sbin/nologin
   sys:x:3:3:sys:/dev:/usr/sbin/nologin
   sync:x:4:65534:sync:/bin:/bin/sync
   games:x:5:60:games:/usr/games:/usr/sbin/nologin
   man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
   lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
   mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
   news:x:9:9:news:/var/spool/news:/usr/sbin/nologin
   uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin
   proxy:x:13:13:proxy:/bin:/usr/sbin/nologin
   www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
   backup:x:34:34:backup:/var/backups:/usr/sbin/nologin
   list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin
   irc:x:39:39:ircd:/run/ircd:/usr/sbin/nologin
   _apt:x:42:65534::/nonexistent:/usr/sbin/nologin
   nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin
   ```

   Yet again we did a command injection attack and we are able to abuse an insecure program and cause the `cat /etc/passwd` command to be injected and then run by the vulnerable program.

1. Try yet another approach.
   Run the Python script and pass another exploit payload to it: `root | cat /etc/passwd`:

   ```console
   root@45df6e3bc5da:/app# python vuln_code.py
   Enter username: root | cat /etc/passwd
   [*] Running: id root | cat /etc/passwd
   root:x:0:0:root:/root:/bin/bash
   daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
   bin:x:2:2:bin:/bin:/usr/sbin/nologin
   sys:x:3:3:sys:/dev:/usr/sbin/nologin
   sync:x:4:65534:sync:/bin:/bin/sync
   games:x:5:60:games:/usr/games:/usr/sbin/nologin
   man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
   lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
   mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
   news:x:9:9:news:/var/spool/news:/usr/sbin/nologin
   uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin
   proxy:x:13:13:proxy:/bin:/usr/sbin/nologin
   www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
   backup:x:34:34:backup:/var/backups:/usr/sbin/nologin
   list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin
   irc:x:39:39:ircd:/run/ircd:/usr/sbin/nologin
   _apt:x:42:65534::/nonexistent:/usr/sbin/nologin
   nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin
   id: write error: Broken pipe
   ```

   Yet again we did a command injection attack and we are able to abuse an insecure program and cause the `cat /etc/passwd` command to be injected and then run by the vulnerable program.

   Ignore the `id: write error` message at the end.
   It's caused by the command `id` writing its output to a pipe that nobody reads from;
   it doesn't affect our exploit.

Keep the container running for the automation steps below.

## Automate the Validating and Testing of the Vulnerability

To automate the process of validating and testing the vulnerability, we have two scripts to use: `exploit.sh` and `verify_fix.sh`.

1. Inside the container, use the `exploit.sh` script to validate the issue:

   ```console
   root@45df6e3bc5da:/app# ./exploit.sh
   ============================================================
    Tutorial 01: Command Injection - Exploit
   ============================================================


   [*] Normal use - querying about user root:
   Enter username: [*] Running: id root
   uid=0(root) gid=0(root) groups=0(root)

   ------------------------------------------------------------
   [*] Injecting payload: root ; cat /etc/passwd
   [*] The semicolon ends the ping command and starts a new one!

   Enter username: [*] Running: id root ; cat /etc/passwd
   uid=0(root) gid=0(root) groups=0(root)
   root:x:0:0:root:/root:/bin/bash
   daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
   bin:x:2:2:bin:/bin:/usr/sbin/nologin
   sys:x:3:3:sys:/dev:/usr/sbin/nologin
   sync:x:4:65534:sync:/bin:/bin/sync
   games:x:5:60:games:/usr/games:/usr/sbin/nologin
   man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
   lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
   mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
   news:x:9:9:news:/var/spool/news:/usr/sbin/nologin
   uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin
   proxy:x:13:13:proxy:/bin:/usr/sbin/nologin
   www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
   backup:x:34:34:backup:/var/backups:/usr/sbin/nologin
   list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin
   irc:x:39:39:ircd:/run/ircd:/usr/sbin/nologin
   _apt:x:42:65534::/nonexistent:/usr/sbin/nologin
   nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin

   [!] We just read /etc/passwd by injecting into the id command!
   ```

   As you can see, the `exploit.sh` script automates the passing the exploit payload (`root ; cat /etc/passwd`).
   So we inject the `cat /etc/passwd` command to the Python script and cause the contents of the `/etc/passwd` file to be shown.

1. Inside the container, use the `verify_fix.sh` script to test the issue:

   ```console
   root@45df6e3bc5da:/app# ./verify_fix.sh
   ============================================================
    Tutorial 01: Command Injection - Verify Fix
   ============================================================


   [TEST 1] Normal input should still work...
     PASS: Normal id works correctly.

   [TEST 2] Injection payload must NOT execute secondary command...
     FAIL: Injection still works! The fix is incomplete.

   [TEST 3] Another injection vector (&&)...
     FAIL: '&&' injection still works!

   ============================================================
    Results: 1 passed, 2 failed
   ============================================================
    Fix is incomplete. Keep trying!
   ```

   As we can see, two tests failed.
   That means we were able to inject a command to the vulnerable Python script.
   We need to fix the script to remove the vulnerability and pass all three tests.

1. Exit (and stop, and remove) the container:

   ```console
   root@45df6e3bc5da:/app#
   exit
   ```

   You will get your initial host console.

## Fixing the Vulnerability and Validating the Fix

### The Issue

The issue in the code is here:

```python
command = "id " + user
print(f"[*] Running: {command}")
os.system(command)
```

`os.system()` passes the string to `/bin/sh -c`, which interprets shell metacharacters.
An attacker supplying `id root ; cat /etc/passwd` causes the shell to run two commands.
Similarly if the attacker supplies `id root && cat /etc/passwd` or `id root | cat /etc/passwd`.
This is because the `;`, `&&`, `|` constructs have a special role that the shell interprets as joining two commands together.

### Fix Idea

We need to disable the passing of the command to the shell.
We want to call the operating system directly, and pass it the command, such that the shell won't be involved in interpreting it wrongly.

### The Fix

To call the operating system directly, we use the `subprocess.run()` command.
Because this command calls the shell directly:

```python
# SECURE
subprocess.run(["id", user])
```

By passing a **list** to `subprocess.run()`, Python calls `execvp()` directly - no shell is spawned.
The OS treats every list element as a literal argument.
Even if `host` contains `;`, `&&`, or backticks, they reach `ping` as data, not shell syntax.

### Action Points

To apply the fix, we do the following:

1. Edit the `vuln_code.py` program use `subprocess.run()` instead of `os.system`.
   The new code will have some removed lines and some added lines, as below:

   ```diff
   -import os
   +import subprocess


   def get_user(user):
       """Get informataion about a user."""
   -   command = "id " + user
   -   print(f"[*] Running: {command}")
   -   os.system(command)
   +   result = subprocess.run(
   +       ["id", user],
   +       capture_output=True,
   +       text=True,
   +   )
   ```

1. Build the container image with the updated `vuln_code.py` file.

1. Start the container.

1. Run the manual step of testing the vulnerability.
   Run the script and pass it different variants of exploit payloads.
   In case of a successful solution (and removal of the vulnerability), you won't be able to inject commands to the script:

   ```console
   root@45df6e3bc5da:/app# python vuln_code.py
   Enter username: root ; cat /etc/passwd
   [*] Getting information about: root ; cat /etc/passwd
   [-] No such user.

   root@45df6e3bc5da:/app# python vuln_code.py
   Enter username: root && cat /etc/passwd
   [*] Getting information about: root && cat /etc/passwd
   [-] No such user.

   root@45df6e3bc5da:/app# python vuln_code.py
   Enter username: root | cat /etc/passwd
   [*] Getting information about: root | cat /etc/passwd
   [-] No such user.
   ```

1. Verify the new file by running the `verify_fix.sh` script inside the container.
   In case of a successful solution, all 3 tests in the `verify_fix.sh` script will work:

   ```console
   root@45df6e3bc5da:/app# ./verify_fix.sh
   ============================================================
    Tutorial 01: Command Injection - Verify Fix
   ============================================================


   [TEST 1] Normal input should still work...
     PASS: Normal id works correctly.

   [TEST 2] Injection payload must NOT execute secondary command...
     PASS: Injection payload was not executed.

   [TEST 3] Another injection vector (&&)...
     PASS: '&&' injection was blocked.

   ============================================================
    Results: 3 passed, 0 failed
   ============================================================
    All tests passed! Great work.
   ```

## Related Vulnerabilities

- [CWE-78: Improper Neutralization of Special Elements used in an OS Command](https://cwe.mitre.org/data/definitions/78.html)
- [OWASP A05:2025 – Injection](https://owasp.org/Top10/2025/A05_2025-Injection/)
