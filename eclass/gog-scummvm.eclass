# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: gog-scummvm.eclass
# @MAINTAINER:
# Denis Dupeyron <calchan@gentoo.org>
# @BLURB: Install ScummVM-based GOG games.
# @DESCRIPTION:
# Describe some sort of description here.

inherit gog

case ${EAPI:-0} in
	6) EXPORT_FUNCTIONS src_prepare src_install;;
	*) die "EAPI=${EAPI} is not supported by gog-scummvm.eclass";;
esac

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

RDEPEND="games-engines/scummvm"

gog-scummvm_wrapper() {
	cat <<-EOF >> gog_${1}
		#!/bin/sh
		mkdir -p "\${HOME}/.local/share/gog/${PN}"
		cd "\${HOME}/.local/share/gog/${PN}"
		find . -type l -delete
		cd ${GOG_DIR}
		for item in ${GOG_NO_SYMLINK}; do
			cp -rfn --parents \${item} "\${HOME}/.local/share/gog/${PN}"
		done
		cd "\${HOME}/.local/share/gog/${PN}"
		cp -rsn ${GOG_DIR} ..
		if [[ -f scummvm.ini ]]; then
			scummvm -c scummvm.ini ${2}
		else
			scummvm ${2}
		fi
	EOF
	eapply_user
}

gog-scummvm_src_prepare() {
	gog-scummvm_wrapper ${PN} "${GOG_EXE}"
	eapply_user
}

gog-scummvm_src_install() {
	dobin gog_${PN}
	make_desktop_entry gog_${PN} "${GOG_NAME}" gog_${PN}
	gog_src_install
}
