#!/usr/bin/env bash

# for all_test_cases
# do
#     run blktrace
#         run fio_script > result_fio.json
#     stop blktrace
#
#     blkparse -i nvme0n1 -d all.blktrace
#     yabtar all.blktrace > result_blktrace.json
#
#     result_fio.json + result_blktrace.json --> result_latency_breakdown.json
# done

source $(dirname $0)/lib/argparse.bash || exit 1
argparse "$@" <<EOF || exit 1

optional = parser._action_groups.pop()
required = parser.add_argument_group('required arguments')
parser._action_groups.append(optional)

required.add_argument('--title', required=True, help='title (postfix will be appended)')
required.add_argument('--rw', required=True, nargs='+', help='read/write ratio - percentage of read')
required.add_argument('--bs', required=True, nargs='+', help='block size split')
required.add_argument('--qd', required=True, nargs='+', help='IO deqpth (queue maximum)')
required.add_argument('--njobs', required=True, nargs='+', help='number of jobs (processes)')
required.add_argument('--time', required=True, help='time to run each test')
required.add_argument('--file', required=True, help='target device or binary file')
required.add_argument('--btarg', required=True, help='blktrace action args ex: "-a queue"')

optional.add_argument('--ioengine', default='libaio', help='I/O engine to use')
optional.add_argument('--direct', default=1, help='use direct I/O (bypass)')
optional.add_argument('--titlepostfix', default='_\${file}_rw\${rw}_b\${bs}_q\${qd}_n\${njobs}_t\${time}_\${repeat}', help='postfix format')
optional.add_argument('--repeat', default=1, help='how many times to repeat')
optional.add_argument('--do', default=False, action='store_true', help='no action if do is 0')
#optional.add_argument('--format', default='json', help='')

## NOT IMPLEMENTED YET
#optional.add_argument('--rand', default='rand', help=' to use')
#optional.add_argument('--order', default='toggle', help='toggle: a-z then z-a')
EOF

# echo ${BTARG}
scriptdir=$(dirname $(readlink -f $0))
format=json

for repeat in $(seq ${REPEAT});
do for rw in ${RW[@]};
do for bs in ${BS[@]};
do for qd in ${QD[@]};
do for njobs in ${NJOBS[@]};
do
    time=${TIME}; btarg="'${BTARG}'";
    ioengine=${IOENGINE}; direct=${DIRECT};

    file_full=${FILE}; file=$(basename ${FILE});
    bs_full=${bs}; bs=$(echo ${bs} | tr ':' ',' | tr '/' '.');

    export repeat;
    export rw; export bs; export qd; export njobs;
    export time; export file;

    titlepostfix=$(sh -c "echo ${TITLEPOSTFIX}");
    title_full="${TITLE}${titlepostfix}"

    if [ ${DO} == "False" ];
    then
        echo ${title_full};
    else
        echo;
        echo "########################";
        echo "## START ${title_full}"
        echo "------------------------";
        cmd="'${scriptdir}/run-fio.sh ${title_full} ${rw} ${bs_full} ${qd} ${njobs} ${time} ${file_full} ${ioengine} ${direct} ${format}'";
        bash -c "${scriptdir}/trace-workload.sh ${cmd} ${file_full} ${btarg} ${title_full}" && \
        bash -c "${scriptdir}/collect-data.sh ${file_full} ${btarg} ${title_full}";
        echo "------------------------";
        echo "# END ${title_full}#"
    fi;
done;
done;
done;
done;
done;

