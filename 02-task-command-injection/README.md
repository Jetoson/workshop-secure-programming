# Exercise 02 – Command Injection

**Language:** Python | **Level:** Beginner | **Category:** Input Validation & Injection

---

## The Scenario

You have been given a simple administrative script used by a sysadmin to check if a remote server is reachable.
The script asks for an IP address and pings it.

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
   docker build -t 02-command-injection .
   ```

1. Start the container:

   ```console
   docker run --rm --name 02-command-inject-cont -it 02-command-injection /bin/bash
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
   Enter IP address to ping: 8.8.8.8
   [*] Running: ping -c 1 8.8.8.8
   PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
   64 bytes from 8.8.8.8: icmp_seq=1 ttl=116 time=25.5 ms

   --- 8.8.8.8 ping statistics ---
   1 packets transmitted, 1 received, 0% packet loss, time 0ms
   rtt min/avg/max/mdev = 25.499/25.499/25.499/0.000 ms
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
   docker run --rm --name 02-command-inject-cont -it 02-command-injection /bin/bash
   ```

   You will get an interactive prompt inside the container:

   ```console
   root@45df6e3bc5da:/app#
   ```

1. Run the `vuln_code.py` Python script:

   ```console
   root@45df6e3bc5da:/app# python vuln_code.py
   ```

1. Pass to the Python script an exploit payload: `127.0.0.1 ; cat /etc/passwd`.
   This exploit payload is a string that will inject the command `cat /etc/passwd` to the script and cause it to print the contents of the `/etc/passwd` file:

   ```console
   Enter IP address to ping: 127.0.0.1 ; cat /etc/passwd
   [*] Running: ping -c 1 127.0.0.1 ; cat /etc/passwd
   PING 127.0.0.1 (127.0.0.1) 56(84) bytes of data.
   64 bytes from 127.0.0.1: icmp_seq=1 ttl=64 time=0.024 ms

   --- 127.0.0.1 ping statistics ---
   1 packets transmitted, 1 received, 0% packet loss, time 0ms
   rtt min/avg/max/mdev = 0.024/0.024/0.024/0.000 ms
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
   Run the Python script and pass another exploit payload to it: `127.0.0.1 && cat /etc/passwd`:

   ```console
   root@45df6e3bc5da:/app# python vuln_code.py
   Enter IP address to ping: 127.0.0.1 && cat /etc/passwd
   [*] Running: ping -c 1 127.0.0.1 && cat /etc/passwd
   PING 127.0.0.1 (127.0.0.1) 56(84) bytes of data.
   64 bytes from 127.0.0.1: icmp_seq=1 ttl=64 time=0.027 ms

   --- 127.0.0.1 ping statistics ---
   1 packets transmitted, 1 received, 0% packet loss, time 0ms
   rtt min/avg/max/mdev = 0.027/0.027/0.027/0.000 ms
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
   Run the Python script and pass another exploit payload to it: `127.0.0.1 | cat /etc/passwd`:

   ```console
   root@45df6e3bc5da:/app# python vuln_code.py
   Enter IP address to ping: 127.0.0.1 | cat /etc/passwd
   [*] Running: ping -c 1 127.0.0.1 | cat /etc/passwd
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

Keep the container running for the automation steps below.

## Automate the Validating and Testing of the Vulnerability

To automate the process of validating and testing the vulnerability, we have two scripts to use: `exploit.sh` and `verify_fix.sh`.

1. Inside the container, use the `exploit.sh` script to validate the issue:

   ```console
   root@45df6e3bc5da:/app# ./expoit.sh
   ============================================================
    Exercise 02: Command Injection - Exploit
   ============================================================


   [*] Normal use - pinging 127.0.0.1:
   Enter IP address to ping: [*] Running: ping -c 1 127.0.0.1
   PING 127.0.0.1 (127.0.0.1) 56(84) bytes of data.
   64 bytes from 127.0.0.1: icmp_seq=1 ttl=64 time=0.035 ms

   --- 127.0.0.1 ping statistics ---
   1 packets transmitted, 1 received, 0% packet loss, time 0ms
   rtt min/avg/max/mdev = 0.035/0.035/0.035/0.000 ms

   ------------------------------------------------------------
   [*] Injecting payload: 127.0.0.1 ; cat /etc/passwd
   [*] The semicolon ends the ping command and starts a new one!

   Enter IP address to ping: [*] Running: ping -c 1 127.0.0.1 ; cat /etc/passwd
   PING 127.0.0.1 (127.0.0.1) 56(84) bytes of data.
   64 bytes from 127.0.0.1: icmp_seq=1 ttl=64 time=0.009 ms

   --- 127.0.0.1 ping statistics ---
   1 packets transmitted, 1 received, 0% packet loss, time 0ms
   rtt min/avg/max/mdev = 0.009/0.009/0.009/0.000 ms
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

   [!] We just read /etc/passwd by injecting into the ping command!
   ```

   As you can see, the `exploit.sh` script automates the passing the exploit payload (`root ; cat /etc/passwd`).
   So we inject the `cat /etc/passwd` command to the Python script and cause the contents of the `/etc/passwd` file to be shown.

1. Inside the container, use the `verify_fix.sh` script to test the issue:

   ```console
   root@45df6e3bc5da:/app# ./verify_fix.sh
   ============================================================
    Exercise 02: Command Injection - Verify Fix
   ============================================================


   [TEST 1] Normal input should still work...
     PASS: Normal ping works correctly.

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

## Your Tasks

Follow the **Audit → Identify → Validate → Fix → Test** cycle:

1. **Audit** – Read `vuln_code.py`.
   Understand what it does.
1. **Identify** – Find the security flaw. Which line is dangerous and why?
1. **Validate** – Build the container image.
   Start the container.
   Inside the container run the `exploit.sh` script to confirm the vulnerability exists.
   Exit the container.
1. **Fix** – Edit `vuln_code.py` to eliminate the flaw.
1. **Test** – Start the container.
   Build the container image.
   Inside the container run the `verify_fix.sh` script to confirm the vulnerability is now removed.
   Exit the container.


If everything is OK (and you fixed the program and removed the vulnerability), all 3 tests in the `verify_fix.sh` script will pass:

```console
root@45df6e3bc5da:/app# ./verify_fix.sh
============================================================
 Exercise 02: Command Injection - Verify Fix
============================================================


[TEST 1] Normal input should still work...
  PASS: Normal ping works correctly.

[TEST 2] Injection payload must NOT execute secondary command...
  PASS: Injection payload was not executed.

[TEST 3] Another injection vector (&&)...
  PASS: '&&' injection was blocked.

============================================================
 Results: 3 passed, 0 failed
============================================================
 All tests passed! Great work.
```

## Hints

<details>
<summary>Hint 1 - What is the flaw?</summary>

The function `ping_host()` builds a shell command by **string concatenation**:

```python
command = "ping -c 1 " + host
os.system(command)
```

The user's input is passed directly to the shell.
A shell interprets special characters like `;`, `&&`, `|`, and `$()` as control operators.
</details>

<details>
<summary>Hint 2 - What does the exploit do?</summary>

The input `127.0.0.1 ; cat /etc/passwd` results in the shell running:

```
ping -c 1 127.0.0.1 ; cat /etc/passwd
```

The `;` terminates the ping command and starts a new one - leaking system user data.
</details>

<details>
<summary>Hint 3 - How to fix it?</summary>

Replace `os.system()` with `subprocess.run()` and pass the command as a **list** of arguments (not a string).
This way, the shell is never invoked and special characters in user input are treated as literal data:

```python
import subprocess
subprocess.run(["ping", "-c", "1", host])
```
</details>
