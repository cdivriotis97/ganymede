# Troubleshooting

### Fix rpmdb: Thread died in Berkeley DB library
If you are encountering this issue when using yum / dnf / rpm :
```ini
rpmdb: Thread/process 277623/140429100390144 failed: Thread died in Berkeley DB library
error: db3 error(-30974) from dbenv->failchk: DB_RUNRECOVERY: Fatal error, run database recovery
error: cannot open Packages index using db3 -  (-30974)
error: cannot open Packages database in /var/lib/rpm
CRITICAL:yum.verbose.cli.yumcompletets:Yum Error: Error: rpmdb open failed
```

Follow the steps below :
```ini
mkdir /var/lib/rpm/backup 
cp -a /var/lib/rpm/__db* /var/lib/rpm/backup/ 
rm -f /var/lib/rpm/__db.[0-9][0-9]* 
rpm --quiet -qa 
rpm --rebuilddb 
yum clean all
```

If the issue reoccurs, please follow the article : [https://access.redhat.com/solutions/3330211](https://access.redhat.com/solutions/3330211).


### Failed to load SELinux policy, freezing
[https://access.redhat.com/support/cases/#/case/02758766](https://access.redhat.com/support/cases/#/case/02758766).

* **Press “e” at the boot screen to edit the startup parameters.
* **HModify the line that starts with “linux16” and append “selinux=0” to the end
* **HPress “ctrl+x” to boot.

```ini
systemctl stop isectpd.service
yum reinstall selinux-policy\*

yum update setup

touch /.autorelabel

init 6
```

### Force fsck

[https://access.redhat.com/solutions/1582803](hhttps://access.redhat.com/solutions/1582803)
[https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/managing_monitoring_and_updating_the_kernel/configuring-kernel-command-line-parameters_managing-monitoring-and-updating-the-kernel#doc-wrapper](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/managing_monitoring_and_updating_the_kernel/configuring-kernel-command-line-parameters_managing-monitoring-and-updating-the-kernel#doc-wrapper)

```
grubby --update-kernel=ALL --args="fsck.mode=force"
grubby --update-kernel=ALL --args="fsck.repair=yes"
# Check variable

cat /boot/grub2/grubenv

grub2-mkconfig -o /etc/grub2.cfg

awk '$6 == 0 && $3 ~ /xfs|ext4/ { print "puppet resource mount "$1" pass=1"  }' /etc/fstab
 
 
perl -i -ape 's/(\d)(\s+\d\s*)$/1$2/g' /etc/fstab 
reboot
```


### Propagate ACL
```
FILE=myfile
getfacl -R $FILE > /tmp/acl-before-$(basename $FILE).out
getfacl $FILE  | setfacl -R  --set-file=-  --test   $FILE
getfacl $FILE  | setfacl -R  --set-file=-    $FILE
getfacl -R $FILE | tee  /tmp/acl-after-$(basename $FILE).out 
```

