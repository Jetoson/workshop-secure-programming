# Secure Programming – Workshop

**Duration:** 90 minutes | **Format:** Online, hands-on | **Prerequisite:** Docker installed

---

## Abstract

The world runs on code.
We write code that is then run in real-world scenarios to improve our lives and well-being.
But code can be faulty.
Code can be insecure.
In this hands-on workshop, we go through a set of core concepts of secure programming, presented as flawed code in C, Python, and JavaScript.
We will follow the steps: **audit, identify, validate, fix, test** on various pieces of code.
In doing so, we aim to get an initial set of skills and a mindset to better write code (secure by implementation) and to assist with our code assessment and code review processes.

## Learning Outcomes

- Analyze and identify common security flaws in C, Python, and JavaScript code
- Apply and implement secure programming practices to refactor and fix flawed code

---

## How It Works

Each exercise follows the same five-step cycle:

```
1. AUDIT    – Read the vulnerable code. Understand what it does.
2. IDENTIFY – Find the flaw. Which line is dangerous and why?
3. VALIDATE – Run exploit.sh to confirm the vulnerability is real.
4. FIX      – Edit vuln_code.[c|py|js] to eliminate the flaw.
5. TEST     – Run verify_fix.sh to confirm your fix is correct.
```

All build, run, exploit, and test steps happen **inside Docker containers** — no compiler or runtime installation needed on your host machine.

---

## Exercise Overview

| # | Exercise | Language | Category | Level |
|---|----------|----------|----------|-------|
| 01 | [Command Injection](01-tutorial-command-injection/) | Python | Input Validation | Beginner |
| 02 | [Command Injection](02-task-command-injection/) | Python | Input Validation | Beginner |
| 03 | [SQL Injection](03-task-sql-injection/) | Python + SQLite | Input Validation | Beginner |
| 04 | [eval() Injection](04-task-eval-injection/) | JavaScript (Node.js) | Injection | Intermediate |
| 05 | [Buffer Overflow](05-tutorial-buffer-overflow/) | C | Memory Safety | Intermediate |
| 06 | [Buffer Overflow](06-task-buffer-overflow/) | C | Memory Safety | Intermediate |
| 07 | [Hardcoded Secret](07-task-hardcoded-secret/) | Python | Secrets Management | Advanced |
| 08 | [Negative Amount](08-task-integer-overflow/) | C | Integer Logic | Advanced |

---

## Quick Start

### Prerequisites

- Docker (version 20+)
- Bash shell

Verify Docker is working:

```console
docker run --rm hello-world
```

### Running an Exercise

```bash
# Navigate to an exercise
cd 02-task-command-injection/

# Read the instructions
cat README.md

# Look at the vulnerable code
cat vuln_code.py

# Build the Docker container
docker build -t 02-command-injection .

# Run the Docker container
docker run --rm --name 02-command-injection-cont -it 02-command-injection /bin/bash

# Demonstrate the exploit (validates the vulnerability)
bash exploit.sh

# Exit the container
exit

# --- Edit vuln_code.py to fix the flaw ---

# Build the Docker container
docker build -t 02-command-injection .

# Run the Docker container
docker run --rm --name 02-command-injection-cont -it 02-buffer-overflow /bin/bash

# Verify your fix
bash verify_fix.sh

# Exit the container
exit
```

### Peeking at the Solution

Each exercise has a `solution/` subdirectory containing a fixed version and an explanation.
Try to solve it yourself first — then compare!

```bash
cat 02-task-command-injection/solution/README.md
cat 02-task-command-injection/solution/fixed_code.py
```

---

## Exercise Descriptions

**Tutorial 01: Command Injection** (`01-tutorial-command-injection/`)

A sysadmin script pings a user-supplied IP address using `os.system("ping " + host)`.
The shell interprets any metacharacters in the input.
Fix: use `subprocess.run()` with a list of arguments.

**Exercise 02: Command Injection** (`02-task-command-injection/`)

A sysadmin script pings a user-supplied IP address using `os.system("ping " + host)`.
The shell interprets any metacharacters in the input.
Fix: use `subprocess.run()` with a list of arguments.

**Exercise 03: SQL Injection** (`03-task-sql-injection/`)

A login function constructs an SQL query with an f-string.
Classic `admin'--` bypass.
Fix: parameterized queries (`cursor.execute("... WHERE name=?", (user,))`).

**Exercise 04: eval() Injection** (`04-task-eval-injection/`)

A Node.js calculator uses `eval(input)` to compute math.
Any JavaScript (including `require('child_process').execSync('id')`) runs instead.
Fix: regex whitelist + `Function()`.

**Tutorial 05: Buffer Overflow** (`05-tutorial-buffer-overflow/`)

A C program reads a name into a 64-byte buffer using `gets()`.
Sending 100 bytes causes a segfault.
Fix: replace `gets()` with `fgets(buffer, sizeof(buffer), stdin)`.

**Exercise 06: Buffer Overflow** (`06-task-buffer-overflow/`)

A C program reads a name into a 64-byte buffer using `gets()`.
Sending 100 bytes causes a segfault.
Fix: replace `gets()` with `fgets(buffer, sizeof(buffer), stdin)`.

**Exercise 07: Hardcoded Secret** (`07-task-hardcoded-secret/`)

An API key is stored as a string literal in source code — visible in git history and logs forever.
Fix: read from `os.getenv("API_KEY")`.

**Exercise 08: Negative Amount** (`08-task-integer-overflow/`)

A banking function checks `balance >= amount` but not whether `amount > 0`.
Transferring -500 coins passes the check and *adds* to the balance.
Fix: validate `amount > 0` first.

---

## Directory Structure

```
secure-programming/
├── README.md                          ← You are here
├── 01-tutorial-command-injection/
│   ├── vuln_code.py                   ← Edit this to fix the flaw
│   ├── exploit.sh                     ← Validates the vulnerability
│   ├── verify_fix.sh                  ← Tests your fix
│   ├── Dockerfile                     ← Container environment
│   ├── README.md                      ← Exercise instructions & hints
│   └── solution/
│       ├── fixed_code.py              ← Reference solution
│       └── README.md                  ← Explanation
├── 02-task-command-injection/         ← Same structure
│   └── ...
└── ...
```

---

## Security Note

All exploits in this workshop target **intentionally vulnerable code** running in **isolated Docker containers**.
No network requests are made to external services.
All exercises are self-contained and safe to run on your machine.
