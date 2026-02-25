#!/bin/bash

# Exercise 06 - Buffer Overflow Fix Verifier

PASS=0
FAIL=0

echo "============================================================"
echo " Exercise 06: Buffer Overflow - Verify Fix"
echo "============================================================"
echo ""

echo ""
echo "[TEST 1] Short name should work normally..."
OUTPUT=$(echo "Alice" | ./vuln_code 2>&1 || true)
if echo "$OUTPUT" | grep -q "Hello"; then
    echo "  PASS: Normal input works."
    PASS=$((PASS+1))
else
    echo "  FAIL: Normal input is broken."
    FAIL=$((FAIL+1))
fi

echo ""
echo "[TEST 2] 100-byte input must NOT crash the program..."
python3 -c "print('A' * 100)" | ./vuln_code > /dev/null 2>&1
EXIT_CODE=$?
if [ "$EXIT_CODE" -eq 139 ] || [ "$EXIT_CODE" -eq 134 ]; then
    echo "  FAIL: Program still crashes on large input! (exit $EXIT_CODE)"
    FAIL=$((FAIL+1))
else
    echo "  PASS: Large input handled without crash."
    PASS=$((PASS+1))
fi

echo ""
echo "[TEST 3] 1000-byte input must also be handled safely..."
python3 -c "print('B' * 1000)" | ./vuln_code > /dev/null 2>&1
EXIT_CODE=$?
if [ "$EXIT_CODE" -eq 139 ] || [ "$EXIT_CODE" -eq 134 ]; then
    echo "  FAIL: Program crashes on 1000-byte input! (exit $EXIT_CODE)"
    FAIL=$((FAIL+1))
else
    echo "  PASS: 1000-byte input handled safely."
    PASS=$((PASS+1))
fi

echo ""
echo "============================================================"
echo " Results: $PASS passed, $FAIL failed"
echo "============================================================"
[ $FAIL -eq 0 ] && echo " All tests passed! Great work." || echo " Fix is incomplete. Keep trying!"
[ $FAIL -eq 0 ]
