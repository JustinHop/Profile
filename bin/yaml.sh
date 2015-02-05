#!/bin/bash

python -c 'import yaml; print(yaml.dump(yaml.load(open("'${1:-/dev/stdin}'"))))'
