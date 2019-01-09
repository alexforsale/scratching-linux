#!/tools/bin/bash
set -e

. ~/.bashrc
. /sources/build/.env

# build libcap (for fakeroot & libarchive)
if [[ ! -f $BUILDDIR/.pacstuffs-libcap-done ]];then
    pushd $BUILDDIR
    libcap=$(grep libcap- /sources/wget-list | grep tar | sed 's/^.*libcap-/libcap-/');
    tar -xf /sources/$libcap;
    cd ${libcap/.tar*}
    sed -i '/install.*STALIBNAME/d' libcap/Makefile
    make RAISE_SETFCAP=no \
         BUILD_GPERF=no \
         KERNEL_HEADERS=/tools/include \
         PAM_CAP=no
    make RAISE_SETFCAP=no lib=lib \
         BUILD_GPERF=no \
         KERNEL_HEADERS=/tools/include \
         PAM_CAP=no \
         prefix=/tools install
    cd $BUILDDIR
    rm -rf ${libcap/.tar*}
    popd
    unset libcap
    touch $BUILDDIR/.pacstuffs-libcap-done
fi

# build libarchive
if [[ ! -f $BUILDDIR/.pacstuffs-libarchive-done ]];then
    pushd $BUILDDIR
    tar -xf /sources/libarchive-3.3.3.tar.gz
    cd libarchive-3.3.3
    ./configure --prefix=/tools --without-xml2
    make
    make install
    cd ..
    rm -rf libarchive-3.3.3
    popd
    touch $BUILDDIR/.pacstuffs-libarchive-done
fi

# build fakeroot
if [[ ! -f $BUILDDIR/.pacstuffs-fakeroot-done ]];then
    pushd $BUILDDIR
    tar -xf /sources/fakeroot_1.23.orig.tar.xz
    cd fakeroot-1.23
    ./configure --prefix=/tools
    make
    make install
    cd $BUILDDIR
    rm -rf fakeroot-1.23
    popd
    touch $BUILDDIR/.pacstuffs-fakeroot-done
fi

# build curl
if [[ ! -f $BUILDDIR/.pacstuffs-curl-done ]];then
    pushd $BUILDDIR
    tar -xf /sources/curl-7.63.0.tar.gz
    cd curl-7.63.0/
    ./configure --prefix=/tools --without-ssl
    make
    make install
    cd $BUILDDIR
    rm -rf curl-7.63.0/
    popd
    touch $BUILDDIR/.pacstuffs-curl-done
fi

# build nettle
if [[ ! -f $BUILDDIR/.pacstuffs-nettle-done ]];then
    pushd $BUILDDIR
    tar -xf /sources/nettle-3.4.1.tar.gz
    cd nettle-3.4.1
    ./configure --prefix=/tools
    make
    make install
    cd $BUILDDIR
    rm -rf nettle-3.4.1
    popd
    touch $BUILDDIR/.pacstuffs-nettle-done
fi

#build pacman
if [[ ! -f $BUILDDIR/.pacstuffs-pacman-done ]];then
    pushd $BUILDDIR
    tar -xf /sources/pacman-5.1.2.tar.gz
    cd pacman-5.1.2
    LIBARCHIVE_CFLAGS="-I/tools/include" \
                     LIBARCHIVE_LIBS="-L/tools/lib -larchive" \
                     NETTLE_CFLAGS="-I/tools/include" \
                     NETTLE_LIBS="-L/tools/lib -lnettle" \
                     ./configure --prefix=/tools/ --sysconfdir=/etc \
                     --localstatedir=/var --disable-doc --with-crypto=nettle
    make
    install -v -d -m755 $BUILDDIR/pacman-package
    make DESTDIR=$BUILDDIR/pacman-package install
    cd $BUILDDIR
    rm -rf pacman-5.1.2
    cp -rv $BUILDDIR/pacman-package/* $LFS/
    popd
    rm -rf $BUILDDIR/pacman-package
    install -v -d -m755 $LFS/etc
    cp -v $SCRIPTDIR/scripts/{makepkg.conf,pacman.conf} $LFS/etc
    touch $BUILDDIR/.pacstuffs-pacman-done
fi
