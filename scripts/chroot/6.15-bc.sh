#!/tools/bin/bash
set -e

pathappend /tools/bin

case ${UID} in
    8000)
        pushd /srv/pacman/recipes/Main/bc
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
                [[ ! -f /usr/lib/libncursesw.so.6 ]] &&
                    ln -sv /tools/lib/libncursesw.so.6 /usr/lib/libncursesw.so.6
                [[ ! -f /usr/lib/libncurses.so ]] &&
                    ln -sfv libncurses.so.6 /usr/lib/libncurses.so
                exit 0
                ;;
        esac

        pushd /srv/pacman/recipes/Main/bc
        . PKGBUILD
        popd
        pushd /srv/pacman/repos/Main
        pacman -U ${pkgname[@]/%/-${pkgver}-${pkgrel}-${arch}.pkg.tar.xz} \
               --needed --noconfirm
        popd
        ;;
esac
