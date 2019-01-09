#!/bin/bash
set -e

pathappend /tools/bin

case ${UID} in
    8000)
        pushd /srv/pacman/recipes/Main/xz
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
        pushd /srv/pacman/recipes/Main/xz
        . PKGBUILD
        popd
        pushd /srv/pacman/repos/Main
        pacman -U ${pkgname[@]/%/-${pkgver}-${pkgrel}-${arch}.pkg.tar.xz} \
               --needed --noconfirm \
               --overwrite /usr/lib/liblzma.so \
               --overwrite /usr/lib/liblzma.so.5 \
               --overwrite /usr/lib/liblzma.so.5.2.4
        popd
        ;;
esac
