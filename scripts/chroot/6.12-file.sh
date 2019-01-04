#!/tools/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-file-done ]];then
    pushd $BUILDDIR
    file=$(grep file- /sources/wget-list | grep tar | sed 's/^.*file-/file-/');
    tar -xf /sources/$file;
    cd ${file/.tar*}

    ./configure --prefix=/usr
    make
    [[ ${TEST} -eq 1 ]] && make check
    make install

    cd $BUILDDIR
    rm -rf ${file/.tar*}
    popd
    unset file
    touch $BUILDDIR/.chroot-file-done
fi

