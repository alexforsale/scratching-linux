#!/bin/bash
set -e

# set default pkgbuilddir
if [[ -z $pkgbuilddir ]];then
    export pkgbuilddir=/srv/pacman/recipes
fi
if [[ -f "/etc/makepkg.conf" ]] &&
       [[ -z "$makepkgconf" ]];then
    export makepkgconf='/etc/makepkg.conf'
fi

if [[ -f "$HOME/.makepkg.conf" ]] &&
       [[ -z "$usermakepkgconf" ]];then
    export usermakepkgconf="$HOME/.makepkg.conf"
fi

if [[ -z $repodir ]];then
    export repodir=/srv/pacman/repos
fi
tmpdir="${TMPDIR:-/tmp}/lfsbuild-$UID"
if [[ -z $BUILDDIR ]];then
    export BUILDDIR=$tmpdir
fi

. $makepkgconf
if [[ -f $usermakepkgconf ]];then
    . "$usermakepkgconf"
fi

[[ $PACMAN ]] || PACMAN="pacman"

REPOS=($(find $pkgbuilddir -maxdepth 1 -mindepth 1 -type d -printf '%f\n'))

for repo in "${REPOS[@]/scripts}";do
    if [[ ! -d $repodir/$repo ]];then
        mkdir -p "$repodir"/"$repo"
        if [[ ! -f "$repodir"/"$repo"/"${repo}".db.tar.gz ]];then
            repo-add "$repodir"/"$repo"/"${repo}".db.tar.gz
        fi
    fi
done

_run_as_root(){
    if sudo -v &>/dev/null && sudo -l "$@" &>/dev/null; then
        sudo -E "$@"
    fi
}

_refresh-pacman(){
    _run_as_root pacman -Syy >/dev/null 2>&1
    _run_as_root pacman -Fyy >/dev/null 2>&1
}

_exists_in_pacman() {
    pacman -Ssq -- "^${1}\$" &>/dev/null
}

_is_installed(){
    pacman -Qq -- "$1" &>/dev/null
}

_check_keys(){
    if [[ $NOPGPCHECK -eq 1 ]] || [[ "${_makepkg_args[*]}" =~ "--skippgpcheck" ]];then
        return 0
    fi
    . $pkgbuild
    [[ -z "${validpgpkeys}" ]] && return 0
    for keys in "${validpgpkeys[@]}";do
        while [[ -z "$(gpg --list-keys | grep ${keys})" ]];do
                gpg --recv-keys "${keys}" ||
                    gpg --keyserver hkp://subkeys.pgp.net --recv-keys "${keys}" ||
                    gpg --keyserver keyring.debian.org --recv-keys "${keys}" ||
                    gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys "${keys}" ||
                    gpg --keyserver pgp.mit.edu --recv-keys "${keys}"
        done
    done
}

_check_package(){
    _refresh-pacman
    echo "checking package ${1}"
    for r in ${REPOS[*]};do
        if [[ -d "${pkgbuilddir}/${r}/${1}" ]];then
            export repo="${r}"
            if [[ -f $pkgbuilddir/$repo/$1/PKGBUILD ]];then
                export pkgbuild=$pkgbuilddir/$repo/$1/PKGBUILD
                export PKGDEST=$repodir/$repo
                return 0
            fi
        elif [[ -d $pkgbuilddir/$r/${1/python*-} ]];then
            export repo="$r"
            if [[ -f $pkgbuilddir/$repo/${1/python*-}/PKGBUILD ]];then
                export pkgbuild=$pkgbuilddir/$repo/${1/python*-}/PKGBUILD
                export PKGDEST=$repodir/$repo
                return 0
            fi
        elif [[ -d $pkgbuilddir/$r/${1/python2-/python} ]];then
            export repo="$r"
            if [[ -f $pkgbuilddir/$repo/${1/python2/python}/PKGBUILD ]];then
                export pkgbuild=$pkgbuilddir/$repo/${1/python2/python}/PKGBUILD
                export PKGDEST=$repodir/$repo
                return 0
            fi
        fi
    done
    if [[ -z $repo ]] &&
           [[ -z $pkgbuild ]] &&
           [[ -z $PKGDEST ]];then
        return 1
    fi
    unset r
}

_build_package(){
    for p in "$@";do
        _refresh-pacman
        if [[ -z "${FORCE}" ]] && _is_installed ${p};then
            echo "package ${p} installed"
            return
        elif [[ -z "${FORCE}" ]] && _exists_in_pacman ${p};then
            echo "package ${p} already exists in repository"
            return
        fi
        if _check_package "$p";then
            echo "package $p repo: ${repo}"
            echo "package $p pkgbuild: ${pkgbuild}"
            echo "package $p PKGDEST: ${PKGDEST}"
            echo "checking pgp keys"
            _check_keys
            . "$pkgbuild"
            pushd "${pkgbuild//\/PKGBUILD}"
            makepkg "${_makepkg_args[@]}"
            popd
            _check_package "$p"
            . "$pkgbuild" # in case of svn pkgver()
            for _pn in "${pkgname[@]}"; do
                repo-add "$PKGDEST"/"${repo}".db.tar.gz \
                         "$PKGDEST"/"${_pn}"-"${pkgver}"-"${pkgrel}"-"${arch}""${PKGEXT}"
            done
            _run_as_root pacman -Syy >/dev/null
            _run_as_root pacman -Fyy >/dev/null
            unset repo pkgbuild PKGDEST _pn
        elif ! _check_package "$p";then
            echo "package $p not exists"
        fi
    done
    unset p
}

_two_step_install_root(){
    while [[ $1 ]];do
        if _is_installed "$1" && [[ -z "${FORCE}" ]];then
            echo -e "package $1 installed"
            return 0
        fi
        _refresh-pacman
        _check_package "$1"
        . $pkgbuild
        for p in "${pkgname[@]}";do
            echo -e "waiting for package: $p"
            while ! _exists_in_pacman "${p}" ;do #[[ -z $(pacman -Ssq ^${p})\$ ]];do
                _refresh-pacman
                while false; do
                    inotifywait -qq --event create \
                                --timeout 5 \
                                --event move \
                                "$PKGDEST" &>/dev/null
                    sleep 2
                done
                _refresh-pacman
            done
            while ! _exists_in_pacman "${p}";do
                _refresh-pacman
                sleep 2
            done
        done
        unset p
        . "$pkgbuild" # in case of svn pkgver()
        ${PACMAN} -S "${pkgname[@]}" --noconfirm "${_pacman_args[@]}"
        shift
    done
}

_two_step_install_user(){
    while [[ $1 ]];do
        if _is_installed "$1";then
            if [[ -z "${FORCE}" ]];then
                echo -e "package $1 installed"
                return 0
            fi
        fi
        _check_package "$1"
        . $pkgbuild
        _check_keys
        pushd "${pkgbuild//\/PKGBUILD}"
        makepkg "${_makepkg_args[@]}"
        popd
        . $pkgbuild
        for p in "${pkgname[@]}"; do
            repo-add "$PKGDEST"/"${repo}".db.tar.gz \
                     "$PKGDEST"/"${p}"-"${pkgver}"-"${pkgrel}"-"${arch}""${PKGEXT}"
        done
        while ! _is_installed "${pkgname}";do sleep 5;done
        shift
    done
}

package=()
while [[ $1 ]]; do
    case "$1" in
        --clean | -c)
            _makepkg_args+=( "--clean")
            ;;
        --cleanbuild | -C )
            _makepkg_args+=( "--cleanbuild")
            ;;
        --force | -f)
            _makepkg_args+=( "--force")
            _pacman_args+=( "--force")
            FORCE=1
            ;;
        --geninteg | -g)
            _makepkg_args+=( "--geninteg")
            ;;
        --nosign)
            _makepkg_args+=( "--nosign")
            ;;
        --skippgpcheck)
            _makepkg_args+=( "--skippgpcheck")
            NOPGPCHECK=1
            ;;
        --skipinteg)
            _makepkg_args+=( "--skipinteg")
            ;;
        --skipchecksums)
            _makepkg_args+=( "--skipchecksums")
            ;;
        --nocheck)
            _makepkg_args+=( "--nocheck")
            NOCHECK=1
            ;;
        --syncdeps | -s)
            _makepkg_args+=( "--syncdeps")
            SYNCDEPS=1
            ;;
        --rmdeps | -r)
            _makepkg_args+=( "--rmdeps")
            ;;
        --noextract| -e)
            _makepkg_args+=( "--noextract")
            ;;
        --noprepare)
            _makepkg_args+=( "--noprepare")
            ;;
        --install | -i)
            _makepkg_args+=( "--install")
            ;;
        --sign)
            _makepkg_args+=( "--sign")
            ;;
        --asdeps)
            _makepkg_args+=( "--asdeps")
            _pacman_args+=( "--asdeps")
            ;;
        --needed)
            _makepkg_args+=( "--needed")
            _pacman_args+=( "--needed")
            ;;
        --noconfirm)
            export NOCONFIRM=1
            _makepkg_args+=( "--noconfirm")
            _pacman_args+=( "--noconfirm")
            ;;
        --nodeps)
            export NODEPS=1;;
        --overwrite) _pacmanargs+=( "--overwrite $@");;
        --debug) _pacman_args+=( "--debug");;
        --alldeps) export ALLDEPS=1;;
        -*)
            $PACMAN "$@"
            exit $?
            ;;
        *)
            package+=("$1")
            ;;
    esac
    shift
done

if [[ ! -f /usr/bin/sudo ]];then
    # sudo not yet installed, assuming two step install(build and install)
    # performed by two separate shell
    case $EUID in
        0) 
            _two_step_install_root "${package[@]}"
            ;;
        *) 
            _two_step_install_user "${package[@]}"
            ;;
    esac
else
    echo "package: ${package[*]}"
    echo "_makepkg_args: ${_makepkg_args[*]}"
    echo "_pacman_args: ${_pacman_args[*]}"
    _build_package "${package[@]}"
fi
