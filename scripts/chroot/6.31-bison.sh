#!/tools/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-bison-done ]];then
    pushd $BUILDDIR
    bison=$(grep bison- /sources/wget-list | grep tar | sed 's/^.*bison-/bison-/');
    tar -xf /sources/$bison;
    cd ${bison/.tar*}

    ./configure --prefix=/usr --docdir=/usr/share/doc/bison-3.0.5
    make
    make install
    
    cd $BUILDDIR
    rm -rf ${bison/.tar*}
    popd
    unset bison
    touch $BUILDDIR/.chroot-bison-done
fi
