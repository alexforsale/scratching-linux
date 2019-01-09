#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.binutils-pass-1-done ]];then 
    binutils=$(grep binutils /sources/wget-list | sed 's/^.*binutils/binutils/')
    pushd $BUILDDIR
    tar -xf /sources/$binutils
    cd ${binutils/.tar*}
    mkdir -pv build && cd $_
    ../configure --prefix=/tools \
                 --with-sysroot=$LFS \
                 --with-lib-path=/tools/lib:/tools/lib32 \
                 --target=$LFS_TGT \
                 --disable-nls \
                 --enable-multilib \
                 --disable-werror
    make
    case $(uname -m) in
        x86_64) mkdir -v /tools/lib && ln -sv lib /tools/lib64 ;;
    esac
    make install
    cd $BUILDDIR
    rm -rf ${binutils/.tar*}
    popd
    unset binutils
    touch $BUILDDIR/.binutils-pass-1-done
fi
