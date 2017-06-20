#!/usr/bin/env bash

source $(dirname $0)/lib/argparse.bash || exit 1
argparse "$@" <<EOF || exit 1

parser.add_argument('dev')
parser.add_argument('btarg')
parser.add_argument('title')
parser.add_argument('yconf')
EOF

cd ./${TITLE};

# parse and analyze block trace log
echo "@@@parsing start";

echo "blkparse"
blkparse -O ${BTARG} -i $(basename ${DEV}) -d all.blktrace; sync;

echo "yabtago"
#yabtago all.blktrace yabtar_result.json | tail -n 25; sync;
yabtago report all.blktrace -c ${YCONF} -o yabtago_result.json -f json; sync;

echo "combine-results"
merge-results.rb fio_result.json yabtago_result.json breakdown.json fio_iops_bw.csv > breakdown.csv; sync;

echo "@@@parsing done"

cd ..;
