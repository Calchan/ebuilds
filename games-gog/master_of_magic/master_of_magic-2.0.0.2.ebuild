# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Fantasy 4X turn-based strategy game"
GOG_NAME="Master of Magic"
GOG_PAGE="master_of_magic"
GOG_EXE="MAGIC.EXE"
GOG_LOCAL_COPY="MAGIC.SET"

inherit gog-dos

src_install() {
	gog_install -d data
	gog-dos_src_install
}
