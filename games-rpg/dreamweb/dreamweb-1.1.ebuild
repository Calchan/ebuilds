# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-rpg/soltys/soltys-1.0.ebuild,v 1.1 2014/10/30 00:16:18 calchan Exp $

EAPI=5
inherit unpacker eutils games

DESCRIPTION="Top-down adventure game set in a gritty futuristic/dystopian city"
HOMEPAGE="http://wiki.scummvm.org/index.php/Dreamweb"
SRC_URI="doc? ( mirror://sourceforge/scummvm/${PN}-manuals-en-highres.zip )
	linguas_de? ( mirror://sourceforge/scummvm/${PN}-cd-de-${PV}.zip )
	linguas_en? ( mirror://sourceforge/scummvm/${PN}-cd-us-${PV}.zip )
	linguas_en_GB? ( mirror://sourceforge/scummvm/${PN}-cd-uk-${PV}.zip )
	linguas_en_US? ( mirror://sourceforge/scummvm/${PN}-cd-us-${PV}.zip )
	linguas_es? ( mirror://sourceforge/scummvm/${PN}-cd-es-${PV}.zip )
	linguas_fr? ( mirror://sourceforge/scummvm/${PN}-cd-fr-${PV}.zip )
	linguas_it? ( mirror://sourceforge/scummvm/${PN}-cd-it-${PV}.zip )
	!linguas_de? ( !linguas_en? ( !linguas_en_GB? ( !linguas_en_US? ( !linguas_es? ( !linguas_fr? ( !linguas_it? \
		( mirror://sourceforge/scummvm/${PN}-cd-us-${PV}.zip ) ) ) ) ) ) )
	http://www.scummvm.org/images/cat-dreamweb.png"

LICENSE="Dreamweb"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc linguas_de linguas_en linguas_en_GB linguas_en_US linguas_es linguas_fr linguas_it"

RDEPEND=">=games-engines/scummvm-1.7[flac]"
DEPEND="$(unpacker_src_uri_depends)"

S=${WORKDIR}

src_unpack() {
	if use linguas_de ; then
		mkdir -p de || die
		cd de || die
		unpacker ${PN}-cd-de-${PV}.zip
		cd .. || die
	fi
	if use linguas_en || use linguas_en_US || ( ! use linguas_de && ! use linguas_en && ! use linguas_en_GB && \
			! use linguas_en_US && ! use linguas_es && ! use linguas_fr && ! use linguas_it ) ; then
		mkdir -p en_US || die
		cd en_US || die
		unpacker ${PN}-cd-us-${PV}.zip
		cd .. || die
	fi
	if use linguas_en_GB ; then
		mkdir -p en_GB || die
		cd en_GB || die
		unpacker ${PN}-cd-uk-${PV}.zip
		cd .. || die
	fi
	if use linguas_es ; then
		mkdir -p es || die
		cd es || die
		unpacker ${PN}-cd-es-${PV}.zip
		cd .. || die
	fi
	if use linguas_fr ; then
		mkdir -p fr || die
		cd fr || die
		unpacker ${PN}-cd-fr-${PV}.zip
		cd .. || die
	fi
	if use linguas_it ; then
		mkdir -p it || die
		cd it || die
		unpacker ${PN}-cd-it-${PV}.zip
		cd .. || die
	fi
	if use doc ; then
		mkdir -p doc || die
		cd doc || die
		unpacker ${PN}-manuals-en-highres.zip
	fi
}

src_prepare() {
	rm -rf */license.txt */*.EXE || die
}

src_install() {
	if use doc ; then
		dodoc -r doc/*
		rm -rf doc || die
	fi
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r *
	newicon "${DISTDIR}"/cat-dreamweb.png dreamweb.png
	if use linguas_de ; then
		games_make_wrapper dreamweb-de "scummvm -f -p \"${GAMES_DATADIR}/${PN}/de\" dreamweb" .
		make_desktop_entry ${PN}-de "Dreamweb (Deutsch)" dreamweb
	fi
	if use linguas_en || use linguas_en_US || ( ! use linguas_de && ! use linguas_en && ! use linguas_en_GB && \
			! use linguas_en_US && ! use linguas_es && ! use linguas_fr && ! use linguas_it ) ; then
		games_make_wrapper dreamweb-en_US "scummvm -f -p \"${GAMES_DATADIR}/${PN}/en_US\" dreamweb" .
		make_desktop_entry ${PN}-en_US "Dreamweb (US English)" dreamweb
	fi
	if use linguas_en_GB ; then
		games_make_wrapper dreamweb-en_GB "scummvm -f -p \"${GAMES_DATADIR}/${PN}/en_GB\" dreamweb" .
		make_desktop_entry ${PN}-en_GB "Dreamweb (UK English)" dreamweb
	fi
	if use linguas_es ; then
		games_make_wrapper dreamweb-es "scummvm -f -p \"${GAMES_DATADIR}/${PN}/es\" dreamweb" .
		make_desktop_entry ${PN}-es "Dreamweb (Español)" dreamweb
	fi
	if use linguas_fr ; then
		games_make_wrapper dreamweb-fr "scummvm -f -p \"${GAMES_DATADIR}/${PN}/fr\" dreamweb" .
		make_desktop_entry ${PN}-fr "Dreamweb (Français)" dreamweb
	fi
	if use linguas_it ; then
		games_make_wrapper dreamweb-it "scummvm -f -p \"${GAMES_DATADIR}/${PN}/it\" dreamweb" .
		make_desktop_entry ${PN}-it "Dreamweb (Italiano)" dreamweb
	fi
	prepgamesdirs
}
