# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Classic first-person RPG in the sewers of Waterdeep"
GOG_NAME="Eye of the Beholder"
GOG_PAGE="forgotten_realms_the_archives_collection_one"
GOG_EXE="START1.EXE"
GOG_TYPE="DOSBOX"

inherit gog

KEYWORDS="~amd64 ~x86"

src_install() {
	gog_install -d data
	gog_src_install
}
