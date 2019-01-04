#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-kbd-done ]];then
    pushd $BUILDDIR
    kbd=$(grep kbd- /sources/wget-list | grep tar | sed 's/^.*kbd-/kbd-/');
    tar -xf /sources/$kbd;
    cd ${kbd/.tar*}

    patch -Np1 -i /sources/kbd-2.0.4-backspace-1.patch
    sed -i 's/\(RESIZECONS_PROGS=\)yes/\1no/g' configure
    sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in

    PKG_CONFIG_PATH=/tools/lib/pkgconfig ./configure --prefix=/usr --disable-vlock
    make
    [[ ${TEST} -eq 1 ]] && make check
    make install

    mkdir -v /usr/share/doc/kbd-2.0.4
    cp -R -v docs/doc/* /usr/share/doc/kbd-2.0.4

    cd $BUILDDIR
    rm -rf ${kbd/.tar*}
    popd
    unset kbd
    touch $BUILDDIR/.chroot-kbd-done
fi
