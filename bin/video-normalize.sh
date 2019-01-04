#!/bin/bash
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

docker_run () {
    $DRY_RUN docker run -t --rm \
        --name ffmpeg \
        --device /dev/dri:/dev/dri \
        -v "$(pwd)":/mnt \
        -v /tmp:/tmp \
        --cpus $CPU \
        jrottenberg/ffmpeg:vaapi -hide_banner $@
}

normal () {
    IN="$1"
    OUT_WAV="${TMPDIR}/${IN%.*}.wav"
    OUT_VID="${IN%.*}-volnorm.${IN##*.}"
    [ $VERBOSE ] && cat <<EON
    Entered normal($1)
    IN=$IN
    OUT_WAV=$OUT_WAV
    OUT_VID=$OUT_VID
EON
    echo "$(date): Processing $IN"

    FFVER="-loglevel +24"
    [ $VERBOSE ] && FFVER="-loglevel +40"

    [ -f "$IN" ] || usage
    BEFORE=$(ls -l "$IN")
    TIME=$(stat --printf '%Y' "$IN")
    [ -f "$OUT_WAV" ] && $DRY_RUN sudo rm "$OUT_WAV"

    if ffprobe -hide_banner "$IN" 2>&1 | grep Normalized_Audio > /dev/null ; then
        echo "$IN Already Normalized"
    else

        eval $DRY_RUN docker_run $FFVER -i /mnt/"$IN" -c:a pcm_s16le -vn "$OUT_WAV"
        [ -f "$OUT_WAV" ] && $DRY_RUN sudo chown justin:justin "$OUT_WAV"

        eval $DRY_RUN $NORM -- "$OUT_WAV"

        eval $DRY_RUN docker_run $FFVER -i /mnt/"$IN" -i "$OUT_WAV" \
            -metadata comment="Normalized_Audio" \
            -map 0:0 -map 1:0 \
            -c:v copy \
            -c:a libfdk_aac \
            -profile:a aac_low \
            -vbr 3 \
            /mnt/"$OUT_VID"

        $DRY_RUN sudo chown justin:justin "$OUT_WAV" "$OUT_VID"
        $DRY_RUN touch --date=@$TIME "$OUT_VID"
        $DRY_RUN rm -v "$OUT_WAV"
        [ -f /tmp/_normAAAAAA ] && rm /tmp/_normAAAAAA

        INTER=""
        [ $DEBUG ] && INTER="-i"
        [ $OVERWRITE ] && $DRY_RUN mv $VERBOSE $INTER -- "$OUT_VID" "$IN" && $DRY_RUN touch --date=@$TIME "$IN"

        $DRY_RUN echo $BEFORE
        if [ $OVERWRITE ]; then 
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


shift $((OPTIND-1))

which $NORM > /dev/null || ( echo "normalize-audio required in \$PATH" ; usage )

for A in "$@" ; do
    normal $A
done
