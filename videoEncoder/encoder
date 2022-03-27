#!/bin/bash
count=0
for FILE in *.MOV
do
 let count++
 #asd="yes"
 newname="$count$FILE"
 #mv "$FILE" "$newname" 
 ffmpeg -i "$FILE" -c:v libx264 -preset slow -profile:v high -crf 18 -coder 1 -pix_fmt yuv420p -movflags +faststart -g 30 -bf 2 -c:a aac -b:a 384k -profile:a aac_low "$newname"
done

