#!/bin/bash
set -x
num=$1
if test $num -ge 49
then
	echo "number of insts exceed 48"
	exit
fi
if test $num -le 0
then
	echo "number of insts can't be 0 or less"
	exit
fi
echo "number of insts: $num"

DATE=$(date +"%m-%d-%y-%H-%M")
PCAP_FILE=$HOME/pcaps/maccdc2012_00001.pcap

for ((i = 1; i <= $num; i++))
do
	PCAP_LIST+="$PCAP_FILE"
	if test $i -lt $num
	then
		PCAP_LIST+=" "
	fi
done
PCAP_LIST_OPT="--pcap-list=\"${PCAP_LIST}\""
echo "$PCAP_LIST"
echo "$PCAP_LIST_OPT"
HYPERSCAN="search_engine.search_method = \"hyperscan\""
search_method=$HYPERSCAN
mkdir -p ./results
#COMMAND="taskset -c 1-$num snort -z 0  -v --rule-path /usr/local/etc/rules/ -c /usr/local/etc/snort/snort.lua --lua 'search_engine.search_method = "hyperscan"' --pcap-list="$PCAP_LISTi""
tnum=$[num - 1]

if test $num -le 10
then
	snum="0"$num
else
	snum=$num
fi
	CMD="taskset -c 0-$tnum snort -z 0  -v --rule-path /usr/local/etc/rules/ -c /usr/local/etc/snort/snort.lua --lua '$HYPERSCAN' $PCAP_LIST_OPT 2>&1 > ./results/snort-$snum-cores-$search_mode-results-mthread-test.txt"

echo "$CMD"
eval $CMD

<<oldcode
if test $num -eq 48
then
	CMD="taskset -c 0-47 snort -z 0  -v --rule-path /usr/local/etc/rules/ -c /usr/local/etc/snort/snort.lua --lua '$HYPERSCAN' $PCAP_LIST_OPT 2>&1 > ./results/snort-$num-cores-$search_mode-results-$DATE-mthread-test.txt"
else
	#CMD="taskset -c 1-$num snort -z 0  -v --rule-path /usr/local/etc/rules/ -c /usr/local/etc/snort/snort.lua --lua '$HYPERSCAN' $PCAP_LIST_OPT 2>&1 > ./results/snort-$num-cores-$search_mode-results-$DATE-mthread-test.txt"
	if test $num -le 10
	then
		snum="0"$num
	else
		snum=$num
	fi
	CMD="taskset -c 0-$tnum snort -z 0  -v --rule-path /usr/local/etc/rules/ -c /usr/local/etc/snort/snort.lua --lua '$HYPERSCAN' $PCAP_LIST_OPT 2>&1 > ./results/snort-$snum-cores-$search_mode-results-mthread-test.txt"
fi
oldcode


