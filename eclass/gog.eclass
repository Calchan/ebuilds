# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: gog.eclass
# @MAINTAINER:
# Denis Dupeyron <calchan@gentoo.org>
# @BLURB: Install GOG games.
# @DESCRIPTION:
# Describe some sort of description here.

inherit games eutils gnome2-utils multilib unpacker

case ${EAPI:-0} in
	5) EXPORT_FUNCTIONS pkg_nofetch src_unpack src_prepare src_install pkg_preinst pkg_postinst pkg_postrm;;
	*) die "EAPI=${EAPI} is not supported by gog.eclass";;
esac

HOMEPAGE="https://www.gog.com/game/${GOG_PAGE}"
SRC_URI="gog_${PN}_${PV}.sh"
LICENSE="all-rights-reserved"
SLOT="0"
RESTRICT="fetch bindist"

if [[ ${GOG_TYPE} == "DOSBOX" ]]; then
	RDEPEND="games-emulation/dosbox"
else
	GOG_DEPEND="${GOG_DEPEND} virtual/opengl"
fi

if [[ ${GOG_TYPE} == "MULTILIB" ]]; then
	for dep in ${GOG_DEPEND}; do
		always_deps="${always_deps} ${dep}[abi_x86_32(-)]"
	done
	for dep in ${GOG_BUNDLE}; do
		bundle_deps="${bundle_deps} ${dep}[abi_x86_32(-)]"
	done
else
	always_deps="${GOG_DEPEND}"
	bundle_deps="${GOG_BUNDLE}"
fi

RDEPEND="${RDEPEND} ${always_deps}"
if [[ ${bundle_deps} != "" ]]; then
	IUSE="unbundle"
	RDEPEND="${RDEPEND} unbundle? ( ${bundle_deps} )"
fi

DEPEND="${DEPEND} app-arch/unzip"

S=${WORKDIR}/data/noarch
GOG_DIR=${GAMES_PREFIX_OPT}/gog/${PN}
GOG_ICON="support/icon.png"
GOG_SUFFIX32=".x86 32.bin"
GOG_SUFFIX64=".x86_64 64.bin"

QA_PREBUILT="${QA_PREBUILT} ${GOG_DIR}/* ${GOG_DIR}/*/* ${GOG_DIR}/*/*/* ${GOG_DIR}/*/*/*/* ${GOG_DIR}/*/*/*/*/*"

gog_install() {
	# FIXME Use dirname
	dodir ${GOG_DIR}
	if [[ "${1}" == "-d" ]]; then
		find "${2}" -mindepth 1 -maxdepth 1 -exec mv -t "${D}/${GOG_DIR}/${3}" {} \; || die
	else
		mv "${1}" "${D}/${GOG_DIR}/${2}" || die
	fi
}

gog_linklib() {
	# FIXME Not only in lib, use dirname
	dodir ${GOG_DIR}/lib
	dosym /usr/$(get_abi_LIBDIR x86)/${1} ${GOG_DIR}/lib/${2}
}

gog_pkg_nofetch() {
	einfo "Please download ${SRC_URI} from your GOG account and move it to ${DISTDIR}"
}

gog_src_unpack() {
	unpack_zip "${DISTDIR}/${SRC_URI}"
}

gog_src_prepare() {
	if [[ ${GOG_TYPE} == "DOSBOX" ]]; then
		cat <<-EOF >> gog_${PN}
			#!/bin/sh
			mkdir -p "\${HOME}/.local/share/gog/${PN}"
			cd "\${HOME}/.local/share/gog/${PN}"
			find . -type l -delete
			for item in ${GOG_LOCAL_COPY}; do mkdir -p \$(dirname "\${item}"); cp -rfn "${GOG_DIR}/\${item}" .; done
			cp -rsn "${GOG_DIR}" ..
			dosbox "${GOG_EXE}" -exit
		EOF
	fi
}

gog_src_install() {
	if [[ ${GOG_TYPE} == "MULTILIB" ]]; then
		use x86 && suffix_list=${GOG_SUFFIX32}
		use amd64 && suffix_list=${GOG_SUFFIX64}
		for suffix in ${suffix_list}; do
			[[ -f "${D}/${GOG_DIR}/${GOG_EXE}${suffix}" ]] && GOG_EXE="${GOG_EXE}${suffix}"
		done
	fi
	if [[ ${GOG_TYPE} == "DOSBOX" ]]; then
		dogamesbin gog_${PN}
	else
		make_wrapper gog_${PN} "\"./${GOG_EXE}\"" "${GOG_DIR}" "${GOG_DIR}/lib"
	fi
	newicon ${GOG_ICON} gog_${PN}.${GOG_ICON##*.}
	make_desktop_entry gog_${PN} "${GOG_NAME}" gog_${PN}
	if [[ ${GOG_EXTRA_EXE} != "" ]]; then
		if [[ ${GOG_TYPE} == "MULTILIB" ]]; then
			use x86 && suffix_list=${GOG_SUFFIX32}
			use amd64 && suffix_list=${GOG_SUFFIX64}
			for suffix in ${suffix_list}; do
				[[ -f "${D}/${GOG_DIR}/${GOG_EXTRA_EXE}${suffix}" ]] && GOG_EXE="${GOG_EXTRA_EXE}${suffix}"
			done
		fi
		make_wrapper gog_${PN}_extra "\"./${GOG_EXTRA_EXE}\"" "${GOG_DIR}" "${GOG_DIR}/lib"
		make_desktop_entry gog_${PN}_extra "${GOG_EXTRA_NAME}" gog_${PN} "" "Comment=${GOG_EXTRA_DESCRIPTION}"
	fi
	prepgamesdirs
}

gog_pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

gog_pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
}

gog_pkg_postrm() {
	gnome2_icon_cache_update
}
