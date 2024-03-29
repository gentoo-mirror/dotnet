# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_DOTNET="net45"

inherit dotnet eutils gac

DESCRIPTION="Microsoft's Xml Document Transformation library"
HOMEPAGE="https://github.com/mrward/xdt"
LICENSE="Apache-2.0"
SLOT="0"

SRC_URI="https://github.com/mrward/xdt/archive/Release-NuGet-${PV}-Mono.tar.gz -> xdt-for-monodevelop-${PV}.tar.gz"
S=${WORKDIR}/xdt-Release-NuGet-${PV}-Mono

KEYWORDS="~amd64"
IUSE=""

DEPEND="|| ( dev-lang/mono )"
RDEPEND="${DEPEND}"

pkg_setup() {
	dotnet_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}/disable-testproject-build-in-sln.patch"
	cp "${FILESDIR}/rsa-4096.snk" "${S}/XmlTransform" || die
	epatch "${FILESDIR}/add-keyfile-option-to-csproj.patch"
	sed -i -e "s/1.0.0/${PV}/g"  "${S}/XmlTransform/Properties/AssemblyInfo.cs" || die
	eapply_user
}

src_configure() {
	export EnableNuGetPackageRestore="true"
}

src_compile() {
	exbuild Microsoft.Web.XmlTransform.sln
	elog "Signing Microsoft.Web.XmlTransform.dll with rsa-4096.snk"
	sn -R XmlTransform/bin/Release/Microsoft.Web.XmlTransform.dll XmlTransform/rsa-4096.snk
}

src_install() {
	elog "Installing Microsoft.Web.XmlTransform.dll to GAC"
	egacinstall XmlTransform/bin/Release/Microsoft.Web.XmlTransform.dll
}
