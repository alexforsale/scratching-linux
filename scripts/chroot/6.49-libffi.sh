#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-libffi-done ]];then
    pushd $BUILDDIR
    libffi=$(grep libffi- /sources/wget-list | grep tar | sed 's/^.*libffi-/libffi-/');
    tar -xf /sources/$libffi;
    cd ${libffi/.tar*}

    sed -e '/^includesdir/ s/$(libdir).*$/$(includedir)/' \
        -i include/Makefile.in

    sed -e '/^includedir/ s/=.*$/=@includedir@/' \
        -e 's/^Cflags: -I${includedir}/Cflags:/' \
        -i libffi.pc.in

    ./configure --prefix=/usr --disable-static --with-gcc-arch=native
    make
    [[ ${TEST} -eq 1 ]] && make check
    make install
    
    cd $BUILDDIR
    rm -rf ${libffi/.tar*}
    popd
    unset libffi
    touch $BUILDDIR/.chroot-libffi-done
fi
