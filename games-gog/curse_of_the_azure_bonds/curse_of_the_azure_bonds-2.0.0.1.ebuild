# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="AD&D RPG, sequel to Pool of Radiance"
GOG_NAME="Curse of the Azure Bonds"
GOG_PAGE="forgotten_realms_the_archives_collection_two"
GOG_EXE="START.EXE"
GOG_LOCAL_COPY="*"

inherit gog-dos

src_install() {
	gog_install -d data
	gog-dos_src_install
}
