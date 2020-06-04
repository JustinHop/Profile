#!/bin/zsh
set -euo pipefail
IFS=$'\t\n'
set -x

vidmanage lists

export LIBVA_DRIVER_NAME=vdpau
export VDPAU_DRIVER=nvidia

VO="--vo=gpu"
HW="--hwdec=cuda-copy"
PIPECMD=""
AUDIO=""

HELP="
$0 [-i|-s|-n] \$MPV_ARGS

-l      Local Audio
-b      Bluetooth Audio
-i      Intel decode
-s      Software decode
-n      Nvidia decode (default)
-N      Play New Vids
-V      Play Vids
"

function newset () {
    export PIPECMD="vidmanage show new | rl | xargs "
    export AUDIO="--audio-device=pulse/alsa_output.pci-0000_00_1b.0.analog-stereo"
}

function vidset () {
    export PIPECMD="~/bin/100next.sh | rl | xargs "
    export AUDIO="--audio-device=pulse/alsa_output.pci-0000_00_1b.0.analog-stereo"
}

while getopts "isnlbNVh" option; do
    case "${option}"
        in
        i)  export VDPAU_DRIVER=va_gl
            export LIBVA_DRIVER_NAME=i915
            #unset LIBVA_DRIVER_NAME
            VO="--vo=gpu"
            HW="--hwdec=vdpau --vaapi-device=/dev/dri/renderD128"
        ;;
        n)  export LIBVA_DRIVER_NAME=nvidia
            export VDPAU_DRIVER=nvidia
            HW="--hwdec=cuda-copy"
        ;;
        b)  export AUDIO="--audio-device=pulse/bluez_sink.30_21_C6_A8_94_2E.a2dp_sink"
        ;;
        l)  export AUDIO="--audio-device=pulse/alsa_output.pci-0000_00_1b.0.analog-stereo"
        ;;
        N)  newset
        ;;
        V)  vidset
        ;;
        h)  echo "$HELP"
            exit 1
        ;;
    esac
done

shift $((OPTIND-1))

echo "LIBVA_DRIVER_NAME=$LIBVA_DRIVER_NAME"
echo "VDPAU_DRIVER=$VDPAU_DRIVER"

eval $PIPECMD mpv -v $VO $HW $AUDIO $@

clear
