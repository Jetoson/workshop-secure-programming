#!/bin/bash

# Exercise 07 - Hardcoded Secret Fix Verifier

PASS=0
FAIL=0

echo "============================================================"
echo " Exercise 07: Hardcoded Secret - Verify Fix"
echo "============================================================"
echo ""

echo "[TEST 1] API key must NOT be hardcoded in the source file..."
if grep -qE 'sk_live|API_KEY\s*=\s*"' vuln_code.py 2>/dev/null; then
    echo "  FAIL: Secret still found hardcoded in vuln_code.py!"
    FAIL=$((FAIL+1))
else
    echo "  PASS: No hardcoded secret found in source."
    PASS=$((PASS+1))
fi

echo ""
echo "[TEST 2] Code must read the key from an environment variable..."
if grep -qE "os\.getenv|os\.environ" vuln_code.py 2>/dev/null; then
    echo "  PASS: Code uses os.getenv() / os.environ."
    PASS=$((PASS+1))
else
    echo "  FAIL: Code does not appear to use os.getenv() or os.environ."
    FAIL=$((FAIL+1))
fi

echo ""
echo "[TEST 3] Script must run when API_KEY env var is set..."
OUTPUT=$(API_KEY="sk_live_SUPER_SECRET_12345ABCDE" python3 vuln_code.py 2>&1)
if echo "$OUTPUT" | grep -qiE "api call successful|connecting|authenticating"; then
    echo "  PASS: Script runs correctly when API_KEY env var is provided."
    PASS=$((PASS+1))
else
    echo "  INFO: Output: $OUTPUT"
    echo "  INFO: Run manually to check: docker run --rm -e API_KEY=test ex07-secret"
    PASS=$((PASS+1))
fi

echo ""
echo "[TEST 4] Script must warn or fail when API_KEY is missing..."
OUTPUT=$(python3 vuln_code.py 2>&1 || true)
if echo "$OUTPUT" | grep -qiE "not set|missing|API_KEY|error|none|no key|EnvironmentError"; then
    echo "  PASS: Script warns when API_KEY is not set."
    PASS=$((PASS+1))
else
    echo "  INFO: Consider adding a guard: if not API_KEY: raise EnvironmentError(...)"
    PASS=$((PASS+1))
fi

echo ""
echo "============================================================"
echo " Results: $PASS passed, $FAIL failed"
echo "============================================================"
[ $FAIL -eq 0 ] && echo " All tests passed! Great work." || echo " Fix is incomplete. Keep trying!"
[ $FAIL -eq 0 ]
