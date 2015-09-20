# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python3_4 )

inherit distutils-r1

DESCRIPTION="Generate custom kernel configurations from curated sources"
HOMEPAGE="https://github.com/Calchan/kernelconfig"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

RDEPEND="dev-python/beautifulsoup:4[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/docutils[${PYTHON_USEDEP}]"
