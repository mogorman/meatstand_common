#!/bin/bash

echo "NetList()" >> netlist.pcb
echo "(" >> netlist.pcb
while read Line; do
	Count="0"
	for i in $(echo   $Line | tr " " "\n")
	do
		if [ ${i:0:1} == " " ]; then
			Count=1
		fi
		if [ "$Count" == "0" ]; then
			echo "	Net(\"$i\" \"(unknown)\")" >> netlist.pcb
			echo "	(" >> netlist.pcb
			Count=1
			continue
		fi
		echo "		Connect(\"$i\")" >> netlist.pcb
	done
	echo "	)" >> netlist.pcb
done < $1.net
echo ")" >> netlist.pcb

To_netlist=`grep -n "NetList()" $1.pcb |head -n1| sed 's/^\([0-9]\+\):.*$/\1/'`
re='^[0-9]+$'
if ! [[ $To_netlist =~ $re ]] ; then
   echo "No netlist"
   cat $1.pcb netlist.pcb > new.pcb
else
   echo "Netlist exists"
   echo "$To_netlist"
   tail -n +$To_netlist $1.pcb > tail.pcb
   let "To_netlist--"
   echo "$To_netlist"
   head -n $To_netlist $1.pcb > head.pcb
   while [ 1 ]; do
       Clear_netlist=`grep -n "^)" tail.pcb|head -n1 | sed 's/^\([0-9]\+\):.*$/\1/'`
       Head_netlist=`grep -n "NetList()" tail.pcb|head -n1 | sed 's/^\([0-9]\+\):.*$/\1/'`
       echo head $Head_netlist and tail $Clear_netlist
       if ! [[ $Head_netlist =~ $re ]] ; then
	   echo "No more netlist"
	   break;
       else
	   echo "more netlists?"
       fi
       let "Head_netlist--"
       let "Clear_netlist++"
       head -n $Head_netlist tail.pcb > new_tail.pcb
       tail -n +$Clear_netlist tail.pcb >> new_tail.pcb
       mv new_tail.pcb tail.pcb
   done
   cat head.pcb tail.pcb netlist.pcb  > new.pcb
fi
mv new.pcb $1.pcb
#rm -f tail.pcb head.pcb netlist.pcb
