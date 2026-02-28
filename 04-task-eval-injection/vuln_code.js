'use strict';

/**
 * Exercise 04 - eval() Injection
 * WORKSHOP: Secure Programming
 *
 * Audit: Read this code carefully. Can you spot the security flaw?
 *
 * A simple CLI calculator: reads a math expression and prints the result.
 */

const readline = require('readline');
const SAFE_MATH = /^[\d\s+\-*/.()]+$/;

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
    terminal: false
});

rl.question('Enter a math expression (e.g. 2+2): ', (input) => {
    try {
        if (!SAFE_MATH.test(input.trim())) {
            console.error('Error: only numeric expressions are allowed.');
            process.exit(1);
        }

        // Only reach here if input is safe
        const result = Function('"use strict"; return (' + input + ')')();
        console.log(`Result: ${result}`);
    } catch (err) {
        console.error(`Error: ${err.message}`);
    }
    rl.close();
});
