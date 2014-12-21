#!/bin/bash
################################################################################
# Name:         temperatura.sh                                                 #
# Autor:        David Bojart                                                   #
# Explicacion:  Muestra la temperatura de la CPU. Segun la temperatura muestra #
#               Verde, Amarillo, o Rojo segun la criticidad.                   #        
################################################################################

mgrados=`cat /sys/class/thermal/thermal_zone0/temp`
engrados=`expr $mgrados / 1000`

if [ $engrados -le 40 ]; then
  echo -e "\033[1;34mCPU Temperature:\033[32m $engrados";
elif [ $engrados -gt 40 ] && [ $engrados -lt 55 ]; then
  echo -e "\033[1;34mCPU Temperature:\033[33m $engrados" ;
else
  echo -e "\033[1;34mCPU Temperature:\033[31m $engrados";
fi
