#!/tools/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-sed-done ]];then
    pushd $BUILDDIR
    sed=$(grep sed- /sources/wget-list | grep tar | sed 's/^.*sed-/sed-/');
    tar -xf /sources/$sed;
    cd ${sed/.tar*}

    sed -i 's/usr/tools/'                 build-aux/help2man
    sed -i 's/testsuite.panic-tests.sh//' Makefile.in

    ./configure --prefix=/usr --bindir=/bin

    make
    make html

    [[ ${TEST} -eq 1 ]] && make check

    make install
    install -d -m755 /usr/share/doc/sed-4.5
    install -m644 doc/sed.html /usr/share/doc/sed-4.5

    cd $BUILDDIR
    rm -rf ${sed/.tar*}
    popd
    unset sed
    touch $BUILDDIR/.chroot-sed-done
fi
