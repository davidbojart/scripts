#!/bin/bash
####################################################################################
# File Name  : limpia_cron_kickstart.bash
# Author     : David Bojart
# Date       : 20141001
# Explanation: Comprueba si el envio de kickstart o los DVD's de Red-Hat esta corriendo o ha finalizado a las 7:00
#	       Sino ha finalizado, para el proceso y programa de nuevo el envio a las 22:00
#
####################################################################################
SEDE=$1
PROCESO_PREPARE=`ps -ef | grep -v grep | grep -i "prepare6.sh $SEDE" | awk '{print $2}'`
PROCESO_BUNDLES=`ps -ef | grep -v grep | grep -i "transfer_bundles6.sh $SEDE" | awk '{print $2}'`
PROCESO="$PROCESO_PREPARE $PROCESO_BUNDLES"
SEMF=`echo $(($RANDOM%100))`
	if [ "$PROCESO" == " " ] ; then
		sleep $SEMF
# Borra las dos tareas del pais programadas del fichero del crontab
		cat /export/kickstart/ks.master/bin/crontab_kickstart | grep -i $SEDE | sed -i".bak" '/'$SEDE'/d' /export/kickstart/ks.master/bin/crontab_kickstart
		
		echo -e "\nNo se ha encontrado el proceso, se borran las tareas.\n" >> /tmp/$SEDE.limpia.txt
        else
# Mata el proceso y borra la linea del limpiador en el fichero del crontab.
		kill -9 $PROCESO
		sleep $SEMF
		cat /export/kickstart/ks.master/bin/crontab_kickstart | grep -i $SEDE | sed -i".bak" '/'"limpia_cron6.bash $SEDE"'/d' /export/kickstart/ks.master/bin/crontab_kickstart
		echo -e "\nSe mata el proceso, tarea programada de nuevo\n" >> /tmp/$SEDE.limpia.txt
	fi

crontab /export/kickstart/ks.master/bin/crontab_kickstart
