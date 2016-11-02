# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: gog.eclass
# @MAINTAINER:
# Denis Dupeyron <calchan@gentoo.org>
# @BLURB: Install GOG games.
# @DESCRIPTION:
# Describe some sort of description here.

inherit eutils gnome2-utils unpacker

case ${EAPI:-0} in
	6) EXPORT_FUNCTIONS pkg_nofetch src_unpack src_install pkg_preinst pkg_postinst pkg_postrm;;
	*) die "EAPI=${EAPI} is not supported by gog.eclass";;
esac

HOMEPAGE="https://www.gog.com/game/${GOG_PAGE:-${PN}}"
SRC_URI="gog_${PN}_${PV}.sh"
LICENSE="all-rights-reserved"
SLOT="0"
RESTRICT="fetch bindist"

DEPEND="${DEPEND} app-arch/unzip"

S=${WORKDIR}/data/noarch
GOG_DIR=/opt/gog/${PN}
GOG_ICON="support/icon.png"
GOG_INSTALLER_URI="${GOG_INSTALLER:-${PN}}/en3installer${GOG_VERSION}"

# FIXME Find a better way to do this
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

gog_wrapper() {
	local tmpwrapper=$(emktemp)
	echo "#!/bin/sh" > ${tmpwrapper}
	# FIXME Make that optional
	echo "export LIBGL_DRI3_DISABLE=1" >> ${tmpwrapper}
	echo "export LD_LIBRARY_PATH=${GOG_DIR}/lib" >> ${tmpwrapper}
	echo "cd ${GOG_DIR}" >> ${tmpwrapper}
	echo "exec \"./${2}\"" >> ${tmpwrapper}
	newbin ${tmpwrapper} gog_${1}
}

gog_linklib() {
	# FIXME Not only in lib, use dirname
	dodir ${GOG_DIR}/lib
	dosym /usr/$(get_abi_LIBDIR x86)/${1} ${GOG_DIR}/lib/${2}
}

gog_pkg_nofetch() {
	echo
	einfo "Please buy ${GOG_NAME} from GOG. Then go to"
	einfo "        https://www.gog.com/downlink/${GOG_INSTALLER_URI}"
	einfo "in order to download"
	einfo "        ${SRC_URI}"
	einfo "and save it into"
	einfo "        ${DISTDIR}"
}

gog_src_unpack() {
	unpack_zip "${DISTDIR}/${SRC_URI}"
}

gog_src_install() {
	newicon ${GOG_ICON} gog_${PN}.${GOG_ICON##*.}
}

gog_pkg_preinst() {
	gnome2_icon_savelist
}

gog_pkg_postinst() {
	gnome2_icon_cache_update
}

gog_pkg_postrm() {
	gnome2_icon_cache_update
}
