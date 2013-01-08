#!/bin/bash

YEAR=$1

ALBUMS=/mnt/mp3s/Albums

count=0
found=0
ls -1 $ALBUMS | cut -d- -f1 | sort | uniq | while read artist; do
	cleanartist=`echo "$artist" | sed 's/The //g' | sed 's/, The//g'`
	echo "Searching for $cleanartist..."
	result=`/opt/scripts/search_amazon.pl -y $YEAR "$cleanartist"`

	if [ ! -z "$result" ]; then
		echo ">>> $result"
		let found=found+1
	else
		echo "No results"
	fi

	unset result

	let count=count+1
done

echo "Done searching: $count total artists, $found with results."
