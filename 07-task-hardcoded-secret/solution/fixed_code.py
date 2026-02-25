#!/usr/bin/env python3

"""
Exercise 07 - Hardcoded Secret: FIXED VERSION

Fix: Read the API key from an environment variable instead of hardcoding it.
     The secret never appears in source code, git history, or build artifacts.
"""
import os

# SECURE: read from environment — never store secrets in source code
API_KEY = os.getenv("API_KEY")
API_ENDPOINT = "https://api.example.com/data"


def call_api():
    """Simulate an authenticated API call."""
    if not API_KEY:
        raise EnvironmentError(
            "API_KEY environment variable is not set!\n"
            "Set it before running: export API_KEY='your-key-here'"
        )

    print(f"[*] Connecting to {API_ENDPOINT}")
    # Never log the full key — log only a prefix for debugging
    print(f"[*] Authenticating (key: {API_KEY[:8]}...)")
    print("[+] API call successful! Data received.")


if __name__ == "__main__":
    call_api()
