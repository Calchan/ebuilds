# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

WX_GTK_VER="2.8"

inherit mercurial wxwidgets toolchain-funcs eutils

DESCRIPTION="Manga Downloader"
HOMEPAGE="http://code.google.com/p/hakuneko/"
SRC_URI="http://c.fsdn.com/allura/p/hakuneko/icon -> hakuneko.png"
EHG_REPO_URI="http://hg.code.sf.net/p/hakuneko/code"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/openssl
	media-libs/libjpeg-turbo
	media-libs/tiff
	net-misc/curl
	x11-libs/wxGTK:2.8[X]"
RDEPEND="${DEPEND}"

src_configure() {
	:
}

src_compile() {
	for source in $(find src -name '*.cpp'); do
		einfo "Compiling ${source}..."
		$(tc-getCXX) $(wx-config --cflags) ${CXXFLAGS} -c ${source}
	done

	einfo "Linking hakuneko..."
	$(tc-getCXX) *.o -o hakuneko ${LDFLAGS} -lcurl -lcrypto -ljpeg -ltiff -lgtk-x11-2.0 -lSM $(wx-config --libs)
}

src_install() {
	dobin hakuneko
	doicon "${DISTDIR}"/hakuneko.png
	make_desktop_entry hakuneko HakuNeko hakuneko
}
