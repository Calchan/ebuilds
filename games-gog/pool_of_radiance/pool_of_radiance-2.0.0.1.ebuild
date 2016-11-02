# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Classic AD&D role-playing game"
GOG_NAME="Pool of Radiance"
GOG_PAGE="forgotten_realms_the_archives_collection_two"
GOG_EXE="poolrad.bat"
GOG_NO_SYMLINK="POOLRAD"

inherit gog-dos

src_prepare() {
	cat <<-EOF >> data/poolrad.bat
		mount c .
		c:
		cd POOLRAD
		START.EXE
	EOF
	gog-dos_src_prepare
}

src_install() {
	gog_install -d data
	gog-dos_src_install
}
