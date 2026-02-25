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
You will also follow the steps after you do the fix (see also the `Your Tasks` section below):

1. Start the container:

   ```console
   docker run --rm --name 01-command-inject-cont -it 01-command-injection /bin/bash
   ```

   You will get an interactive prompt inside the container:

   ```console
   root@45df6e3bc5da:/app#
   ```

1. Validate the issue using the `exploit.sh` script inside the container:

   ```console
   root@2a4db176d366:/app# ./exploit.sh
   ============================================================
   Tutorial 01: Command Injection - Exploit
   ============================================================


   [*] Normal use - querying about user root:
   Enter username: [*] Running: id root
   uid=0(root) gid=0(root) groups=0(root)

   ------------------------------------------------------------
   [*] Injecting payload: root; cat /etc/passwd
   [*] The semicolon ends the ping command and starts a new one!

   Enter username: [*] Running: id root; cat /etc/passwd
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
   systemd-network:x:998:998:systemd Network Management:/:/usr/sbin/nologin
   systemd-timesync:x:996:996:systemd Time Synchronization:/:/usr/sbin/nologin
   dhcpcd:x:100:65534:DHCP Client Daemon,,,:/usr/lib/dhcpcd:/bin/false
   messagebus:x:995:995:System Message Bus:/nonexistent:/usr/sbin/nologin
   syslog:x:101:101::/nonexistent:/usr/sbin/nologin
   systemd-resolve:x:990:990:systemd Resolver:/:/usr/sbin/nologin
   tss:x:102:104:TPM software stack,,,:/var/lib/tpm:/bin/false
   uuidd:x:103:106::/run/uuidd:/usr/sbin/nologin
   systemd-oom:x:989:989:systemd Userspace OOM Killer:/:/usr/sbin/nologin
   whoopsie:x:104:109::/nonexistent:/bin/false
   dnsmasq:x:999:65534:dnsmasq:/var/lib/misc:/usr/sbin/nologin
   avahi:x:105:111:Avahi mDNS daemon,,,:/run/avahi-daemon:/usr/sbin/nologin
   nm-openvpn:x:106:112:NetworkManager OpenVPN,,,:/var/lib/openvpn/chroot:/usr/sbin/nologin
   tcpdump:x:107:113::/nonexistent:/usr/sbin/nologin
   sssd:x:108:114:SSSD system user,,,:/var/lib/sss:/usr/sbin/nologin
   speech-dispatcher:x:109:29:Speech Dispatcher,,,:/run/speech-dispatcher:/bin/false
   usbmux:x:110:46:usbmux daemon,,,:/var/lib/usbmux:/usr/sbin/nologin
   cups-pk-helper:x:111:115:user for cups-pk-helper service,,,:/nonexistent:/usr/sbin/nologin
   fwupd-refresh:x:988:988:Firmware update daemon:/var/lib/fwupd:/usr/sbin/nologin
   saned:x:112:116::/var/lib/saned:/usr/sbin/nologin
   geoclue:x:113:117::/var/lib/geoclue:/usr/sbin/nologin
   cups-browsed:x:114:115::/nonexistent:/usr/sbin/nologin
   hplip:x:115:7:HPLIP system user,,,:/run/hplip:/bin/false
   gnome-remote-desktop:x:987:987:GNOME Remote Desktop:/var/lib/gnome-remote-desktop:/usr/sbin/nologin
   polkitd:x:986:986:User for polkitd:/:/usr/sbin/nologin
   rtkit:x:116:119:RealtimeKit,,,:/proc:/usr/sbin/nologin
   colord:x:117:120:colord colour management daemon,,,:/var/lib/colord:/usr/sbin/nologin
   gnome-initial-setup:x:118:65534::/run/gnome-initial-setup/:/bin/false
   gdm:x:119:121:Gnome Display Manager:/var/lib/gdm3:/bin/false
   razvan:x:1000:1000:Razvan Deaconescu:/home/razvan:/bin/bash
   sshd:x:120:65534::/run/sshd:/usr/sbin/nologin
   postfix:x:121:123:Postfix MTA,,,:/var/spool/postfix:/usr/sbin/nologin
   snapd-range-524288-root:x:524288:524288::/nonexistent:/usr/bin/false
   snap_daemon:x:584788:584788::/nonexistent:/usr/bin/false
   dovecot:x:122:125:Dovecot mail server,,,:/usr/lib/dovecot:/usr/sbin/nologin
   dovenull:x:123:126:Dovecot login user,,,:/nonexistent:/usr/sbin/nologin

   [!] We just read /etc/passwd by injecting into the ping command!
   ```

1. Test the vulnerability.
   At this point, it will fail:

   ```console
   root@2a4db176d366:/app# ./verify_fix.sh
   ============================================================
   Tutorial 01: Command Injection - Verify Fix
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
An attacker supplying `id ; cat /etc/passwd` causes the shell to run two commands.
This is because the `;` character is a special character that the shell interprets as concatenating two commands.

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

By passing a **list** to `subprocess.run()`, Python calls `execvp()` directly — no shell is spawned.
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

1. Start the container.

1. Verify the new file by running the `verify_fix.sh` script inside the container.
