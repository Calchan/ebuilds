# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Classic game of 4X science fiction strategy"
GOG_NAME="Master of Orion"
GOG_PAGE="master_of_orion_1_2"
GOG_EXE="ORION.EXE"
GOG_NO_SYMLINK="CONFIG.MOO"

inherit gog-dos

src_install() {
	gog_install -d data
	gog-dos_src_install
}
