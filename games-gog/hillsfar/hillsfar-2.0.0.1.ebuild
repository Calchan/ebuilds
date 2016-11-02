# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="AD&D RPG, side story to Pool of Radiance"
GOG_NAME="Hillsfar"
GOG_PAGE=forgotten_realms_the_archives_collection_two
GOG_INSTALLER=hillsfar_copy3
GOG_VERSION=1
GOG_EXE=MAIN.EXE

inherit gog-dos

src_install() {
	gog_install -d data
	gog-dos_src_install
}
