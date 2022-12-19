TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X virtual framebuffer"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.20.14
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/xserver/xorg-server-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=5cc5b70b9be89443e2594b93656c60bd5e82cd7f01deb4ce4faf81dcf546a16b

TERMUX_PKG_DEPENDS="libandroid-shmem, libdrm, libpixman, libx11, libxau, libxfont2, libxinerama, libxkbfile, libxshmfence, mesa, openssl, xkeyboard-config, xorg-protocol-txt, xorg-xkbcomp"
TERMUX_PKG_CONFLICTS="xorg-xvfb"
TERMUX_PKG_REPLACES="xorg-xvfb"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_path_RAWCPP=/usr/bin/cpp
--enable-composite
--enable-mitshm
--enable-xres
--enable-record
--enable-xv
--enable-xvmc
--enable-dga
--enable-screensaver
--enable-xdmcp
--disable-glx
--disable-dri
--disable-dri2
--disable-dri3
--enable-present
--enable-xinerama
--enable-xf86vidmode
--enable-xace
--enable-xcsecurity
--enable-dbe
--enable-xf86bigfont
--disable-xfree86-utils
--disable-vgahw
--disable-vbe
--disable-int10-module
--enable-libdrm
--disable-pciaccess
--disable-linux-acpi
--disable-linux-apm
--disable-xorg
--disable-dmx
--enable-xvfb
--disable-xnest
--disable-xwayland
--disable-xwin
--disable-kdrive
--disable-xephyr
--disable-libunwind
--enable-xshmfence
--enable-ipv6
--with-sha1=libcrypto
--with-fontrootdir=${TERMUX_PREFIX}/share/fonts
--with-xkb-path=${TERMUX_PREFIX}/share/X11/xkb
LIBS=-landroid-shmem
"

TERMUX_PKG_RM_AFTER_INSTALL="
share/X11/xkb/compiled
share/man/man1/Xserver.1
"

termux_step_pre_configure() {
	CFLAGS+=" -DFNDELAY=O_NDELAY"
	CPPFLAGS+=" -I${TERMUX_PREFIX}/include/libdrm"

	if [ "$TERMUX_DEBUG_BUILD" = "true" ]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --enable-debug"
	fi
}
