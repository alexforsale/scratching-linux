#!/tools/bin/bash

pushd /
for d in bin boot etc/opt etc/sysconfig home lib/firmware mnt opt \
         media/floppy media/cdrom sbin srv var;do
    if [[ ! -d $d ]];then
        mkdir -pv $d
    fi
done

[[ ! -d root ]] && install -dv -m 0750 root
[[ ! -d tmp ]] && install -dv -m 1777 tmp
[[ ! -d var/tmp ]] && install -dv -m 1777 var/tmp

for d in bin include lib sbin src;do
    if [[ ! -d usr/$d ]];then
        mkdir -pv usr/$d
    fi
    if [[ ! -d usr/local/$d ]];then
        mkdir -pv usr/local/$d
    fi
done

for d in color dict doc info locale man;do
    if [[ ! -d usr/share/$d ]];then
        mkdir -pv usr/share/$d
    fi
    if [[ ! -d usr/local/share/$d ]];then
        mkdir -pv usr/local/share/$d
    fi
done

for d in misc terminfo zoneinfo;do
    if [[ ! -d usr/share/$d ]];then
       mkdir -pv usr/share/$d
    fi
       if [[ ! -d usr/local/share/$d ]];then
           mkdir -pv usr/local/share/$d
       fi
done
[[ ! -d usr/libexec ]] && mkdir -pv  usr/libexec
for (( i=1;i<9;i++ )); do
    if [[ ! -d usr/share/man/man$i ]];then
        mkdir -pv usr/share/man/man$i
    fi
    if [[ ! -d usr/local/share/man/man$i ]];then
        mkdir -pv usr/local/share/man/man$i;fi
done

case $(uname -m) in
    x86_64)
        if [[ ! -d lib64 ]];then
            mkdir -pv lib64
        fi
        ;;
esac

for d in log mail spool;do
    if [[ ! -d var/$d ]];then
        mkdir -pv var/$d
    fi
done

[[ ! -L var/run ]] && ln -sfv /run var/run
[[ ! -L var/lock ]] && ln -sfv /run/lock var/lock

for d in opt cache lib/color lib/misc lib/locale local;do
    if [[ ! -d var/$d ]];then
        mkdir -pv var/$d
    fi
done
popd
