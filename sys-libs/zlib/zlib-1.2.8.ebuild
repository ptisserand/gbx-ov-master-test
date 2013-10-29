# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/zlib/zlib-1.2.3-r1.ebuild,v 1.12 2007/05/14 23:51:14 vapier Exp $

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="Standard (de)compression library"
HOMEPAGE="http://www.zlib.net/"
SRC_URI="mirror://community/${PN}-1.2.8.tar.gz"

LICENSE="BSD"
PUBLIC=1

SLOT="0"
KEYWORDS="arm mips x86-intelce x86 sh"
IUSE="redist"


RDEPEND=""

S=${WORKDIR}/zlib-1.2.8

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PV}/zlib-minizip.patch
	use sh && epatch "${FILESDIR}"/${PV}/zlib-1.2.8-sh4.patch
}

src_compile() {
	export LDCONFIG=true
	./configure --shared --prefix=/usr --libdir=/$(get_libdir) || die
	emake libz.a || die
	emake || die
}

src_install() {
	emake DESTDIR=${D} install || die
	dodir /usr/lib

	# the .a file needs to be in /usr/lib
	mv ${D}/lib/*.a ${D}/usr/lib
	gen_usr_ldscript libz.so

	if use redist
	then
		into /redist
		dolib.so ${D}/lib/*.so*
	fi

}
