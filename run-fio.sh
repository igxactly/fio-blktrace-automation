#!/usr/bin/env bash

source $(dirname $0)/lib/argparse.bash || exit 1
argparse "$@" <<EOF || exit 1

parser.add_argument('title')
#parser.add_argument('rand')
parser.add_argument('rw')
parser.add_argument('bs')
parser.add_argument('qd')
parser.add_argument('njobs')
parser.add_argument('time')
parser.add_argument('file')
parser.add_argument('ioengine')
parser.add_argument('direct')
parser.add_argument('format')
EOF

echo \
"
[global]
group_reporting
numjobs=${NJOBS}
runtime=${TIME}

direct=${DIRECT}
ioengine=${IOENGINE}
iodepth=${QD}
bssplit=${BS}

rw=randrw
rwmixwrite=${RW}

[${TITLE}]
filename=${FILE}
" \
| sudo fio --output-format=${FORMAT} - ;

