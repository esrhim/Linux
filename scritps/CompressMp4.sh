#!/bin/bash
# ---------------------------------------------------------------------
# -vcodec codec (output)
#           Set the video codec. This is an alias for "-codec:v". 
#
# -acodec codec (input/output)
#           Set the audio codec. This is an alias for "-codec:a".
#
# h264
# H.264 or MPEG-4 Part 10, Advanced Video Coding (MPEG-4 AVC) is a block-oriented motion-compensation-based video compression standard that is currently one of the most commonly used formats for the recording, 
# compression, and distribution of video content.
#
# mp2
# MPEG-2 (aka H.222/H.262 as defined by the ITU) is a standard for "the generic coding of moving pictures and ISO/IEC 13818 MPEG-2 at the ISO Store. 
# It describes a combination of lossy video compression and lossy audio data compression methods, which permit storage and transmission of movies using currently available storage media and transmission bandwidth. 
# While MPEG-2 is not as efficient as newer standards such as H.264 and H.265/HEVC, backwards compatibility with existing hardware and software means it is still widely used, 
# for example in over-the-air digital television broadcasting and in the DVD-Video standard
#
# Reference: https://gist.github.com/lukehedger/277d136f68b028e22bed
# ---------------------------------------------------------------------

append=Compressed
currentDir=$(pwd)

for file in $currentDir/*.mp4
do
  # separate the file name from its extension.
  if [[ $file == *.* ]]; then
    filename=$(basename "$file")
    extension="${filename##*.}"
    filename="${filename%%.*}"    
    
    echo "$filename.$extension -> $filename-$append.$extension"

    ffmpeg -i "$file" -vcodec h264 -acodec mp2 "${filename}-${append}.$extension"
  fi
done
