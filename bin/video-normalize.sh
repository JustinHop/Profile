#!/bin/zsh
set -euo pipefail
#IFS=$'\n\t'

NORM=normalize-audio
TMPDIR=/tmp
DRY_RUN=""
OVERWRITE=""
VERBOSE=""
DEBUG=""
CPU=0
ARGS=$@

usage () {
    cat <<EOU
Usage: $0 [OPTION]... [FILE]...

Options:
    -c      cpus
    -d      debug
    -n      dry run
    -f      overwrite original file
    -v      verbose
    -h      help
EOU
    exit 1
}

CONTAINER="jrottenberg/ffmpeg:vaapi"

show_vars () {
    cat <<EOV
DEBUG=$DEBUG
DRY_RUN=$DRY_RUN
OVERWRITE=$OVERWRITE
VERBOSE=$VERBOSE
CPU=$CPU
ARGS="$ARGS"
EOV
}

trap "{ docker kill ffmpeg-$$ || true;
        docker rm ffmpeg-$$ || true; }" SIGTERM SIGSTOP SIGHUP


docker_run () {
    $DRY_RUN docker run -t --rm \
        --user 1000:1000 \
        --network none \
        --name ffmpeg-$$ \
        --device /dev/dri:/dev/dri \
        -v "$(pwd)":/mnt \
        -v /tmp:/tmp \
        --cpus $CPU \
        $CONTAINER -hide_banner -y $@
}

normal () {
    IN="$1"
    OUT_WAV="${TMPDIR}/${IN%.*}.wav"
    OUT_VID="${IN%.*}-volnorm.mkv"
    [ $VERBOSE ] && cat <<EON
    Entered normal($1)
    IN=$IN
    OUT_VID=$OUT_VID
EON
    # OUT_WAV=$OUT_WAV

    FFVER="-loglevel +24"
    [ $VERBOSE ] && FFVER="-loglevel +40"

    [ -f "$IN" ] || ( echo "$IN Not found" && return )
    BEFORE=$(ls -l "$IN")
    IN_SIZE=$(stat -c '%s' "$IN")
    TIME=$(stat --printf '%Y' "$IN")
    # [ -f "$OUT_WAV" ] && $DRY_RUN sudo rm "$OUT_WAV"

    PROBE=$( { ffprobe -hide_banner "$IN"; } 2>&1 )
    VIDEO_MAP=$(echo "$PROBE" | grep Stream | grep Video | grep -oP '(:?#)[01]:[01](:?\(\w+\):)' | grep -oP '\d:\d')

    if echo $PROBE | grep Normalized_Audio > /dev/null ; then
        echo "$IN Already Normalized"

    elif ! echo $VIDEO_MAP | grep -P '^\d:\d$' > /dev/null ; then
        echo "$IN could not find Video stream"
    else

        # eval $DRY_RUN docker_run $FFVER -i /mnt/"$IN" -c:a pcm_s16le -vn "$OUT_WAV"
        # [ -f "$OUT_WAV" ] && $DRY_RUN sudo chown justin:justin "$OUT_WAV"

        # eval $DRY_RUN $NORM -- "$OUT_WAV" || rm -v "$OUT_WAV"

        # eval $DRY_RUN docker_run $FFVER -i /mnt/"$IN" -i "$OUT_WAV" \
            # -map $VIDEO_MAP -map 1:0 \
        eval docker_run $FFVER -i /mnt/"$IN" \
            -metadata comment="'Normalized_Audio+ffmpeg+loudnorm-$(date)'" \
            -metadata JHOP=modified \
            -c:v copy \
            -c:a libfdk_aac \
            -profile:a aac_low \
            -af loudnorm \
            -vbr 4 \
            /mnt/"$OUT_VID" || return

        mkvpropedit -v --add-track-statistics-tags "$OUT_VID" || true
        # $DRY_RUN sudo chown justin:justin "$OUT_WAV" "$OUT_VID"
        $DRY_RUN sudo chown justin:justin "$OUT_VID"
        $DRY_RUN touch --date=@$TIME "$OUT_VID"
        # $DRY_RUN rm $VERBOSE "$OUT_WAV"
        [ -f /tmp/_normAAAAAA ] && rm /tmp/_normAAAAAA

        OUT_SIZE=$(stat -c '%s' "$OUT_VID")
        INOUT=$(echo "$IN_SIZE"/"$OUT_SIZE" | bc -l)

        echo "IN/OUT ratio: $INOUT"

        INTER=""
        [ $DEBUG ] && INTER="-i"


        $DRY_RUN echo $BEFORE
        if [ $OVERWRITE ]; then 
            if [ $( echo "$INOUT"' < 0.9' | bc -l ) -eq 1 ]; then
                echo "OUTPUT FILE TOO SMALL!"
            else
                if [ $( echo "$INOUT"' > 1.1' | bc -l ) -eq 1 ]; then
                    echo "OUTPUT FILE TOO BIG!"
                    $DRY_RUN ls -l "$OUT_VID"
                else
                    $DRY_RUN mv $VERBOSE $INTER -- "$OUT_VID" "$IN" 
                    $DRY_RUN touch --date=@$TIME "$IN"
                fi
            fi
            $DRY_RUN ls -l "$IN"
        else
            $DRY_RUN ls -l "$OUT_VID"
        fi

    fi


}

while getopts "c:dnfvh" OPT; do
    case "${OPT}" in
        c)
            CPUS="${OPTARG}"
            ;;
        d)
            set -x
            DEBUG=1
            VERBOSE="-v"
            show_vars
            ;;
        n)
            DRY_RUN="echo"
            ;;
        f)
            OVERWRITE="1"
            ;;
        v)
            VERBOSE="-v"
            set -x
            ;;
        *)
            show_vars
            usage
            ;;
    esac
done


if ! [ $DEBUG ]; then
    if [ $# -eq 0 ]; then
        show_vars
        usage
    fi
fi

$DRY_RUN docker pull $CONTAINER

shift $((OPTIND-1))

which $NORM > /dev/null || ( echo "normalize-audio required in \$PATH" ; usage )

COUNT=1
for A in "$@" ; do
    echo "--- $(date): Processing $A [$((COUNT++))/$#]"
    normal $A || echo "$A failed, continuing"
    find /tmp -maxdepth 1 -type f -name '*.wav' -exec rm -v {} \;
done
