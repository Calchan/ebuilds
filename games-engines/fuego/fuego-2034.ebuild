# Copyright 2016-2018 Denis Dupeyron <calchan@gentoo.org>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_PN=fuego-code-r${PV}-trunk
DESCRIPTION="Monte Carlo Tree Search game engine for Go"
HOMEPAGE="https://fuego.sourceforge.net/"
SRC_URI="https://sourceforge.net/code-snapshots/svn/f/fu/fuego/code/${MY_PN}.zip"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cache-sync"

DEPEND=">=dev-libs/boost-1.50.0"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_PN}

src_prepare() {
	sed 's/^fuego_LDFLAGS = \$(BOOST_LDFLAGS)/fuego_LDFLAGS = \$(BOOST_LDFLAGS) -pthread/' -i fuegomain/Makefile.am || die
	sed '/ABS_TOP_SRCDIR/d' -i fuegomain/Makefile.am || die
	eapply_user
	eautoreconf
}

src_configure() {
	econf \
		--datadir="${EPREFIX}/usr/share" \
		--enable-max-size=19 \
		--enable-uct-value-type=float \
		$(use_enable cache-sync)
}
