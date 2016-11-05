# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# TODO unbundle mono?
# TODO delete files for the other arch

EAPI=6

DESCRIPTION="Puzzle platformer about a young vampire who just inherited a haunted castle"
GOG_NAME="The Adventures of Shuggy"
GOG_VERSION=1
GOG_EXE=Shuggy.bin
GOG_BUNDLE="
	media-libs/libogg
	media-libs/libsdl2
	media-libs/libtheora
	media-libs/libvorbis
	media-libs/openal
"

inherit gog-3264

src_install() {
	if use amd64; then
		rm -rf game/lib || die
		mv game/lib64 game/lib || die
	else
		rm -rf game/lib64 || die
	fi
	if use unbundle; then
		rm -f game/lib/lib{ogg.*,openal.*,SDL2-*,theoradec.*,vorbis.*} || die
	fi
	gog_install -d game
	gog-3264_src_install
}
