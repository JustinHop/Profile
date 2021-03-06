#!/bin/zsh
set -euo pipefail
IFS=$'\n\t'

setopt braceccl

DRYRUN=""
VRATIO="0.9"
ARATIO="0.9"
ENC="nv"
SCALE=""
RESIZETO720=""
MPV_ARGS=""
COMMAND=$(echo "$0 $*" | xargs)
NORMAL=""
NORMAL_WRITE=""
SHA="$(sha256sum $0 | awk '{ print $1 }')"
MPVVERBOSE=""

HELP="$0 - video encoder
Usage: $0 [options] FILE...

-7      Scale to 720p
-a      Output audio bitrate ratio. Default 0.9
-D      Debug
-e      Encoding type, [hand,x264,nv,vaapi,copy] nv is default
-F      Fixed bitrate size not ratio
-h      Help
-m      Extra args to mpv, if mpv encoder is selected
-n      Dry run
-N      Only normalize audio
-v      Output video bitrate ratio. Default 0.9
-W      Normalize audio and overwrite input file
"


while getopts "a:v:he:nm:7NWFDR" option; do
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
        a)  ARATIO="$OPTARG"
        ;;
        v)  VRATIO="$OPTARG"
        ;;
        7)  SCALE="-vf-add=scale:w=1280:h=720"
            RESIZETO720=1
        ;;
        N)  NORMAL=1
        ;;
        W)  NORMAL=1
            NORMAL_WRITE=1
        ;;
        D)  set -x
            MPVVERBOSE="--msg-level=all=v"
        ;;
    esac
done

shift $((OPTIND-1))

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

#set -x

for FILE in $@ ; do
    if [ -f "$FILE" ]; then
        TYPE="${FILE##*.}"
        RUNCMD=echo
        if [[ $ENC == "copy" ]]; then
            FILE_OUT="${FILE%.*}-$ENC.mkv"
            RUNCMD='$DRYRUN ionice -c 3 nice ffmpeg -fflags +igndts+genpts -i '"$FILE"' \
                -dts_delta_threshold 0 -vcodec copy -acodec copy '"$FILE_OUT"

        else
            ABITRATE=$(echo $(mediainfo --Inform='Audio;%BitRate%' "$FILE") $(mediainfo --Inform='Audio;%FromStats_BitRate%' "$FILE") 0 | awk '{ print $1 }')
            VBITRATE=$(echo $(mediainfo --Inform='Video;%BitRate%' "$FILE") $(mediainfo --Inform='Video;%FromStats_BitRate%' "$FILE") 0 | awk '{ print $1 }')
            BITRATE=$(echo $(mediainfo --Inform='General;%BitRate%' "$FILE") $(mediainfo --Inform='General;%OverallBitRate%' "$FILE") 0 | awk '{ print $1 }')
            WIDTH=$(mediainfo --Inform='Video;%Width%' "$FILE")
            HEIGHT=$(mediainfo --Inform='Video;%Height%' "$FILE")

            NEWRATE=$(echo "$VBITRATE*$VRATIO" | bc -l | numfmt --to=iec)
            MAXNEWRATE=$(echo "$VBITRATE*$VRATIO*1.5" | bc -l | numfmt --to=iec)
            MINNEWRATE=$(echo "$VBITRATE*$VRATIO*0.25" | bc -l | numfmt --to=iec)
            ANEWRATE=$(echo "$ABITRATE*$ARATIO" | bc -l | numfmt --to=iec)

            FILE_OUT="${FILE%.*}-$ENC-$NEWRATE-$ANEWRATE.mkv"

            if [ "$RESIZETO720" ]; then
                FILE_OUT=${FILE_OUT:gs/1080/720/}
                if  ! echo $FILE_OUT | grep -sq 720 ; then
                    FILE_OUT=$(echo $FILE_OUT | perl -pe 's/\.mkv$/-720p\.mkv/')
                fi
            fi

            OLDSIZE=$(stat -c '%s' "$FILE")
            HWDEC=" --hwdec=vaapi --vo=h264_cuvid "

            if (( $WIDTH == 4096 )) && (( $HEIGHT == 2160 )) ; then
                if [ -z "$SCALE" ]; then
                    SCALE="-vf-add=scale:w=1920:h=1080"
                    FILE_OUT=${FILE_OUT:gs/2160/1080/}
                fi
            elif (( $WIDTH != 1920 )) && (( $HEIGHT == 1080 )) ; then
                if [ -z "$SCALE" ]; then
                    SCALE="-vf-add=scale:w=$WIDTH:h=1080"
                fi
            elif (( $WIDTH == 1440 )) ; then
                if [ -z "$SCALE" ]; then
                    SCALE="-vf-add=scale:w=1440:h=$HEIGHT"
                fi
            fi

            if (( $VBITRATE == 0 )); then
                if echo $TYPE | grep -qs mkv ; then
                    mkvpropedit --add-track-statistics-tags "$FILE"
                    VBITRATE=$(mediainfo --Inform='Video;%FromStats_BitRate%' "$FILE")
                    ABITRATE=$(mediainfo --Inform='Audio;%FromStats_BitRate%' "$FILE")
                else
                    if (( $ABITRATE == 0 )); then
                        VBITRATE=$BITRATE
                        ABITRATE=128000
                    else
                        if (( $VBITRATE == 0 )); then
                            VBITRATE=$(echo "$BITRATE - $ABITRATE" | bc -l)
                        fi
                    fi
                fi
            fi

            NORMFILTER="--af=dynaudnorm"
            NORMCOMMENT="comment=Normalized_Audio_MPVdynaudnorm,"
            if mediainfo -f "$FILE" | grep -sq Normalized_Audio ; then
                echo "Already Normalized Audio"
                if [ ! -z "$NORMAL" ]; then
                    continue
                fi
                NORMFILTER=""
                NORMCOMMENT=""
            else
                echo "Normalizing Audio"
            fi
            if [ ! -z "$MPVVERBOSE" ] ; then
                mediainfo "$FILE"
            fi
            ENCODER=
            ECOUNT=00
            for LINE in $(mpv -V) ; do 
                if [ ! -z "$ENCODER" ]; then
                    ENCODER=${ENCODER},
                fi
                ENCODER="${ENCODER}ENCODER$ECOUNT=\"$LINE\""
                ECOUNT=$(echo "$ECOUNT + 1" | bc)
                ECOUNT=$(printf '%02d' $ECOUNT)
            done
            META="${NORMCOMMENT}command=\"${COMMAND}\",reencoded=\"$(date)\",$ENCODER,"
            META="${META}ORIGINAL_SIZE=$OLDSIZE,ORIGINAL_FILE=$FILE,FILE=$FILE_OUT,TARGET_AUDIO_BITRATE=$ANEWRATE,TARGET_VIDEO_BITRATE=$NEWRATE,NORMFILTER=x${NORMFILTER:-none},JHOP=Modified,"
            META="${META}VIDEO_RATIO=$VRATIO,AUDIO_RATIO=$ARATIO,ORIGINAL_VIDEO_BITRATE=$VBITRATE,ORIGINAL_AUDIO_BITRATE=$ABITRATE,ENCODE_SCRIPT_SHA256=$SHA,"
            VIDEO_SYNC=
            if [ ! -z "$NORMAL" ]; then
                FILE_OUT="${FILE%.*}-norm.mkv"
                RUNCMD='$DRYRUN docker run -t --rm \
                    --user 1000:1000 \
                    --network none \
                    --name ffmpeg-$$ \
                    --device /dev/dri:/dev/dri \
                    -w /mnt \
                    -v "$(pwd)":/mnt \
                    -v /tmp:/tmp \
                    jrottenberg/ffmpeg:vaapi -hide_banner -y \
                        -i "$FILE" \
                        -metadata JHOP=modified \
                        -metadata audiobitrate="Audio:\ $ANEWRATE\/s" \
                        -metadata videobitrate="Video:\ $VBITRATE\/s" \
                        -metadata normal=Normalized_Audio_MPVdynaudnorm \
                        -metadata comment=Normalized_Audio_MPVdynaudnorm \
                        -metadata command=\"${COMMAND}\" \
                        -metadata encoded=\"$(date)\" \
                        -metadata input_size=$OLDSIZE \
                        -metadata FILE=$FILE \
                        -c:v copy \
                        -c:a libfdk_aac \
                        -af dynaudnorm \
                        -profile:a aac_low \
                        -vbr 4 \
                        $FILE_OUT'
            elif [[ "$ENC" == "hand" ]]; then
                RUNCMD='$DRYRUN ionice -c 3 nice HandBrakeCLI --preset-import-file /home/justin/Fast\ 1080p30\ Justin.json \
                    --preset "Fast 1080p30 Justin" \
                    --optimize \
                    --align-av \
                    --input $FILE \
                    --output $FILE_OUT'
            elif [[ "$ENC" == "x264" ]]; then
                RUNCMD='$DRYRUN ionice -c 3 nice mpv '" $MPVVERBOSE $FILE "' --o '" $FILE_OUT "' --of mkv '" $NORMFILTER "' \
                    $VIDEO_SYNC --oac=libfdk_aac \
                    --oacopts="b=${ANEWRATE},afterburner=1,vbr=4" \
                    --ovc=libx264 \
                    --ovcopts=preset=slow,crf=22,psy=1 $SCALE $MPV_ARGS --oset-metadata="${META}"'
            elif [[ "$ENC" == "nv" ]]; then
                RUNCMD='$DRYRUN ionice -c 3 nice mpv '" $MPVVERBOSE $FILE  "' --o  '" $FILE_OUT  "' \
                    --of mkv '" $HWDEC $NORMFILTER $VIDEO_SYNC $SCALE $MPV_ARGS "' --oac=libfdk_aac \
                    --oacopts="b='${ANEWRATE}',afterburner=1,vbr=4" \
                    --video-sync=display-resample \
                    --ovc=h264_nvenc \
                    --ovcopts="b='${NEWRATE}',preset=fast,cq=0,profile=main,level=auto,rc=vbr_hq,maxrate='${MAXNEWRATE}',minrate='${MINNEWRATE}'" \
                    --oset-metadata="${META}"'
            elif [[ "$ENC" == "vaapi" ]]; then
                RUNCMD='$DRYRUN ionice -c 3 nice mpv '" $MPVVERBOSE $FILE  "' --o  '" $FILE_OUT  "' \
                    --of mkv '" $HWDEC $NORMFILTER $VIDEO_SYNC $SCALE $MPV_ARGS "' --oac=libfdk_aac \
                    --oacopts="b='${ANEWRATE}',afterburner=1,vbr=4" \
                    --video-sync=display-resample \
                    --ovc=h264_vaapi \
                    --ovcopts=b='${NEWRATE}',quality=23,qp=23,global_quality=23 \
                    --oset-metadata="${META}"'
            fi
            MPVCMDS=""
            MCOUNT=00
            for LINE in $(echo "$RUNCMD" | grep -v metadata) ; do 
                if [ ! -z "$MPVCMDS" ]; then
                    MPVCMDS="${MPVCMDS},"
                fi
                MPVCMDS=${MPVCMDS}MPVCMD$MCOUNT="\"$(echo ${${${LINE//\"}//\'}//\\} | sed 's/,/\\,/g')\""
                MCOUNT=$(echo "$MCOUNT + 1" | bc)
                MCOUNT=$(printf '%0*d\n' 2 $MCOUNT)
            done
            META=${META}${MPVCMDS}
        fi
        if eval "${RUNCMD}"  ; then
            if [ -f "$FILE_OUT" ]; then
                if $DRYRUN mkvpropedit -v --add-track-statistics-tags "$FILE_OUT" ; then
                    echo "Prop set worked"
                else
                    echo "Prop set failed"
                fi
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

