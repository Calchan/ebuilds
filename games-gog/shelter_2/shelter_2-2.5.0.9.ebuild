# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Follow a mother lynx raising her cubs in vast open landscapes"
GOG_NAME="Shelter 2"
GOG_VERSION=1
GOG_EXE=Shelter2.x86
RDEPEND="
	dev-db/sqlite
	virtual/glu
	x11-libs/cairo
	x11-libs/libX11
	x11-libs/libXcursor
"

inherit gog-32

src_install() {
	gog_install -d game
	gog-32_src_install
}
