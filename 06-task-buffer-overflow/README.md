# Exercise 06 - Buffer Overflow

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

## Running the Exercise

1. Open up a console and terminal to run Docker commands.
   This can be a Linux or macOS terminal or a Windows Command Prompt or PowerShell or WSL terminal.

1. Enter the current directory of the exercise.

1. Build the container image:

   ```console
   docker build -t 06-buffer-overflow .
   ```

1. Start the container:

   ```console
   docker run --rm --name 06-buffer-overflow-cont -it 06-buffer-overflow /bin/bash
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
   Hello, Alice!
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
   docker run --rm --name 06-buffer-overflow-cont -it 06-buffer-overflow /bin/bash
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
   Hello, AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA!
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
   What is your name? Hello, AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA!
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
    Exercise 06: Buffer Overflow - Exploit
   ============================================================


   [*] Normal use - short name:
   What is your name? Hello, Alice!

   ------------------------------------------------------------
   [*] Sending 100 'A' characters (buffer is only 64 bytes)...
   What is your name? Hello, AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA!
   ./exploit.sh: line 19:    13 Done                    python3 -c "print('A' * 100)"
           14 Segmentation fault      (core dumped) | ./vuln_code

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
    Exercise 06: Buffer Overflow - Verify Fix
   ============================================================


   [TEST 1] Short name should work normally...
     PASS: Normal input works.

   [TEST 2] 100-byte input must NOT crash the program...
   ./verify_fix.sh: line 26:    21 Done                    python3 -c "print('A' * 100)"
           22 Segmentation fault      (core dumped) | ./vuln_code > /dev/null 2>&1
     FAIL: Program still crashes on large input! (exit 139)

   [TEST 3] 1000-byte input must also be handled safely...
   ./verify_fix.sh: line 38:    23 Done                    python3 -c "print('B' * 1000)"
           24 Segmentation fault      (core dumped) | ./vuln_code > /dev/null 2>&1
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

## Your Tasks

Follow the **Audit → Identify → Validate → Fix → Test** cycle:

1. **Audit** - Read `vuln_code.c`.
   Understand what it does.
1. **Identify** - Find the security flaw.
   What makes the query dangerous?
1. **Validate** - Build the container image.
   Start the container.
   Inside the container run the `exploit.sh` script to confirm the vulnerability exists.
   Exit the container.
1. **Fix** - Edit `vuln_code.c` to use a bounds-checking alternative.
1. **Test** - Start the container.
   Build the container image.
   Inside the container run the `verify_fix.sh` script to confirm the vulnerability is now removed.
   Exit the container.

If everything is OK (and you fixed the program and removed the vulnerability), all 3 tests in the `verify_fix.sh` script will pass:

```console
root@45df6e3bc5da:/app# ./verify_fix.sh
============================================================
 Exercise 06: Buffer Overflow - Verify Fix
============================================================


[TEST 1] Short name should work normally...
  PASS: Normal input works.

[TEST 2] 100-byte input must NOT crash the program...
  PASS: Large input handled without crash.

[TEST 3] 1000-byte input must also be handled safely...
  PASS: 1000-byte input handled safely.

============================================================
 Results: 3 passed, 0 failed
============================================================
 All tests passed! Great work.
```

## Background: Stack Memory Layout

```text
High addresses
  ┌─────────────────────┐
  │  return address     │  ← gets() can overwrite this!
  ├─────────────────────┤
  │  saved frame ptr    │
  ├─────────────────────┤
  │  buffer[63]         │
  │  buffer[62]         │
  │  ...                │
  │  buffer[0]          │  ← input starts here
  └─────────────────────┘
Low addresses
```

Writing past `buffer[63]` corrupts the return address - the program jumps to an attacker-controlled location when the function returns.

## Hints

<details>
<summary>Hint 1 - What is the flaw?</summary>

`gets()` reads from stdin until a newline or EOF - **with no length limit**.
It will happily write hundreds of bytes into a 64-byte buffer, corrupting everything on the stack above it.

`gets()` is so dangerous it was **removed from the C standard in C11**.
</details>

<details>
<summary>Hint 2 - How to fix it?</summary>

Replace `gets()` with `fgets()`, which requires a maximum length:

```c
fgets(buffer, sizeof(buffer), stdin);
```

`fgets()` reads at most `sizeof(buffer) - 1` bytes and always null-terminates.
Note: `fgets()` includes the newline `\n` - you may want to strip it:

```c
buffer[strcspn(buffer, "\n")] = '\0';
```
</details>
