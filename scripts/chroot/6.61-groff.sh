#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-groff-done ]];then
    pushd $BUILDDIR
    groff=$(grep groff- /sources/wget-list | grep tar | sed 's/^.*groff-/groff-/');
    tar -xf /sources/$groff;
    cd ${groff/.tar*}

    PAGE=A4 ./configure --prefix=/usr
    make -j1
    make install
    
    cd $BUILDDIR
    rm -rf ${groff/.tar*}
    popd
    unset groff
    touch $BUILDDIR/.chroot-groff-done
fi
