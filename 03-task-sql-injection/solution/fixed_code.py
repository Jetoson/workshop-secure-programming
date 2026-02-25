#!/usr/bin/env python3

"""
Exercise 03 - SQL Injection: FIXED VERSION

Fix: Replace f-string query construction with parameterized queries.
     The database driver separates SQL code from data — input can never
     alter the query structure, regardless of special characters.
"""

import sqlite3


def setup_db(conn):
    conn.execute("""
        CREATE TABLE IF NOT EXISTS users (
            id       INTEGER PRIMARY KEY,
            name     TEXT UNIQUE,
            password TEXT
        )
    """)
    conn.execute("INSERT OR IGNORE INTO users (name, password) VALUES ('admin', 'supersecret123')")
    conn.execute("INSERT OR IGNORE INTO users (name, password) VALUES ('alice', 'password456')")
    conn.execute("INSERT OR IGNORE INTO users (name, password) VALUES ('bob',   'hunter2')")
    conn.commit()


def login(conn, username, password):
    """Check credentials using a parameterized query."""
    # SECURE: The ? placeholders are filled by the database driver.
    # User data is never interpreted as SQL syntax.
    cursor = conn.execute(
        "SELECT * FROM users WHERE name=? AND password=?",
        (username, password)
    )
    row = cursor.fetchone()
    return row is not None


if __name__ == "__main__":
    conn = sqlite3.connect(":memory:")
    setup_db(conn)

    print("=== Simple Login ===")
    username = input("Username: ")
    password = input("Password: ")

    if login(conn, username, password):
        print(f"\n[+] Login successful! Welcome, {username}.")
    else:
        print("\n[-] Login failed. Invalid credentials.")
