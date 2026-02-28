# Exercise 06 - Solution: Buffer Overflow

## The Flaw

```c
char buffer[64];
gets(buffer);   // reads unlimited bytes into a 64-byte buffer
```

`gets()` has **no way to limit input**.
It writes bytes from stdin until it sees `\n` or EOF. Input longer than 63 bytes overwrites memory beyond the buffer - including the saved frame pointer and return address on the stack.

This is a **stack-based buffer overflow**.
In the worst case, an attacker crafts input that overwrites the return address with a value pointing to shellcode or a return-oriented-programming (ROP) chain.

## The Fix

```c
fgets(buffer, sizeof(buffer), stdin);
buffer[strcspn(buffer, "\n")] = '\0';   // strip trailing newline
```

`fgets()` reads **at most `sizeof(buffer) - 1`** bytes and always null-terminates.
Any excess input remains in the stdin buffer (or is discarded on EOF).

## Key Principle

> **Always specify a maximum length when reading unbounded input into a fixed buffer.**
> Prefer `fgets()` over `gets()`, `strncpy()` over `strcpy()`, `snprintf()` over `sprintf()`.

## Related Vulnerabilities

- [CWE-121: Stack-based Buffer Overflow](https://cwe.mitre.org/data/definitions/121.html)
- [CWE-120: Buffer Copy without Checking Size of Input](https://cwe.mitre.org/data/definitions/120.html)
