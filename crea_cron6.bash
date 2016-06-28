#!/bin/bash
####################################################################################
# File Name  : crea_cron6.bash
# Author     : David Bojart
# Date       : 20141001
# Explanation: Programa el envio de kickstart o los DVD's de Red-Hat a las 22:00 de cada pais.
# Parameters : 1 (Opcional) Nombre del pais. Programa la tarea solo para ese pais.
#	       Sin parametro programa la tarea en todos los paises que esten en el sitelist.
# Update     : Se aniade envio de los DVD's de Red-Hat
#	       Permite elegir el tipo de envio Kickstart o DVD's.
#
####################################################################################

# VARIABLES
SEDE=$1
HORA_MADRID=`date +"%H"`
SITELIST=/export/kickstart/ks.master/bin/sitelist6
CRON_FILE=/export/kickstart/ks.master/bin/crontab_kickstart
PREPARE=/export/kickstart/ks.master/bin/prepare6.sh
BUNDLES=/export/kickstart/ks.master/bin/transfer_bundles6.sh

## COLORES
ROJO="\e[31m"     # Mensajes de error
VERDE="\e[32m"
AMARILLO="\e[33m"
AZUL="\e[34m"     # Mensajes OK
ROSA="\e[35m"     # Mensajes informativos
CYAN="\033[1;36m"
BLANCO="\033[1;37m"
NEGRITA="\033[1m"
FONDONEGRO="\033[7m"
SUBRAYADO="\033[4m"
NORMAL="\033[m"

funcion_envio ()
{

ENVIO=$1
LOG_ENVIO=`echo $ENVIO | awk -F "/" '{print $6}'`

if [ "$SEDE" == "" ] ; then

	for PAIS in `cat $SITELIST | grep -v "#" | cut -d"," -f1`; do	
	
		SERVIDOR=`cat $SITELIST | grep $PAIS | grep -v "#" | cut -d"," -f7`
        	echo "$PAIS" 
		echo -e "Comprobando la hora en $SERVIDOR ...."
        	HORA_SERVER=`ssh $SERVIDOR date +"%H"`
        	DIFF_HORA=`expr $HORA_SERVER - $HORA_MADRID`
        	HORA_MADRID2=`expr 22 - $DIFF_HORA`
		LIMPIADOR=`expr $HORA_MADRID2 + 9`

# Control de la Hora de la programacion de la tarea del prepare6.sh
		if [ $HORA_MADRID2 -ge 24 ] ; then
			HORA_MADRID2=`expr $HORA_MADRID2 - 24`
		fi
		if [ $HORA_MADRID2 -lt 0 ] ; then
			HORA_MADRID2=`expr $HORA_MADRID2 + 24`
		fi
		
# Aniade las tareas al crontab controlando si ya estan en el fichero y omitiendo la sede sino ha podido calcular la hora
		TAREA=`cat $CRON_FILE | grep -i "$ENVIO $PAIS"`
		if [ "$HORA_SERVER" == "" ] ; then
			echo -e "$ROJO Imposible comprobar la hora en $PAIS, se omite la tarea para este pais$NORMAL"
		else
			if [ "$TAREA" == "" ] ; then 
				echo -e "$VERDE SE PROGRAMA LA EJECUCION DE $LOG_ENVIO EN $PAIS A LAS $HORA_MADRID2:00 Europe/Madrid$NORMAL"
				echo "00 $HORA_MADRID2 * * * $ENVIO $PAIS y > /tmp/$PAIS.$LOG_ENVIO.log" >> $CRON_FILE
			else
                		echo -e "$AZUL Tarea ya programada, no se hace nada.$NORMAL"
        		fi
		fi
	done
else
		SERVIDOR=`cat $SITELIST | grep $SEDE | grep -v "#" | cut -d"," -f7`
		echo $SERVIDOR
		echo -e "Comprobando la hora en $SERVIDOR ...."
                HORA_SERVER=`ssh $SERVIDOR date +"%H"`
		DIFF_HORA=`expr $HORA_SERVER - $HORA_MADRID`	
                HORA_MADRID2=`expr 22 - $DIFF_HORA`
                LIMPIADOR=`expr $HORA_MADRID2 + 9`

                if [ $HORA_MADRID2 -ge 24 ] ; then
                	HORA_MADRID2=`expr $HORA_MADRID2 - 24`
                fi
                if [ $HORA_MADRID2 -lt 0 ] ; then
                	HORA_MADRID2=`expr $HORA_MADRID2 + 24`
                fi

	TAREA=`cat $CRON_FILE | grep -i "$ENVIO $SEDE"`
	if [ "$TAREA" == "" ] ; then 
                echo -e "$VERDE SE PROGRAMA LA EJECUCION DE $LOG_ENVIO EN $SEDE A LAS $HORA_MADRID2:00 Europe/Madrid$NORMAL"
                echo "00 $HORA_MADRID2 * * * $ENVIO $SEDE y > /tmp/$SEDE.$LOG_ENVIO.log" >> $CRON_FILE
	else
		echo -e "$AZUL Tarea ya programada, no se hace nada.$NORMAL"
	fi
fi	
crontab $CRON_FILE
}

echo -e "\n¿Que deseas enviar?"
echo -e "  1) Kickstart"
echo -e "  2) DVD's Red Hat"
read RESPUESTA

case $RESPUESTA in
       1) funcion_envio "$PREPARE" "$SEDE" "$SITELIST" "$CRON_FILE" "$HORA_MADRID" ;;
       2) funcion_envio "$BUNDLES" "$SEDE" "$SITELIST" "$CRON_FILE" "$HORA_MADRID" ;;
       *) exit ;;
esac
