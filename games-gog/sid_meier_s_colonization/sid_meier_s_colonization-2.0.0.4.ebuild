# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Turn-based strategy game on the colonization of the New World"
GOG_NAME="Sid Meier's Colonization"
GOG_PAGE="sid_meiers_colonization"
GOG_EXE="COLONIZE.BAT"
GOG_NO_SYMLINK="AMER2.MP"

inherit gog-dos

src_prepare() {
	gog-dos_wrapper ${PN}_editor MAPEDIT.EXE
	gog-dos_src_prepare
}

src_install() {
	gog_install -d data/MPS/COLONIZE
	dobin gog_${PN}_editor
	make_desktop_entry gog_${PN}_editor "${GOG_NAME}" gog_${PN} "" "Comment=Map editor"
	gog-dos_src_install
}
