# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Cold War combat flight simulator"
GOG_NAME="F-117A Nighthawk Stealth Fighter 2.0"
GOG_PAGE="f117a_nighthawk_stealth_fighter_20"
GOG_EXE="F117.COM"
GOG_LOCAL_COPY="ROSTER.FIL"

inherit gog-dos

src_install() {
	gog_install -d data
	gog-dos_src_install
}
