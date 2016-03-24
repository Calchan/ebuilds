# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python3_4 )
inherit versionator gnome2-utils distutils-r1

DESCRIPTION="Lightweight user-configuration application"
HOMEPAGE="https://launchpad.net/mugshot"
SRC_URI="${HOMEPAGE}/$(get_version_component_range 1-2)/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pexpect[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	sys-apps/shadow"
DEPEND=">=dev-python/python-distutils-extra-2.18[${PYTHON_USEDEP}]"

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	einfo "For webcam support you should emerge media-video/cheese with the introspection USE flag."
	gnome2_schemas_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_schemas_update
	gnome2_icon_cache_update
}
