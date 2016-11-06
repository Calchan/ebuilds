# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Darkly humorous over-the-top surgery simulation"
GOG_NAME="Surgeon Simulator 2013"
GOG_VERSION=1
GOG_EXE=ss2013.bin
RDEPEND="
	virtual/glu
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXext
"

inherit gog-3264

src_install() {
	if use amd64; then
		mv game/64/* game || die
	else
		mv game/32/* game || die
	fi
	rm -rf game/{32,64} || die
	gog_install -d game
	gog-3264_src_install
}
