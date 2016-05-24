# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Epic fantasy RPG mixing mystery, intrigue, and adventure"
SRC_URI="gog_${PN}_${PV}.sh"
GOG_NAME="Baldur's Gate: Enhanced Edition"
GOG_PAGE="baldurs_gate_enhanced_edition"
GOG_BUNDLE="
	dev-libs/expat
	dev-libs/json-c
	dev-libs/openssl
	media-libs/openal
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libxcb
	x11-libs/libXcursor
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXrender
"
GOG_EXE="BaldursGate"

inherit gog

KEYWORDS="~amd64 ~x86"

src_install() {
	gog_install -d game
	if use unbundle; then
		gog_linklib libjson-c.so libjson.so.0
	else
		gog_install lib
	fi
	gog_install docs/Manuals
	gog_src_install
}
