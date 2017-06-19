#!/usr/bin/env bash

source $(dirname $0)/lib/argparse.bash || exit 1
argparse "$@" <<EOF || exit 1

parser.add_argument('workloadcmd')
parser.add_argument('dev')
parser.add_argument('btarg')
parser.add_argument('title')
EOF

# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

## single_test_script=~/fio_presets/do_test_normalWorkload.sh;
## dev=/dev/nvme0n1
## kernel=$(uname -r | sed 's/\([0-9]\.[0-9]\+\).\+/\1/g');
## trace_arg="-a queue -a drv_data -a complete"
## testname="${kernel}_${1}_test${i}";

mkdir -p ./${TITLE}; cd ./${TITLE};

### start trace
echo "@@@starting blktrace/fio..."

sleep 3; blktrace ${BTARG} ${DEV} & PID_BLKTRACE=$!;

# log cpu load
while true; do echo $(date -Ins) $(cat /proc/stat | egrep "(cpu |ctx)"); sleep 0.25; done > cpuload.log & PID_CPULOGGER=$!;

# run fio test
${WORKLOADCMD} > fio_result.json; kill ${PID_CPULOGGER}; sync;

# stop trace
sleep 3; kill ${PID_BLKTRACE};
wait ${PID_BLKTRACE}; sync;

echo "@@@blktrace/fio done";
### end of trace
cd ..;

