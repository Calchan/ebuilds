# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="4X turn-based strategy game"
GOG_NAME="Master of Orion II"
GOG_PAGE=master_of_orion_1_2
GOG_VERSION=1
GOG_EXE=Orion2.exe
GOG_NO_SYMLINK="MOX.SET SOUND.LBX"

inherit gog-dos

src_install() {
	gog_install -d data
	gog-dos_src_install
}
