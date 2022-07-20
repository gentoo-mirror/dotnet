# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools mono-env dotnet

DESCRIPTION="D-Bus for .NET: GLib integration module"
HOMEPAGE="https://github.com/mono/dbus-sharp"
SRC_URI="https://github.com/mono/dbus-sharp-glib/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND=">=dev-lang/mono-4.0.2.5
	>=dev-dotnet/dbus-sharp-0.8.1"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( AUTHORS README )

src_prepare() {
	default

	sed -i "s@gmcs@mcs@g" configure.ac || die
	find . -iname "*.csproj" | xargs sed -i "s@v3.5@v4.5@g" || die
	eautoreconf
}
