#!/bin/bash
# Service watchdog script
# Put in crontab to automatially restart services (and optionally email you) if they die for some reason.
# Note: You need to run this as root otherwise you won't be able to restart services.
#

DATE=`date +%Y-%m-%d--%H-%M-%S`
SERVICE_NAME="asterisk"
EXTRA_PGREP_PARAMS="-x" #Extra parameters to pgrep, for example -x is good to do exact matching
MAIL_TO="aaaaaa@aa.com" #Email to send restart notifications to
LOG=`tail -10 /var/log/asterisk/messages `
SEND=`echo -e "$DATE : Performing restart of ${SERVICE_NAME} : \n LOGFILE : \n$LOG  " | mail -s "Service failure: ${SERVICE_NAME}" ${MAIL_TO}`
#path to pgrep command, for example /usr/bin/pgrep
PGREP="pgrep"
 
   LogFile =`cat /var/log/asterisk/messages`
  

 
#Check if we have have a second param
if [ -z $SERVICE_RESTARTNAME ]
  then
    RESTART="/usr/sbin/service ${SERVICE_NAME} restart" #No second param
  else
    RESTART="/usr/sbin/service ${SERVICE_RESTARTNAME} restart" #Second param
  fi
 
pids=`$PGREP ${EXTRA_PGREP_PARAMS} ${SERVICE_NAME}`
 
#if we get no pids, service is not running
if [ "$pids" == "" ]
then
 $RESTART
 if [ -z $MAIL_TO ]
   then
     echo "$DATE : ${SERVICE_NAME} restarted - no email report configured."
   else
     echo "$DATE : Performing restart of ${SERVICE_NAME} : File log : $LogFile " | mail -s "Service failure: ${SERVICE_NAME}" ${MAIL_TO}
cat /var/log/asterisk/messages
 fi
else
  echo "$DATE : Service ${SERVICE_NAME} is still working!"
fi
