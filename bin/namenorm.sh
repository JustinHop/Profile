#!/bin/bash

DRY=""

while getopts "n" option; do
    case "${option}"
        in
        n)  DRY="-n"
        ;;
    esac
done

shift $((OPTIND-1))

rename -v $DRY -- 's/^(\.\/|\.*_+)+//;
           s/^nzb_?//;
           s/(mp4-?)?(ktr-?)?xpost$/.mp4/i;
           s/_mp4$/.mp4/gi;
           s/\/$//;
           s/[^\w\d\.]/_/g;
           s/_+/_/g; s/(^_|_$)//g;
           s/_?\[^\]+]?//g;
           s/_?\[^\]+]?//g;
           s/_?split_?scenes_?//gi;
           s/_?web_?dl_?//gi;
           s/_?rarbg_?//gi;
           s/_?ktr_?//gi;
           s/(\w+)\[?PRiVATE\]?_?/$1/gi;
           s/[\._-]mp4.*$/.mp4/gi;
           s/_(\.\w\w\w)$/$1/;
           s/^_+//g;
           s/(1080|720)(p|i|).*(_EDIT_\d\d).*$/$3_$1$2.mp4/i;
           s/(1080|720)(p|i|).*$/$1$2.mp4/i;
           s/\.?wmv-\w+$/.wmv/i;
           s/\.+/./g;
           s/\.xxx\._edit/_EDIT/i;
           s/_1_.mp3/.mp3/g;' "$@"
