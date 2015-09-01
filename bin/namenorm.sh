#!/bin/bash

rename -v 's/^(\.\/|\.*_+)+//;
           s/\/$//;
           s/[^\w\d\.]/_/g;
           s/_+/_/g; s/(^_|_$)//g;
           s/_?\[^\]+]?//g;
           s/_?\[^\]+]?//g;
           s/_?split_?scenes_?//gi;
           s/_?web_?dl_?//gi;
           s/_?rarbg_?//gi;
           s/_?ktr_?//gi;
           s/_(\.\w\w\w)$/$1/;
           s/^_+//g;
           s/_1_.mp3/.mp3/g;' "$@"
