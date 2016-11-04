# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# TODO unbundle mono?
# TODO delete files for the other arch

EAPI=6

DESCRIPTION="Hand-painted action RPG with a reactive narrator"
GOG_NAME="Bastion"
GOG_VERSION=1
GOG_EXE=Bastion.bin
GOG_BUNDLE="
	media-libs/libsdl2
"

inherit gog-3264

src_install() {
	if use unbundle; then
		rm -f game/lib{,64}/libSDL2-2.0.so.0 || die
	fi
	if use amd64; then
		rm -rf game/lib || die
		mv game/lib64 game/lib || die
	else
		rm -rf game/lib64 || die
	fi
	gog_install -d game
	gog-3264_src_install
}
