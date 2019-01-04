#!/tools/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-attr-done ]];then
    pushd $BUILDDIR
    attr=$(grep attr- /sources/wget-list | grep tar | sed 's/^.*attr-/attr-/');
    tar -xf /sources/$attr;
    cd ${attr/.tar*}

    ./configure --prefix=/usr --bindir=/bin --disable-static --sysconfdir=/etc \
                --docdir=/usr/share/doc/attr-2.4.48
    make
    [[ ${TEST} -eq 1 ]] && make check
    make install

    mv -v /usr/lib/libattr.so.* /lib
    ln -sfv ../../lib/$(readlink /usr/lib/libattr.so) /usr/lib/libattr.so

    cd $BUILDDIR
    rm -rf ${attr/.tar*}
    popd
    unset attr
    touch $BUILDDIR/.chroot-attr-done
fi
