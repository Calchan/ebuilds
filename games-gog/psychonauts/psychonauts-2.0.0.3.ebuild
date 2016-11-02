# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Delve into people's minds"
GOG_NAME="Psychonauts"
GOG_VERSION=1
GOG_BUNDLE="
	media-libs/glu
	media-libs/libsdl
	media-libs/openal
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libxcb
	x11-libs/libXcursor
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libXrender
"
GOG_EXE=Psychonauts

inherit gog-32

src_install() {
	if use unbundle; then
		rm -f game/{libopenal.so.1,libSDL-1.2.so.0} || die
	else
		mv game/{libopenal.so.1,libSDL-1.2.so.0} lib || die
	fi
	gog_install -d game
	use unbundle || gog_install lib
	gog-32_src_install
}
