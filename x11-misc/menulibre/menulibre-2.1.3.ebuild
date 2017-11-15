# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python3_{4,5,6} )
inherit versionator gnome2-utils distutils-r1

DESCRIPTION="Advanced FreeDesktop.org compliant menu editor"
HOMEPAGE="https://launchpad.net/menulibre"
SRC_URI="${HOMEPAGE}/$(get_version_component_range 1-2)/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/gobject-introspection
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	>=gnome-base/gnome-menus-3.5.3[introspection]
	x11-libs/gdk-pixbuf[introspection,X]
	>=x11-libs/gtk+-3.8:3[introspection,X]
	x11-libs/pango[introspection,X]
	x11-misc/xdg-utils"
DEPEND="${DEPEND}
	>=dev-python/python-distutils-extra-2.18[${PYTHON_USEDEP}]"

pkg_preinst() {	gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
