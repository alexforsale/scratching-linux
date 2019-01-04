#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-libpipeline-done ]];then
    pushd $BUILDDIR
    libpipeline=$(grep libpipeline- /sources/wget-list | grep tar | sed 's/^.*libpipeline-/libpipeline-/');
    tar -xf /sources/$libpipeline;
    cd ${libpipeline/.tar*}

    ./configure --prefix=/usr
    make
    [[ $TEST -eq 1 ]] && make check
    make install
    
    cd $BUILDDIR
    rm -rf ${libpipeline/.tar*}
    popd
    unset libpipeline
    touch $BUILDDIR/.chroot-libpipeline-done
fi
