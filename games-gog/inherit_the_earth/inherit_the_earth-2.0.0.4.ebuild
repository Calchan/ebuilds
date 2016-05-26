# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Adventure game full of talking, humanoid animals"
GOG_NAME="Inherit the Earth"
GOG_PAGE="inherit_the_earth"
GOG_EXE="itegame"
GOG_TYPE="64BIT"

inherit gog

KEYWORDS="~amd64 ~x86"

src_install() {
	gog_install -d game
	gog_install docs/Manual.pdf
	gog_src_install
}
