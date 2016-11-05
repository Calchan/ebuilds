# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Journey through the night-time city in this charming card-playing game"
GOG_NAME="Card City Nights"
GOG_VERSION=1
GOG_EXE=CCN
RDEPEND="
	virtual/glu
	x11-libs/libX11
	x11-libs/libXcursor
"

inherit gog-3264

src_install() {
	gog_install -d game
	gog-3264_src_install
}
