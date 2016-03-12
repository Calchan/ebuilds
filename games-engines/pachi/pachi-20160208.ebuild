# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit games toolchain-funcs

COMMIT=27b4f1910a79dbe23ed7bebd3dfd8b10267e72d2

DESCRIPTION="Monte Carlo tree search game engine for Go"
HOMEPAGE="http://pachi.or.cz/"
SRC_URI="http://repo.or.cz/pachi.git/snapshot/${COMMIT}.tar.gz -> ${P}.tar.gz
	http://pachi.or.cz/pat/gogod-handikgspachi/patterns.prob.xz
	http://pachi.or.cz/pat/gogod-handikgspachi/patterns.spat.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S=${WORKDIR}/${PN}-${COMMIT:0:7}

src_prepare() {
	sed "s/patterns\.spat/${GAMES_DATADIR//\//\\/}\/${PN}\/patterns.spat/" -i patternsp.c || die
	sed "s/patterns\.prob/${GAMES_DATADIR//\//\\/}\/${PN}\/patterns.prob/" -i patternprob.c || die
}

src_compile() {
	subdirs=$(find . -name Makefile | sed 's/\/Makefile//')
	for subdir in ${subdirs}; do
		cd ${subdir}
		for source in *.c; do
			echo "Compiling ${source}"
			$(tc-getCC) ${CFLAGS} -pthread -I. -I"${S}" -c ${source}
		done
		cd "${S}"
	done
	echo "Linking ${PN}"
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} -pthread -o ${PN} $(find . -name "*.o") -lm -lrt -ldl
}

src_install() {
	exeinto "${GAMES_BINDIR}"
	doexe ${PN}
	insinto "${GAMES_DATADIR}/${PN}"
	doins "${WORKDIR}"/patterns.*
	dodoc CREDITS README TODO
}

pkg_postinst() {
	einfo "You can use Fuego's openings book by installing games-engines/fuego and starting Pachi like this:"
	einfo "    pachi -f ${GAMES_DATADIR}/fuego/book.dat"
}
