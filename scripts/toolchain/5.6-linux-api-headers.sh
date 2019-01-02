#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.linux-api-headers-done ]];then
    pushd $BUILDDIR
    linux_api_headers=$(grep linux-4 /sources/wget-list | sed 's/^.*linux-/linux-/');
    tar -xf /sources/$linux_api_headers;
    cd ${linux_api_headers/.tar*}

    make mrproper

    make INSTALL_HDR_PATH=dest headers_install
    cp -rv dest/include/* /tools/include

    cd $BUILDDIR
    rm -rf ${linux_api_headers/.tar*}
    popd
    unset linux_api_headers
    touch $BUILDDIR/.linux-api-headers-done
fi
