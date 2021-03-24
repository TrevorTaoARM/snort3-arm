#!/bin/bash
set -x
num=$1

for i in {1,2,4,8,12,16,20,24}
do
	./run_snort_mthread_x86_numa.sh $i numa0 ac_full
	./run_snort_mthread_x86_numa.sh $i numa1 ac_full
done

for i in {1,2,4,8,12,16,20,24}
do
	./run_snort_mthread_x86_numa.sh $i numa0 ac_bnfa
	./run_snort_mthread_x86_numa.sh $i numa1 ac_bnfa
done


for i in {1,2,4,8,12,16,20,24}
do
	./run_snort_mthread_x86_numa.sh $i numa0 hyperscan
	./run_snort_mthread_x86_numa.sh $i numa1 hyperscan
done

#echo "$CMD"
#eval $CMD
