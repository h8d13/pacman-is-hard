#!/bin/sh

test_description='install / uninstall against real pacman (uses the tiny "tree" pkg)'

. ./test-lib.sh

test_expect_success 'install runs -S and the package lands' '
	reset_calls &&
	aptac --no-color install tree --noconfirm >out &&
	grep_call "pacman -S" &&
	pacman -Q tree
'

test_expect_success 'uninstall runs -Rns and the package is gone' '
	reset_calls &&
	aptac --no-color uninstall tree --noconfirm >out &&
	grep_call "pacman -Rns" &&
	! pacman -Q tree
'

test_expect_success 'install "pkg-" uninstalls' '
	pacman -S --noconfirm tree &&
	reset_calls &&
	aptac --no-color install tree- --noconfirm >out &&
	grep_call "pacman -Rns" &&
	! pacman -Q tree
'

test_expect_success 'uninstall --no-deps runs -R (not -Rns)' '
	pacman -S --noconfirm tree &&
	test_when_finished "pacman -Rns --noconfirm tree 2>/dev/null || true" &&
	reset_calls &&
	aptac --no-color uninstall tree --no-deps --noconfirm >out &&
	grep_call "pacman -R " &&
	! grep_call "pacman -Rns" &&
	! pacman -Q tree
'

test_expect_success 'a freshly installed package tops --last 1' '
	pacman -Rns --noconfirm tree 2>/dev/null || true &&
	test_when_finished "pacman -Rns --noconfirm tree 2>/dev/null || true" &&
	aptac --no-color install tree --noconfirm >out &&
	aptac --no-color list --last 1 >last &&
	tail -n 1 last >name &&
	grep -q "^tree-" name
'

test_expect_success 'install with no package errors' '
	test_must_fail aptac install
'

test_expect_success 'uninstall with no package errors' '
	test_must_fail aptac uninstall
'

test_done
