#!/bin/bash

Already_applied=`grep "Pretty font applied" "$1.pcb"|wc -l`

if [ "${Already_applied}" -gt 0 ]; then
  echo "Nothing to do. Pretty font already applied"
  exit 0
fi
Lines=`cat -n $1.pcb | sed -n '/Styles/p' | head -1|cut -f1 -d'	'`
Clean_lines=`echo $Lines`

head -n ${Lines}  $1.pcb > test.pcb
echo "" >> test.pcb
cat ../meatstand_common/schematics/pcb_font >> test.pcb
echo "" >> test.pcb
tail --lines=+"`expr ${Clean_lines} + 1`" $1.pcb >> test.pcb
mv test.pcb $1.pcb
