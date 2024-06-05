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

	elif [[ $selection == "3" ]]
	then
		echo "Especifique una ruta (/home, por ejemplo):"
		read path

		echo ""
		echo "Archivo más grande:"
		echo "Tamaño (bytes) | Ruta del archivo más grande"
		find $path -type f -exec du -ab {} + | sort -n -r | head -n 1

	elif [[ $selection == "4" ]]
	then
		echo "Memoria libre y espacio swap en uso:"
		free -b | awk '
			NR==2{free_mem=$4; total_mem=$2}
			NR==3{swap_used=$3; total_swap=$2}
			END {free_mem_per=(free_mem/total_mem)*100; swap_used_per=(swap_used/total_swap)*100; printf "Memoria libre: %d bytes (%.2f%%)\nEspacio de swap: %d (%.2f%%)\n", free_mem, free_mem_per, swap_used, swap_used_per}
		'
	fi

	echo ""

done
