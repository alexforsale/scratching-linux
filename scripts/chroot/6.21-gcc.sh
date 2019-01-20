#!/tools/bin/bash
set -e

pathappend /tools/bin

case ${UID} in
    8000)
        pushd /srv/pacman/recipes/Main/gcc
        . PKGBUILD
        if [[ ! -f /srv/pacman/repos/Main/${pkgname}-${pkgver}-${pkgrel}-${arch}.pkg.tar.xz ]];then
            PKGDEST=/srv/pacman/repos/Main \
                   SRCDEST=/sources \
                   _BUILD_ADA=1 _BUILD_FORTRAN=1 _BUILD_GO=1 _BUILD_OBJC=1 \
                   makepkg --skipinteg --nocheck --clean --cleanbuild --needed
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
                [[ -L /usr/lib/gcc ]] && rm -f /usr/lib/gcc
                exit 0
                ;;
            post-install)
                set +e
                pushd /tmp

                echo 'int main(){}' > dummy.c
                cc -m64 dummy.c -v -Wl,--verbose -o dummy64 &> dummy.log
                cc -m32 dummy.c -v -Wl,--verbose -o dummy32 &>> dummy.log
                readelf -l dummy{32,64} | grep ': /lib'

                grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log

                grep -B4 '^ /usr/include' dummy.log

                grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'

                grep "/lib.*/libc.so.6 " dummy.log

                grep found dummy.log

                rm -fv dummy.c dummy{32,64} dummy.log

                popd
                exit 0
                ;;
        esac
        pushd /srv/pacman/recipes/Main/gcc
        . PKGBUILD
        popd
        pushd /srv/pacman/repos/Main
        pacman -U ${pkgname[@]/%/-${pkgver}-${pkgrel}-${arch}.pkg.tar.xz} \
               --needed --noconfirm \
               --overwrite /usr/lib/libgcc_s.so \
               --overwrite /usr/lib/libgcc_s.so.1 \
               --overwrite /usr/lib/libstdc++.so \
               --overwrite /usr/lib/libstdc++.so.6 \
               --overwrite /usr/lib/libstdc++.a
        popd
        ;;
esac
