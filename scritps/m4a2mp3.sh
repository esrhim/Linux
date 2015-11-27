#!/bin/bash
#
# # Auckland / 28/11/2015
#
# Pablo Magro
#
# ######################################################
#
# Script to convert .m4a to .mp3
#
# Use: ./m4a2mp3.sh <source-folder> <target-folder> <-ab=320> <-rm=y/n>
#
#      ./scritps/m4a2mp3.sh ~/Downloads/jd/ ~/mp3-converted/ -ab=320 -rm=y
#
# Debug: add "-x" after bash in the 1st program line (without quotes).
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
WORK_PATH="."
NUM_ARGUMENTS=$#
AB=256
REMOVE=false

pkg=ffmpeg

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

# READ customized parameters.

if [ $NUM_ARGUMENTS -gt 1 ]; then
	arr=($@);

	for i in ${arr[@]}; do
		# Bit rate
		if [[ "$i" =~ "-ab" ]]; then			
			IFS='=' read -a argumentArray <<< "$i"
			if [[ -n ${argumentArray[1]} ]]; then
				AB=${argumentArray[1]}
			fi
		# Remove original m4a files.
		elif [[ "$i" =~ "-rm" ]]; then
			IFS='=' read -a argumentArray <<< "$i"
			if [[ -n ${argumentArray[1]} ]]; then
				rm=${argumentArray[1]}

				if [[ "$rm" == "y" || "$rm" == "yes" ]]; then
					REMOVE=true
				fi
			fi
		fi
	done
fi

# Check if $1 is a folder. 
# Return 0 true and 1 otherwise.
checkFolder () {
	if [ ! -e "$1" ]; then
		echo "Directory $1 doesn't exist !!!";
		return 1;
	fi

	return 0;
}

# 1st move files from $1 to $2.

if [ $NUM_ARGUMENTS -gt 2 ]; then
	checkFolder $1
	[ "$?" -eq 1 ] && exit 1;

	if [ ! -e "$2" ]; then
		echo "Creating folder $2";
		mkdir -p $2;
	fi

	WORK_PATH=$2;

	# Move files.
	find "$1" -type f -name "*.$M4A" -print0 | xargs -0 -I "file" mv -v "file" "$2";

elif [ $NUM_ARGUMENTS -eq 1 ]; then
	checkFolder $1

	[ "$?" -eq 1 ] && exit 1;

	WORK_PATH=$1;
fi

NUM_FIND_ELEMS=$(find $WORK_PATH -name *.m4a | wc -l);

echo "[*] Working path: $WORK_PATH"
echo "[*] Elements to convert: $NUM_FIND_ELEMS"

if [ $NUM_FIND_ELEMS -eq 0 ]; then
	echo "Nothing to do, no matches found."
else	
	cd $WORK_PATH

	echo -e "[*] Converting files..."
	
	for file in *.m4a
	do
		ffmpeg -i "$file" -ab "$AB"k "${file%m4a}mp3";

		[ $REMOVE ] && rm "$file";
	done
fi

exit 0