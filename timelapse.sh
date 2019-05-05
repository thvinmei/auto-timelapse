#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Parameter Error"
    exit 1
fi

TargetDir=$1
FPS=$2

## rename files in target folder
cd ../$TargetDir
mkdir ../tempdir

i=0
for n in *.JPG
do
    ##-------------------------------
    ## jpgファイルをリネームして保存
    ##-------------------------------
    mv $n $(printf %05d $i).jpg
#    mv $n.xmp $(printf %05d $i).jpg.xmp

    j=$i
    i=$(expr $i + 1)

    ##-------------------------------
    ## 比較明合成
    ##-------------------------------
    if [ $j -eq 0 ] ; then
        echo "init temp"
        cp $(printf %05d $j).jpg ../tempdir/$(printf %05d $j).jpg
    fi

    echo "composite:" "img"$j "+" "temp"$j "=" "temp"$i
    composite -compose lighten $(printf %05d $j).jpg ../tempdir/$(printf %05d $j).jpg ../tempdir/$(printf %05d $i).jpg
done

avconv -r $FPS -i "%05d.jpg" -r $FPS -vcodec libx264 -crf 0 -g $FPS ../export/tl-${TargetDir}.mp4