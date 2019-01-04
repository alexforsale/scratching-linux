#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-kmod-done ]];then
    pushd $BUILDDIR
    kmod=$(grep kmod- /sources/wget-list | grep tar | sed 's/^.*kmod-/kmod-/');
    tar -xf /sources/$kmod;
    cd ${kmod/.tar*}

    ./configure --prefix=/usr --bindir=/bin --sysconfdir=/etc --with-rootlibdir=/lib \
                --with-kmod --with-zlib
    make
    make install
    
    for target in depmod insmod lsmod modinfo modprobe rmmod; do
        ln -sfv ../bin/kmod /sbin/$target
    done

    ln -sfv kmod /bin/lsmod

    cd $BUILDDIR
    rm -rf ${kmod/.tar*}
    popd
    unset kmod
    touch $BUILDDIR/.chroot-kmod-done
fi
