# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} pypy pypy2_0 )

inherit python-single-r1

DESCRIPTION="A text document format for writing short documents, articles, books and UNIX man pages"
HOMEPAGE="http://asciidoc.org/"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}/${PV}/${P}.tar.gz"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"

LICENSE="GPL-2"
SLOT="0"
IUSE="examples graphviz highlight test vim-syntax"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND=">=app-text/docbook-xsl-stylesheets-1.75
		dev-libs/libxslt
		graphviz? ( media-gfx/graphviz )
		app-text/docbook-xml-dtd:4.5
		highlight? ( || ( dev-python/pygments[${PYTHON_USEDEP}] dev-util/source-highlight ) )
		${PYTHON_DEPS}
"
DEPEND="test? ( dev-util/source-highlight
			media-sound/lilypond
			media-gfx/imagemagick
			dev-texlive/texlive-latex
			app-text/dvipng
			media-gfx/graphviz
			${PYTHON_DEPS} )
"

src_prepare() {
	if ! use vim-syntax; then
		sed -i -e '/^install/s/install-vim//' Makefile.in || die
	else
		sed -i\
			-e "/^vimdir/s:@sysconfdir@/vim:${EPREFIX}/usr/share/vim/vimfiles:" \
			-e 's:/etc/vim::' \
			Makefile.in || die
	fi

	# Only needed for prefix - harmless (does nothing) otherwise
	sed -i -e "s:^CONF_DIR=.*:CONF_DIR='${EPREFIX}/etc/asciidoc':" \
		"${S}/asciidoc.py" || die
}

src_configure() {
	econf --sysconfdir="${EPREFIX}"/usr/share
}

src_install() {
	use vim-syntax && dodir /usr/share/vim/vimfiles

	emake DESTDIR="${D}" install

	python_fix_shebang "${ED}"/usr/bin/*.py

	if use examples; then
		# This is a symlink to a directory
		rm examples/website/images || die

		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
		dosym ../../../asciidoc/images /usr/share/doc/${PF}/examples
	fi

	dodoc BUGS CHANGELOG README docbook-xsl/asciidoc-docbook-xsl.txt \
			dblatex/dblatex-readme.txt filters/code/code-filter-readme.txt
}

src_test() {
	cd tests || die
	local -x ASCIIDOC_PY=../asciidoc.py
	"${PYTHON}" test${PN}.py update || die
	"${PYTHON}" test${PN}.py run || die
}
