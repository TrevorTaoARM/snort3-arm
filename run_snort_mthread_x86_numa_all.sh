#!/bin/bash
set -x
num=$1

for i in {1,2,4,8,12,16,20,24}
do
	./run_snort_mthread_x86_numa.sh $i numa0
	./run_snort_mthread_x86_numa.sh $i numa1
done


#echo "$CMD"
#eval $CMD
