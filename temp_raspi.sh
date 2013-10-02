#!/bin/bash

#########################################
# Comprueba la temperatura del sistema. #
#########################################

TEMPERATURA=`cat /sys/class/thermal/thermal_zone0/temp`
TEMPERATURA2=`expr $TEMPERATURA / 1000` # Temperatura en grados

if [ $TEMPERATURA2 -gt 80 ]  ; then

	/bin/echo -e "Temperatura actual del sistema: $TEMPERATURA2'C.\nLa temperatura del sistema es alta.\n\nEsta es la IP que tiene actualmente: $MIP\n\nSería conveniente apagar el sistema." | /usr/bin/mail -s "Temperatura ALTA en Raspberry" your@mail.com

fi
