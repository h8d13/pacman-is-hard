#!/bin/sh
# Run every t[0-9]*.sh, stream a per-script PASS/FAIL line, and exit non-zero
# if any script failed. Output is TAP, so `prove ./t[0-9]*.sh` also works.
# Pass -v to surface each test body's output.

cd "$(dirname "$0")" || exit 1
ret=0
for t in t[0-9]*.sh; do
	test -f "$t" || continue
	if sh "$t" "$@" >"$t.log" 2>&1; then
		echo "PASS $t"
	else
		echo "FAIL $t"
		ret=1
		grep -E '^(not ok|Bail out!|# failed)' "$t.log" | sed 's/^/    /'
	fi
done
exit $ret
