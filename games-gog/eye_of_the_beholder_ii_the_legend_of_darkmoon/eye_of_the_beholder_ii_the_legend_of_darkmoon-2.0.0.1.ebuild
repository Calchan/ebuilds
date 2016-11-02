# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Classic first-person RPG, investigate the temple of Darkmoon"
GOG_NAME="Eye of the Beholder II: The Legend of Darkmoon"
GOG_PAGE=forgotten_realms_the_archives_collection_one
GOG_VERSION=1
GOG_EXE=START.EXE

inherit gog-dos

src_install() {
	gog_install -d data
	gog-dos_src_install
}
