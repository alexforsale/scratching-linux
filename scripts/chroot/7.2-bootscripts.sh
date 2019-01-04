#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-bootscripts-done ]];then
    pushd $BUILDDIR
    bootscripts=$(grep lfs-bootscripts- /sources/wget-list | grep tar | sed 's/^.*lfs-bootscripts-/lfs-bootscripts-/');
    tar -xf /sources/$bootscripts;
    cd ${bootscripts/.tar*}

    make install

    cd $BUILDDIR
    rm -rf ${bootscripts/.tar*}
    popd
    unset bootscripts
    touch $BUILDDIR/.chroot-bootscripts-done
fi
