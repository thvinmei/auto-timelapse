#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Parameter Error"
    exit 1
fi

TargetDir=$1
FPS=$2
i=0

## rename files in target folder
cd ../$TargetDir
mkdir -p ../tempdir
mkdir -p ../export

rename 's/JPG/jpg/' *.JPG
rename 's/JPG/jpg/' *.JPG.xmp

for n in *.jpg
do
    ##-------------------------------
    ## jpgファイルをリネームして保存
    ##-------------------------------
    mv $n $(printf %05d $i).jpg
    # darktableの編集ファイルもリネーム
    mv $n.xmp $(printf %05d $i).jpg.xmp

    j=$i
    i=$(expr $i + 1)

    ##-------------------------------
    ## 比較明合成
    ##-------------------------------
    if [ $j -eq 0 ] ; then
        cp $(printf %05d $j).jpg ../tempdir/$(printf %05d $j).jpg
    fi

    composite -compose lighten $(printf %05d $j).jpg ../tempdir/$(printf %05d $j).jpg ../tempdir/$(printf %05d $i).jpg
done

##-------------------------------
## 出力動画・画像の生成
##-------------------------------
yes|ffmpeg -r $FPS -i "%05d.jpg" -r $FPS -vcodec libx264 -crf 0 -g $FPS ../export/${TargetDir}.mp4
yes|ffmpeg -r $FPS -i "../tempdir/%05d.jpg" -r $FPS -vcodec libx264 -crf 0 -g $FPS ../export/${TargetDir}-composited.mp4
cp ../tempdir/$(printf %05d $i).jpg ../export/${TargetDir}-composited.jpg

# お片付け
rm -rf ../tempdir