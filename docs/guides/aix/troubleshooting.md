# Troubleshooting

## sendmail not working after update
After each AIX update, the sendmail configuration is reset.
The only thing to change is to define our mail server relay into the sendmail configuration file :
# cat /etc/mail/submit.cf | grep ^DS
DS myrelay.com

# cp /etc/mail/sendmail.cf  /etc/mail/submit.cf

#  echo "toto" | mailx -vvv -s "This is my test" mailbox@domain.com
