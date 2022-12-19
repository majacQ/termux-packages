TERMUX_PKG_HOMEPAGE=https://www.pcre.org
TERMUX_PKG_DESCRIPTION="Perl 5 compatible regular expression library"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="10.42"
TERMUX_PKG_SRCURL=https://github.com/PhilipHazel/pcre2/releases/download/pcre2-${TERMUX_PKG_VERSION}/pcre2-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=8d36cd8cb6ea2a4c2bb358ff6411b0c788633a2a45dabbf1aeb4b701d1b5e840
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+"
TERMUX_PKG_BREAKS="pcre2-dev"
TERMUX_PKG_REPLACES="pcre2-dev"
TERMUX_PKG_RM_AFTER_INSTALL="
bin/pcre2test
share/man/man1/pcre2test.1
"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-jit
--enable-pcre2-16
--enable-pcre2-32
"
