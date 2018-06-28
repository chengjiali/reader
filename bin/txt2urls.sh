#!/usr/bin/env bash

# txt2urls.sh - given a file name, output a list of urls

# usage: find carrels/word2vec/txt -name '*.txt' -exec ./bin/txt2ent.sh {} \;

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame and distributed under a GNU Public License

# June 26, 2018 - first cut

# configure
HOME='/Users/emorgan/Desktop/reader'
URLS='urls'

# sanity check
if [[ -z "$1" ]]; then
	echo "Usage: $0 <file>" >&2
	exit
fi

# get input
FILE=$1

# make sane
cd $HOME

# compute I/O names
ORIGINAL=$( dirname "${FILE}" )
LEAF=$( basename "$FILE" .txt )
mkdir -p "$ORIGINAL/../$URLS"
OUTPUT="$ORIGINAL/../$URLS/$LEAF.url"

# get the data
RECORDS=$(cat $FILE | egrep -o 'https?://[^ ]+' | sed -e 's/https/http/g' |  sed -e 's/\W+$//g' )

SIZE=${#RECORDS} 
if [[ $SIZE > 0 ]]; then

	# proces each item in the data
	printf "id\tdomain\turl\n" >  $OUTPUT
	while read -r RECORD; do
		DOMAIN=$(echo $RECORD | sed -e 's/http:\/\///g' | sed -e 's/\/.*$//g')
		echo -e "$LEAF\t$DOMAIN\t$RECORD" >> $OUTPUT
	done <<< "$RECORDS"

fi

