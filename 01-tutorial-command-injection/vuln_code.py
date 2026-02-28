#!/usr/bin/env python3

"""
Tutorial 01 - Command Injection
WORKSHOP: Secure Programming

Audit: Read this code carefully. Can you spot the security flaw?
"""

import os
import subprocess

def get_user(user):
    """Get informataion about a user."""
    result = subprocess.run(
          ["id", user],
          capture_output=True,
          text=True,
    )

if __name__ == "__main__":
    user = input("Enter username: ")
    get_user(user)
