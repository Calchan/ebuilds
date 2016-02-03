# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils versionator gnome2-utils fdo-mime

GIN_VER=1.5
GWT_VER=2.7.0
SELENIUM_VER=2.37.0
CHROMEDRIVER_VER=2.7
RMARKDOWN_VER=de4529eda7be281bb09858bfe0b94da984edcab2
RSCONNECT_VER=3034ab8a812858c2ac649171bcadafd149b83bb7

AWS=https://s3.amazonaws.com/rstudio-buildtools/
GITHUB=https://github.com/rstudio/
GIN=gin-${GIN_VER}.zip
GWT=gwt-${GWT_VER}.zip
SELENIUM=selenium-java-${SELENIUM_VER}.zip
SELENIUM_SERVER=selenium-server-standalone-${SELENIUM_VER}.jar
CHROMEDRIVER=chromedriver-linux
RMARKDOWN=${RMARKDOWN_VER}.tar.gz
RSCONNECT=${RSCONNECT_VER}.tar.gz

DESCRIPTION="IDE for the R language"
HOMEPAGE="http://www.rstudio.org https://github.com/rstudio/"
SRC_URI="${GITHUB}rstudio/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${AWS}${GIN} -> rstudio-${GIN}
	${AWS}${GWT} -> rstudio-${GWT}
	${AWS}${SELENIUM} -> rstudio-${SELENIUM}
	${AWS}${SELENIUM_SERVER} -> rstudio-${SELENIUM_SERVER}
	${AWS}${CHROMEDRIVER} -> rstudio-${CHROMEDRIVER}
	${GITHUB}rmarkdown/archive/${RMARKDOWN} -> rstudio-rmarkdown-${RMARKDOWN}
	${GITHUB}rsconnect/archive/${RSCONNECT} -> rstudio-rsconnect-${RSCONNECT}
	https://s3.amazonaws.com/rstudio-dictionaries/core-dictionaries.zip -> rstudio-core-dictionaries.zip"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

QTVER=5.4
QTSLOT=5
QTUSE="declarative opengl qml ssl webkit widgets xml"
QT="-${QTVER}:${QTSLOT}[${QTUSE// /(+),}(+)]"
RDEPEND="app-text/pandoc
	dev-haskell/pandoc-citeproc
	>=dev-lang/R-2.11.1
	>=dev-libs/boost-1.50:=
	>=dev-libs/mathjax-2.3
	dev-libs/openssl:0
	>=dev-qt/qtcore${QT}
	>=dev-qt/qtdbus${QT}
	>=dev-qt/qtdeclarative${QT}
	>=dev-qt/qtgui${QT}
	>=dev-qt/qtnetwork${QT}
	>=dev-qt/qtpositioning${QT}
	>=dev-qt/qtprintsupport${QT}
	>=dev-qt/qtquick1${QT}
	>=dev-qt/qtsensors${QT}
	>=dev-qt/qtsql${QT}
	>=dev-qt/qtsvg${QT}
	>=dev-qt/qtwebkit${QT}
	>=dev-qt/qtwidgets${QT}
	>=dev-qt/qtxml${QT}
	>=dev-qt/qtxmlpatterns${QT}
	sys-apps/util-linux
	>=sys-devel/clang-3.5.0
	sys-libs/zlib
	>=virtual/jre-1.5:=
	x11-libs/pango"
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-java/ant-core
	>=virtual/jdk-1.5
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-*.patch )

unpack_to() {
	mkdir tmp
	cd tmp
	unpack ${1}
	cd ..
	mkdir -p ${P}/${3}
	mv -T tmp/${2} ${P}/${3} || die
	rm -rf tmp
}

cp_to() {
	mkdir -p ${P}/$(dirname ${2})
	cp "${DISTDIR}"/${1} ${P}/${2}
}

src_unpack() {
	unpack ${P}.tar.gz
	unpack_to rstudio-${GWT} gwt-${GWT_VER} src/gwt/lib/gwt/${GWT_VER}
	unpack_to rstudio-${GIN} "" src/gwt/lib/gin/${GIN_VER}
	unpack_to rstudio-${SELENIUM} selenium-${SELENIUM_VER} src/gwt/lib/selenium/${SELENIUM_VER}
	cp_to rstudio-${SELENIUM_SERVER} src/gwt/lib/selenium/${SELENIUM_VER}/${SELENIUM_SERVER}
	cp_to rstudio-${CHROMEDRIVER} src/gwt/lib/selenium/chromedriver/${CHROMEDRIVER_VER}/${CHROMEDRIVER}
	unpack_to rstudio-core-dictionaries.zip "" dependencies/common/dictionaries
	unpack_to rstudio-rmarkdown-${RMARKDOWN} rmarkdown-${RMARKDOWN_VER} dependencies/common/rmarkdown
	unpack_to rstudio-rsconnect-${RSCONNECT} rsconnect-${RSCONNECT_VER} dependencies/common/rsconnect
}

src_configure() {
	export RSTUDIO_VERSION_MAJOR=$(get_version_component_range 1)
	export RSTUDIO_VERSION_MINOR=$(get_version_component_range 2)
	export RSTUDIO_VERSION_PATCH=$(get_version_component_range 3)
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=/usr/lib/rstudio
		-DCMAKE_BUILD_TYPE=Release
		-DRSTUDIO_TARGET=Desktop )
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
