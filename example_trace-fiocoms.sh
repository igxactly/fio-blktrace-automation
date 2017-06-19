#/usr/bin/env bash

# !!!WARNING!!!
#
# If you run this example
#   especially WITH 'sudo' and '--do',
#
# you MAY LOSE your data of device
#   specified in '--file' arg.

# trace-fiocombs goes through
# all of each combinations of configurations
# running blktrace & fio.

#sudo # to access fio/device/blktrace
$(dirname ${0})/trace-fiocombs.sh               \
    ${1} --title test                           \
    --file /dev/nvme0n1                         \
    --rw 50                                     \
    --bs 4k/100 64k/100 4k/70:64k/30            \
    --qd 1 32 128                               \
    --njobs 1 4                                 \
    --time 10                                   \
    --btarg '-a queue -a drv_data -a complete'  ;
    # --do # no action if '--do' is not present
