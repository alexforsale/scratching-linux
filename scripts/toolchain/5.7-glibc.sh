#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.glibc-done ]];then
    pushd $BUILDDIR
    glibc=$(grep glibc /sources/wget-list | grep tar.* | sed 's/^.*glibc/glibc/');
    tar -xf /sources/$glibc;
    cd ${glibc/.tar*}

    mkdir -v build && cd $_

    ../configure \
        --prefix=/tools \
        --host=$LFS_TGT \
        --build=$(../scripts/config.guess) \
        --enable-kernel=3.2 \
        --with-headers=/tools/include \
        libc_cv_forced_unwind=yes \
        libc_cv_c_cleanup=yes
    make
    make install

    cd $BUILDDIR
    rm -rf ${glibc/.tar*}
    popd
    unset glibc
    touch $BUILDDIR/.glibc-done
fi
