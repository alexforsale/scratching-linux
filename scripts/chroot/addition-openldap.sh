#!/bin/bash
set -e

pathappend /tools/bin

case ${UID} in
    8000)
        case $1 in
            pass-2)
                if [[ -f $BUILDDIR/.openldap-pass2-done ]];then exit 0;fi
                pushd /srv/pacman/recipes/Extra/openldap
                . PKGBUILD
                PKGDEST=/srv/pacman/repos/Extra \
                       SRCDEST=/sources makepkg --skipinteg --nocheck --clean --cleanbuild --needed --force
                popd
                exit 0
                ;;
        esac
        
        pushd /srv/pacman/recipes/Extra/openldap
        . PKGBUILD
        if [[ ! -f /srv/pacman/repos/Extra/${pkgname}-${pkgver}-${pkgrel}-${arch}.pkg.tar.xz ]];then
            PKGDEST=/srv/pacman/repos/Extra \
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
            pass-2)
                if [[ -f $BUILDDIR/.openldap-pass2-done ]];then exit 0;fi
                pushd /srv/pacman/recipes/Extra/openldap
                . PKGBUILD
                popd
                pushd /srv/pacman/repos/Extra
                pacman -U ${pkgname[@]/%/-${pkgver}-${pkgrel}-${arch}.pkg.tar.xz} \
                       --noconfirm
                popd
                touch $BUILDDIR/.openldap-pass2-done
                exit 0
                ;;
        esac
        pushd /srv/pacman/recipes/Extra/openldap
        . PKGBUILD
        popd
        pushd /srv/pacman/repos/Extra
        pacman -U ${pkgname[@]/%/-${pkgver}-${pkgrel}-${arch}.pkg.tar.xz} \
               --needed --noconfirm
        popd
        ;;
esac
