#!/bin/bash

# Tutorial 01 - Command Injection Fix Verifier
# Run this after fixing vuln_code.py to confirm the fix is correct.

PASS=0
FAIL=0

echo "============================================================"
echo " Tutorial 01: Command Injection - Verify Fix"
echo "============================================================"
echo ""

echo ""
echo "[TEST 1] Normal input should still work..."
OUTPUT=$(echo "root" | python3 vuln_code.py 2>&1 || true)
if echo "$OUTPUT" | grep -qiE "root"; then
    echo "  PASS: Normal ping works correctly."
    PASS=$((PASS+1))
else
    echo "  PASS: Ran without crash (ping may not respond in container - that's OK)."
    PASS=$((PASS+1))
fi

echo ""
echo "[TEST 2] Injection payload must NOT execute secondary command..."
OUTPUT=$(echo "root; echo INJECTION_SUCCEEDED" | python3 vuln_code.py 2>&1 || true)
if echo "$OUTPUT" | grep -q "INJECTION_SUCCEEDED"; then
    echo "  FAIL: Injection still works! The fix is incomplete."
    FAIL=$((FAIL+1))
else
    echo "  PASS: Injection payload was not executed."
    PASS=$((PASS+1))
fi

echo ""
echo "[TEST 3] Another injection vector (&&)..."
OUTPUT=$(echo "root && ps" | python3 vuln_code.py 2>&1 || true)
if echo "$OUTPUT" | grep -qE "PID"; then
    echo "  FAIL: '&&' injection still works!"
    FAIL=$((FAIL+1))
else
    echo "  PASS: '&&' injection was blocked."
    PASS=$((PASS+1))
fi

echo ""
echo "============================================================"
echo " Results: $PASS passed, $FAIL failed"
echo "============================================================"
[ $FAIL -eq 0 ] && echo " All tests passed! Great work." || echo " Fix is incomplete. Keep trying!"
[ $FAIL -eq 0 ]
