#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-meson-done ]];then
    pushd $BUILDDIR
    meson=$(grep meson- /sources/wget-list | grep tar | sed 's/^.*meson-/meson-/');
    tar -xf /sources/$meson;
    cd ${meson/.tar*}

    python3 setup.py build
    python3 setup.py install --root=dest
    cp -rv dest/* /

    cd $BUILDDIR
    rm -rf ${meson/.tar*}
    popd
    unset meson
    touch $BUILDDIR/.chroot-meson-done
fi
