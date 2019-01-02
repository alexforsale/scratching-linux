#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.gettext-done ]];then
    pushd $BUILDDIR;
    gettext=$(grep gettext /sources/wget-list | sed 's/^.*gettext/gettext/');

    tar -xf /sources/$gettext
    cd ${gettext/.tar*}

    cd gettext-tools
    EMACS="no" ./configure --prefix=/tools --disable-shared

    make -C gnulib-lib
    make -C intl pluralx.c
    make -C src msgfmt
    make -C src msgmerge
    make -C src xgettext

    cp -v src/{msgfmt,msgmerge,xgettext} /tools/bin

    cd $BUILDDIR
    rm -rf ${gettext/.tar*}
    popd
    unset gettext
    touch $BUILDDIR/.gettext-done
fi
