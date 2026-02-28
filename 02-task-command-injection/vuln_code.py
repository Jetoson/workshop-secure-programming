#!/usr/bin/env python3

"""
Exercise 02 - Command Injection
WORKSHOP: Secure Programming

Audit: Read this code carefully. Can you spot the security flaw?
"""

import os
import subprocess


def ping_host(host):
    """Ping a host to check if it is alive."""
    result = subprocess.run(
        ["ping", "-c", "1", host],
        capture_output=True,
        text=True,
    )
    if result.returncode == 0:
        print("[+] Host Responds.")
    else:
        print("[-] Host did not respond.")

if __name__ == "__main__":
    host = input("Enter IP address to ping: ")
    ping_host(host)
