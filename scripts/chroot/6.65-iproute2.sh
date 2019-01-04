#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-iproute2-done ]];then
    pushd $BUILDDIR
    iproute2=$(grep iproute2- /sources/wget-list | grep tar | sed 's/^.*iproute2-/iproute2-/');
    tar -xf /sources/$iproute2;
    cd ${iproute2/.tar*}

    sed -i /ARPD/d Makefile
    rm -fv man/man8/arpd.8

    sed -i 's/.m_ipt.o//' tc/Makefile
    make
    make DOCDIR=/usr/share/doc/iproute2-4.18.0 install

    cd $BUILDDIR
    rm -rf ${iproute2/.tar*}
    popd
    unset iproute2
    touch $BUILDDIR/.chroot-iproute2-done
fi
