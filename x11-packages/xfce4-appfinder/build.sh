TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/xfce/xfce4-appfinder/start
TERMUX_PKG_DESCRIPTION="Application launcher and finder"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=4.18
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.0
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/xfce/xfce4-appfinder/${_MAJOR_VERSION}/xfce4-appfinder-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=962a98d7b327d2073ed4cd0f78bce7945ed51b97d52fd60196e8b02ef819c18c
TERMUX_PKG_DEPENDS="garcon, gdk-pixbuf, gtk3, libcairo, libxfce4ui, libxfce4util, xfconf"
