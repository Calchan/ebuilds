# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Classic first-person RPG, save the city of Myth Drannor"
GOG_NAME="Eye of the Beholder III: Assault on Myth Drannor"
GOG_PAGE="forgotten_realms_the_archives_collection_one"
GOG_EXE="EYE.BAT"
GOG_LOCAL_COPY="SAVEGAME"

inherit gog-dos

src_install() {
	gog_install -d data
	for name in DARK FINALE INTRO LICH; do
		fowners root:users ${GOG_DIR}/${name}.GFF
		fperms g+w ${GOG_DIR}/${name}.GFF
	done
	gog-dos_src_install
}
