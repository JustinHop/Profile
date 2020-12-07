#!/bin/bash

cat <<EOF | awesome-client
io.stderr:write("ret", "\n")
EOF

