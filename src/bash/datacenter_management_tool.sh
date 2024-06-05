#!/bin/bash

while [[ $selection != "0" ]]
do
	echo "======================================"
	echo "            Menú principal            "
	echo "======================================"
	echo "(Digite el número correspondiente a la opción que desea)"
	echo "1) Desplegar los cinco procesos que más CPU estén consumiendo en ese momento"
	echo "2) Desplegar los filesystems o discos conectados a la máquina"
	echo "3) Desplegar el nombre y el tamaño del archivo más grande almacenado en un disco o filesystem especificado"
	echo "4) Desplegar cantidad de memoria libre y cantidad del espacio de swap en uso"
	echo "5) Desplegar número de conexiones de red activas actualmente (en estado ESTABLISHED)"
	echo "0) Salir"
	read selection

	echo ""

	if [[ $selection == "1" ]]
	then
		echo "Top 5 procesos que más están consumiendo, en este momento, son:"
		ps aux --sort=-%cpu | head -n 6

	elif [[ $selection == "2" ]]
	then
		echo "Filesystems/Discos conectados:"
		df -B 1 -a -t ext4 -t ext3 -t xfs --output=source,size,avail
	fi

	echo ""

done
