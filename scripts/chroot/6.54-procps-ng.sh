#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-procps-done ]];then
    pushd $BUILDDIR
    procps=$(grep procps- /sources/wget-list | grep tar | sed 's/^.*procps-/procps-/');
    tar -xf /sources/$procps;
    cd ${procps/.tar*}

    ./configure --prefix=/usr --exec-prefix= --libdir=/usr/lib --docdir=/usr/share/doc/procps-ng-3.3.15 \
                --disable-static --disable-kill
    make

    if [[ ${TEST} -eq 1 ]];then
        sed -i -r 's|(pmap_initname)\\\$|\1|' testsuite/pmap.test/pmap.exp
        sed -i '/set tty/d' testsuite/pkill.test/pkill.exp
        rm testsuite/pgrep.test/pgrep.exp
        make check
    fi
    
    make install
    mv -v /usr/lib/libprocps.so.* /lib
    ln -sfv ../../lib/$(readlink /usr/lib/libprocps.so) /usr/lib/libprocps.so

    cd $BUILDDIR
    rm -rf ${procps/.tar*}
    popd
    unset procps
    touch $BUILDDIR/.chroot-procps-done
fi
