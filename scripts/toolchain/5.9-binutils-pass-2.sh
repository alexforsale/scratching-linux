#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.binutils-pass-2-done ]];then 
    binutils=$(grep binutils /sources/wget-list | sed 's/^.*binutils/binutils/')
    pushd $BUILDDIR
    tar -xf /sources/$binutils
    cd ${binutils/.tar*}
    mkdir -pv build && cd $_

    CC=$LFS_TGT-gcc \
      AR=$LFS_TGT-ar \
      RANLIB=$LFS_TGT-ranlib \
      ../configure \
      --prefix=/tools \
      --disable-nls \
      --disable-werror \
      --with-lib-path=/tools/lib \
      --with-sysroot
    make
    make install

    make -C ld clean
    make -C ld LIB_PATH=/usr/lib:/lib
    cp -v ld/ld-new /tools/bin

    cd $BUILDDIR
    rm -rf ${binutils/.tar*}
    popd
    unset binutils
    touch $BUILDDIR/.binutils-pass-2-done
fi
