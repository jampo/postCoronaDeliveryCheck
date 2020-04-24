#!/bin/bash

country=$1

wget --quiet https://www.post.at/p/c/liefereinschraenkungen-coronavirus;
cat liefereinschraenkungen-coronavirus | sed -n  's/.*\(https\:.*\.csv\).*/\1/p' > stopCSVs;
cat stopCSVs | while read line
do
	fileName=$(echo $line | sed -n 's/.*\/\(.*\.csv\)/\1/p')
	wget --quiet -O "$fileName" $line
	grep -F "$country" "$fileName"
done
rm liefereinschraenkungen-coronavirus
