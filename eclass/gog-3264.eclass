# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: gog-3264.eclass
# @MAINTAINER:
# Denis Dupeyron <calchan@gentoo.org>
# @BLURB: Install GOG games which have both 32-bit and 64-bit binaries.
# @DESCRIPTION:
# Describe some sort of description here.

inherit gog

case ${EAPI:-0} in
	6) EXPORT_FUNCTIONS src_install;;
	*) die "EAPI=${EAPI} is not supported by gog-3264.eclass";;
esac

KEYWORDS="~amd64 ~x86"

GOG_DEPEND="${GOG_DEPEND} virtual/opengl"
for dep in ${GOG_DEPEND}; do
	always_deps="${always_deps} ${dep}"
done
for dep in ${GOG_BUNDLE}; do
	bundle_deps="${bundle_deps} ${dep}"
done
RDEPEND="${RDEPEND} ${always_deps}"
if [[ ${bundle_deps} != "" ]]; then
	IUSE="unbundle"
	RDEPEND="${RDEPEND} unbundle? ( ${bundle_deps} )"
fi

GOG_SUFFIX32=".x86 32.bin 32"
GOG_SUFFIX64=".x86_64 64.bin 64 amd64"

gog-3264_src_install() {
	use x86 && suffix_list=${GOG_SUFFIX32}
	use amd64 && suffix_list=${GOG_SUFFIX64}
	for suffix in ${suffix_list}; do
		[[ -f "${D}/${GOG_DIR}/${GOG_EXE}${suffix}" ]] && GOG_EXE="${GOG_EXE}${suffix}"
	done
	gog_wrapper ${PN} "${GOG_EXE}"
	make_desktop_entry gog_${PN} "${GOG_NAME}" gog_${PN}
	if [[ ${GOG_EXTRA_EXE} != "" ]]; then
		for suffix in ${suffix_list}; do
			[[ -f "${D}/${GOG_DIR}/${GOG_EXTRA_EXE}${suffix}" ]] && GOG_EXTRA_EXE="${GOG_EXTRA_EXE}${suffix}"
		done
		gog_wrapper ${PN}_extra "${GOG_EXTRA_EXE}"
		make_desktop_entry gog_${PN}_extra "${GOG_EXTRA_NAME}" gog_${PN} "" "Comment=${GOG_EXTRA_DESCRIPTION}"
	fi
	gog_src_install
}
