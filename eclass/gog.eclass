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
	5) EXPORT_FUNCTIONS pkg_nofetch src_unpack src_install pkg_preinst pkg_postinst pkg_postrm;;
	*) die "EAPI=${EAPI} is not supported by gog.eclass";;
esac

HOMEPAGE="https://www.gog.com/game/${GOG_PAGE}"
SRC_URI="gog_${PN}_${PV}.sh"
LICENSE="all-rights-reserved"
SLOT="0"
RESTRICT="fetch bindist"

GOG_DEPEND="${GOG_DEPEND} virtual/opengl"

if [[ ${GOG_TYPE} == "64BIT" ]]; then
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
GOG_SUFFIX32=".x86"
GOG_SUFFIX64=".x86_64"

QA_PREBUILT="${QA_PREBUILT} ${GOG_DIR}/* ${GOG_DIR}/*/* ${GOG_DIR}/*/*/* ${GOG_DIR}/*/*/*/* ${GOG_DIR}/*/*/*/*/*"

gog_install() {
	dodir ${GOG_DIR}
	if [[ "${1}" == "-d" ]]; then
		find "${2}" -mindepth 1 -maxdepth 1 | xargs mv -t "${D}/${GOG_DIR}/${3}" || die
	else
		mv "${1}" "${D}/${GOG_DIR}/${2}" || die
	fi
}

gog_linklib() {
	dodir ${GOG_DIR}/lib
	dosym /usr/$(get_abi_LIBDIR x86)/${1} ${GOG_DIR}/lib/${2}
}

gog_pkg_nofetch() {
	einfo "Please download ${SRC_URI} from your GOG account and move it to ${DISTDIR}"
}

gog_src_unpack() {
	unpack_zip "${DISTDIR}/${SRC_URI}"
}

gog_src_install() {
	if [[ ${GOG_TYPE} == "64BIT" ]]; then
		use x86 && GOG_EXE="${GOG_EXE}${GOG_SUFFIX32}"
		use amd64 && GOG_EXE="${GOG_EXE}${GOG_SUFFIX64}"
	fi
	make_wrapper gog_${PN} "./${GOG_EXE}" "${GOG_DIR}" "${GOG_DIR}/lib"
	newicon ${GOG_ICON} gog_${PN}.${GOG_ICON##*.}
	make_desktop_entry gog_${PN} "${GOG_NAME}" gog_${PN}
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
