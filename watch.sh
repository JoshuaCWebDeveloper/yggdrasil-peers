#!/bin/bash
export VERSION=12
touch "/shared_etc/hosts_crawled$VERSION"
SLEEP=10
while :
do
  echo "peers crawl loop"
  tmp=$(mktemp)
  cat hosts_header > $tmp
  cat "/shared_etc/hosts_crawled$VERSION" >> $tmp

  if diff $tmp /shared_etc/yg_hosts > /dev/null
  then
      echo "No difference, skip update, increase sleep"
      SLEEP=10
  else
      SLEEP=10
      cat $tmp > /shared_etc/yg_hosts
      echo "Difference, update yg_hosts, reset sleep"
  fi
  rm $tmp
  cat /shared_etc/yg_hosts
  echo "run crawl script"
  python3 -u example.py
  echo "ran script"

  sleep $SLEEP
done