# Troubleshooting

## sendmail not working after update
After each AIX update, the sendmail configuration is reset.
The only thing to change is to define our mail server relay into the sendmail configuration file :
```ini
cat /etc/mail/submit.cf | grep ^DS
DS myrelay.com
```
```ini
cp /etc/mail/sendmail.cf  /etc/mail/submit.cf
```
```ini
#  echo "toto" | mailx -vvv -s "This is my test" mailbox@domain.com
```

## 0042-137 nimclient: the /etc/niminfo file is missing some required environment variables
Check if the nimsh service is started :
```ini
lssrc -a | grep nim
 nimsh            nimclient        36307360     active
 nimhttp                                        inoperative
```

If not, start the service :
```ini
stopsrc -s nimsh; startsrc -s nimsh
```
Check the niminfo file ; it should be empty, then remove the file niminfo :
```ini
rm -f /etc/niminfo
```

Go to your NIM master to run this command :
```ini
cd /nim/script/
nim -o remove <hostname>
```
Then run these commands on the client again:
```ini
nimclient -C
nimclient -c
niminit -a name=<hostname> -a master=<nim_master> -a pif_name=en0 -a platform=chrp -a netboot_kernel=64 -c
```
