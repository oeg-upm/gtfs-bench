#!/bin/bash

#
# Copyright (c) 2022 SPARQL Anything Contributors @ http://github.com/sparql-anything
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

declare -a mem=("32768" "16384" "8192" "4096" "1024" "512" "256")

function errcho {
  echo >&2 "$@"
}

function execute-query() {
  memory="-Xmx$1m"
  SPARQL_ANYTHING_JAR=$2
  QUERY_FILE=$3
  ERR_FILE=$4

  t0=$(gdate +%s%3N)
  # echo "java $memory -jar $SPARQL_ANYTHING_JAR -q $QUERY_FILE 2>>ERR_FILE > /dev/null "
  java $memory -jar $SPARQL_ANYTHING_JAR -q $QUERY_FILE 2>>ERR_FILE >/dev/null
  t1=$(gdate +%s%3N)
  total_time=$(($total + $t1 - $t0))

  echo "$QUERY_FILE $total_time ms"
}

function monitor-query {

  cd $1
  QUERY=$2
  STRATEGY=$3
  SLICE=$4
  FORMAT=$5
  TMP_FOLDER=$6
  if [ -z ${6+x} ]; then
    QUERY_FILE=$2-${FORMAT}-${STRATEGY}-${SLICE}.sparql
    ON_DISK="False"
  else
    QUERY_FILE=$2-${FORMAT}-${STRATEGY}-${SLICE}-ondisk.sparql
    ON_DISK="True"
  fi

  #echo "Query File $QUERY_FILE : 1 $1 STRATEGY $STRATEGY SLICE $SLICE $ON_DISK $6 $FORMAT"

  MEM_FILE="$RESULTS_DIR/mem_${QUERY}_${FORMAT}.tsv"
  TIME_FILE="$RESULTS_DIR/time_${QUERY}_${FORMAT}.tsv"

  if [[ ! -f $MEM_FILE ]]; then
    echo -e "Query InputSize Strategy Slice Ondisk MemoryLimit Run PID %cpu %mem vsz rss" >>$MEM_FILE
    echo -e "Query\tInputSize\tStrategy\tSlice\tOndisk\tMemoryLimit\tRun\tTime\tUnit\tStatus\tSTDErr" >>$TIME_FILE
  fi

  for mm in "${mem[@]}"; do
    memory="-Xmx${mm}m"
    total=0

    RUN_CNT=0

    for i in 1 2 3; do
      #echo "java $memory -jar $SPARQL_ANYTHING_JAR -q $QUERY_FILE 2>>ERR_FILE > /dev/null &"

      echo -n -e "$(date): $QUERY\t$1\t$mm\t$STRATEGY\t$SLICE\t ondisk:$ON_DISK\t$1\t RUN $i\t$FORMAT"

      MEM_RECORDS=""
      if [[ -f ERR_FILE ]]; then
        rm ERR_FILE
      fi

      t0=$(gdate +%s%3N)
      CNT=0
      java $memory -jar $SPARQL_ANYTHING_JAR -q $QUERY_FILE 2>>ERR_FILE >/dev/null &
      MPID=$!
      while kill -0 $MPID 2>/dev/null; do
        MEM_RECORDS+="$QUERY $1 $STRATEGY $SLICE $ON_DISK $mm RUN$i $(ps -p $MPID -o pid,%cpu,%mem,vsz,rss | sed 1d)\n"
        CNT=$((CNT + 1))
        if [[ "$CNT" -eq 1500 ]]; then
          echo "Error: Timeout 300s" >>ERR_FILE
          echo "Error: Timeout 300s"
          kill $MPID 2>/dev/null
          break
        fi
        sleep 0.2
      done
      t1=$(gdate +%s%3N)
      RUN_CNT=$((RUN_CNT + 1))

     # WRITE MEM_RECORDS ON FILE
      echo -e -n $MEM_RECORDS >>$MEM_FILE
      #echo $ERR
      if [[ "$(cat ERR_FILE)" == *"Error"* ]]; then
        STATUS="Error"
      elif [[ "$(cat ERR_FILE)" == *"Exception"* ]]; then
        STATUS="Exception"
      else
        STATUS="OK"
      fi

      total=$(($total + $t1 - $t0))
      TIME_RUN="$QUERY\t$1\t$STRATEGY\t$SLICE\t$ON_DISK\t$mm\tRUN$i\t$(($t1 - $t0))\tms\t$STATUS\t$(cat ERR_FILE)"
      echo -e $TIME_RUN >>$TIME_FILE
      #echo -e $TIME_RUN
      echo -e "\t$(($t1 - $t0))ms\t$STATUS\t$(cat ERR_FILE)"
      sleep 1

      if [[ "$(cat ERR_FILE)" == *"Timeout"* ]]; then
        break
      fi

      if [[ "$(cat ERR_FILE)" == *"OutOfMemoryError"* ]]; then
        echo "OutOfMemoryError"
        break
      fi

      if [[ "$(cat ERR_FILE)" == *"Exception"* ]]; then
        echo "Exception"
        break
      fi

      if [[ $ON_DISK == "True" ]]; then
        rm -rf $TMP_FOLDER/*
      fi

    done


  done

  sed 's/ \{1,\}/\t/g' $MEM_FILE >$MEM_FILE~
  rm $MEM_FILE
  mv $MEM_FILE~ $MEM_FILE
  cd ..

}

function monitor-query-singlerun-notimeout {

  cd $1
  STRATEGY=$3
  SLICE=$4
  QUERY=$2
  FORMAT=$5
  QUERY_FILE=$2-${FORMAT}-${STRATEGY}-${SLICE}.sparql
  MEMORY=$6

  MEM_FILE="$RESULTS_DIR/mem_${QUERY}_${FORMAT}.tsv"
  TIME_FILE="$RESULTS_DIR/time_${QUERY}_${FORMAT}.tsv"

  if [[ ! -f $MEM_FILE ]]; then
    echo -e "Query InputSize Strategy Slice MemoryLimit PID %cpu %mem vsz rss" >>$MEM_FILE
    echo -e "Query\tInputSize\tStrategy\tSlice\tMemoryLimit\tTime\tUnit\tStatus\tSTDErr" >>$TIME_FILE
  fi

  total=0

  RUN_CNT=0

  echo "$(date): $QUERY LIMIT $MEMORY mb - $STRATEGY - $SLICE - SIZE $1 - FORMAT $FORMAT "

  MEM_RECORDS=""
  if [[ -f ERR_FILE ]]; then
    rm ERR_FILE
  fi

  t0=$(gdate +%s%3N)
  java $MEMORY -jar $SPARQL_ANYTHING_JAR -q $QUERY_FILE 2>>ERR_FILE >/dev/null &
  MPID=$!
  while kill -0 $MPID 2>/dev/null; do
    MEM_RECORDS+="$QUERY $1 $STRATEGY $SLICE $MEMORY $(ps -p $MPID -o pid,%cpu,%mem,vsz,rss | sed 1d)\n"
    sleep 0.2
  done
  t1=$(gdate +%s%3N)
  echo -e -n $MEM_RECORDS >>$MEM_FILE
  if [ "$(cat ERR_FILE)" == *"Error"* ] || [ "$(cat ERR_FILE)" == *"Exception"* ]; then
    STATUS="Error"
  else
    STATUS="OK"
  fi
  if [[ "$(cat ERR_FILE)" == *"OutOfMemoryError"* ]]; then
    break
  fi
  total=$(($total + $t1 - $t0))
  TIME_RUN="$QUERY\t$1\t$STRATEGY\t$SLICE\t$MEMORY\t$(($t1 - $t0))\tms\t$STATUS\t$(cat ERR_FILE)"
  echo -e $TIME_RUN >>$TIME_FILE
  echo -e $TIME_RUN
  sleep 1

  sed 's/ \{1,\}/\t/g' $MEM_FILE >$MEM_FILE~
  rm $MEM_FILE
  mv $MEM_FILE~ $MEM_FILE
  cd ..

}

function monitor-construct-query {

  cd $1
  STRATEGY=$3
  SLICE=$4
  QUERY=$2
  FORMAT=$5
  TMP_FOLDER=$6
  if [ -z ${6+x} ]; then
    QUERY_FILE=$2-${FORMAT}-${STRATEGY}-${SLICE}.sparql
    ON_DISK="False"
  else
    QUERY_FILE=$2-${FORMAT}-${STRATEGY}-${SLICE}-ondisk.sparql
    ON_DISK="True"
  fi

  #echo "Query File $QUERY_FILE : 1 $1 STRATEGY $STRATEGY SLICE $SLICE $ON_DISK $6 $FORMAT"

  MEM_FILE="$RESULTS_DIR/mem_${QUERY}_${FORMAT}.tsv"
  TIME_FILE="$RESULTS_DIR/time_${QUERY}_${FORMAT}.tsv"

  # echo $OUT_FILE

  if [[ ! -f $MEM_FILE ]]; then
    echo -e "Query InputSize Strategy Slice Ondisk MemoryLimit Run PID %cpu %mem vsz rss" >>$MEM_FILE
    echo -e "Query\tInputSize\tStrategy\tSlice\tOndisk\tMemoryLimit\tRun\tTime\tUnit\tStatus\tSTDErr" >>$TIME_FILE
  fi

  for mm in "${mem[@]}"; do
    memory="-Xmx${mm}m"
    total=0

    RUN_CNT=0

    for i in 1 2 3; do
      # echo "java $memory -jar $SPARQL_ANYTHING_JAR -q $QUERY_FILE -o $OUT_FILE -f NT 2>>ERR_FILE > /dev/null &"

      echo -n -e "$(date): $QUERY\t$1\t$mm\t$STRATEGY\t$SLICE\t ondisk:$ON_DISK\t RUN $i\t$FORMAT"
      OUT_FILE="$RESULTS_DIR/$QUERY-$s1-$mm-$STRATEGY-$SLICE-$ON_DISK-$i-$FORMAT.nt"

      MEM_RECORDS=""
      if [[ -f ERR_FILE ]]; then
        rm ERR_FILE
      fi

      t0=$(gdate +%s%3N)
      CNT=0
      java $memory -jar $SPARQL_ANYTHING_JAR -q $QUERY_FILE -o $OUT_FILE -f NT 2>>ERR_FILE >/dev/null &
      MPID=$!
      while kill -0 $MPID 2>/dev/null; do
        MEM_RECORDS+="$QUERY $1 $STRATEGY $SLICE $ON_DISK $mm RUN$i $(ps -p $MPID -o pid,%cpu,%mem,vsz,rss | sed 1d)\n"
        CNT=$((CNT + 1))
        if [[ "$CNT" -eq 1500 ]]; then
          echo "Error: Timeout 300s" >>ERR_FILE
          echo "Error: Timeout 300s"
          kill $MPID 2>/dev/null
          break
        fi
        sleep 0.2
      done

      t1=$(gdate +%s%3N)
      RUN_CNT=$((RUN_CNT + 1))
      echo -e -n $MEM_RECORDS >>$MEM_FILE
      #echo $ERR
      if [[ "$(cat ERR_FILE)" == *"Error"* ]]; then
        STATUS="Error"
      elif [[ "$(cat ERR_FILE)" == *"Exception"* ]]; then
        STATUS="Exception"
      else
        STATUS="OK"
      fi

      total=$(($total + $t1 - $t0))
      TIME_RUN="$QUERY\t$1\t$STRATEGY\t$SLICE\t$ON_DISK\t$mm\tRUN$i\t$(($t1 - $t0))\tms\t$STATUS\t$(cat ERR_FILE)"
      echo -e $TIME_RUN >>$TIME_FILE
      #echo -e $TIME_RUN
      echo -e "\t$(($t1 - $t0))ms\t$STATUS\t$(cat ERR_FILE)"
      sleep 1

      if [[ "$(cat ERR_FILE)" == *"Timeout"* ]]; then
        break
      fi

      if [[ "$(cat ERR_FILE)" == *"OutOfMemoryError"* ]]; then
        echo "OutOfMemoryError"
        break
      fi

      if [[ "$(cat ERR_FILE)" == *"Exception"* ]]; then
        echo "Exception"
        break
      fi

      if [[ $ON_DISK == "True" ]]; then
        rm -rf $TMP_FOLDER/*
      fi

    done

  done

  sed 's/ \{1,\}/\t/g' $MEM_FILE >$MEM_FILE~
  rm $MEM_FILE
  mv $MEM_FILE~ $MEM_FILE
  cd ..

}
