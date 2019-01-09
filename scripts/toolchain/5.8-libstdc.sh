#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.libstdc-done ]];then
    pushd $BUILDDIR
    gcc=$(grep gcc /sources/wget-list | sed 's/^.*gcc/gcc/');
    tar -xf /sources/$gcc;
    cd ${gcc/.tar*}

    mkdir -v build && cd $_

    ../libstdc++-v3/configure \
        --host=$LFS_TGT \
        --prefix=/tools \
        --disable-nls \
        --disable-libstdcxx-threads \
        --disable-libstdcxx-pch \
        --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/8.2.0
    make
    make install
    cd $BUILDDIR
    rm -rf ${gcc/.tar*}
    popd
    unset gcc
    touch $BUILDDIR/.libstdc-done
fi
