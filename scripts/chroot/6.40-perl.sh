#!/bin/bash
set -e

pathappend /tools/bin

case ${UID} in
    8000)
        pushd /srv/pacman/recipes/Main/perl
        . PKGBUILD
        if [[ ! -f /srv/pacman/repos/Main/${pkgname}-${pkgver}-${pkgrel}-${arch}.pkg.tar.xz ]];then
            PKGDEST=/srv/pacman/repos/Main \
                   SRCDEST=/sources makepkg --skipinteg --nocheck --clean --cleanbuild --needed
        fi
#        for p in ${pkgname[@]};do
#            if [[ -z "$(pacman -Ss ^${p}$)" ]];then
#                repo-add --new /srv/pacman/repos/Main/Main.db.tar.gz \
#                         /srv/pacman/repos/Main/${p}-${pkgver}-${pkgrel}-${arch}.pkg.tar.xz
#            fi
#        done
        popd
        ;;
    0)
        case $1 in
            prepare)
                [[ ! -f /etc/hosts ]] && echo "127.0.0.1 localhost $(hostname)" > /etc/hosts
                exit 0
                ;;
        esac

        pushd /srv/pacman/recipes/Main/perl
        . PKGBUILD
        popd
        pushd /srv/pacman/repos/Main
        pacman -U ${pkgname[@]/%/-${pkgver}-${pkgrel}-${arch}.pkg.tar.xz} \
               --overwrite /usr/bin/perl \
               --needed --noconfirm
        popd
        ;;
esac
