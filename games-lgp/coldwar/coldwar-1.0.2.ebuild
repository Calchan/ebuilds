# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils unpacker cdrom games

DESCRIPTION="On your own behind the Iron Curtain"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI=""

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="linguas_de linguas_fr linguas_ru unbundle"
RESTRICT="bindist strip"

RDEPEND="
	media-libs/alsa-lib[abi_x86_32(-)]
	media-libs/openal[abi_x86_32(-)]
	virtual/opengl[abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]
	x11-libs/libXext[abi_x86_32(-)]
	x11-libs/libXi[abi_x86_32(-)]
	unbundle? (
		media-libs/libogg[abi_x86_32(-)]
		media-libs/libsdl[abi_x86_32(-)]
		media-libs/libtheora[abi_x86_32(-)]
		media-libs/libvorbis[abi_x86_32(-)]
		x11-libs/gtk+:1[abi_x86_32(-)]
	)
"

S=${WORKDIR}
installdir=${GAMES_PREFIX_OPT}/lgp/${PN}

QA_PREBUILT="
	${installdir#/}/lib/libSDL-1.2.so.0.7.2
"

src_unpack() {
	cdrom_get_cds bin/Linux/x86/${PN}
	ln -sfn "${CDROM_ROOT}"/data cd
	unpack ./cd/data.tar.gz
	use linguas_de && unpack ./cd/langpack_de.tar.gz
	use linguas_fr && unpack ./cd/langpack_fr.tar.gz
	use linguas_ru && unpack ./cd/langpack_ru.tar.gz
	rm -f cd
	cp -rf "${CDROM_ROOT}"/bin/Linux/x86/* . || die
	cp -f "${CDROM_ROOT}"/{READ*,icon*} . || die

	for patchnum in 1.0-1.0.1 1.0.1-1.0.2 ; do
		mkdir -p "patch" || die
		cd "patch"
		unpack_makeself "${FILESDIR}"/coldwar-${patchnum}-x86.run
		bin/Linux/x86/loki_patch patch.dat "${S}" || die "loki_patch failed"
		cd "${S}"
		rm -rf "patch"
	done

	if use unbundle ; then
		rm -f lib/*
	else
		mv lib2/* lib || die
		rm -f lib/lib{asound,openal,stdc++}.so.*
	fi
	ln -s /usr/lib32/libopenal.so lib/libopenal.so.0 || die
	rm -rf lib2
}

src_install() {
	insinto "${installdir}"
	mv * "${D}/${installdir}" || die

	games_make_wrapper ${PN} ./coldwar "${installdir}" "${installdir}"/lib
	newicon "${CDROM_ROOT}"/icon.xpm ${PN}.xpm
	make_desktop_entry ${PN} "Cold War" ${PN}

	prepgamesdirs
}
