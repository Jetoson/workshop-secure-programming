#!/usr/bin/env python3

"""
Exercise 02 - Command Injection: FIXED VERSION

Fix: Replace os.system() with subprocess.run() using an argument list.
     This separates the command from user data — the shell is never invoked,
     so special characters in input are treated as literal strings.
"""

import subprocess


def ping_host(host):
    """Ping a host to check if it is alive."""
    # SECURE: Pass command as a list — no shell interpolation possible.
    # The OS directly exec()s the ping binary with 'host' as a plain argument.
    print(f"[*] Pinging: {host}")
    result = subprocess.run(
        ["ping", "-c", "1", host],
        capture_output=True,
        text=True,
    )
    if result.returncode == 0:
        print("[+] Host is alive.")
    else:
        print("[-] Host did not respond (or invalid address).")


if __name__ == "__main__":
    host = input("Enter IP address to ping: ")
    ping_host(host)
