# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Family friendly, hand-animated, puzzle-filled adventure"
GOG_NAME="Broken Age"
GOG_VERSION=2
GOG_EXE=BrokenAge
GOG_BUNDLE="
	media-libs/libsdl2
	x11-libs/libX11
"

inherit gog-32

src_install() {
	if use unbundle; then
		rm -rf game/lib/libSDL2-2.0.so.0 || die
	fi
	gog_install -d game
	gog-32_src_install
}
