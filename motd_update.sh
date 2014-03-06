#!/bin/sh

# Modifica el fichero /etc/motd, el cual veremos al hacer login por consola.
# + Info en: https://wiki.debian.org/motd#How_to_update_your_.2Fetc.2Fmotd

IP=`ip addr show scope global | grep inet | cut -d' ' -f6 | cut -d/ -f1`
UP=`uptime | awk -F"up " '{print $2}' | awk -F"," '{print $1}'`
USED=`df -h | grep 'dev/sda1' | awk '{print $3}'`
AVAIL=`df -h | grep 'dev/sda1' | awk '{print $4}'`
MIP=`/usr/bin/curl icanhazip.com 2>/dev/null`
TEMP=`cat /sys/class/thermal/thermal_zone0/temp`
TEMP2=`expr $TEMP / 1000` # Temperatura en grados
DATE=`date +"%A, %e %B %Y, %r"`

echo "\033[1;32m
    .~~.   .~~.
   '. \ ' ' / .'   \033[1;31m
    .~ .~~~..~.    \033[1;37m                   _                          _ \033[1;31m
   : .~.'~'.~. :   \033[1;37m   ___ ___ ___ ___| |_ ___ ___ ___ _ _    ___|_|\033[1;31m
  ~ (   ) (   )$ ~ \033[1;37m  |  _| .'|_ -| . | . | -_|  _|  _| | |  | . | |\033[1;31m
 ( : '~'.~.'~' : ) \033[1;37m  |_| |__,|___|  _|___|___|_| |_| |_  |  |  _|_|\033[1;31m
  ~ .~ (   ) ~. ~  \033[1;37m              |_|                 |___|  |_|    \033[1;31m
   (  : '~' :  )
    '~ .~~~. ~'
        '~'

    \033[1;37m-------------------------------------------------    
    \033[1;37m$DATE
    \033[1;31m`hostname -f` IP: \033[1;30m$IP / $MIP
    \033[1;34mUsed | Free on /dev/sda1:\033[1;30m $USED | $AVAIL
    \033[1;34mRunning Processes:\033[1;30m `ps ax | wc -l | tr -d " "`
    \033[1;34mUpTime:\033[1;30m $UP
    \033[1;34mSystem Temperature:\033[1;30m $TEMP2ºC
    \033[1;37m-------------------------------------------------
" > $1
