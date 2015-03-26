#!/bin/bash

OPTIND=1

bucket=""

show_help () {
  echo "Usage: pull.sh -b <bucket> <source>:<destination>..."
}

pull () {
  bucket=$1
  source=$2
  dest=$3

  echo "s3://$bucket/$source => $dest"
  aws s3 cp "s3://$bucket/$source" "$dest"
}

while getopts "hb:" opt; do
  case "$opt" in
    h|\?)
      show_help
      exit 0
      ;;
    b)
      bucket=$OPTARG
      ;;
  esac
done
shift $((OPTIND-1))

if [ -z "$bucket" ]; then
  echo "Bucket not set"
  show_help
  exit 1
fi

for x in $@
do
  IFS=':' read -a array <<< "$x"
  source="${array[0]}"
  dest="${array[1]}"

  pull $bucket $source $dest
done
