#!/bin/bash
set -e

. settings.conf

pushd $LFS/sources
[[ ! -f wget-list ]] &&
    wget http://www.linuxfromscratch.org/lfs/view/stable/wget-list
if [[ ! -f .lfs-wget-done ]];then
    wget --input-file=wget-list --continue;
    wget http://www.linuxfromscratch.org/lfs/view/stable/md5sums;
    md5sum -c md5sums;

    pacstuffs=("https://sources.archlinux.org/other/pacman/pacman-5.1.2.tar.gz"
               "https://libarchive.org/downloads/libarchive-3.3.3.tar.gz"
               "http://ftp.debian.org/debian/pool/main/f/fakeroot/fakeroot_1.23.orig.tar.xz"
               "https://ftp.gnu.org/gnu/nettle/nettle-3.4.1.tar.gz"
               "https://curl.haxx.se/download/curl-7.63.0.tar.gz")

    for l in ${pacstuffs[@]};do
        wget --continue $l
    done
    touch .lfs-wget-done;
    unset l
fi
