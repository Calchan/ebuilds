# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils

DESCRIPTION="Sandbox game in 3D procedurally generated worlds"
HOMEPAGE="http://www.minecraft.net"
SRC_URI="https://s3.amazonaws.com/Minecraft.Download/launcher/Minecraft.jar -> ${P}.jar"
LICENSE="Minecraft"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND=""
RDEPEND=">=virtual/jre-1.6
	x11-apps/xrandr"

S="${WORKDIR}"

src_install() {
	insinto /opt/${PN}
	doins "${DISTDIR}"/${P}.jar
	make_wrapper ${PN} "java -jar /opt/${PN}/${P}.jar"
	newicon favicon.png minecraft.png
	make_desktop_entry ${PN} Minecraft minecraft
}
