#!/tools/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-acl-done ]];then
    pushd $BUILDDIR
    acl=$(grep acl- /sources/wget-list | grep tar | sed 's/^.*acl-/acl-/');
    tar -xf /sources/$acl;
    cd ${acl/.tar*}

    ./configure --prefix=/usr --bindir=/bin --disable-static --libexecdir=/usr/lib \
                --docdir=/usr/share/doc/acl-2.2.53
    make
    make install

    mv -v /usr/lib/libacl.so.* /lib
    ln -sfv ../../lib/$(readlink /usr/lib/libacl.so) /usr/lib/libacl.so
    
    cd $BUILDDIR
    rm -rf ${acl/.tar*}
    popd
    unset acl
    touch $BUILDDIR/.chroot-acl-done
fi
