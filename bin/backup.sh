#!/bin/bash
eval "$(docopts -V - -h - : "$@" <<EOF
Usage: backup  [options] <FILE>...

      -n --dry-run  Take no action.

      -D --debug    Generate DEBUG messages.
      -v --verbose  Generate verbose messages.

      -h --help     Show help options.
      -V --version  Print program version.
----
backup 0.1.2 - Copyright (C) 2015 Justin Hoppensteadt
EOF
)"

#This is free software: you are free to change and redistribute it.
#There is NO WARRANTY, to the extent permitted by law.
#BSD License

_BD="$HOME"/backup

_CMD="diff -rq"
[[ "$debug" == "true" ]] && verbose="true"
[[ "$verbose" == "true" ]] && _V="-v" && _CMD="diff -rs"
[[ "$dry_run" == "true" ]] && _E="echo -e Would Excute:\t" && echo "Dry run"

realpath() {
    if [ -f "$1" ]; then
        echo $(cd $(dirname "$1"); pwd)/$(basename "$1");
        return 0
    elif [ -d "$1" ]; then
        echo $(cd "$1"; pwd);
        return 0
    fi
    return 1
}

lastbackup() {
    if ls -trd "$1":* 2> /dev/null | tail -n 1 ; then
        return 0
    fi
    return 1
}

dump() {
    [[ "$debug" == "true" ]] && for D in "$@"; do
        eval DD=\$$D
        [[ "$D" ]] && [[ "$DD" ]] && echo -e "DEBUG:\t$D=$DD"
    done
}

dobackup() {
    $_E cp -avn "$RP" "$BP":$(hostname):$(date +%FT%T)
}

for F in "${FILE[@]}"; do
    [[ "$debug" == "true" ]] && echo Arg: $F
    RP="$(realpath "$F")"; [[ "$RP" ]] || continue
    BP="$_BD/${RP#$HOME/}"
    BD="$(dirname "$BP")"
    LB="$(realpath "$(lastbackup "$BP")")"
    dump RP BP BD LB
    [[ -d "$BD" ]] || $_E mkdir $_V -p "$BD"
    [[ "$LB" ]] && $_CMD "$RP" "$LB" || dobackup && continue
    dobackup
done
