#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-gdbm-done ]];then
    pushd $BUILDDIR
    gdbm=$(grep gdbm- /sources/wget-list | grep tar | sed 's/^.*gdbm-/gdbm-/');
    tar -xf /sources/$gdbm;
    cd ${gdbm/.tar*}

    ./configure --prefix=/usr --disable-static --enable-libgdbm-compat
    make
    [[ ${TEST} -eq 1 ]] && make check
    make install
    
    cd $BUILDDIR
    rm -rf ${gdbm/.tar*}
    popd
    unset gdbm
    touch $BUILDDIR/.chroot-gdbm-done
fi
