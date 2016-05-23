# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Puzzle game where you help mice in their relentless quest for cheese"
GOG_NAME="MouseCraft"
GOG_PAGE="mousecraft"
SRC_URI="gog_${PN}_${PV}.sh"
GOG_EXE="Mouse"
GOG_ICON="support/icon.png"
GOG_NATIVE64=1

inherit gog

KEYWORDS="~amd64 ~x86"

src_install() {
	gog_move -d game
	if use unbundle; then
		gog_linklib libjson-c.so libjson.so.0
	else
		gog_move lib
	fi
	gog_move docs/Manuals
	gog_src_install
}
