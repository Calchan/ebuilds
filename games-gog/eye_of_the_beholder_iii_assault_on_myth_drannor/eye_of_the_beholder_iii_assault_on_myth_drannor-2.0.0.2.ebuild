# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Classic first-person RPG, save the city of Myth Drannor"
GOG_NAME="Eye of the Beholder III: Assault on Myth Drannor"
GOG_PAGE="forgotten_realms_the_archives_collection_one"
GOG_EXE="EYE.BAT"
GOG_TYPE="DOSBOX"
GOG_LOCAL_COPY="SAVEGAME"

inherit gog

KEYWORDS="~amd64 ~x86"

src_install() {
	gog_install -d data
	gog_src_install
	fperms -R g+w ${GOG_DIR}/*.GFF
}
