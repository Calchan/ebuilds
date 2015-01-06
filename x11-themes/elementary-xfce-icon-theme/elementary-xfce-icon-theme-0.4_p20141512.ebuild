# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit vcs-snapshot gnome2-utils

COMMIT="2f74e250c6b7af686d9d6a879b129a80692f5ca7"

DESCRIPTION="Elementary icons forked from upstream, extended and maintained for Xfce"
HOMEPAGE="http://github.com/shimmerproject/elementary-xfce"
SRC_URI="${HOMEPAGE}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
LICENSE="public-domain GPL-1 GPL-2 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND=""

src_install() {
	insinto /usr/share/icons/
	dodoc README
	for shade in elementary-xfce*; do
		for doc in {AUTHORS,CONTRIBUTORS,LICENSE}; do
			if [[ -f ${shade}/${doc} ]]; then
				newdoc ${shade}/${doc} ${shade}-${doc}
				rm -f ${shade}/${doc}
			fi
		done
		doins -r ${shade}
	done
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
