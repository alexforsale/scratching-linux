#!/tools/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-man-pages-done ]];then
    pushd $BUILDDIR
    man_pages=$(grep man-pages-4 /sources/wget-list | sed 's/^.*man-pages-4/man-pages-4/');
    tar -xf /sources/$man_pages;
    cd ${man_pages/.tar*}

    make install

    cd $BUILDDIR
    rm -rf ${man_pages/.tar*}
    popd
    unset man_pages
    touch $BUILDDIR/.chroot-man-pages-done
fi
