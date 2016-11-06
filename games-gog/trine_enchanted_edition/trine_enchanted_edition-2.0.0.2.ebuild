# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Physics-based action game where thre characters combine their powers to devise clever solutions"
GOG_NAME="Trine Enchanted Edition"
GOG_VERSION=1
GOG_EXE=trine1_linux_32bit
GOG_BUNDLE="
	media-gfx/nvidia-cg-toolkit
	media-libs/alsa-lib
	media-libs/freetype
	virtual/glu
	media-libs/libogg
	sys-libs/zlib
"

inherit gog-32

src_install() {
	mv game/bin/trine1_linux_32bit game || die
	mv game/lib/lib32/* game/lib || die
	rm -rf game/{bin,lib/lib32} || die
	if use unbundle; then
		rm -rf game/lib || die
	fi
	gog_install -d game
	gog-32_src_install
}
