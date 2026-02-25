#!/usr/bin/env python3

"""
Tutorial 01 - Command Injection
WORKSHOP: Secure Programming

Audit: Read this code carefully. Can you spot the security flaw?
"""

import subprocess


def get_user(user):
    """Get informataion about a user."""
    # SECURE: Pass command as a list — no shell interpolation possible.
    # The OS directly exec()s the ping binary with 'user' as a plain argument.
    print(f"[*] Getting information about: {user}")
    result = subprocess.run(
        ["id", user],
        capture_output=True,
        text=True,
    )
    if result.returncode == 0:
        print("[+] User exists.")
    else:
        print("[-] No such user.")


if __name__ == "__main__":
    user = input("Enter username: ")
    get_user(user)
