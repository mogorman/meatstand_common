#!/bin/bash
Keep_out_minimum=$1
PCB=$2
Tmp=${PCB}.tmp
rm -f $Tmp
touch $Tmp
export IFS=
while read -r  Line
do
    Pad=`echo ${Line} | grep "Pad\["`
    Trace=`echo ${Line} | grep "Line\[" | grep -v "SymbolLine\["`
    Pin=`echo ${Line} | grep "Via\["`
    Via=`echo ${Line} | grep "Pin\["`
    if [ "${Pad}" != "" ]; then
	Keep_out_full=`echo ${Line} | awk '{print $6}'`
	Units="${Keep_out_full:${#Keep_out_full}-3:3}"
	Keep_out="${Keep_out_full:0:${#Keep_out_full}-3}"
    	Check=`echo "${Keep_out_minimum} < $Keep_out" | bc -l`
    	if [ "${Units}" = "mil" ]; then
    	    if [ "${Check}" = "0" ]; then
    		echo "$Line" | awk -v Tmp=$Tmp -v Units="${Keep_out_minimum}${Units}" '{$6 = Units; print >> Tmp}'
    	    else
		echo "$Line" >> $Tmp
	    fi
	else
	    echo "$Line" >> $Tmp # not a mil just passing it along
	fi
    elif [ "${Trace}" != "" ]; then
	Keep_out_full=`echo ${Line} | awk '{print $6}'`
	Units="${Keep_out_full:${#Keep_out_full}-3:3}"
	Keep_out="${Keep_out_full:0:${#Keep_out_full}-3}"
    	Check=`echo "${Keep_out_minimum} < $Keep_out" | bc -l`
    	if [ "${Units}" = "mil" ]; then
    	    if [ "${Check}" = "0" ]; then
    		echo "$Line" | awk -v Tmp=$Tmp -v Units="${Keep_out_minimum}${Units}" '{$6 = Units; print >> Tmp}'
    	    else
		echo "$Line" >> $Tmp
	    fi
	else
	    echo "$Line" >> $Tmp # not a mil just passing it along
	fi
    elif [ "${Pin}" != "" ]; then
	Keep_out_full=`echo ${Line} | awk '{print $4}'`
	Units="${Keep_out_full:${#Keep_out_full}-3:3}"
	Keep_out="${Keep_out_full:0:${#Keep_out_full}-3}"
    	Check=`echo "${Keep_out_minimum} < $Keep_out" | bc -l`
    	if [ "${Units}" = "mil" ]; then
    	    if [ "${Check}" = "0" ]; then
    		echo "$Line" | awk -v Tmp=$Tmp -v Units="${Keep_out_minimum}${Units}" '{$4 = Units; print >> Tmp}'
    	    else
		echo "$Line" >> $Tmp
	    fi
	else
	    echo "$Line" >> $Tmp # not a mil just passing it along
	fi
    elif [ "${Via}" != "" ]; then
	Keep_out_full=`echo ${Line} | awk '{print $4}'`
	Units="${Keep_out_full:${#Keep_out_full}-3:3}"
	Keep_out="${Keep_out_full:0:${#Keep_out_full}-3}"
    	Check=`echo "${Keep_out_minimum} < $Keep_out" | bc -l`
    	if [ "${Units}" = "mil" ]; then
    	    if [ "${Check}" = "0" ]; then
    		echo "$Line" | awk -v Tmp=$Tmp -v Units="${Keep_out_minimum}${Units}" '{$4= Units; print >> Tmp}'
    	    else
		echo "$Line" >> $Tmp
	    fi
	else
	    echo "$Line" >> $Tmp # not a mil just passing it along
	fi
    else
    	echo "$Line" >> $Tmp
    fi 
done < $PCB

