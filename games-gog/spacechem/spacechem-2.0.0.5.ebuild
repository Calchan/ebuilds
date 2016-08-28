# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# TODO unbundle?

EAPI=6

DESCRIPTION="Puzzle game based on principles of automation and chemical bonding"
GOG_NAME="SpaceChem"
GOG_PAGE="spacechem"
GOG_EXE="spacechem-launcher.sh"

inherit gog-32

src_install() {
	gog_install -d game
	gog-32_src_install
}
