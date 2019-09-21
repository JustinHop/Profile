#!/bin/bash

OUT=./split.sh

cat <<EOH > $OUT
#!/bin/bash
set -x
EOH
chmod +x $OUT

for VCP in $(find -L -type f -name '*.vcp') ; do
    ~/Profile/bin/cutvid.sh $VCP | tee -a $OUT
done
