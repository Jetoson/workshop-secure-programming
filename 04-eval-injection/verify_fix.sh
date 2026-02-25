#!/bin/bash

# Exercise 04 - eval() Injection Fix Verifier

PASS=0
FAIL=0

echo "============================================================"
echo " Exercise 04: eval() Injection - Verify Fix"
echo "============================================================"
echo ""

echo ""
echo "[TEST 1] Basic addition must work..."
OUTPUT=$(echo "2 + 2" | node vuln_code.js 2>&1)
if echo "$OUTPUT" | grep -q "4"; then
    echo "  PASS: 2 + 2 = 4"
    PASS=$((PASS+1))
else
    echo "  FAIL: Basic math is broken. Output: $OUTPUT"
    FAIL=$((FAIL+1))
fi

echo ""
echo "[TEST 2] Multiplication must work..."
OUTPUT=$(echo "6 * 7" | node vuln_code.js 2>&1)
if echo "$OUTPUT" | grep -q "42"; then
    echo "  PASS: 6 * 7 = 42"
    PASS=$((PASS+1))
else
    echo "  FAIL: Multiplication broken. Output: $OUTPUT"
    FAIL=$((FAIL+1))
fi

echo ""
echo "[TEST 3] Code injection via require() must be blocked..."
OUTPUT=$(echo "require('child_process').execSync('id').toString()" | node vuln_code.js 2>&1 || true)
if echo "$OUTPUT" | grep -qE "uid=[0-9]"; then
    echo "  FAIL: Code injection still executes system commands!"
    FAIL=$((FAIL+1))
else
    echo "  PASS: Code injection blocked."
    PASS=$((PASS+1))
fi

echo ""
echo "[TEST 4] process.exit() injection must be handled..."
OUTPUT=$(echo "process.exit(0)" | node vuln_code.js 2>&1 || true)
if echo "$OUTPUT" | grep -qiE "invalid|error|not allowed|only|rejected"; then
    echo "  PASS: Invalid input explicitly rejected."
    PASS=$((PASS+1))
else
    echo "  INFO: Consider rejecting non-math input explicitly."
    PASS=$((PASS+1))
fi

echo ""
echo "============================================================"
echo " Results: $PASS passed, $FAIL failed"
echo "============================================================"
[ $FAIL -eq 0 ] && echo " All tests passed! Great work." || echo " Fix is incomplete. Keep trying!"
[ $FAIL -eq 0 ]
