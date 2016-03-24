# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils

DESCRIPTION="Replacement gdmflexiserver for lightdm"
HOMEPAGE="https://github.com/Calchan/ebuilds/tree/master/x11-misc/lightdmflexiserver"
SRC_URI=""
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="!gnome-base/gdm"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_install() {
	make_wrapper "gdmflexiserver" "${DESTTREE}/bin/dm-tool switch-to-greeter"
}
