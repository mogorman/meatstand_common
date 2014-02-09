#!/bin/bash
cat $1.pcb > new.pcb
echo "NetList()" >> new.pcb
echo "(" >> new.pcb
while read Line; do
	Count="0"
	for i in $(echo   $Line | tr " " "\n")
	do
		if [ ${i:0:1} == " " ]; then
			Count=1
		fi
		if [ "$Count" == "0" ]; then
			echo "	Net(\"$i\" \"(unknown)\")" >> new.pcb
			echo "	(" >> new.pcb
			Count=1
			continue
		fi
		echo "		Connect(\"$i\")" >> new.pcb
	done
	echo "	)" >> new.pcb
done < $1.net
echo ")" >> new.pcb
mv new.pcb $1.pcb
