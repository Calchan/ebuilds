# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils versionator gnome2-utils fdo-mime

GIN_VER=1.5
GWT_VER=2.7.0
SELENIUM_VER=2.37.0
CHROMEDRIVER_VER=2.7
MATHJAX_VER=23
CLANG_VER=3.5
PANDOC_VER=1.13.1
RMARKDOWN_VER=ee2f13cd209f72984fb9aba7364712744364a65b
RSCONNECT_VER=295276cd75787b48ec2d48c31e4830553be45d50

AWS=https://s3.amazonaws.com/rstudio-buildtools/
GITHUB=https://github.com/rstudio/
GIN=gin-${GIN_VER}.zip
GWT=gwt-${GWT_VER}.zip
SELENIUM=selenium-java-${SELENIUM_VER}.zip
SELENIUM_SERVER=selenium-server-standalone-${SELENIUM_VER}.jar
CHROMEDRIVER=chromedriver-linux
MATHJAX=mathjax-${MATHJAX_VER}.zip
PANDOC=pandoc-${PANDOC_VER}.zip
RMARKDOWN=${RMARKDOWN_VER}.tar.gz
RSCONNECT=${RSCONNECT_VER}.tar.gz
LIBCLANG=libclang-${CLANG_VER}.zip
CLANG_HEADERS=libclang-builtin-headers.zip

DESCRIPTION="IDE for the R language"
HOMEPAGE="http://www.rstudio.org https://github.com/rstudio/"
SRC_URI="${GITHUB}rstudio/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${AWS}${GIN} -> rstudio-${GIN}
	${AWS}${GWT} -> rstudio-${GWT}
	${AWS}${SELENIUM} -> rstudio-${SELENIUM}
	${AWS}${SELENIUM_SERVER} -> rstudio-${SELENIUM_SERVER}
	${AWS}${CHROMEDRIVER} -> rstudio-${CHROMEDRIVER}
	${AWS}${MATHJAX} -> rstudio-${MATHJAX}
	${AWS}${PANDOC} -> rstudio-${PANDOC}
	${GITHUB}rmarkdown/archive/${RMARKDOWN} -> rstudio-rmarkdown-${RMARKDOWN}
	${GITHUB}rsconnect/archive/${RSCONNECT} -> rstudio-rsconnect-${RSCONNECT}
	${AWS}${LIBCLANG} -> rstudio-${LIBCLANG}
	${AWS}${CLANG_HEADERS} -> rstudio-${CLANG_HEADERS}
	https://s3.amazonaws.com/rstudio-dictionaries/core-dictionaries.zip -> rstudio-core-dictionaries.zip"

LICENSE="AGPL-3"
SLOT="0"
# Will not work on anything else until the built-in pandoc and libclang are dealt with
KEYWORDS="~amd64"
IUSE=""

QTVER=5.4
QTSLOT=5
QTUSE="declarative opengl qml ssl webkit widgets xml"
QT="-${QTVER}:${QTSLOT}[${QTUSE// /(+),}(+)]"
RDEPEND=">=dev-lang/R-2.11.1
	>=dev-libs/boost-1.50:=
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
	sys-libs/zlib
	>=virtual/jre-1.5:=
	x11-libs/pango"
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-java/ant-core
	>=virtual/jdk-1.5
	virtual/pkgconfig"

QA_PREBUILT="/usr/lib/rstudio/bin/pandoc/pandoc*"

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
	unpack_to rstudio-${MATHJAX} "" dependencies/common/mathjax-${MATHJAX_VER}
	unpack_to rstudio-${PANDOC} pandoc-${PANDOC_VER}/linux/debian/x86_64 dependencies/common/pandoc/${PANDOC_VER}
	unpack_to rstudio-rmarkdown-${RMARKDOWN} rmarkdown-${RMARKDOWN_VER} dependencies/common/rmarkdown
	unpack_to rstudio-rsconnect-${RSCONNECT} rsconnect-${RSCONNECT_VER} dependencies/common/rsconnect
	unpack_to rstudio-${CLANG_HEADERS} "" dependencies/common/libclang
	unpack_to rstudio-${LIBCLANG} libclang-${CLANG_VER}/linux/x86_64 dependencies/common/libclang/${CLANG_VER}
}

src_prepare() {
	# Do not build and/or install these
	sed \
		-e '/include(CMakeInstallDocs.txt)/d' \
		-e '/add_subdirectory(package)/d' \
		-i CMakeLists.txt || die

	# Adjust location of Qt5 and cmake
	sed \
		-e '/get_filename_component(QT_BIN_DIR \${QT_QMAKE_EXECUTABLE} PATH)/d' \
		-e 's|${QT_BIN_DIR}//\.\.//lib//cmake|/usr/lib/cmake|' \
		-i src/cpp/desktop/CMakeLists.txt || die

	# Fix linker flags
	sed \
		-e 's/${CMAKE_EXE_LINKER_FLAGS} -Wl,-z,relro,-z,now/-Wl,-z,relro,-z,now ${CMAKE_EXE_LINKER_FLAGS}/' \
		-i src/cpp/CMakeLists.txt || die

	# Disable java's preferences subsystem
	# See http://www.allaboutbalance.com/articles/disableprefs/
	sed \
		-e '/property name="ace.bin"/a <property environment="env"/>' \
		-e '/target name="gwtc"/,/<\/target>/s/<jvmarg value="-Xmx1024M"\/>/<jvmarg value="-Xmx1024M"\/>\
			<jvmarg value="-Djava.util.prefs.userRoot=${env.T}"\/>/' \
		-i src/gwt/build.xml || die
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
