#!/usr/bin/env python3

"""
Exercise 02 - Command Injection
WORKSHOP: Secure Programming

Audit: Read this code carefully. Can you spot the security flaw?
"""

import os


def ping_host(host):
    """Ping a host to check if it is alive."""
    command = "ping -c 1 " + host
    print(f"[*] Running: {command}")
    os.system(command)


if __name__ == "__main__":
    host = input("Enter IP address to ping: ")
    ping_host(host)
