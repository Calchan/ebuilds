# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Point-and-click educational adventure game"
GOG_NAME="Pajama Sam: No Need to Hide When It’s Dark Outside"
GOG_PAGE=pajama_sam_vol_1
GOG_VERSION=1
GOG_EXE=PAJAMA

inherit gog-scummvm

src_install() {
	gog_install -d data
	gog-scummvm_src_install
}
