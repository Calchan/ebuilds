# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils cdrom unpacker games

DESCRIPTION="Action role-playing game"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI=""

LICENSE="all-rights-reserved GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="unbundle"
RESTRICT="bindist strip"

RDEPEND="
	media-libs/alsa-lib[abi_x86_32(-)]
	sys-libs/zlib[abi_x86_32(-)]
	virtual/opengl[abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]
	x11-libs/libXext[abi_x86_32(-)]
	x11-libs/libXi[abi_x86_32(-)]
	unbundle? (
		dev-libs/glib:1[abi_x86_32(-)]
		dev-libs/libxml2[abi_x86_32(-)]
		dev-libs/openssl:0.9.8[abi_x86_32(-)]
		media-libs/freetype[abi_x86_32(-)]
		media-libs/libjpeg-turbo[abi_x86_32(-)]
		media-libs/libogg[abi_x86_32(-)]
		media-libs/libsdl[abi_x86_32(-)]
		media-libs/libvorbis[abi_x86_32(-)]
		media-libs/openal[abi_x86_32(-)]
		x11-libs/gtk+:1[abi_x86_32(-)]
	)
"
DEPEND=""

S=${WORKDIR}
installdir=${GAMES_PREFIX_OPT}/lgp/${PN}

QA_TEXTRELS="
	${installdir#/}/lib/libxml2.so.2
	${installdir#/}/lib/libavutil.so
	${installdir#/}/lib/libavformat.so
	${installdir#/}/lib/libavcodec.so
"

src_unpack() {
	cdrom_get_cds .data/bin/Linux/x86/sacred
	ln -sfn "${CDROM_ROOT}"/.data cd
	unpack ./cd/data/data.tar.gz
	rm -f cd
	cp -f "${CDROM_ROOT}"/.data/bin/Linux/x86/sacred* . || die
	cp -f "${CDROM_ROOT}"/README* . || die
	cp -f "${CDROM_ROOT}"/manual.pdf . || die

	for patchnum in 1.0-1.0.01 1.0.01-1.0.02 1.0.02-1.0.03 ; do
		mkdir -p "patch" || die
		cd "patch"
		unpack_makeself "${FILESDIR}"/sacred-${patchnum}-x86.run
		bin/Linux/x86/loki_patch patch.dat "${S}" || die "loki_patch failed"
		cd "${S}"
		rm -rf "patch"
	done

	if use unbundle ; then
		mv lib/lib1/libav*.so lib || die
		mv lib/lib1/libgrapple.so lib || die
	else
		mv lib/lib{1,2}/* lib || die
		rm -f lib/lib{asound,gcc_s,m,stdc++,z}.so.*
	fi
	rm -rf lib/lib{1,2}
}

src_install() {
	insinto "${installdir}"
	mv * "${D}/${installdir}" || die

	games_make_wrapper ${PN} ./sacred "${installdir}" "${installdir}"/lib
	newicon "${CDROM_ROOT}"/.data/icon.xpm ${PN}.xpm
	make_desktop_entry ${PN} "Sacred - Gold" ${PN}

	prepgamesdirs
}
