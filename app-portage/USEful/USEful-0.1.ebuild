# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

DESCRIPTION="Audit and manipulate USE and EXPAND_USE flags"
HOMEPAGE="https://github.com/Calchan/USEful/"
SRC_URI="https://github.com/Calchan/USEful/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="app-text/asciidoc"
RDEPEND="sys-apps/gentoo-functions
	sys-apps/portage"

src_compile() {
	a2x -f manpage README.asciidoc
}

src_install() {
	dobin USEful
	doman USEful.1
}
