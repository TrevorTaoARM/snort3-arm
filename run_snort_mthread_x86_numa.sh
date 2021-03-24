#!/bin/bash
set -x
num=$1
numa=$2
method=$3

if test $num -ge 160
then
	echo "number of insts exceed 160"
	exit
fi
if test $num -le 0
then
	echo "number of insts can't be 0 or less"
	exit
fi
echo "number of insts: $num"

DATE=$(date +"%m-%d-%y-%H-%M")
#PCAP_FILE=$HOME/pcaps/maccdc2012_00001.pcap
PCAP_FILE=$HOME/pcaps/defcon.pcap
#PCAP_FILE=$HOME/pcaps/get250.pcap

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

echo "Method: "$method
if [ $method = "ac_bnfa" ]; then
	search_method="search_engine.search_method = \"ac_bnfa\""
elif [ $method = "ac_full" ]; then
	search_method="search_engine.search_method = \"ac_full\""
else
	search_method="search_engine.search_method = \"hyperscan\""
fi

echo "Search_method: "$search_method
search_mode=$search_method


#HYPERSCAN="search_engine.search_method = \"hyperscan\""
#search_method=$HYPERSCAN

mkdir -p ./results-numa
#COMMAND="taskset -c 1-$num snort -z 0  -v --rule-path /usr/local/etc/rules/ -c /usr/local/etc/snort/snort.lua --lua 'search_engine.search_method = "hyperscan"' --pcap-list="$PCAP_LISTi""
tnum=$[num - 1]

if test $num -eq 80
then
	CMD="taskset -c 0-79 snort -z 0  -v --rule-path /usr/local/etc/rules/ -c /usr/local/etc/snort/snort.lua --lua '$HYPERSCAN' $PCAP_LIST_OPT 2>&1 > ./results/snort-$num-cores-$search_mode-results-$DATE-mthread-test.txt"
else
	#CMD="taskset -c 1-$num snort -z 0  -v --rule-path /usr/local/etc/rules/ -c /usr/local/etc/snort/snort.lua --lua '$HYPERSCAN' $PCAP_LIST_OPT 2>&1 > ./results/snort-$num-cores-$search_mode-results-$DATE-mthread-test.txt"
case $numa in
        "numa0")
                for ((i = 0; i < $num; i++))
                do
                        cpuset+="$[i*2]"
                        if test $i -lt $[num-1] 
			then
                        	cpuset+=","
                        fi
                done
                ;;
        "numa1")
                for ((i = 0; i < $num; i++))
                do
                        cpuset+="$[i*2+1]"
                        if test $i -lt $[num-1]
		       	then
                        	cpuset+=","
                        fi
                done
                ;;
        *)
                echo "Wrong numa!!!"
                exit
esac
echo "cpuset:"$cpuset
	if test $num -le 10
	then
		snum="0"$num
	else
		snum=$num
	fi
	#CMD="taskset -c 0-$tnum snort -z 0  -v --rule-path /usr/local/etc/rules/ -c /usr/local/etc/snort/snort.lua --lua '$HYPERSCAN' $PCAP_LIST_OPT 2>&1 > ./results/snort-$snum-cores-$search_mode-results-mthread-test.txt"
	CMD="taskset -c $cpuset snort -z 0  -v --rule-path /usr/local/etc/rules/ -c /usr/local/etc/snort/snort.lua --lua '$search_method' $PCAP_LIST_OPT 2>&1 > ./results-numa/snort-$numa-$snum-cores-$search_mode-results-mthread-test.txt"
#	if [ $numa = "numa0" ] 
#	then
#	CMD="numactl --membind=0 --cpunodebind=0 --physcpubind=$cpuset snort -z 0  -v --rule-path /usr/local/etc/rules/ -c /usr/local/etc/snort/snort.lua --lua '$HYPERSCAN' $PCAP_LIST_OPT 2>&1 > ./results-numa/snort-$numa-$snum-cores-$search_mode-results-mthread-test.txt"
#	else
#	CMD="numactl --membind=1 --cpunodebind=1 --physcpubind=$cpuset snort -z 0  -v --rule-path /usr/local/etc/rules/ -c /usr/local/etc/snort/snort.lua --lua '$HYPERSCAN' $PCAP_LIST_OPT 2>&1 > ./results-numa/snort-$numa-$snum-cores-$search_mode-results-mthread-test.txt"
#	fi
fi

echo "$CMD"
eval $CMD
