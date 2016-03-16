# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

WX_GTK_VER="3.0"

inherit mercurial wxwidgets toolchain-funcs eutils

DESCRIPTION="Manga Downloader"
HOMEPAGE="http://hakuneko.sourceforge.net/"
SRC_URI="http://c.fsdn.com/allura/p/hakuneko/icon -> hakuneko.png"
EHG_REPO_URI="http://hg.code.sf.net/p/hakuneko/code"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/openssl:0
	net-misc/curl
	x11-libs/wxGTK:2.8[X]"
RDEPEND="${DEPEND}"

src_configure() {
	:
}

src_compile() {
	for source in $(find src -name '*.cpp'); do
		einfo "Compiling ${source}..."
		$(tc-getCXX) $(wx-config --cflags) ${CXXFLAGS} -c ${source} || die
	done

	einfo "Linking hakuneko..."
	$(tc-getCXX) *.o -o hakuneko ${LDFLAGS} -lcurl -lcrypto -lgtk-x11-2.0 -lSM $(wx-config --libs) || die
}

src_install() {
	dobin hakuneko
	doicon "${DISTDIR}"/hakuneko.png
	make_desktop_entry hakuneko HakuNeko hakuneko
}
