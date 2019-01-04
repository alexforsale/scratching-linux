#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-elfutils-done ]];then
    pushd $BUILDDIR
    elfutils=$(grep elfutils- /sources/wget-list | grep tar | sed 's/^.*elfutils-/elfutils-/');
    tar -xf /sources/$elfutils;
    cd ${elfutils/.tar*}

    ./configure --prefix=/usr
    make
    [[ ${TEST} -eq 1 ]] && make check
    make -C libelf install
    install -vm644 config/libelf.pc /usr/lib/pkgconfig

    cd $BUILDDIR
    rm -rf ${elfutils/.tar*}
    popd
    unset elfutils
    touch $BUILDDIR/.chroot-elfutils-done
fi
