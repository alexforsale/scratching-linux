#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-check-done ]];then
    pushd $BUILDDIR
    check=$(grep check- /sources/wget-list | grep tar | sed 's/^.*check-/check-/');
    tar -xf /sources/$check;
    cd ${check/.tar*}

    ./configure --prefix=/usr
    make
    [[ ${TEST} -eq 1 ]] && make check
    make install
    sed -i '1 s/tools/usr/' /usr/bin/checkmk

    cd $BUILDDIR
    rm -rf ${check/.tar*}
    popd
    unset check
    touch $BUILDDIR/.chroot-check-done
fi
