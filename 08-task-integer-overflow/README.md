# Exercise 08 – Negative Amount (Integer Logic Flaw)

**Language:** C | **Level:** Advanced | **Category:** Integer Safety & Logic

---

## The Scenario

You have been given a simplified banking function.
Users can transfer coins from their account.
The function checks whether the balance is sufficient before proceeding:

```
$ ./vuln_code
Current balance: 1000 coins
Enter transfer amount: 200
[+] Transferred 200 coins. New balance: 800
```

## Directory Contents

| File | Purpose |
|------|---------|
| `vuln_code.c` | The vulnerable program — **edit this to fix it** |
| `exploit.sh` | Demonstrates the logic flaw (Validate step) |
| `verify_fix.sh` | Tests your fix (Test step) |
| `Dockerfile` | Compiles and runs in a container |
| `solution/` | Reference solution (try yourself first!) |

## Running the Exercise

1. Open up a console and terminal to run Docker commands.
   This can be a Linux or macOS terminal or a Windows Command Prompt or PowerShell or WSL terminal.

1. Enter the current directory of the exercise.

1. Build the container image:

   ```console
   docker build -t 08-integer-overflow .
   ```

1. Start the container:

   ```console
   docker run --rm --name 08-integer-overflow-cont -it 08-integer-overflow /bin/bash
   ```

   You will get an interactive prompt inside the container:

   ```console
   root@45df6e3bc5da:/app#
   ```

1. Run the executable:

   ```console
   root@2aa9d853c1a3:/app# ls
   exploit.sh  verify_fix.sh  vuln_code  vuln_code.c

   root@2aa9d853c1a3:/app# ./vuln_code
   Current balance: 1000 coins
   Enter transfer amount: 500
   [+] Transferred 500 coins. New balance: 500
   Current balance: 500 coins
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
   docker run --rm --name 08-integer-overflow-cont -it 08-integer-overflow /bin/bash
   ```

   You will get an interactive prompt inside the container:

   ```console
   root@45df6e3bc5da:/app#
   ```

1. Validate the issue using the `exploit.sh` script inside the container:

   ```console
   root@2a4db176d366:/app# ./exploit.sh
   ============================================================
    Exercise 08: Negative Amount (Integer Logic Flaw) - Exploit
   ============================================================


   [*] Normal transfer of 200 coins:
   Current balance: 1000 coins
   Enter transfer amount: [+] Transferred 200 coins. New balance: 800
   Current balance: 800 coins

   ------------------------------------------------------------
   [*] Transferring -500 coins (negative amount)...
   [*] Logic trace:
       balance = 1000
       amount  = -500
       Check:  balance >= amount  →  1000 >= -500  →  TRUE (passes!)
       Then:   balance -= -500    →  balance = 1000 + 500 = 1500

   Current balance: 1000 coins
   Enter transfer amount: [+] Transferred -500 coins. New balance: 1500
   Current balance: 1500 coins

   [!] We GAINED 500 coins by transferring a negative amount!
   [!] The guard checked for overdraft, but not for negative amounts.
   ```

1. Test the vulnerability.
   At this point, it will fail:

   ```console
   root@2a4db176d366:/app# ./verify_fix.sh
   ============================================================
    Exercise 08: Negative Amount - Verify Fix
   ============================================================


   [TEST 1] Valid transfer (200 from balance of 1000) should succeed...
     PASS: Transfer of 200 leaves balance of 800.

   [TEST 2] Negative transfer (-500) must be REJECTED...
     FAIL: Negative transfer still increases balance to 1500!

   [TEST 3] Transfer exceeding balance must be rejected...
     PASS: Overdraft correctly rejected.

   [TEST 4] Zero transfer should be handled without crash...
     PASS: Zero handled without crash.

   ============================================================
    Results: 3 passed, 1 failed
   ============================================================
    Fix is incomplete. Keep trying!
   ```

1. Exit (and stop, and remove) the container:

   ```console
   root@45df6e3bc5da:/app# exit
   ```

   You will get your initial host console.

## Your Tasks

Follow the **Audit → Identify → Validate → Fix → Test** cycle:

1. **Audit** – Read `vuln_code.c`.
   What does the `transfer()` function do?
1. **Identify** – What happens if `amount` is negative?
   Trace through the logic.
1. **Validate** – Build the container image.
   Start the container.
   Inside the container run the `exploit.sh` script to confirm the vulnerability exists: gain coins using a negative transfer.
   Exit the container.
1. **Fix** – Edit `vuln_code.c` to prevent invalid transfer amounts.
1. **Test** – Start the container.
   Build the container image.
   Inside the container run the `verify_fix.sh` script to confirm the vulnerability is now removed.
   Exit the container.

## The Logic Flaw Explained

```text
balance = 1000
amount  = -500

Check: balance >= amount
       1000    >= -500     → TRUE  (passes!)

Transfer: balance -= amount
          balance -= -500
          balance = balance + 500 = 1500   ← we gained money!
```

## Hints

<details>
<summary>Hint 1 – What is the flaw?</summary>

The function checks `balance >= amount`, which only prevents *overdraft*.
It does not check whether `amount` is positive. A negative `amount` passes
the check (any positive balance is greater than a negative number), then
`balance -= negative_number` *adds* to the balance.
</details>

<details>
<summary>Hint 2 – How to fix it?</summary>

Add an explicit validation that `amount` is positive (and non-zero):

```c
if (amount <= 0) {
    printf("[-] Invalid amount: must be a positive number.\n");
    return;
}
```

Alternatively, use `unsigned int` for `amount` — but be careful: unsigned
arithmetic has its own pitfalls (wraparound). Explicit validation is clearer.
</details>
