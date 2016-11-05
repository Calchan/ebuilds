# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Rotate a triangle around a spinning, pulsating hexagon"
GOG_NAME="Super Hexagon"
GOG_VERSION=1
GOG_EXE=superhexagon
GOG_BUNDLE="
	media-libs/freeglut
	media-libs/glew
	media-libs/libogg
	media-libs/libvorbis
	media-libs/openal
	virtual/glu
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libxcb
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXxf86vm
"

inherit gog-3264

src_install() {
	if use amd64; then
		rm -rf game/x86 || die
		mv game/x86_64 game/lib || die
	else
		rm -rf game/x86_64 || die
		mv game/x86 game/lib || die
	fi
	mv game/lib/superhexagon.x86* game || die
	if use unbundle; then
		rm -rf game/lib || die
	fi
	gog_install -d game
	gog-3264_src_install
}
