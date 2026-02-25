'use strict';

/**
 * Exercise 04 - eval() Injection: FIXED VERSION
 *
 * Fix: Validate input against a strict regex whitelist before evaluating.
 *      Only digits, operators, parentheses, and whitespace are allowed.
 *      This prevents any non-math code from reaching the evaluator.
 */

const readline = require('readline');

// Whitelist: digits, spaces, +, -, *, /, ., (, )
// Anything else (letters, require, process, backticks, etc.) is rejected.
const SAFE_MATH_PATTERN = /^[\d\s+\-*/.()]+$/;

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
    terminal: false
});

rl.question('Enter a math expression (e.g. 2+2): ', (input) => {
    const trimmed = input.trim();

    // SECURE: reject anything that isn't a simple arithmetic expression
    if (!SAFE_MATH_PATTERN.test(trimmed)) {
        console.error('Error: only numeric/arithmetic expressions are allowed.');
        rl.close();
        return;
    }

    try {
        // Use Function() in strict mode for tighter scope than bare eval(),
        // but the regex guard above is the primary security control.
        const result = Function('"use strict"; return (' + trimmed + ')')();
        console.log(`Result: ${result}`);
    } catch (err) {
        console.error(`Error: ${err.message}`);
    }
    rl.close();
});
