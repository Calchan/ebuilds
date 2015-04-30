# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python3_4 )
inherit versionator gnome2-utils distutils-r1 user

DESCRIPTION="Settings dialog for the LightDM GTK+ Greeter"
HOMEPAGE="https://launchpad.net/lightdm-gtk-greeter-settings"
SRC_URI="${HOMEPAGE}/$(get_version_component_range 1-2)/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-python/pygobject:3[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	sys-auth/polkit
	>=x11-libs/gtk+-3.8:3
	>=x11-misc/lightdm-gtk-greeter-2.0"
DEPEND="${DEPEND}
	>=dev-python/python-distutils-extra-2.18"

pkg_setup() {
	enewgroup sys # Just make sure it exists
}

src_install() {
	distutils-r1_src_install
	insinto /usr/share/polkit-1/rules.d
	doins "${FILESDIR}/01-com.ubuntu.pkexec.lightdm-gtk-greeter-settings.rules"
}

pkg_preinst() {	gnome2_icon_savelist; }

pkg_postinst() {
	gnome2_icon_cache_update
	einfo "Add users allowed to change settings for the LightDM GTK+ Greeter to the 'sys' group"
}

pkg_postrm() { gnome2_icon_cache_update; }
