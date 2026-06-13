#!/bin/sh

test_description='mirrors via reflector (dry-run only; the saving path rewrites
/etc and force-syncs, too disruptive to run mid-suite)'

. ./test-lib.sh

test_expect_success 'dry-run runs reflector, prints mirrors, no save, no sync' '
	reset_calls &&
	aptac --no-color mirrors --dry-run >out &&
	grep_call "reflector --protocol https --latest 20 --sort rate" &&
	! grep_call "--save" &&
	! grep_call "pacman -Syy" &&
	grep -q "^Server = " out
'

test_expect_success 'passthrough flags are appended after the defaults' '
	reset_calls &&
	aptac --no-color mirrors --dry-run --country France >out &&
	grep_call "reflector --protocol https --latest 20 --sort rate --country France"
'

test_done
