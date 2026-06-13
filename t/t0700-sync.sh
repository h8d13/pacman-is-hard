#!/bin/sh

test_description='update, upgrade, check'

. ./test-lib.sh

test_expect_success 'update force-syncs dbs (-Syy)' '
	reset_calls &&
	aptac --no-color update >out &&
	grep_call "pacman -Syy"
'

test_expect_success 'upgrade runs -Syu' '
	reset_calls &&
	aptac --no-color upgrade >out &&
	grep_call "pacman -Syu"
'

test_expect_success 'check lists pending updates (checkupdates)' '
	reset_calls &&
	( export STUB_UPDATES=firefox && aptac --no-color check >out ) &&
	grep_call checkupdates &&
	grep -q firefox out
'

test_expect_success 'check reports up to date when checkupdates exits 2' '
	reset_calls &&
	( export STUB_CHECK_RC=2 && aptac --no-color check >out ) &&
	grep -q "up to date" out
'

test_expect_success 'check propagates a real error (exit 1)' '
	( export STUB_CHECK_RC=1 && test_must_fail aptac --no-color check )
'

test_done
