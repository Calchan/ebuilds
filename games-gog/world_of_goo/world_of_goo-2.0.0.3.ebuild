# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# TODO unbundle mono?
# TODO delete files for the other arch

EAPI=6

DESCRIPTION="Physics-based puzzle/construction game"
GOG_NAME="World of Goo"
GOG_VERSION=1
GOG_EXE=WorldOfGoo.bin
GOG_BUNDLE="
	media-libs/libogg
	media-libs/libsdl
	media-libs/sdl-mixer
"

inherit gog-3264

src_install() {
	if use unbundle; then
		rm -f game/libs*
	else
		if use amd64; then
			rm -rf game/libs32 || die
			mv game/libs64 game/lib || die
		else
			rm -rf game/libs64 || die
			mv game/libs32 game/lib || die
		fi
	fi
	gog_install -d game
	gog-3264_src_install
}
