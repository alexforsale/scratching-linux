#!/bin/bash
set -e

pathappend /tools/bin

case ${UID} in
    8000)
        pushd /srv/pacman/recipes/Main/sudo
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
            post-install)
                if [[ -z "$(getent group wheel)" ]];then
                    groupadd wheel -g 998
                fi
                if [[ -z "$(id pacman | grep wheel)" ]];then
                    usermod -aG wheel pacman
                    sed -i 's/# %wheel ALL=(ALL) NOPASSWD: ALL/ %wheel ALL=(ALL) NOPASSWD: ALL/g' /etc/sudoers
                fi
                if [[ -n "$(getent shadow | grep '^[^:]*:.\?:' | cut -d: -f1 | grep root)" ]];then
                    echo -e "set password for root"
                    passwd root
                fi
                if [[ -n "$(getent shadow | grep '^[^:]*:.\?:' | cut -d: -f1 | grep pacman)" ]];then
                    echo -e "set password for user pacman"
                    passwd pacman
                fi
                exit 0
                ;;
        esac
        pushd /srv/pacman/recipes/Main/sudo
        . PKGBUILD
        popd
        pushd /srv/pacman/repos/Main
        pacman -U ${pkgname[@]/%/-${pkgver}-${pkgrel}-${arch}.pkg.tar.xz} \
               --needed --noconfirm
        popd
        ;;
esac
