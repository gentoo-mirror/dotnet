# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils dotnet multilib autotools

DESCRIPTION="A generic framework for creating extensible applications"
HOMEPAGE="https://www.mono-project.com/Mono.Addins"
SRC_URI="https://github.com/mono/${PN}/archive/${P}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
IUSE="+gtk"

RDEPEND=">=dev-lang/mono-6.0.0.334
	gtk? ( >=dev-dotnet/gtk-sharp-2.12.21:2 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
MAKEOPTS="${MAKEOPTS} -j1" #nowarn

S="${WORKDIR}/${PN}-${P}"

src_prepare() {
	eautoreconf
	## with dev-dotnet/gtk-sharp-2.99.1
	## it gives
	## checking for GTK_SHARP_20... no
	## configure: error: Package requirements (gtk-sharp-2.0) were not met:
	##
	## No package 'gtk-sharp-2.0' found

	sed -i "s;Mono.Cairo;Mono.Cairo, Version=4.0.0.0, Culture=neutral, PublicKeyToken=0738eb9f132ed756;g" Mono.Addins.Gui/Mono.Addins.Gui.csproj || die "sed failed"
}

src_configure() {
	econf $(use_enable gtk gui)
}

src_compile() {
	default
	cd bin
	for all in `ls *.dll`; do sn -q -R $all ../mono-addins.snk; done
}

src_install() {
	default
	dotnet_multilib_comply
}
