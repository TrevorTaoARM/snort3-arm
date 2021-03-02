#!/bin/bash
echo "Please input the result dir:"

echo "Runtime:"
./tradir.sh $1 | xargs grep -i "runtime" | cut -d ":" -f 3,4,5
echo "Pkts/sec:"
./tradir.sh $1 | xargs grep -i "pkts/sec" | cut -d ":" -f 3
echo "Mbits/sec:"
./tradir.sh $1 | xargs grep -i "mbits/sec" |  cut -d ":" -f 3
