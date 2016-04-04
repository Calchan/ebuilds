# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: z-machine.eclass
# @MAINTAINER:
# Denis Dupeyron <calchan@gentoo.org>
# @BLURB: Install Infocom's Z-machine games.
# @DESCRIPTION:
# This eclass will automatically install Infocom's Z-machine games. Although
# considered abandoned by a lot of people these games are now owned by
# Activision. The user will thus have to buy the game, extract the
# corresponding .DAT file and place it in the system's distfiles location. All
# the developer has to do is, in the following order, set the GAME_DATA
# variable to the name of the .DAT file, import the z-machine eclass and then set
# the DESCRIPTION variable appropriately.

inherit games unpacker

case ${EAPI:-0} in
	0|1|2|3|4|5) EXPORT_FUNCTIONS pkg_nofetch src_unpack src_prepare src_install pkg_postinst;;
	*) die "EAPI=${EAPI} not supported because of games.eclass" ;;
esac

HOMEPAGE="https://github.com/Calchan/ebuilds/tree/master/infocom/${PN}"
SRC_URI="${GAME_DATA}"
LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="bindist fetch"
DEPEND=""
RDEPEND="games-engines/frotz"
S="${WORKDIR}"
INFOCOM_INSTALLDIR="${GAMES_PREFIX_OPT}/infocom"

z-machine_pkg_nofetch() {
	einfo "Please extract ${GAME_DATA} from your install medium and move it to ${DISTDIR}"
}

z-machine_src_unpack() {
	:
}

z-machine_src_prepare() {
	cat <<-EOF >> ${PN}
		#!/bin/sh
		mkdir -p "\${HOME}/.local/share/infocom/${PN}"
		cd "\${HOME}/.local/share/infocom/${PN}"
		frotz "\${@}" "${INFOCOM_INSTALLDIR}/${GAME_DATA}"
	EOF
}

z-machine_src_install() {
	dogamesbin ${PN}
	insinto "${INFOCOM_INSTALLDIR}"
	doins "${DISTDIR}/${GAME_DATA}"
	prepgamesdirs
}

z-machine_pkg_postinst() {
	games_pkg_postinst
	einfo "${PN} is a text-mode game. To play it, type the following command in a terminal:"
	einfo "    ${PN} [options]"
	einfo "All options will be passed as-is to the interpreter (frotz)."
}
