# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools games

DESCRIPTION="Monte Carlo tree search game engine for Go"
HOMEPAGE="http://fuego.sourceforge.net/"
SRC_URI=""

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cache-sync"

DEPEND=">=dev-libs/boost-1.50.0"
RDEPEND="${DEPEND}"

MY_PN=fuego-code-${PV}-trunk
S=${WORKDIR}/${MY_PN}

src_unpack() {
	# Ugly hack due to the checksum of the source tarball not being constant.
	# Kids, do not do that at home.
	wget https://sourceforge.net/code-snapshots/svn/f/fu/fuego/code/${MY_PN}.zip
	unzip ${MY_PN}.zip
}

src_prepare() {
	sed 's/^fuego_LDFLAGS = \$(BOOST_LDFLAGS)/fuego_LDFLAGS = \$(BOOST_LDFLAGS) -pthread/' -i fuegomain/Makefile.am || die
	eautoreconf
}

src_configure() {
	econf \
		--prefix="${GAMES_PREFIX}" \
		--datadir="${GAMES_DATADIR}" \
		--enable-max-size=19 \
		--enable-uct-value-type=float \
		$(use_enable cache-sync)
}

src_install() {
	exeinto "${GAMES_BINDIR}"
	doexe fuegomain/fuego
	insinto "${GAMES_DATADIR}/${PN}"
	doins book/book.dat
	dohtml doc/manual/index.html
}
