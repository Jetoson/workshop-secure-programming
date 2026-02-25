#!/usr/bin/env python3

"""
Tutorial 01 - Command Injection
WORKSHOP: Secure Programming

Audit: Read this code carefully. Can you spot the security flaw?
"""

import os


def get_user(user):
    """Get informataion about a user."""
    command = "id " + user
    print(f"[*] Running: {command}")
    os.system(command)


if __name__ == "__main__":
    user = input("Enter username: ")
    get_user(user)
