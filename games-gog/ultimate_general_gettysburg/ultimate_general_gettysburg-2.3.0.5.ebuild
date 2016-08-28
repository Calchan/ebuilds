# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# TODO Unbundle mono?

EAPI=6

DESCRIPTION="Tactical simulation of the Battle of Gettysburg"
GOG_NAME="Ultimate General: Gettysburg"
GOG_PAGE="ultimate_general_gettysburg"
GOG_EXE="Ultimate General Gettysburg"
GOG_EXTRA_EXE="Ultimate General Multiplayer"
GOG_EXTRA_NAME="Ultimate General: Gettysburg (Multiplayer)"
GOG_EXTRA_DESCRIPTION="Multiplayer client for Ultimate General: Gettysburg"

inherit gog-3264

src_install() {
	gog_install -d game
	gog-3264_src_install
}
