#!/bin/bash
#
# ######################################################
#
# Script to convert .m4a to .mp3
# name of this script: m4a2mp3.sh # m4a to mp3
#
# Dependencies:
# sudo apt-get install ffmpeg libavcodec-extra-53
#
# #######################################################
#
# man xargs
#
# -0
# Input items are terminated by a null character instead of by whitespace, and the quotes and backslash are not special 
#(every character is taken literally). Disables the end of file string, which is treated like any other argument. Useful 
# when input items might contain white space, quote marks, or backslashes. 
# The GNU find -print0 option produces input suitable for this mode.
#
# -I replace-str
# Replace occurrences of replace-str in the initial-arguments with names read from standard input. Also, unquoted blanks 
# do not terminate input items; instead the separator is the newline character. Implies -x and -L 1.
#
# #######################################################
#
# man ffmpeg
# 
# -ab
#
# CBR Encoding
# Constant bitrate (CBR) MP3 audio,
# 
# Available options are: 
# 8, 16, 24, 32, 40, 48, 64, 80, 96, 112, 128, 160, 192, 224, 256, or 320 (add a k after each to get that rate)
#
# #######################################################

M4A=m4a
NUMVAR=$#
AB=256

# Search for the ab parameter.
if [ $NUMVAR -gt 1 ]; then
	# To change...
	var=$(echo $@ | awk -F" " '{print $1,$2,$3,$4}')
	set -- $var

	if [[ "$1" =~ "ab" ]]; then
		AB=$2
	elif [[ "$2" =~ "ab" ]]; then
		AB=$3
	elif [[ "$3" =~ "ab" ]]; then
		AB=$4
	fi
fi

# Check if $1 is a folder. 
# Return 0 true and 1 otherwise.
checkFolder () {
	if [ ! -e "$1" ]; then
		echo "Directory $1 doesn't exist!!!";
		return 1;
	fi

	return 0;
}

# 1st move files from $1 to $2.

if [ $NUMVAR -eq 2 ]; then
	checkFolder $1
	[ "$?" -eq 1 ] && exit 1;

	if [ ! -e "$2" ]; then
		# echo "Create folder $2";
		mkdir -p $2;
	fi

	# Move files.
	find "$1" -type f -name "*.$M4A" -print0 | xargs -0 -I "file" mv -v "file" "$2"

	# Move to the target directory to complete the convertion.
	cd $2

elif [ $NUMVAR -eq 1 ]; then
	checkFolder $1
	[ "$?" -eq 1 ] && exit 1;
	cd $1
fi

NUM_ELEMENTS=$(find . -name *.m4a | wc -l);

if [ $NUM_ELEMENTS -eq 0 ]; then
	echo "Nothing to do."
else
	echo -e "Converting files..."
	
	for file in *.m4a
	do
		ffmpeg -i "$file" -ab "$AB"k "${file%m4a}mp3" && rm "$file"
	done
fi

exit 0