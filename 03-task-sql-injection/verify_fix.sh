#!/bin/bash
# Exercise 03 - SQL Injection Fix Verifier

PASS=0
FAIL=0

echo "============================================================"
echo " Exercise 03: SQL Injection - Verify Fix"
echo "============================================================"
echo ""

echo ""
echo "[TEST 1] Correct credentials must still work..."
OUTPUT=$(printf "admin\nsupersecret123\n" | python3 vuln_code.py 2>&1)
if echo "$OUTPUT" | grep -q "Login successful"; then
    echo "  PASS: Correct credentials accepted."
    PASS=$((PASS+1))
else
    echo "  FAIL: Legitimate login is broken!"
    FAIL=$((FAIL+1))
fi

echo ""
echo "[TEST 2] Wrong password must be rejected..."
OUTPUT=$(printf "admin\nwrongpassword\n" | python3 vuln_code.py 2>&1)
if echo "$OUTPUT" | grep -q "Login failed"; then
    echo "  PASS: Wrong password rejected."
    PASS=$((PASS+1))
else
    echo "  FAIL: Wrong password was accepted!"
    FAIL=$((FAIL+1))
fi

echo ""
echo "[TEST 3] Classic injection (admin'--) must not bypass login..."
OUTPUT=$(printf "admin'--\nwrongpassword\n" | python3 vuln_code.py 2>&1)
if echo "$OUTPUT" | grep -q "Login successful"; then
    echo "  FAIL: SQL injection still bypasses login!"
    FAIL=$((FAIL+1))
else
    echo "  PASS: SQL injection rejected."
    PASS=$((PASS+1))
fi

echo ""
echo "[TEST 4] OR-based injection must be blocked..."
OUTPUT=$(printf "admin' OR '1'='1\nwrongpassword\n" | python3 vuln_code.py 2>&1)
if echo "$OUTPUT" | grep -q "Login successful"; then
    echo "  FAIL: OR-injection still works!"
    FAIL=$((FAIL+1))
else
    echo "  PASS: OR-injection blocked."
    PASS=$((PASS+1))
fi

echo ""
echo "============================================================"
echo " Results: $PASS passed, $FAIL failed"
echo "============================================================"
[ $FAIL -eq 0 ] && echo " All tests passed! Great work." || echo " Fix is incomplete. Keep trying!"
[ $FAIL -eq 0 ]
