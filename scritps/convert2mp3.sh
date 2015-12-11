#!/bin/bash
################################################################################################################
# Version: 1.0
################################################################################################################
# Pablo Magro / Auckland / 28/11/2015.
#
# Script to convert .m4a to .mp3
#
################################################################################################################
# Dependencies:
# sudo apt-get install ffmpeg libavcodec-extra-53
################################################################################################################
# man xargs
#
# -0
# Input items are terminated by a null character instead of by whitespace, and the quotes and backslash are not special 
# (every character is taken literally). Disables the end of file string, which is treated like any other argument. Useful 
# when input items might contain white space, quote marks, or backslashes. 
# The GNU find -print0 option produces input suitable for this mode.
#
# -I replace-str
# Replace occurrences of replace-str in the initial-arguments with names read from standard input. Also, unquoted blanks 
# do not terminate input items; instead the separator is the newline character. Implies -x and -L 1.
################################################################################################################
# man ffmpeg
# 
# -ab
#
# CBR Encoding
# Constant bitrate (CBR) MP3 audio,
# 
# Available options are: 
# 8, 16, 24, 32, 40, 48, 64, 80, 96, 112, 128, 160, 192, 224, 256, or 320 (add a k after each to get that rate)
################################################################################################################

EXTENSION=
CONVERTION_PATH="." # By default
SEARCH_PATH="."     # By default
NUM_ARGUMENTS=$#
AB=256
REMOVE=false
pkg=ffmpeg


# READ command line parameters.

self="$0"

##DOC0
## any comment line ##between DOC0 and ##DOC1 that starts '# ' 
## will be printed in the help.

if [ $NUM_ARGUMENTS -gt 0 ]; then	
	arr=($@);

	for i in ${arr[@]}; do
		if [[ "$i" =~ "-ext" ]]; then
			IFS='=' read -a argumentArray <<< "$i"
			EXTENSION=${argumentArray[1]}

		## Search directory
		elif [[ "$i" =~ "-search-folder" ]]; then
			IFS='=' read -a argumentArray <<< "$i"
			if [[ -n ${argumentArray[1]} ]]; then
				SEARCH_PATH=${argumentArray[1]}
				SEARCH_PATH="${SEARCH_PATH/\~/$HOME}"
			fi
		## Convertion directory
		elif [[ "$i" =~ "-convertion-folder" ]]; then
			IFS='=' read -a argumentArray <<< "$i"
			if [[ -n ${argumentArray[1]} ]]; then
				CONVERTION_PATH=${argumentArray[1]}
				CONVERTION_PATH="${CONVERTION_PATH/\~/$HOME}"
			fi
		## Bit rate
		elif [[ "$i" =~ "-ab" ]]; then
			IFS='=' read -a argumentArray <<< "$i"
			if [[ -n ${argumentArray[1]} ]]; then
				AB=${argumentArray[1]}
			fi
		## Remove the original files
		elif [[ "$i" =~ "-rm" ]]; then
			IFS='=' read -a argumentArray <<< "$i"
			if [[ -n ${argumentArray[1]} ]]; then
				rm=${argumentArray[1]}

				if [[ "$rm" == "y" || "$rm" == "yes" ]]; then
					REMOVE=true
				fi
			fi
		elif [[ "$i" == "--help" || "$i" == "-h" ]]; then 
			# 
			#   Usage: m4a2mp3.sh <-search-folder=> <-convertion-folder=> <-ab=320> <-rm=y/n> <-ext=m4a/ogg>
			# 
			# Example: m4a2mp3.sh -search-folder=~/Downloads/ -convertion-folder=~/mp3-converted/ -ab=320 -rm=y -ext=m4a
			sed '/^##DOC0$/,/^##DOC1$/ { s/^[ 	]*//; /)$/ d; /) \#/ { s/) \#/ / ; s/^/ / ; p ; d } ; /^# / { s/^# / / ; s/ \.// ; p;} } ; d' < "$self"
			exit
		fi
	done
fi
# .
##DOC1

# Check if the ffmpeg program is installed.

dpkg -s "$pkg" >/dev/null 2>&1 && {
	echo "[*] $pkg is installed."    
} || {
    echo "$pkg is not installed, do you wish to install it?"
	select yn in "Yes" "No"; do
	    case $yn in
	        Yes) sudo -s apt-get install -y $pkg; break;;
	        No ) exit 0;;
	    esac
	done    
}

# Check if $1 is a folder. 
# Return 0 true and 1 otherwise.
checkFolder () {
	if [ ! -e "$1" ]; then
		echo "Directory $1 doesn't exist !!!";
		return 1;
	fi

	return 0;
}

# First of all, check if the extension to convert to mp3 is valid.

if [ "$EXTENSION" != "ogg" -a "$EXTENSION" != "m4a" ]; then
	echo "Wrong file extension, please expecify an availabe extension: m4a or ogg."
	exit 1
fi

# Set the command to execute.

COMMAND=""
if [ "$EXTENSION" == "m4a" ]; then
	COMMAND='ffmpeg -i "$file" -ab "$AB"k "${file%$EXTENSION}mp3"'
elif [ "$EXTENSION" == "ogg" ]; then
	#COMMAND='ffmpeg -i "$file" -ab "$AB"k -map_metadata 0:s:0 -id3v2_version 3 -write_id3v1 1 -acodec libvorbis -aq 6 "${file%$EXTENSION}mp3"'
	COMMAND='ffmpeg -i "$file" -ab "$AB"k -map_metadata 0:s:0 -id3v2_version 3 -write_id3v1 1 -acodec libmp3lame "${file%$EXTENSION}mp3"'
fi

# Create the convertion folder if it doesn't exist.

if [ ! -e "$CONVERTION_PATH" ]; then
	echo "Creating folder $CONVERTION_PATH...";
	mkdir -p $CONVERTION_PATH;
fi

# Move and convert counters.
NUM_ELEMS_MOVED=$(find $SEARCH_PATH -type f -name "*.$EXTENSION" -print0 | xargs -0 -I "file" mv -v "file" $CONVERTION_PATH | wc -l)
NUM_ELEMS_CONVERT=$(find $CONVERTION_PATH -type f -name "*.$EXTENSION" 2> /dev/null | wc -l)

echo "[*] Search path: $SEARCH_PATH";
echo "[*] Convertion path: $CONVERTION_PATH"
echo "[*] Files moved: $NUM_ELEMS_MOVED"
echo "[*] Files to convert: $NUM_ELEMS_CONVERT"

if [ $NUM_ELEMS_CONVERT -eq 0 ]; then
	echo "Nothing to do, no matches found."
else	
	cd $CONVERTION_PATH

	echo -e "[*] Converting files..."
	
	for file in *.$EXTENSION
	do		
		eval $COMMAND

		[ $REMOVE == true ] && rm -v "$file";
		trap - INT TERM EXIT
	done
fi

exit 0