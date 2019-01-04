#!/tools/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-mpfr-done ]];then
    pushd $BUILDDIR
    mpfr=$(grep mpfr- /sources/wget-list | grep tar | sed 's/^.*mpfr-/mpfr-/');
    tar -xf /sources/$mpfr;
    cd ${mpfr/.tar*}

    ./configure --prefix=/usr --enable-thread-safe --disable-static --docdir=/usr/share/doc/mpfr-4.0.1
    make
    make html
    [[ ${TEST} -eq 1 ]] && make check

    make install
    make install-html

    cd $BUILDDIR
    rm -rf ${mpfr/.tar*}
    popd
    unset mpfr
    touch $BUILDDIR/.chroot-mpfr-done
fi
