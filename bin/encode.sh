#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

DRYRUN=""
RATIO="0.9"
ENC="nv"
SCALE=""
MPV_ARGS=""
COMMAND="$0 $@"
NORMAL=""
NORMAL_WRITE=""

HELP="$0 - video encoder

-n      Dry run
-m      Extra args to mpv, if mpv encoder is selected
-e      Encoding type, [hand,x264,nv,vaapi] nv is default
-r      Output bitrate ratio. Default 0.9
-7      Scale to 720p
-h      Help
-N      Only normalize audio
-W      Normalize audio and overwrite input file
"


while getopts "he:r:nm:7NW" option; do
    case "${option}"
        in
        h)  echo "$HELP"
            exit 1
        ;;
        n)  DRYRUN="echo"
        ;;
        m)  MPV_ARGS="$OPTARG"
        ;;
        e)  ENC="$OPTARG"
        ;;
        r)  RATIO="$OPTARG"
        ;;
        7)  SCALE="-vf-add=scale:w=1280:h=720"
        ;;
        N)  NORMAL=1
        ;;
        W)  NORMAL=1
            NORMAL_WRITE=1
        ;;
    esac
done

shift $((OPTIND-1))

RATIO=$(echo "$RATIO * 1000" | bc)

docker_run () {
    $DRYRUN docker run -t --rm \
        --user 1000:1000 \
        --network none \
        --name ffmpeg-$$ \
        --device /dev/dri:/dev/dri \
        -v "$(pwd)":/mnt \
        -v /tmp:/tmp \
        jrottenberg/ffmpeg:vaapi -hide_banner -y $@
}

set -x

for FILE in $@ ; do
    if [ -f "$FILE" ]; then
        BITRATE=$(ffprobe -hide_banner "$FILE" 2>&1 | grep Video: | grep -oP '\d+ kb\/s' | awk '{ print $1 }')
        ABITRATE=$(ffprobe -hide_banner "$FILE" 2>&1 | grep Audio: | grep -oP '\d+ kb\/s' | awk '{ print $1 }')
        NEWRATE=$(echo "$BITRATE*$RATIO" | bc)
        ANEWRATE=$(echo "$ABITRATE*900" | bc)
        SHORT=$(echo "$NEWRATE / 1000" | bc )
        SHORT="${SHORT%.*}k"
        FILE_OUT="${FILE%.*}-$ENC-$SHORT.mkv"
        OLDSIZE=$(stat -c '%s' "$FILE")
        CMD=echo
        NORMFILTER="--af=dynaudnorm"
        NORMCOMMENT="comment=Normalized_Audio_MPVdynaudnorm,"
        if ffprobe -hide_banner "$FILE" 2>&1 | grep -sq Normalized_Audio ; then
            echo "Already Normalized Audio"
            if [ ! -z "$NORMAL" ]; then
                continue
            fi
            NORMFILTER=""
            NORMCOMMENT=""
        else
            echo "Normalizing Audio"
        fi
        ENCODER=""
        ECOUNT=00
        for LINE in $(mpv -V) ; do 
            if [ ! -z "$ENCODER" ]; then
                ENCODER=${ENCODER},
            fi
            ENCODER="${ENCODER}ENCODER$ECOUNT=\"$LINE\""
            ECOUNT=$(echo "$ECOUNT + 1" | bc)
            ECOUNT=$(printf '%02d' $ECOUNT)
        done
        VIDEO_SYNC=""
        if [ ! -z "$NORMAL" ]; then
            FILE_OUT="${FILE%.*}-norm.mkv"
            CMD='$DRYRUN docker run -t --rm
                --user 1000:1000
                --network none
                --name ffmpeg-$$
                --device /dev/dri:/dev/dri
                -w /mnt
                -v "$(pwd)":/mnt
                -v /tmp:/tmp
                jrottenberg/ffmpeg:vaapi -hide_banner -y
                    -i "$FILE"
                    -metadata audiobitrate=\"Audio:\ $ANEWRATE\ kb\/s\"
                    -metadata videobitrate=\"Video:\ $BITRATE\ kb\/s\"
                    -metadata normal=Normalized_Audio_MPVdynaudnorm
                    -metadata command=\"${COMMAND}\"
                    -metadata encoded=\"$(date)\"
                    -metadata input_size=$OLDSIZE
                    -metadata FILE=$FILE
                    -c:v copy
                    -c:a libfdk_aac
                    -af dynaudnorm
                    -profile:a aac_low
                    -vbr 4
                    $FILE_OUT'
        elif [ "$ENC" == "hand" ]; then
            CMD='$DRYRUN ionice -c 3 nice HandBrakeCLI --preset-import-file /home/justin/Fast\ 1080p30\ Justin.json \
                --preset "Fast 1080p30 Justin" \
                --optimize \
                --align-av \
                --input $FILE \
                --output $FILE_OUT'
        elif [ "$ENC" == "x264" ]; then
            CMD='$DRYRUN ionice -c 3 nice mpv $FILE -o $FILE_OUT -of mkv \
                $NORMFILTER \
                --oset-metadata=${NORMCOMMENT}command=\"${COMMAND}\",encoded=\"$(date)\",$ENCODER,$MPVCMDS,input_size=$OLDSIZE,FILE=$FILE,FILE_OUT=$FILE_OUT,ANEWRATE=$ANEWRATE,NEWRATE=$NEWRATE,NORMFILTER=$NORMFILTER \
                $VIDEO_SYNC --oac=libfdk_aac \
                --oacopts-add="b=${ANEWRATE},afterburner=1,vbr=4" \
                --ovc=libx264 \
                --ovcopts-add=preset=slow,crf=22,psy=1 $SCALE $MPV_ARGS'
        elif [ "$ENC" == "nv" ]; then
            CMD='$DRYRUN ionice -c 3 nice mpv --msg-level=all=v $FILE -o $FILE_OUT -of mkv
                --hwdec=vaapi
                --vo=h264_cuvid
                $NORMFILTER $VIDEO_SYNC --oac=libfdk_aac
                --oset-metadata=${NORMCOMMENT}command=\"${COMMAND}\",encoded=\"$(date)\",$ENCODER,$MPVCMDS,input_size=$OLDSIZE,FILE=$FILE,FILE_OUT=$FILE_OUT,ANEWRATE=$ANEWRATE,NEWRATE=$NEWRATE,NORMFILTER=$NORMFILTER
                --oacopts-add="b=${ANEWRATE},afterburner=1,vbr=4"
                --video-sync=display-resample
                --ovc=h264_nvenc
                --ovcopts-add="b=${NEWRATE},preset=fast,cq=0,profile=main,level=auto,rc=vbr_hq,maxrate=10M,minrate=2M" $SCALE $MPV_ARGS'
        elif [ "$ENC" == "vaapi" ]; then
            CMD='$DRYRUN ionice -c 3 nice mpv $FILE -o $FILE_OUT -of mkv
                --hwdec=vaapi
                --vo=h264_cuvid $NORMFILTER
                --oset-metadata=${NORMCOMMENT}command=\"${COMMAND}\",encoded=\"$(date)\",$ENCODER,$MPVCMDS,input_size=$OLDSIZE,FILE=$FILE,FILE_OUT=$FILE_OUT,ANEWRATE=$ANEWRATE,NEWRATE=$NEWRATE,NORMFILTER=$NORMFILTER
                $VIDEO_SYNC --oac=libfdk_aac
                --oacopts-add="b=${ANEWRATE},afterburner=1,vbr=4"
                --video-sync=display-resample
                --ovc=h264_vaapi
                --ovcopts-add=quality=23,qp=23,global_quality=23 $SCALE $MPV_ARGS'
        fi
        MPVCMDS=""
        MCOUNT=00
        for LINE in $CMD ; do 
            if [ ! -z "$MPVCMDS" ]; then
                MPVCMDS="${MPVCMDS},"
            fi
            LINE=$(echo "$LINE" | tr -d '\\')
            MPVCMDS="${MPVCMDS}MPVCMD$MCOUNT=\"$(echo $(echo $LINE | tr -d "\'" | tr -d "\""))\""
            MCOUNT=$(echo "$MCOUNT + 1" | bc)
            MCOUNT=$(printf '%0*d\n' 2 $MCOUNT)
        done
        #if (eval $CMD || VIDEO_SYNC="--video-sync=display-resample" eval $CMD ) ; then
        if eval $CMD  ; then
            if [ -f "$FILE_OUT" ]; then
                NEWSIZE=$(stat -c '%s' "$FILE_OUT")
                TIME=$(stat --printf '%Y' "$FILE")
                if [ ! -z "$NORMAL_WRITE" ]; then
                    RATIO=$(echo "($NEWSIZE-$OLDSIZE)/$NEWSIZE" | bc -l)
                    if [ $(echo "$RATIO"' < 0.9' | bc -l ) -eq 1 ]; then
                        echo OUTPUT FILE TOO SMALL
                    else
                        if [ $(echo "$RATIO"' > 1.1' | bc -l) -eq 1 ]; then
                            echo OUTPUT FILE TOO BIG
                        else
                            $DRYRUN echo rm -v "$FILE"
                            $DRYRUN echo mv -v "$FILE_OUT" "${FILE%.*}.mkv"
                            $DRYRUN echo touch --date=@$TIME "${FILE%.*}.mkv"
                        fi
                    fi
                fi
            fi
        fi
    fi
done
