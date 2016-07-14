# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )
inherit autotools eutils python-single-r1 autotools gnome2-utils

COMMIT="6aa89efa0e3b86af08d479187dba33554c701ec6"

DESCRIPTION="Japanese input method Anthy IMEngine for IBus Framework"
HOMEPAGE="https://github.com/fujiwarat/ibus-anthy"
SRC_URI="${HOMEPAGE}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="nls"

RDEPEND="${PYTHON_DEPS}
	>=app-i18n/ibus-1.5.0[introspection]
	app-i18n/anthy
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	dev-libs/gobject-introspection
	dev-util/intltool
	virtual/pkgconfig
	nls? ( >=sys-devel/gettext-0.16.1 )"

S=${WORKDIR}/${PN}-${COMMIT}

src_prepare() {
	eautoreconf
	>py-compile #397497
	eapply_user
}

src_configure() {
	econf --libexecdir=/usr/libexec --enable-private-png $(use_enable nls)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS README
	find "${ED}" -name '*.la' -type f -delete || die
	python_optimize
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	elog "app-dicts/kasumi is not required but probably useful for you."
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
