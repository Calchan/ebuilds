# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: gog-32.eclass
# @MAINTAINER:
# Denis Dupeyron <calchan@gentoo.org>
# @BLURB: Install 32-bit GOG games on 32-bit and multilib 64-bit systems.
# @DESCRIPTION:
# Describe some sort of description here.

inherit gog

case ${EAPI:-0} in
	6) EXPORT_FUNCTIONS src_install;;
	*) die "EAPI=${EAPI} is not supported by gog-32.eclass";;
esac

KEYWORDS="~amd64 ~x86"

GOG_DEPEND="${GOG_DEPEND} virtual/opengl"
for dep in ${GOG_DEPEND}; do
	always_deps="${always_deps} ${dep}[abi_x86_32(-)]"
done
for dep in ${GOG_BUNDLE}; do
	bundle_deps="${bundle_deps} ${dep}[abi_x86_32(-)]"
done
RDEPEND="${RDEPEND} ${always_deps}"
if [[ ${bundle_deps} != "" ]]; then
	IUSE="unbundle"
	RDEPEND="${RDEPEND} unbundle? ( ${bundle_deps} )"
fi

gog-32_src_install() {
	gog_wrapper ${PN} ${GOG_EXE}
	if [[ ${GOG_EXTRA_EXE} != "" ]]; then
		gog_wrapper ${PN}_extra ${GOG_EXTRA_EXE}
		make_desktop_entry gog_${PN}_extra "${GOG_EXTRA_NAME}" gog_${PN} "" "Comment=${GOG_EXTRA_DESCRIPTION}"
	fi
	gog_src_install
}
