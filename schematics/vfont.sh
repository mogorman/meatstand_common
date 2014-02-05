#!/bin/bash

cd production

Lines=`cat -n $1.pcb | sed -n '/Styles/p' | head -1|cut -f1 -d'	'`
Clean_lines=`echo $Lines`

head -n ${Lines}  $1.pcb > test.pcb
echo "" >> test.pcb
cat ../../meatstand-common/pcb_font >> test.pcb
echo "" >> test.pcb
tail --lines=+"`expr ${Clean_lines} + 1`" $1.pcb >> test.pcb
mv test.pcb $1.pcb
