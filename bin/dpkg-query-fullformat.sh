#!/bin/bash

FULLFORMAT="\${Package}:
    Architecture  : \${Architecture}
    Bugs          : \${Bugs}
    Conflicts     : \${Conflicts}
    Breaks        : \${Breaks}
    Depends       : \${Depends}
    Description   : \${Description}
    Enhances      : \${Enhances}
    Essential     : \${Essential}
    Homepage      : \${Homepage}
    Installed-Size: \${Installed-Size}
    Maintainer    : \${Maintainer}
    Origin        : \${Origin}
    Package       : \${Package}
    Pre-Depends   : \${Pre-Depends}
    Priority      : \${Priority}
    Provides      : \${Provides}
    Recommends    : \${Recommends}
    Replaces      : \${Replaces}
    Section       : \${Section}
    Size          : \${Size}
    Source        : \${Source}
    Suggests      : \${Suggests}
    Tag           : \${Tag}
    Version       : \${Version}"


for PACKAGE in $* ; do
    dpkg-query --show --showformat="$FULLFORMAT" $PACKAGE
done
