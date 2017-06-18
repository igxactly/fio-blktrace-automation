#!/usr/bin/env bash

source $(dirname $0)/lib/argparse.bash || exit 1
argparse "$@" <<EOF || exit 1

parser.add_argument('dev')
parser.add_argument('btarg')
parser.add_argument('title')
EOF

#cd ./${TITLE};
echo "cd ./${TITLE};"

# parse and analyze block trace log
echo "parsing results...";
#blkparse -O ${BTARG} -i $(basename ${DEV}) -d all.blktrace; sync;
#yabtago all.blktrace yabtar_result.json | tail -n 25; sync;
echo "blkparse -O ${BTARG} -i $(basename ${DEV}) -d all.blktrace; sync;"
echo "yabtago all.blktrace yabtar_result.json | tail -n 25; sync;"

# final result
#combine-results.rb fio_result.json yabtar_result.json breakdown.json > breakdown.csv; sync;
echo "combine-results.rb fio_result.json yabtar_result.json breakdown.json > breakdown.csv; sync;"
echo "parsing and anylysis done"

#cd ..;
echo "cd ..;"
