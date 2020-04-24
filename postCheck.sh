#!/bin/bash

if [ "$#" -ne  "1" ]
then
	echo "Wrong number of arguments only exactly 1 argument COUNTRY supported";
	exit 1;
fi

country=$1

wget --quiet https://www.post.at/p/c/liefereinschraenkungen-coronavirus;
cat liefereinschraenkungen-coronavirus | sed -n  's/.*\(https\:.*\.csv\).*/\1/p' > stopCSVs;
cat stopCSVs | while read line
do
	fileName=$(echo $line | sed -n 's/.*\/\(.*\.csv\)/\1/p');
	stopName=$(echo $line | sed -n 's/.*\/\(.*\)\.csv/\1/p');

	wget --quiet -O "$fileName" $line;
	#Change encoding to UTF8
	iconv -f ISO-8859-1 -t UTF-8 "$fileName" > "utf8_$fileName";
	grep -q "$country" "utf8_$fileName";
	if [ $? -ne 0 ]
	then
		echo "Kein $stopName für $country";
		#TODO sendmail
	else
		echo "$stopName für $country";
	fi
	rm "$fileName" "utf8_$fileName";
done
rm liefereinschraenkungen-coronavirus stopCSVs;
