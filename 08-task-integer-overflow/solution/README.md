# Exercise 08 – Solution: Negative Amount

## The Flaw

```c
void transfer(int amount)
{
    if (balance >= amount) {   // passes when amount is negative!
        balance -= amount;     // subtraction of negative = addition
    }
}
```

`int` in C can hold negative values.
The guard `balance >= amount` was designed to prevent overdraft, but it never checks the *sign* of `amount`. When `amount` is -500:
- `1000 >= -500` is **true** → check passes
- `balance -= -500` → `balance = 1500` → free money!

## The Fix

```c
void transfer(int amount)
{
    // SECURE: validate sign before anything else
    if (amount <= 0) {
        printf("[-] Invalid amount: must be positive.\n");
        return;
    }
    if (balance >= amount) {
        balance -= amount;
    }
}
```

A single `amount <= 0` guard eliminates the attack.
It appears **before** the balance check — defense at the point of input, not buried in logic.

## Key Principle

> **Validate all input constraints — not just the ones that seem obvious.**
> "Transfer amount" implies positive; enforce that explicitly in code.

## Related Vulnerabilities

- [CWE-20: Improper Input Validation](https://cwe.mitre.org/data/definitions/20.html)
- [CWE-191: Integer Underflow](https://cwe.mitre.org/data/definitions/191.html)
