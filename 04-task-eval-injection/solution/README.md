# Exercise 04 – Solution: eval() Injection

## The Flaw

```javascript
const result = eval(input);  // executes ANY JavaScript
```

`eval()` compiles and runs its argument as a JavaScript program in the current scope.
An attacker can pass `require('child_process').execSync('id').toString()` - which runs an OS command and returns the output as the "result".

## The Fix

```javascript
const SAFE_MATH_PATTERN = /^[\d\s+\-*/.()]+$/;

if (!SAFE_MATH_PATTERN.test(input)) {
    console.error('Error: only numeric/arithmetic expressions are allowed.');
    return;
}
const result = Function('"use strict"; return (' + input + ')')();
```

1. **Regex whitelist** — accepts only characters that can appear in arithmetic.
   Letters, backticks, brackets, semicolons, etc. are all rejected before evaluation.
2. **`Function()` instead of `eval()`** — runs in a separate scope (no access to local variables), adding defence-in-depth.

## Key Principle

> **Never pass unsanitized user input to eval() or similar dynamic code execution functions.**
> Prefer purpose-built parsers; when none exists, use strict input whitelisting.

## Related Vulnerabilities

- [CWE-95: Improper Neutralization of Directives in Dynamically Evaluated Code](https://cwe.mitre.org/data/definitions/95.html)
- [OWASP A05:2025 – Injection](https://owasp.org/Top10/2025/A05_2025-Injection/)
