#!/tools/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-gmp-done ]];then
    pushd $BUILDDIR
    gmp=$(grep gmp- /sources/wget-list | grep tar | sed 's/^.*gmp-/gmp-/');
    tar -xf /sources/$gmp;
    cd ${gmp/.tar*}

    ./configure --prefix=/usr --enable-cxx --disable-static --docdir=/usr/share/doc/gmp-6.1.2
    make
    make html
    [[ ${TEST} -eq 1 ]] && make check 2>&1 | tee gmp-check-log
    awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log

    make install
    make install-html

    cd $BUILDDIR
    rm -rf ${gmp/.tar*}
    popd
    unset gmp
    touch $BUILDDIR/.chroot-gmp-done
fi
