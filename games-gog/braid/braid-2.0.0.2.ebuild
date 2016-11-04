# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Puzzle platformer, manipulate the flow of time"
GOG_NAME="Braid"
GOG_VERSION=1
GOG_EXE=launcher.bin.x86
GOG_BUNDLE="
	media-gfx/nvidia-cg-toolkit
	media-libs/libsdl2
	x11-libs/fltk
	x11-libs/libX11
"

inherit gog-32

src_install() {
	if use unbundle; then
		rm -rf game/lib || die
	fi
	gog_install -d game
	gog-32_src_install
}
