TERMUX_PKG_HOMEPAGE=http://picolisp.com
TERMUX_PKG_DESCRIPTION="Lisp interpreter and application server framework"
TERMUX_PKG_DEPENDS="libcrypt, openssl"
_PICOLISP_YEAR=17
_PICOLISP_MONTH=1
_PICOLISP_DAY=23
TERMUX_PKG_VERSION=${_PICOLISP_YEAR}.${_PICOLISP_MONTH}.${_PICOLISP_DAY}
# We use our bintray mirror since old version snapshots are not kept on main site.
TERMUX_PKG_SRCURL=https://dl.bintray.com/termux/upstream/picolisp_${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=35f9264c9665d4247033e8d86f7fc31285621aee08009f77691e065c629c3ffd
TERMUX_PKG_FOLDERNAME=picoLisp
TERMUX_PKG_BUILD_IN_SRC=true
# The assembly is not position-independent (would be a major rewrite):
TERMUX_PKG_BLACKLISTED_ARCHES="x86_64"
if [ $TERMUX_ARCH_BITS = 32 ]; then
	# "Variable length array in structure won't be supported"
	TERMUX_PKG_CLANG=no
fi

termux_step_pre_configure() {
	# Validate that we have the right version:
	grep -q "Version $_PICOLISP_YEAR $_PICOLISP_MONTH $_PICOLISP_DAY" src64/version.l || {
		echo "ERROR: Picolisp version needs to be bumped" 1>&2
		grep Version src64/version.l 1>&2
		exit 1
	}

	if [ $TERMUX_ARCH_BITS = 64 ]; then
		cd $TERMUX_PKG_SRCDIR
		if [ $TERMUX_ARCH = "aarch64" ]; then
			export TERMUX_PKG_EXTRA_MAKE_ARGS=arm64.linux
		elif [ $TERMUX_ARCH = "x86_64" ]; then
			export TERMUX_PKG_EXTRA_MAKE_ARGS=x86-64.linux
		else
			termux_error_exit "Unsupported arch: $TERMUX_ARCH"
		fi
		TERMUX_PKG_SRCDIR=$TERMUX_PKG_SRCDIR/src64
	else
		TERMUX_PKG_SRCDIR=$TERMUX_PKG_SRCDIR/src
	fi
	TERMUX_PKG_BUILDDIR=$TERMUX_PKG_SRCDIR
	ORIG_CFLAGS="$CFLAGS"
	CFLAGS+=" -c $LDFLAGS $CPPFLAGS"
}

termux_step_make_install () {
	cd $TERMUX_PKG_SRCDIR/

	if [ $TERMUX_ARCH_BITS = "64" ]; then
		$CC -fno-integrated-as -pie -o ../bin/picolisp -rdynamic ${TERMUX_PKG_EXTRA_MAKE_ARGS}.base.s -lc -lm -ldl
		chmod +x ../bin/picolisp
		$CC -fno-integrated-as -pie -o ../lib/ext -shared -export-dynamic ${TERMUX_PKG_EXTRA_MAKE_ARGS}.ext.s
		$CC -fno-integrated-as -pie -o ../lib/ht -shared -export-dynamic ${TERMUX_PKG_EXTRA_MAKE_ARGS}.ht.s
	fi

	mkdir -p $TERMUX_PREFIX/share/man/man1
	cp $TERMUX_PKG_SRCDIR/../man/man1/{pil,picolisp}.1 $TERMUX_PREFIX/share/man/man1/

	rm -Rf $TERMUX_PREFIX/lib/picolisp
	mkdir -p $TERMUX_PREFIX/lib/picolisp

	cp -Rf $TERMUX_PKG_SRCDIR/../* $TERMUX_PREFIX/lib/picolisp/
	rm -Rf $TERMUX_PREFIX/lib/picolisp/{src,man,java,ersatz}

	# Replace first line "#!/usr/bin/picolisp /usr/lib/picolisp/lib.l":
	sed -i "1 s|^.*$|#!$TERMUX_PREFIX/bin/picolisp $TERMUX_PREFIX/lib/picolisp/lib.l|g" $TERMUX_PREFIX/lib/picolisp/bin/pil

	( cd $TERMUX_PREFIX/bin && ln -f -s ../lib/picolisp/bin/picolisp picolisp && ln -f -s ../lib/picolisp/bin/pil pil )

	# Bundled tools:
	$CC $ORIG_CFLAGS $CPPFLAGS $LDFLAGS -o $TERMUX_PREFIX/lib/picolisp/bin/ssl ../src/ssl.c -lssl -lcrypto
	$CC $ORIG_CFLAGS $CPPFLAGS $LDFLAGS -o $TERMUX_PREFIX/lib/picolisp/bin/httpGate ../src/httpGate.c -lssl -lcrypto

	# Man pages:
	cp $TERMUX_PKG_SRCDIR/../man/man1/{pil,picolisp}.1 $TERMUX_PREFIX/share/man/man1/
}
