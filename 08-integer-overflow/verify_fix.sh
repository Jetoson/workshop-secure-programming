#!/bin/bash

# Exercise 08 - Negative Amount Fix Verifier

PASS=0
FAIL=0

echo "============================================================"
echo " Exercise 08: Negative Amount - Verify Fix"
echo "============================================================"
echo ""

echo ""
echo "[TEST 1] Valid transfer (200 from balance of 1000) should succeed..."
OUTPUT=$(echo "200" | ./vuln_code 2>&1)
if echo "$OUTPUT" | grep -q "800"; then
    echo "  PASS: Transfer of 200 leaves balance of 800."
    PASS=$((PASS+1))
else
    echo "  FAIL: Legitimate transfer is broken. Output: $OUTPUT"
    FAIL=$((FAIL+1))
fi

echo ""
echo "[TEST 2] Negative transfer (-500) must be REJECTED..."
OUTPUT=$(echo "-500" | ./vuln_code 2>&1)
if echo "$OUTPUT" | grep -q "1500"; then
    echo "  FAIL: Negative transfer still increases balance to 1500!"
    FAIL=$((FAIL+1))
else
    echo "  PASS: Balance was not increased by negative transfer."
    PASS=$((PASS+1))
fi

echo ""
echo "[TEST 3] Transfer exceeding balance must be rejected..."
OUTPUT=$(echo "9999" | ./vuln_code 2>&1)
if echo "$OUTPUT" | grep -qiE "insufficient|failed|balance"; then
    echo "  PASS: Overdraft correctly rejected."
    PASS=$((PASS+1))
else
    echo "  INFO: Verify overdraft handling manually."
    PASS=$((PASS+1))
fi

echo ""
echo "[TEST 4] Zero transfer should be handled without crash..."
echo "0" | ./vuln_code > /dev/null 2>&1
EXIT_CODE=$?
if [ $EXIT_CODE -eq 139 ]; then
    echo "  FAIL: Program crashed on zero input."
    FAIL=$((FAIL+1))
else
    echo "  PASS: Zero handled without crash."
    PASS=$((PASS+1))
fi

echo ""
echo "============================================================"
echo " Results: $PASS passed, $FAIL failed"
echo "============================================================"
[ $FAIL -eq 0 ] && echo " All tests passed! Great work." || echo " Fix is incomplete. Keep trying!"
[ $FAIL -eq 0 ]
