# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit autotools eutils python-single-r1 autotools gnome2-utils

DESCRIPTION="Japanese input method Anthy IMEngine for IBus Framework"
HOMEPAGE="https://github.com/fujiwarat/ibus-anthy"
SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz
	https://raw.github.com/ibus/ibus-anthy/${PV}/engine/anthy.i"

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

src_prepare() {
	eautoreconf
	>py-compile #397497
	cp "${DISTDIR}"/anthy.i "${S}"/engine # deal with packaging bug
}

src_configure() {
	econf --enable-private-png \
		$(use_enable nls)
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
}

pkg_postrm() {
	gnome2_icon_cache_update
}
