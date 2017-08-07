#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Parameter Error"
    exit 1
fi

TargetDir=$1
FPS=$2

## rename files in target folder
cd $TargetDir
i=0
for n in *.JPG
do
    mv $n $(printf %05d $i).jpg
    i=$(expr $i + 1)
done

avconv -r $FPS -i "%05d.jpg" -r $FPS -vcodec libx264 -crf 0 -g $FPS ../animation_${TargetDir}.mp4