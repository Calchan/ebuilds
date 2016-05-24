# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Puzzle game where you help mice in their relentless quest for cheese"
SRC_URI="gog_${PN}_${PV}.sh"
GOG_NAME="MouseCraft"
GOG_PAGE="mousecraft"
GOG_EXE="MouseCraft"
GOG_TYPE="64BIT"

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
