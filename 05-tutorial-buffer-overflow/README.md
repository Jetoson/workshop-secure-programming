# Tutorial 05 - Buffer Overflow

**Language:** C | **Level:** Intermediate | **Category:** Memory Safety

---

## The Scenario

You have been given a small C program that asks for a name and prints a greeting.
It allocates a fixed-size buffer and reads user input into it.

```
$ ./vuln_code
What is your name? Alice
Hello, Alice!
```

## Directory Contents

| File | Purpose |
|------|---------|
| `vuln_code.c` | The vulnerable C source - **edit this to fix it** |
| `exploit.sh` | Demonstrates the crash (Validate step) |
| `verify_fix.sh` | Tests your fix (Test step) |
| `Dockerfile` | Compiles and runs the program in a container |
| `solution/` | Reference solution (try yourself first!) |

## Running the Tutorial

1. Open up a console and terminal to run Docker commands.
   This can be a Linux or macOS terminal or a Windows Command Prompt or PowerShell or WSL terminal.

1. Enter the current directory of the exercise.

1. Build the container image:

   ```console
   docker build -t 05-buffer-overflow .
   ```

1. Start the container:

   ```console
   docker run --rm --name 05-buffer-overflow-cont -it 05-buffer-overflow /bin/bash
   ```

   You will get an interactive prompt inside the container:

   ```console
   root@45df6e3bc5da:/app#
   ```

1. Run the executable:

   ```console
   root@2d5b0b2c6637:/app# ls
   exploit.sh  verify_fix.sh  vuln_code  vuln_code.c

   root@2d5b0b2c6637:/app# ./vuln_code
   What is your name? Alice
   Hello, Alice
   ```

1. Exit (and stop, and remove) the container:

   ```console
   root@45df6e3bc5da:/app#
   exit
   ```

   You will get your initial host console.

## Validating and Testing the Vulnerability

To validate and test the vulnerability, follow the steps below.
You will also follow the steps after you do the fix (see also the `Action Points` section below):

1. Start the container:

   ```console
   docker run --rm --name 05-buffer-overflow-cont -it 05-buffer-overflow /bin/bash
   ```

   You will get an interactive prompt inside the container:

   ```console
   root@45df6e3bc5da:/app#
   ```

1. Run the `vuln_code` program:

   ```console
   root@45df6e3bc5da:/app# ./vun_code
   ```

1. Pass to the program a large string:

   ```console
   What is your name? AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
   Hello, AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA!
   Segmentation fault (core dumped)
   ```

   This is an exploit of the buffer overflow vulnerability.
   Memory gets overwritten, and this causes the program to do an invalid memory access (`Segmentation fault`) and crash.
   With some additional work, we can be able to leak data from memory or cause execution of arbitrary code.

1. Try another approach.
   Use Python to generate a large string and pass it to the program:

   ```console
   root@45df6e3bc5da:/app# python3 -c 'print(150*"A")'
   AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA

   root@45df6e3bc5da:/app# python3 -c 'print(150*"A")' | ./vuln_code
   What is your name? Hello, AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
   !
   Segmentation fault (core dumped)
   ```

   Yet again we caused the program to crash by passing a large enough input and exploiting the buffer overflow vulnerability.

Keep the container running for the automation steps below.

## Automate the Validating and Testing of the Vulnerability

To automate the process of validating and testing the vulnerability, we have two scripts to use: `exploit.sh` and `verify_fix.sh`.

1. Inside the container, use the `exploit.sh` script to validate the issue:

   ```console
   root@45df6e3bc5da:/app# ./exploit.sh
   ============================================================
    Tutorial 05: Buffer Overflow - Exploit
   ============================================================


   [*] Normal use - short name:
   What is your name? Hello, Alice
   !

   ------------------------------------------------------------
   [*] Sending 150 'A' characters (buffer is only 128 bytes)...
   What is your name? Hello, AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
   !
   ./exploit.sh: line 19:    14 Done                    python3 -c "print('A' * 150)"
           15 Segmentation fault      (core dumped) | ./vuln_code

   [!] Program CRASHED with a segmentation fault (exit 139)!
   [!] Overwriting stack memory beyond the buffer caused the crash.
   [!] In an exploitable program, this can redirect execution to attacker code.
   ```

   As you can see, the `exploit.sh` script automates the passing the large payload.
   This causes the program to crash.

1. Inside the container, use the `verify_fix.sh` script to test the issue:

   ```console
   root@45df6e3bc5da:/app# ./verify_fix.sh
   ============================================================
    Tutorial 05: Buffer Overflow - Verify Fix
   ============================================================


   [TEST 1] Short name should work normally...
     PASS: Normal input works.

   [TEST 2] 150-byte input must NOT crash the program...
   ./verify_fix.sh: line 26:    22 Done                    python3 -c "print('A' * 150)"
           23 Segmentation fault      (core dumped) | ./vuln_code > /dev/null 2>&1
     FAIL: Program still crashes on large input! (exit 139)

   [TEST 3] 1000-byte input must also be handled safely...
   ./verify_fix.sh: line 38:    24 Done                    python3 -c "print('B' * 1000)"
           25 Segmentation fault      (core dumped) | ./vuln_code > /dev/null 2>&1
     FAIL: Program crashes on 1000-byte input! (exit 139)

   ============================================================
    Results: 1 passed, 2 failed
   ============================================================
    Fix is incomplete. Keep trying!
   ```

   As we can see, 2 tests failed.
   That means we were able to send input that caused the program to crash.
   We need to fix the script to remove the vulnerability and pass all 3 tests.

1. Exit (and stop, and remove) the container:

   ```console
   root@45df6e3bc5da:/app#
   exit
   ```

   You will get your initial host console.

## Background: Stack Memory Layout

```text
High addresses
  ┌─────────────────────┐
  │  return address     │  ← fgets() can overwrite this!
  ├─────────────────────┤
  │  saved frame ptr    │
  ├─────────────────────┤
  │  buffer[127]        │
  │  buffer[126]        │
  │  ...                │
  │  buffer[0]          │  ← input starts here
  └─────────────────────┘
Low addresses
```

Writing past `buffer[127]` corrupts the return address - the program jumps to an attacker-controlled location when the function returns.

## Fixing the Vulnerability and Validating the Fix

## The Flaw

```c
char buffer[128];
fgets(buffer, 192, stdin);      /* UNSAFE: reads past buffer size - no bounds check! */
```

`fgets()` has **a wrong limit of reading**.
It writes bytes from stdin until it sees `\n` or EOF or until reaching 192 characters.
Input longer than 128 bytes overwrites memory beyond the buffer - including the saved frame pointer and return address on the stack.

This is a **stack-based buffer overflow**.
In the worst case, an attacker crafts input that overwrites the return address with a value pointing to shellcode or a return-oriented-programming (ROP) chain.

## The Fix

```c
fgets(buffer, 128, stdin);
```

In the above code `fgets()` reads **at most `sizeof(buffer) - 1`** bytes.
Any excess input remains in the stdin buffer (or is discarded on EOF).

### Action Points

To apply the fix, we do the following:

1. Edit the `vuln_code.c` program and make it use the correct `fgets` function.
   The new code will have some removed lines and some added lines, as below:

   ```diff
   -       fgets(buffer, 192, stdin);      /* UNSAFE: reads past buffer size - no bounds check! */
   +       fgets(buffer, 128, stdin);
   ```

1. Build the container image with the updated `vuln_code.c` file.

1. Start the container.

1. Run the manual step of testing the vulnerability.
   Run the program and pass it different variants of exploit payloads.
   In case of a successful solution (and removal of the vulnerability), the program will not crash:

   ```console
   root@45df6e3bc5da:/app# ./vuln_code
   What is your name? AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
   Hello, AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA!

   root@45df6e3bc5da:/app# python3 -c 'print(150*"A")' | ./vuln_code
   What is your name? Hello, AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA!
   ```

1. Verify the new file by running the `verify_fix.sh` script inside the container.
   In case of a successful solution, all 3 tests in the `verify_fix.sh` script will work:

   ```console
   root@45df6e3bc5da:/app# ./verify_fix.sh
   ============================================================
    Tutorial 05: Buffer Overflow - Verify Fix
   ============================================================


   [TEST 1] Short name should work normally...
     PASS: Normal input works.

   [TEST 2] 150-byte input must NOT crash the program...
     PASS: Large input handled without crash.

   [TEST 3] 1000-byte input must also be handled safely...
     PASS: 1000-byte input handled safely.

   ============================================================
    Results: 3 passed, 0 failed
   ============================================================
   All tests passed! Great work.
   ```

## Related Vulnerabilities

- [CWE-121: Stack-based Buffer Overflow](https://cwe.mitre.org/data/definitions/121.html)
- [CWE-120: Buffer Copy without Checking Size of Input](https://cwe.mitre.org/data/definitions/120.html)
