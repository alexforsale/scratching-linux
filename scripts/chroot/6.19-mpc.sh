#!/tools/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-mpc-done ]];then
    pushd $BUILDDIR
    mpc=$(grep mpc- /sources/wget-list | grep tar | sed 's/^.*mpc-/mpc-/');
    tar -xf /sources/$mpc;
    cd ${mpc/.tar*}

    ./configure --prefix=/usr --disable-static --docdir=/usr/share/doc/mpc-1.1.0
    make
    make html
    [[ ${TEST} -eq 1 ]] && make check

    make install
    make install-html

    cd $BUILDDIR
    rm -rf ${mpc/.tar*}
    popd
    unset mpc
    touch $BUILDDIR/.chroot-mpc-done
fi
