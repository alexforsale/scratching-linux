#!/tools/bin/bash
export PATH=$PATH:/tools/bin
pushd /

for f in bash cat dd echo ln pwd rm stty;do
    if [[ ! -e bin/$f ]];then
        ln -sv /tools/bin/$f bin
    fi
done

for f in env install perl;do
    if [[ ! -e usr/bin/$f ]];then
        ln -sv /tools/bin/$f usr/bin
    fi
done

for f in libgcc_s.so libgcc_s.so.1;do
    if [[ ! -e usr/lib/$f ]];then
        ln -sv /tools/lib/$f usr/lib
    fi
done

for f in libstdc++.a libstdc++.so libstdc++.so.6;do
    if [[ ! -e usr/lib/$f ]];then
        ln -sv /tools/lib/$f usr/lib
    fi
done

for lib in blkid lzma mount uuid;do
    for f in $(ls /tools/lib |grep ${lib}.so);do
        [[ ! -e usr/lib/$f ]] && ln -sv /tools/lib/$f usr/lib
    done
done

[[ ! -e usr/include/blkid ]] && ln -svf /tools/include/blkid usr/include
[[ ! -e usr/include/libmount ]] && ln -svf /tools/include/libmount usr/include
[[ ! -e usr/include/uuid ]] && ln -svf /tools/include/uuid usr/include
[[ ! -d usr/lib/pkgconfig ]] && install -vdm755 usr/lib/pkgconfig

for pc in blkid mount uuid
do
    if [[ ! -e usr/lib/pkgconfig/${pc}.pc ]];then
    sed 's@tools@usr@g' /tools/lib/pkgconfig/${pc}.pc \
        > usr/lib/pkgconfig/${pc}.pc
    fi
done

[[ ! -e bin/sh ]] && ln -sv bash bin/sh

[[ ! -e /etc/mtab ]] && ln -sv /proc/self/mounts etc/mtab


[[ ! -e etc/passwd ]] && cat > etc/passwd << "EOF"
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/dev/null:/bin/false
daemon:x:6:6:Daemon User:/dev/null:/bin/false
messagebus:x:18:18:D-Bus Message Daemon User:/var/run/dbus:/bin/false
nobody:x:99:99:Unprivileged User:/dev/null:/bin/false
EOF

[[ ! -e etc/group ]] && cat > etc/group << "EOF"
root:x:0:
bin:x:1:daemon
sys:x:2:
kmem:x:3:
tape:x:4:
tty:x:5:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
video:x:12:
utmp:x:13:
usb:x:14:
cdrom:x:15:
adm:x:16:
messagebus:x:18:
systemd-journal:x:23:
input:x:24:
mail:x:34:
nogroup:x:99:
users:x:999:
EOF

touch /var/log/{btmp,lastlog,faillog,wtmp}
chgrp -v utmp /var/log/lastlog
chmod -v 664  /var/log/lastlog
chmod -v 600  /var/log/btmp
[[ ! -f /usr/bin/du ]] && ln -sv /tools/bin/du /usr/bin
[[ ! -f /usr/bin/id ]] && ln -sv /tools/bin/id /usr/bin
popd

# create pacman repositories
if [[ ! -f $BUILDDIR/.local-repo-done ]];then
    pushd /srv/pacman/repos
    repos=($(ls /srv/pacman/recipes))
    for r in ${repos[@]};do
        if [[ "${r}" != "scripts" ]];then
            [[ ! -d "${r}" ]] && mkdir -pv "${r}"
            pushd ${r};
            if [[ ! -f "${r}".db.tar.gz ]];then
                /tools/bin/repo-add "${r}".db.tar.gz
            fi
            popd
        fi
    done
    popd
    touch $BUILDDIR/.local-repo-done
fi

# permission fixes
chown -v root.root /var/{cache,lib}
