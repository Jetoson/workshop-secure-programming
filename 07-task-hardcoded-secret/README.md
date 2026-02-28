# Exercise 07 - Hardcoded Secret

**Language:** Python | **Level:** Advanced | **Category:** Secrets Management

---

## The Scenario

You have been given an API client script. It connects to a remote service and authenticates using an API key.
The developer put the key directly in the file:

```python
API_KEY = "sk_live_SUPER_SECRET_12345ABCDE"
```

## Directory Contents

| File | Purpose |
|------|---------|
| `vuln_code.py` | The vulnerable script — **edit this to fix it** |
| `exploit.sh` | Finds the secret statically (Validate step) |
| `verify_fix.sh` | Tests your fix (Test step) |
| `Dockerfile` | Container environment |
| `solution/` | Reference solution (try yourself first!) |

## Running the Exercise

1. Open up a console and terminal to run Docker commands.
   This can be a Linux or macOS terminal or a Windows Command Prompt or PowerShell or WSL terminal.

1. Enter the current directory of the exercise.

1. Build the container image:

   ```console
   docker build -t 07-hardcoded-secret .
   ```

1. Start the container:

   ```console
   docker run --rm --name 07-hardcoded-secret-cont -it 07-hardcoded-secret /bin/bash
   ```

   You will get an interactive prompt inside the container:

   ```console
   root@45df6e3bc5da:/app#
   ```

1. Run the executable:

   ```console
   root@6c5ad4cfeaa5:/app# ls
   exploit.sh  verify_fix.sh  vuln_code.py

   root@6c5ad4cfeaa5:/app# python vuln_code.py
   [*] Connecting to https://api.example.com/data
   [*] Authenticating with key: sk_live_SUPER_SECRET_12345ABCDE
   [+] API call successful! Data received.
   ```

1. Exit (and stop, and remove) the container:

   ```console
   root@45df6e3bc5da:/app#
   exit
   ```

   You will get your initial host console.

## Validating and Testing the Vulnerability

To validate and test the vulnerability, follow the steps below.
You will also follow the steps after you do the fix (see also the `Your Tasks` section below):

1. Start the container:

   ```console
   docker run --rm --name 07-hardcoded-secret-cont -it 07-hardcoded-secret /bin/bash
   ```

   You will get an interactive prompt inside the container:

   ```console
   root@45df6e3bc5da:/app#
   ```

1. Run the `vuln_code.py` program:

   ```console
   root@45df6e3bc5da:/app# python vuln_code.py
   [*] Connecting to https://api.example.com/data
   [*] Authenticating with key: sk_live_SUPER_SECRET_12345ABCDE
   [+] API call successful! Data received.
   ```

1. You can see the program ran successfully with an API key.
   However, the API key is hardcoded in the program.
   We can see it part of the code

   ```console
   root@57ca2e8e74c0:/app# grep 'API_KEY' vuln_code.py
   API_KEY = "sk_live_SUPER_SECRET_12345ABCDE"
       print(f"[*] Authenticating with key: {API_KEY}")
       # response = requests.get(API_ENDPOINT, headers={"Authorization": f"Bearer {API_KEY}"})
   ```

   This is bad.
   This means that anyone who has access to the code, or the repository where the code is stored, will know my API key, which should be a secret.

   Programs code must not store secrets.
   Secrets must be passed from the outside world to the program, only during runtime.
   Otherwise, anyone with access to the program code will know the secrets.

Keep the container running for the automation steps below.

## Automate the Validating and Testing of the Vulnerability

To automate the process of validating and testing the vulnerability, we have two scripts to use: `exploit.sh` and `verify_fix.sh`.

1. Inside the container, use the `exploit.sh` script to validate the issue:

   ```console
   root@45df6e3bc5da:/app# ./exploit.sh
   ============================================================
    Exercise 07: Hardcoded Secret - Exploit
   ============================================================

   [*] Scanning source code for secrets (simulating an attacker
       who obtained a copy of the repository)...

   --- grep output ---
   13:API_KEY = "sk_live_SUPER_SECRET_12345ABCDE"
   -------------------

   [!] The API key was found in plain text in the source file!

   [*] Why this is critical:
       1. Source code is often stored in git — keys persist in
          git HISTORY even after deletion.
       2. CI/CD pipelines log build context — keys appear in logs.
       3. Code review platforms cache file contents.
       4. Anyone with read access to the repo has the key.

   [*] This is what a secret scanner (e.g. truffleHog, gitleaks) does automatically:
       It searches for high-entropy strings and known key patterns in all commits.
   ```

   As you can see, the `exploit.sh` script automates the discovery of the hard-coded value in the program.
   This is a leak of our secret.

1. Inside the container, use the `verify_fix.sh` script to test the issue:

   ```console
   root@45df6e3bc5da:/app# ./verify_fix.sh
   ============================================================
    Exercise 07: Hardcoded Secret - Verify Fix
   ============================================================

   [TEST 1] API key must NOT be hardcoded in the source file...
     FAIL: Secret still found hardcoded in vuln_code.py!

   [TEST 2] Code must read the key from an environment variable...
     FAIL: Code does not appear to use os.getenv() or os.environ.

   [TEST 3] Script must run when API_KEY env var is set...
     PASS: Script runs correctly when API_KEY env var is provided.

   [TEST 4] Script must warn or fail when API_KEY is missing...
     INFO: Consider adding a guard: if not API_KEY: raise EnvironmentError(...)

   ============================================================
    Results: 2 passed, 2 failed
   ============================================================
    Fix is incomplete. Keep trying!
   ```

   As we can see, 2 tests failed.
   That means the program stores secrets inside the source code.
   We need to fix the Python program to not store secrets inside the source code and pass all 4 tests.
   Secrets are to be passed from the outside world, at runtime.

1. Exit (and stop, and remove) the container:

   ```console
   root@45df6e3bc5da:/app#
   exit
   ```

   You will get your initial host console.

## Your Tasks

Follow the **Audit → Identify → Validate → Fix → Test** cycle:

1. **Audit** - Read `vuln_code.py`.
   Understand what it does.
1. **Identify** - Where is the secret stored, and why is that a problem?
1. **Validate** - Build the container image.
   Start the container.
   Inside the container run the `exploit.sh` script to confirm the vulnerability exists.
   Exit the container.
1. **Fix** - Edit `vuln_code.py` to read the key from an environment variable.
1. **Test** - Start the container.
   Build the container image.
   Inside the container run the `verify_fix.sh` script to confirm the vulnerability is now removed.
   Exit the container.

If everything is OK (and you fixed the program and removed the vulnerability), all 4 tests in the `verify_fix.sh` script will pass:

```console
root@45df6e3bc5da:/app# ./verify_fix.sh
============================================================
 Exercise 07: Hardcoded Secret - Verify Fix
============================================================

[TEST 1] API key must NOT be hardcoded in the source file...
  PASS: No hardcoded secret found in source.

[TEST 2] Code must read the key from an environment variable...
  PASS: Code uses os.getenv() / os.environ.

[TEST 3] Script must run when API_KEY env var is set...
  PASS: Script runs correctly when API_KEY env var is provided.

[TEST 4] Script must warn or fail when API_KEY is missing...
  PASS: Script warns when API_KEY is not set.

============================================================
 Results: 4 passed, 0 failed
============================================================
 All tests passed! Great work.
```

## Why This Matters

```text
Developer commits vuln_code.py to GitHub
         ↓
Key is now in git history - forever
         ↓
Key is rotated and removed from the file
         ↓
git log --all can still retrieve the old commit with the key
```

Real-world breaches have happened because API keys were committed to public repositories, even briefly.

## Hints

<details>
<summary>Hint 1 - What is the flaw?</summary>

The API key `sk_live_SUPER_SECRET_12345ABCDE` is stored as a Python string literal.
Anyone who reads the file - a teammate, contractor, or attacker who gained access to the repo — can see and use the key immediately.
</details>

<details>
<summary>Hint 2 - How to fix it?</summary>

Read the secret from an **environment variable** at runtime:

```python
import os

API_KEY = os.getenv("API_KEY")
if not API_KEY:
    raise EnvironmentError("API_KEY environment variable is not set!")
```

Inject it at runtime - the key never touches source code:

```console
export API_KEY="sk_live_SUPER_SECRET_12345ABCDE"
python3 fixed_code.py
```
</details>
