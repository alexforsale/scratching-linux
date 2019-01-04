#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-gettext-done ]];then
    pushd $BUILDDIR
    gettext=$(grep gettext- /sources/wget-list | grep tar | sed 's/^.*gettext-/gettext-/');
    tar -xf /sources/$gettext;
    cd ${gettext/.tar*}

    sed -i '/^TESTS =/d' gettext-runtime/tests/Makefile.in
    sed -i 's/test-lock..EXEEXT.//' gettext-tools/gnulib-tests/Makefile.in

    sed -e '/AppData/{N;N;p;s/\.appdata\./.metainfo./}' \
        -i gettext-tools/its/appdata.loc

    ./configure --prefix=/usr --disable-static --docdir=/usr/share/doc/gettext-0.19.8.1
    make
    [[ ${TEST} -eq 1 ]] && make check
    make install
    chmod -v 0755 /usr/lib/preloadable_libintl.so
    
    cd $BUILDDIR
    rm -rf ${gettext/.tar*}
    popd
    unset gettext
    touch $BUILDDIR/.chroot-gettext-done
fi
