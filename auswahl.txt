#!/bin/bash
function func_SETenv() { 
i=0
eingabe=0
}
func_SETenv
clear

echo -e "Bitte geben Sie, durch eine Eingabe, an welches der zwei Scheduling-Verfahren Sie simulieren moechten\n"

# Hier kann der Benutzer Entscheiden, welches Verfahren er Simulieren möchte
while [ ${i} -le ${eingabe} ]   
do	
	read -p "Tippen Sie für FIFO, die Ziffer (1) über die Tastatur oder für Round Robin, die Ziffer (2) über die Tastatur ein: " eingabe

	
	if  [ ${eingabe} -eq 1 ]
	then
		fifo
		i=$(( ${i} + 1 ))
	
	else
		if [ ${eingabe} -eq 2 ]
		then
			roundRobin
			i=$(( ${i} + 2 ))
		
		else 
			if [ "${eingabe}" -eq $"{eingabe}" ] &>/dev/null
			then
				builtin unset ${eingabe} 
		
		
			fi
		fi	
	fi
done
exit 0
#EOF
