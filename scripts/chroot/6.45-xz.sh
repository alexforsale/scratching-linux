#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-xz-done ]];then
    pushd $BUILDDIR
    xz=$(grep xz- /sources/wget-list | grep tar | sed 's/^.*xz-/xz-/');
    tar -xf /sources/$xz;
    cd ${xz/.tar*}

    ./configure --prefix=/usr --disable-static --docdir=/usr/share/doc/xz-5.2.4
    make
    [[ ${TEST} -eq 1 ]] && make check
    make install

    mv -v   /usr/bin/{lzma,unlzma,lzcat,xz,unxz,xzcat} /bin
    mv -v /usr/lib/liblzma.so.* /lib
    ln -svf ../../lib/$(readlink /usr/lib/liblzma.so) /usr/lib/liblzma.so

    cd $BUILDDIR
    rm -rf ${xz/.tar*}
    popd
    unset xz
    touch $BUILDDIR/.chroot-xz-done
fi
