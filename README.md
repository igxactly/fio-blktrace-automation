# fio-blktrace-automation

This is a set of scripts that allows you to run test through various combination of fio configuration with blktrace tracing and simple cpu usage logging.

## usage
```
$ ./trace-fiocombs.sh --help
usage: trace-fiocombs.sh [-h] --title TITLE --rw RW [RW ...] --bs BS [BS ...]
                         --qd QD [QD ...] --njobs NJOBS [NJOBS ...] --time
                         TIME --file FILE --btarg BTARG [--ioengine IOENGINE]
                         [--direct DIRECT] [--titlepostfix TITLEPOSTFIX]
                         [--repeat REPEAT] [--do]

required arguments:
  --title TITLE         multiple values allowed
  --rw RW [RW ...]      read/write ratio - percentage of read
  --bs BS [BS ...]      block size split
  --qd QD [QD ...]      IO deqpth (queue maximum)
  --njobs NJOBS [NJOBS ...]
                        number of jobs (processes)
  --time TIME           time to run each test
  --file FILE           target device or binary file
  --btarg BTARG         blktrace action args ex: "-a queue"

optional arguments:
  -h, --help            show this help message and exit
  --ioengine IOENGINE   I/O engine to use (default: libaio)
  --direct DIRECT       use direct I/O (bypass) (default: 1)
  --titlepostfix TITLEPOSTFIX
                        postfix format (default: _${file}_rw${rw}_b${bs}_q${qd
                        }_n${njobs}_t${time}_${repeat})
  --repeat REPEAT       how many times to repeat (default: 1)
  --do                  no action if do is 0 (default: False)
```

part-scripts:
```
$ ./run-fio.sh -h
usage: run-fio.sh [-h] title rw bs qd njobs time file ioengine direct format
...

$ ./trace-workload.sh -h
usage: trace-workload.sh [-h] workloadcmd dev btarg title
...

$ ./collect-data.sh -h
usage: collect-data.sh [-h] dev btarg title
...
```
