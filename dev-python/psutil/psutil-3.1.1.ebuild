# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python3_4 )

inherit distutils-r1

DESCRIPTION="Python system and process utilities"
HOMEPAGE="https://github.com/giampaolo/psutil"
SRC_URI="https://github.com/giampaolo/${PN}/archive/release-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${PN}-release-${PV}"
