#!/tools/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-iana-done ]];then
    pushd $BUILDDIR
    iana=$(grep iana- /sources/wget-list | grep tar | sed 's/^.*iana-/iana-/');
    tar -xf /sources/$iana;
    cd ${iana/.tar*}

    make
    make install
    
    cd $BUILDDIR
    rm -rf ${iana/.tar*}
    popd
    unset iana
    touch $BUILDDIR/.chroot-iana-done
fi
