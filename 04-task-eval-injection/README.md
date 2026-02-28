# Exercise 04 – eval() Injection

**Language:** JavaScript (Node.js) | **Level:** Intermediate | **Category:** Injection

---

## The Scenario

You have been given a simple command-line calculator. Users type a math expression
and the program returns the result:

```console
$ node vuln_code.js
Enter a math expression (e.g. 2+2): 6 * 7
Result: 42
```

## Directory Contents

| File | Purpose |
|------|---------|
| `vuln_code.js` | The vulnerable calculator — **edit this to fix it** |
| `exploit.sh` | Validates the vulnerability (Validate step) |
| `verify_fix.sh` | Tests your fix (Test step) |
| `Dockerfile` | Container environment |
| `solution/` | Reference solution (try yourself first!) |

## Running the Exercise

1. Open up a console and terminal to run Docker commands.
   This can be a Linux or macOS terminal or a Windows Command Prompt or PowerShell or WSL terminal.

1. Enter the current directory of the exercise.

1. Build the container image:

   ```console
   docker build -t 04-eval-injection .
   ```

1. Start the container:

   ```console
   docker run --rm --name 04-eval-inject-cont -it 04-eval-injection /bin/bash
   ```

   You will get an interactive prompt inside the container:

   ```console
   root@45df6e3bc5da:/app#
   ```

1. Run the Python code:

   ```console
   root@45df6e3bc5da:/app# ls
   vuln_code.js

   root@45df6e3bc5da:/app# node vuln_code.js
   Enter a math expression (e.g. 2+2): 5+6
   Result: 11
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
   docker run --rm --name 04-eval-inject-cont -it 04-eval-injection /bin/bash
   ```

   You will get an interactive prompt inside the container:

   ```console
   root@45df6e3bc5da:/app#
   ```

1. Run the `vuln_code.py` Python script:

   ```console
   root@45df6e3bc5da:/app# python vuln_code.js
   ```

1. Pass to the JavaScript program, as input, a complex JavaScript expression: `require('child_process').execSync('id').toString()`.
   This exploit payload is a string that will cause the program to run the `id` shell command, showing information about the current user:

   ```console
   Enter a math expression (e.g. 2+2): require('child_process').execSync('id').toString()
   Result: uid=0(root) gid=0(root) groups=0(root)

   ```

   This is an `eval()` injection attack.
   We are able to run custom commands by passing the corresponding JavaScript instructions to be interpreted by the `eval()` function.
   This happens because the `eval()` function can interpret any JavaScript constructs, not just math constructs.
   This is obviously an issue;
   we should restrict the JavaScript program to only work with math constructs.

1. Try another approach.
   Pass to the JavaScript program, as input, a complex JavaScript expression: `require('child_process').execSync('ls /app').toString()`.
   This exploit payload is a string that will cause the program to run the `ls /app` shell command, listing the contents of the `/app` directory:

   ```console
   root@45df6e3bc5da:/app# python vuln_code.js
   Enter a math expression (e.g. 2+2): require('child_process').execSync('ls /app').toString()
   Result: exploit.sh
   verify_fix.sh
   vuln_code.js
   ```

   Yet again we did an `eval()` injection attack
   We are able to run custom commands by passing the corresponding JavaScript instructions to be interpreted by the `eval()` function.
   Again, this happens because the `eval()` function can interpret any JavaScript constructs, not just math constructs.

Keep the container running for the automation steps below.

## Automate the Validating and Testing of the Vulnerability

To automate the process of validating and testing the vulnerability, we have two scripts to use: `exploit.sh` and `verify_fix.sh`.

1. Inside the container, use the `exploit.sh` script to validate the issue:

   ```console
   root@45df6e3bc5da:/app# ./expoit.sh
   ============================================================
    Exercise 04: eval() Injection - Exploit
   ============================================================


   [*] Normal use - math expression:
   Enter a math expression (e.g. 2+2): Result: 42

   ------------------------------------------------------------
   [*] Injecting Node.js code to run a system command:
   [*] Payload: require('child_process').execSync('id').toString()

   Enter a math expression (e.g. 2+2): Result: uid=0(root) gid=0(root) groups=0(root)


   [!] eval() ran arbitrary OS commands instead of doing math!

   ------------------------------------------------------------
   [*] Listing /app directory via injection:
   Enter a math expression (e.g. 2+2): Result: exploit.sh
   verify_fix.sh
   vuln_code.js


   [!] eval() listed directory contents instead of doing math!
   ```

   As you can see, the `exploit.sh` script automates the passing the exploit payloads to the program.
   It passes custom JavaScript instructions to the program.
   With these payloads, the script is able to cause the running of system commands.

1. Inside the container, use the `verify_fix.sh` script to test the issue:

   ```console
   root@45df6e3bc5da:/app# ./verify_fix.sh
   ============================================================
    Exercise 04: eval() Injection - Verify Fix
   ============================================================


   [TEST 1] Basic addition must work...
     PASS: 2 + 2 = 4

   [TEST 2] Multiplication must work...
     PASS: 6 * 7 = 42

   [TEST 3] Code injection via require() must be blocked...
     FAIL: Code injection still executes system commands!

   [TEST 4] process.exit() injection must be handled...
     INFO: Consider rejecting non-math input explicitly.

   ============================================================
    Results: 3 passed, 1 failed
   ============================================================
    Fix is incomplete. Keep trying!
   ```

   As we can see, one test (the most relevant one) failed.
   That means we were able to do an `eval()` injection and cause the running of system commands.
   We need to fix the script to remove the vulnerability and pass all three tests.

1. Exit (and stop, and remove) the container:

   ```console
   root@45df6e3bc5da:/app#
   exit
   ```

   You will get your initial host console.

## Your Tasks

Follow the **Audit → Identify → Validate → Fix → Test** cycle:

1. **Audit** - Read `vuln_code.js`.
   Understand what it does.
1. **Identify** - Find the security flaw.
   What makes the query dangerous?
1. **Validate** - Build the container image.
   Start the container.
   Inside the container run the `exploit.sh` script to confirm the vulnerability exists.
   Exit the container.
1. **Fix** - Edit `vuln_code.js` to only allow safe math expressions.
1. **Test** - Start the container.
   Build the container image.
   Inside the container run the `verify_fix.sh` script to confirm the vulnerability is now removed.
   Exit the container.

If everything is OK (and you fixed the program and removed the vulnerability), all 4 tests in the `verify_fix.sh` script will pass:

```console
root@45df6e3bc5da:/app# ./verify_fix.sh
============================================================
 Exercise 04: eval() Injection - Verify Fix
============================================================


[TEST 1] Basic addition must work...
  PASS: 2 + 2 = 4

[TEST 2] Multiplication must work...
  PASS: 6 * 7 = 42

[TEST 3] Code injection via require() must be blocked...
  PASS: Code injection blocked.

[TEST 4] process.exit() injection must be handled...
  PASS: Invalid input explicitly rejected.

============================================================
 Results: 4 passed, 0 failed
============================================================
 All tests passed! Great work.
```

## Hints

<details>
<summary>Hint 1 – What is the flaw?</summary>

`eval(input)` executes **any valid JavaScript expression**, not just arithmetic.
An attacker can pass `require('child_process').execSync('id').toString()` to run arbitrary OS commands with the privileges of the Node.js process.
</details>

<details>
<summary>Hint 2 – How to fix it?</summary>

**Validate input with a regex before computing.**
A safe math expression contains only digits, whitespace, and arithmetic operators:

```javascript
const SAFE_MATH = /^[\d\s+\-*/.()]+$/;

if (!SAFE_MATH.test(input.trim())) {
    console.error('Error: only numeric expressions are allowed.');
    process.exit(1);
}

// Only reach here if input is safe
const result = Function('"use strict"; return (' + input + ')')();
```

Using `Function()` instead of `eval()` limits scope - but the regex whitelist is the critical protection layer.
</details>
