#!/usr/bin/env python3

"""
Exercise 07 - Hardcoded Secret
WORKSHOP: Secure Programming

Audit: Read this code carefully. Can you spot the security flaw?

An API client that connects to a remote service.
"""

# WARNING: Never do this in real code!
API_KEY = "sk_live_SUPER_SECRET_12345ABCDE"
API_ENDPOINT = "https://api.example.com/data"


def call_api():
    """Simulate an authenticated API call."""
    print(f"[*] Connecting to {API_ENDPOINT}")
    print(f"[*] Authenticating with key: {API_KEY}")
    # In a real scenario this would be an HTTP request, e.g.:
    # response = requests.get(API_ENDPOINT, headers={"Authorization": f"Bearer {API_KEY}"})
    print("[+] API call successful! Data received.")


if __name__ == "__main__":
    call_api()
