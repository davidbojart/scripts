#!/bin/bash

###########################################
# Comprueba si la IP Publica ha cambiado. #
###########################################

RUTA=`TU RUTA DONDE SE ENCUENTRA EL SCRIPT`
IPANTERIOR="0.0.0.0"
MIP=`/usr/bin/curl icanhazip.com 2>/dev/null`


if [ "$MIP" != "$IPANTERIOR" ] ; then

	if [ "$MIP" == "" ] ; then
	
		echo "No se ha podido obtener la nueva IP"

	else
             	/bin/sed -i "s|$IPANTERIOR|$MIP|g" $RUTA/new_ip.sh
             	/bin/echo -e "La IP ha cambiado en la Rapsberry.\n\nNueva IP: $MIP" | /usr/bin/mail -s "IP Nueva en Raspberry" tumail@mail.com
             	/bin/echo "$MIP" >> $RUTA/.mip     
        fi
fi
