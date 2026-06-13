#!/bin/sh

test_description='install, uninstall, and the apt-style pkg- syntax'

. ./test-lib.sh

test_expect_success 'install runs -S' '
	reset_calls &&
	aptac --no-color install firefox >out &&
	grep_call "pacman -S firefox"
'

test_expect_success 'install "pkg-" uninstalls (-Rns)' '
	reset_calls &&
	aptac --no-color install firefox- >out &&
	grep_call "pacman -Rns firefox"
'

test_expect_success 'uninstall runs -Rns' '
	reset_calls &&
	aptac --no-color uninstall firefox >out &&
	grep_call "pacman -Rns firefox"
'

test_expect_success 'uninstall --no-deps runs -R' '
	reset_calls &&
	aptac --no-color uninstall firefox --no-deps >out &&
	grep_call "pacman -R firefox"
'

test_expect_success 'install with no package errors' '
	test_must_fail aptac install
'

test_expect_success 'uninstall with no package errors' '
	test_must_fail aptac uninstall
'

test_done
