#!/bin/bash
Title=$1
Version=$2
Author=${*:3}
cp `dirname $0`/attribs ./
gnetlist -g bom -o bom_temp pig.sch
awk -F"\t" '{print $5"\t"$1"\t"$2"\t"$3"\t"$4}' bom_temp|grep -v ^0 | \
awk -F"\t" '{print $5"\t"$3"\t"$4}' |grep -v ^unknown| grep -v ^manufacturer-part | \
sort | uniq -c| sort -nr |sed 's/^ *//'| \
awk -F"\t" '{print $1"\t"$2"\t"$3}'|sed -e 's/ /\t/' > bom_temp2

awk -F"\t" '{print $5"\t"$1"\t"$2"\t"$3"\t"$4}' bom_temp|grep -v ^0 | \
awk -F"\t" '{print $5"\t"$3"\t"$4"\t"$2}' |grep ^unknown| \
awk -F"\t" '{print $4"\t"$2"\t"$1}' > bom_incomplete

Bom_incomplete=`wc -l bom_incomplete|cut -f1 -d' '`

echo "#Date: "` date -u +"%a %d %b %Y %I:%M:%S %p GMT %Z"` > bom
echo "#Author: ${Author}" >> bom
echo "#Title: ${Title} ${Version} " >> bom
if [ "${Bom_incomplete}" -gt "0" ]; then
    echo "#Status: Incomplete" >> bom
else
    echo "#Status: Complete" >> bom
fi
echo "" >> bom

echo "Qty	REFDES	manufacturer-part	value	footprint" > bom_temp3
while read p; do
    Part=`echo "$p" | awk -F"\t" '{print $2}'`
    Count=`echo "$p" | awk -F"\t" '{print $1}'`
    echo -n "$Count	" >> bom_temp3
    grep "$Part" bom_temp | awk -F"\t" '{printf $1","}'| sed -e 's/,$//' >> bom_temp3
    echo -n "	" >> bom_temp3
    echo "$p" | awk -F"\t" '{print $2"\t"$3"\t"$4}' >> bom_temp3
done < bom_temp2

column -t -s'	' bom_temp3 >> bom

if [ "${Bom_incomplete}" -gt "0" ]; then
    echo "" >> bom
    echo "" >> bom
    echo "" >> bom
    echo "#BOM INCOMPLETE" >> bom
    echo "refdes	value	manufacturer-part" >> bom
    cat bom_incomplete >> bom
fi

echo "" >> bom
rm bom_incomplete bom_temp bom_temp2 bom_temp3 attribs
