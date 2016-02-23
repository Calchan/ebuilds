# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils cdrom unpacker games

DESCRIPTION="Space trading and combat"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI=""

LICENSE="all-rights-reserved GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="bonuspack cockpit linguas_de linguas_fr linguas_it modkit unbundle xtm"
REQUIRED_USE="xtm? ( bonuspack )"
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
		dev-libs/openssl:0.9.8[abi_x86_32(-)]
		media-libs/libjpeg-turbo[abi_x86_32(-)]
		media-libs/libogg[abi_x86_32(-)]
		media-libs/libsdl[abi_x86_32(-)]
		media-libs/libsndfile[abi_x86_32(-)]
		media-libs/libvorbis[abi_x86_32(-)]
		media-libs/openal[abi_x86_32(-)]
		x11-libs/gtk+:1[abi_x86_32(-)]
	)
"
DEPEND=""

S=${WORKDIR}

QA_TEXTRELS="
	${GAMES_PREFIX_OPT#/}/lgp/x3-reunion/lib/libavutil.so
	${GAMES_PREFIX_OPT#/}/lgp/x3-reunion/lib/libavformat.so
	${GAMES_PREFIX_OPT#/}/lgp/x3-reunion/lib/libavcodec.so
"

src_unpack() {
	cdrom_get_cds .data/bin/Linux/x86/x3
	ln -sfn "${CDROM_ROOT}"/.data cd
	unpack ./cd/data/{x3,datfiles,mov}.tar.gz
	use linguas_de && unpack ./cd/data/de_lang.tar.gz
	use linguas_fr && unpack ./cd/data/fr_lang.tar.gz
	use linguas_it && unpack ./cd/data/it_lang.tar.gz
	use modkit && unpack ./cd/data/modkit.tar.gz
	use cockpit && unpack ./cd/data/cockpit.tar.gz
	use bonuspack && unpack ./cd/data/bonuspack.tar.gz
	use xtm && unpack ./cd/data/xtm.tar.gz
	rm -f cd
	cp -f "${CDROM_ROOT}"/.data/bin/Linux/x86/x3* . || die
	cp -f "${CDROM_ROOT}"/README* . || die
	use modkit && cp -rf "${CDROM_ROOT}"/.data/bin/Linux/x86/modkit . || die

	for patchnum in 2.5-2.5.01 2.5.01-2.5.02 2.5.02-2.5.03 ; do
		mkdir -p "patch" || die
		cd "patch"
		unpack_makeself "${FILESDIR}"/x3-${patchnum}-x86.run
		bin/Linux/x86/loki_patch patch.dat "${S}" || die "loki_patch failed"
		cd "${S}"
		rm -rf "patch"
	done

	if use unbundle ; then
		mv lib/lib1/libav*.so lib || die
	else
		mv lib/lib{1,2}/* lib || die
		rm -f lib/lib{asound,gcc_s,m,stdc++,z}.so.*
	fi
	rm -rf lib/lib{1,2}
}

src_install() {
	dir=${GAMES_PREFIX_OPT}/lgp/${PN}

	insinto "${dir}"
	mv * "${D}/${dir}" || die
	fperms +x "${dir}"/x3-launcher

	games_make_wrapper ${PN} ./x3-launcher "${dir}" "${dir}"/lib
	newicon "${CDROM_ROOT}"/.data/icon.xpm ${PN}.xpm
	make_desktop_entry ${PN} "X3 Reunion" ${PN}

	prepgamesdirs
}
