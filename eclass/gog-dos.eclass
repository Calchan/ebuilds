# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: gog-dos.eclass
# @MAINTAINER:
# Denis Dupeyron <calchan@gentoo.org>
# @BLURB: Install DOSBOX-based GOG games.
# @DESCRIPTION:
# Describe some sort of description here.

inherit gog

case ${EAPI:-0} in
	6) EXPORT_FUNCTIONS src_prepare src_install;;
	*) die "EAPI=${EAPI} is not supported by gog-dos.eclass";;
esac

KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="games-emulation/dosbox"

gog-dos_wrapper() {
	cat <<-EOF >> gog_${1}
		#!/bin/sh
		mkdir -p "\${HOME}/.local/share/gog/${PN}"
		cd "\${HOME}/.local/share/gog/${PN}"
		find . -type l -delete
		for item in ${GOG_LOCAL_COPY}; do mkdir -p \$(dirname "\${item}"); cp -rfn "${GOG_DIR}/\${item}" .; done
		cp -rsn "${GOG_DIR}" ..
		dosbox "${2}" -exit
	EOF
	eapply_user
}

gog-dos_src_prepare() {
	gog-dos_wrapper ${PN} "${GOG_EXE}"
	eapply_user
}

gog-dos_src_install() {
	dobin gog_${PN}
	make_desktop_entry gog_${PN} "${GOG_NAME}" gog_${PN}
	gog_src_install
}
