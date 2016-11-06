# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Fast music/rhythm-platformer"
GOG_NAME="BIT.TRIP RUNNER"
GOG_VERSION=1
GOG_PAGE=bittrip_runner
GOG_INSTALLER=bittrip_runner
GOG_EXE=bit.trip.runner
RDEPEND="
	media-libs/libogg
	media-libs/libsdl
	media-libs/libvorbis
	media-libs/openal
	sys-libs/zlib
"

inherit gog-3264

src_install() {
	if use amd64; then
		mv game/bit.trip.runner-1.0-64/bit.trip.runner/* game || die
		rm -rf game/bit.trip.runner-1.0-32 || die
	else
		mv game/bit.trip.runner-1.0-32/bit.trip.runner/* game || die
		rm -rf game/bit.trip.runner-1.0-64 || die
	fi
	gog_install -d game
	gog-3264_src_install
}
