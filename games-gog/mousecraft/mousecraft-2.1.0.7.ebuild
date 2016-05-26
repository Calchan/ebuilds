# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# FIXME fix QA_WX_LOAD
# TODO unbundle mono?
# TODO delete files for the other arch

EAPI=5

DESCRIPTION="Puzzle game where you help mice in their relentless quest for cheese"
GOG_NAME="MouseCraft"
GOG_PAGE="mousecraft"
GOG_EXE="MouseCraft"
GOG_TYPE="MULTILIB"

inherit gog

KEYWORDS="~amd64 ~x86"

src_install() {
	gog_install -d game
	gog_src_install
}
