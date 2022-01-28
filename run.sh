#!/bin/bash

mkdir output_counts
cd snap/examples/temporalmotifs/

for suffix in all_journals Top4 IMS_family RSS_family
do
  filename="../../../data_edge_streams2/data_edge_streams_${suffix}.txt"
  echo ${filename}
  for delta in 10 5 3 0
    do
      output_name="../../../output_counts/counts_${suffix}_${delta}.txt"
      echo ${output_name}
      ./temporalmotifsmain -i:${filename} -delta:${delta} -o:${output_name}
    done
done

#for suffix in \
#AIHPP AISM AoAS AoP AoS AuNZ Bay Bcs \
#Bern Biost Bka CanJS CSDA CSTM EJS Extrem ISRe JASA \
#JCGS JClas JMLR JMVA JNS JoAS JRSSA JRSSB
#do
#  filename="../../../data_edge_streams2/edge_streams_by_journals/data_edge_streams_${suffix}.txt"
#  echo ${filename}
#  for delta in 10 5 3 0
#    do
#      output_name="../../../output_counts/counts_${suffix}_${delta}.txt"
#      echo ${output_name}
#      ./temporalmotifsmain -i:${filename} -delta:${delta} -o:${output_name}
#    done
#done

for suffix in decade_1 decade_2 decade_3 decade_4
do
  filename="../../../data_edge_streams2/data_edge_streams_all_family_${suffix}.txt"
  echo ${filename}
  for delta in 0 
    do
      output_name="../../../output_counts/counts_${suffix}_${delta}.txt"
      echo ${output_name}
      ./temporalmotifsmain -i:${filename} -delta:${delta} -o:${output_name}
    done
done
