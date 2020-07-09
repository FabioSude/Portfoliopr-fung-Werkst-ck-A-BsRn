#!/bin/bash 
# shebang gibt an, welche shell das Skript bearbeiten soll

function func_SETenv() {   
	anzahlCOUNT=1
	anzCOUNT=1
	runCOUNT=1
	debug="yes" 
	waitingTIME=0 
	runtimeFINAL=[] 
	runTIME=0
	numberPROCESS=0
	waitingtimeFAINAL=[]
	numberPROCESS2=0
	averageWAIT=0
	
}

func_SETenv
clear
echo -e "Hier wird das First In First Out Verfahren simuliert\n\n"
# "anzR" -> Anzahl der Prozesse definieren
read -p "Bitte geben Sie eine Ganzzahl für die Anzahl der Prozesse ein, die in der CPU abgearbeitet werden sollen: " anzR 
echo -e "\nBitte Geben Sie die Laufzeit der Prozesse in ms an (Bitte nur Ganzzahlen):\n"   

# Werte in das Array Laufzeit einlesen
# "rtime" sind die Laufzeiten die in dem Array gespeichert werden
while [ ${#rtime[@]} -lt ${anzR} ]   
do
	read -p "Prozess ${anzahlCOUNT}: " rtime[${anzahlCOUNT}]
	
	# Vergleicht Variable mit sich selbst, um zu schasuen ob sie ein Integer ist, ansonsten wird Eingabeaufforderung wiederholt
	# Fehlermeldung wird nicht auf dem Display angezeigt, ein auszugebender Datenstrom wird verworfen -> "&>/dev/null"
	if test "${rtime[${anzahlCOUNT}]}" -eq "${rtime[${anzahlCOUNT}]}" &>/dev/null
	then
		anzahlCOUNT=$(( ${anzahlCOUNT} + 1 ))
	else	
		# "builtin unset rtime[${anzahlCOUNT}]" -> Fehlerhafte Eingabe wird aus dem Array gelöscht
		builtin unset rtime[${anzahlCOUNT}]
	fi
done
# Variable anzahlCOUNT wird gelöscht, da nicht mehr benötigt
builtin unset anzahlCOUNT
# Ausgabe der Prozesse, die im Hintergrund des Programmes ausgeführt/ausgegeben werden, wenn debug = "yes" 
if [ "${debug}" = "yes" ]  
then
	echo -e "\n"
fi

for index in ${!rtime[@]}
do
	if [ "${debug}" = "yes" ]
	then
		echo "DEBUG: Laufzeit fuer Prozess ${index}: ${rtime[${index}]} ms"
		# sleep bedeutet, dass die Ausgabe verzögert auf dem Terminal erscheint
		sleep 0.2
	fi
	# Die Werte werden an das Array "openRuns" übergeben
	openRUNS[${index}]=${rtime[${index}]}
done

echo -e "\nBitte Geben Sie die Ankunftszeiten der Prozesse in ms an (Bitte nur Ganzzahlen):\n"   

while [ ${#atime[@]} -lt ${anzR} ]   
do
	read -p "Prozess ${anzCOUNT}: " atime[${anzCOUNT}]
	
	# Vergleicht Variable mit sich selbst, um zu schasuen ob sie ein Integer ist, ansonsten wird Eingabeaufforderung wiederholt
	# Fehlermeldung wird nicht auf dem Display angezeigt, ein auszugebender Datenstrom wird verworfen -> "&>/dev/null"
	if test "${atime[${anzCOUNT}]}" -eq "${atime[${anzCOUNT}]}" &>/dev/null
	then
		anzCOUNT=$(( ${anzCOUNT} + 1 ))
	else
		builtin unset atime[${anzCOUNT}]
	fi
done
# Die Variablen "anzR" und "anzahlCOUNT" werden gelöscht, da nicht mehr benötigt
builtin unset anzR anzCOUNT
# Ausgabe der Prozesse, die im Hintergrund des Programmes ausgeführt/ausgegeben werden, wenn debug = "yes" 
if [ "${debug}" = "yes" ]  
then
	echo -e "\n"
fi

for index in ${!atime[@]}
do
	if [ "${debug}" = "yes" ]
	then
		echo "DEBUG: Ankunftszeit fuer Prozess ${index}: ${atime[${index}]} ms"
		sleep 0.2
	fi
	# Die Werte werden an das Array openRuns übergeben
	openRUNS[${index}]=${atime[${index}]}
done
echo 
while [ ${numberPROCESS} -ne ${#rtime[@]} ]
do	
	# Es wird jeder Index im Array durchlaufen
	for index in ${!openRUNS[@]} 
	do 	
		# Laufzeiten berechnen
		# In "runTIME" wird die Laufzeit aus "${rtime[${index}]}" gespeichert
		runTIME=$(( ${runTIME} + ${rtime[${index}]} ))
		# Es wird ein Array "runtimeFINAL" ertsellt, dort wird die Laufzeit des Prozesses berechnet
		runtimeFINAL[${index}]=$(( ${runTIME} - ${atime[${index}]} ))
		# In averageRUN werden die Laufzeiten aufaddiert, um später den Durchschnitt zu berechnen
		averageRUN=$(( ${averageRUN} + ${runtimeFINAL[${index}]} ))
			
		# Wartezeit berechnen
		# Laufzeit des Prozesses wird minus die CPU-Laufzeit gerechnet -> Wartezeit
		waitingTIME=$(( ${runtimeFINAL[${index}]} - ${rtime[${index}]} )) 
		# Es wird ein Array "waitingtimeFINAL" erstellt, dort werden die Wartezeiten der Prozesse berechnet 	
		waitingtimeFINAL[${index}]=$(( ${waitingtimeFINAL[${index}]} + ${waitingTIME} ))
		# In "averageWAIT" werden die Wartezeiten aufaddiert, um später den Durchschnitt zu berechnen
		averageWAIT=$(( ${waitingtimeFINAL[${index}]} + ${averageWAIT} ))
		
		if [ "${debug}" = "yes" ]
		then
			echo -e "DEBUG: Laufzeit  fuer Prozess ${index}: ${runtimeFINAL[${index}]} ms"
			sleep 0.2
			echo -e "DEBUG: Wartezeit fuer Prozess ${index}: ${waitingtimeFINAL[${index}]} ms\n"
			sleep 0.2
		fi
		
		# counter, identisch zu let numberPROCESS=numberPROCESS + 1
		numberPROCESS=$(( ${numberPROCESS} + 1 )) 
	done	
	
done
builtin unset runTIME numberPROCESS
# Tabellarische Ausgabe der Auswertung, "printf" sorgt für eine formatierte Ausgabe
echo -e "\n\nNun folgt eine tabellarische Auswertung der verabeiteten Prozesse, die zuvor eingegeben wurden:"
sleep 0.4
printf "\n\n%-7s\t%-17s\t%-17s\t%-19s\t%-14s\n" "Prozess" "CPU-Laufzeit (ms)" "Ankunftszeit (ms)" "Gesamtlaufzeit (ms)" "Wartezeit (ms)"

for index in ${!rtime[@]}
do
		printf "%7d\t%17d\t%17d\t%19d\t%14d\n" "${index}" "${rtime[${index}]}" "${atime[${index}]}" "${runtimeFINAL[${index}]}" "${waitingtimeFINAL[${index}]}"
done

# Berechnung der durchschnittlichen Laufzeit aller Prozesse
averageRUNTIME=$(( ${averageRUN} / ${#rtime[@]} ))
# Berechnung der durchschnittlichen Wartezeit aller Prozesse
averageWAITINGTIME=$(( ${averageWAIT} / ${#rtime[@]} ))
# Ausgabe der durchschnittlichen Laufzeit aller Prozesse
sleep 0.4
echo -e "\n\n\nDurchschnittliche Laufzeit der ${#rtime[@]} Prozesse: ${averageRUNTIME} ms\n"
# Ausgabe der durchschnittlichen Wartezeit aller Prozesse
sleep 0.4
echo -e "\nDurchschnittliche Wartezeit der ${#rtime[@]} Prozesse: ${averageWAITINGTIME} ms\n\n"
# "set +x" -> Debugger und Fehlersuche
set +x
# "exit 0" -> Code wurde erfolgreich ausgeführt
exit 0
#EOF		

		
		



































