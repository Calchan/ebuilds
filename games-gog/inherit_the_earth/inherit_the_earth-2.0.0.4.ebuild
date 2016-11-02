# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Adventure game full of talking, humanoid animals"
GOG_NAME="Inherit the Earth"
GOG_VERSION=1
GOG_EXE=itegame

inherit gog-3264

src_install() {
	gog_install -d game
	gog_install docs/Manual.pdf
	gog-3264_src_install
}
