# Exercise 06 – Buffer Overflow

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

1. Validate the issue using the `exploit.sh` script inside the container:

   ```console
   root@2a4db176d366:/app# ./exploit.sh
   ============================================================
    Exercise 06: Buffer Overflow - Exploit
   ============================================================


   [*] Normal use - short name:
   What is your name? Hello, Alice!

   ------------------------------------------------------------
   [*] Sending 100 'A' characters (buffer is only 64 bytes)...
   What is your name? Hello, AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA!
   ./exploit.sh: line 19:    11 Done                    python3 -c "print('A' * 100)"
           12 Segmentation fault      (core dumped) | ./vuln_code

   [!] Program CRASHED with a segmentation fault (exit 139)!
   [!] Overwriting stack memory beyond the buffer caused the crash.
   [!] In an exploitable program, this can redirect execution to attacker code.
   ```

1. Test the vulnerability.
   At this point, it will fail:

   ```console
   root@2a4db176d366:/app# ./verify_fix.sh
   ============================================================
    Exercise 06: Buffer Overflow - Verify Fix
   ============================================================


   [TEST 1] Short name should work normally...
     PASS: Normal input works.

   [TEST 2] 100-byte input must NOT crash the program...
   ./verify_fix.sh: line 26:    19 Done                    python3 -c "print('A' * 100)"
           20 Segmentation fault      (core dumped) | ./vuln_code > /dev/null 2>&1
     FAIL: Program still crashes on large input! (exit 139)

   [TEST 3] 1000-byte input must also be handled safely...
   ./verify_fix.sh: line 38:    21 Done                    python3 -c "print('B' * 1000)"
           22 Segmentation fault      (core dumped) | ./vuln_code > /dev/null 2>&1
     FAIL: Program crashes on 1000-byte input! (exit 139)

   ============================================================
    Results: 1 passed, 2 failed
   ============================================================
    Fix is incomplete. Keep trying!
   ```

1. Exit (and stop, and remove) the container:

   ```console
   root@45df6e3bc5da:/app#
   exit
   ```

   You will get your initial host console.

## Your Tasks

Follow the **Audit → Identify → Validate → Fix → Test** cycle:

1. **Audit** – Read `vuln_code.c`.
   Understand what it does.
1. **Identify** – Find the security flaw.
   What makes the query dangerous?
1. **Validate** – Build the container image.
   Start the container.
   Inside the container run the `exploit.sh` script to confirm the vulnerability exists.
   Exit the container.
1. **Fix** – Edit `vuln_code.c` to use a bounds-checking alternative.
1. **Test** – Start the container.
   Build the container image.
   Inside the container run the `verify_fix.sh` script to confirm the vulnerability is now removed.
   Exit the container.

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

Writing past `buffer[63]` corrupts the return address — the program jumps to an attacker-controlled location when the function returns.

## Hints

<details>
<summary>Hint 1 – What is the flaw?</summary>

`gets()` reads from stdin until a newline or EOF — **with no length limit**.
It will happily write hundreds of bytes into a 64-byte buffer, corrupting
everything on the stack above it.

`gets()` is so dangerous it was **removed from the C standard in C11**.
</details>

<details>
<summary>Hint 2 – How to fix it?</summary>

Replace `gets()` with `fgets()`, which requires a maximum length:

```c
fgets(buffer, sizeof(buffer), stdin);
```

`fgets()` reads at most `sizeof(buffer) - 1` bytes and always null-terminates.
Note: `fgets()` includes the newline `\n` — you may want to strip it:

```c
buffer[strcspn(buffer, "\n")] = '\0';
```
</details>
