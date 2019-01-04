#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-grub-done ]];then
    pushd $BUILDDIR
    grub=$(grep grub- /sources/wget-list | grep tar | sed 's/^.*grub-/grub-/');
    tar -xf /sources/$grub;
    cd ${grub/.tar*}

    ./configure --prefix=/usr --sbindir=/sbin --sysconfdir=/etc --disable-efiemu --disable-werror
    make
    make install
    
    cd $BUILDDIR
    rm -rf ${grub/.tar*}
    popd
    unset grub
    touch $BUILDDIR/.chroot-grub-done
fi
