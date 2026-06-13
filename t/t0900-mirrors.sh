#!/bin/sh

test_description='mirrors via reflector'

. ./test-lib.sh

test_expect_success 'dry-run prints the reflector cmd, no save, no sync' '
	reset_calls &&
	aptac --no-color mirrors --dry-run >out &&
	grep_call "reflector --protocol https --latest 20 --sort rate" &&
	! grep_call "--save" &&
	! grep_call "pacman -Syy"
'

test_expect_success 'saves the mirrorlist then force-syncs' '
	reset_calls &&
	aptac --no-color mirrors >out &&
	grep_call "reflector --protocol https --latest 20 --sort rate --save /etc/pacman.d/mirrorlist" &&
	grep_call "pacman -Syy"
'

test_expect_success 'passthrough flags are appended (can override defaults)' '
	reset_calls &&
	aptac --no-color mirrors --dry-run --country France >out &&
	grep_call "--country France"
'

test_done
