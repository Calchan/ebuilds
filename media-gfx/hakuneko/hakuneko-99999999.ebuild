# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

WX_GTK_VER="3.0-gtk3"

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
	x11-libs/wxGTK:3.0-gtk3[X]"
RDEPEND="${DEPEND}"

src_configure() {
	:
}

src_compile() {
	for source in $(find src -name '*.cpp'); do
		einfo "Compiling ${source}..."
		echo "$(tc-getCXX) $(wx-config --version=3.0 --static=no --debug=no --cflags) ${CXXFLAGS} -c ${source}"
		$(tc-getCXX) $(wx-config --version=3.0 --static=no --debug=no --cflags) ${CXXFLAGS} -c ${source} || die
	done

	einfo "Linking hakuneko..."
	echo "$(tc-getCXX) *.o -o hakuneko ${LDFLAGS} -lcurl -lcrypto -lgtk-3 -lSM $(wx-config --version=3.0 --static=no --debug=no --libs)"
	$(tc-getCXX) *.o -o hakuneko ${LDFLAGS} -lcurl -lcrypto -lgtk-3 -lSM $(wx-config --version=3.0 --static=no --debug=no --libs) || die
}

src_install() {
	dobin hakuneko
	doicon "${DISTDIR}"/hakuneko.png
	make_desktop_entry hakuneko HakuNeko hakuneko
}
