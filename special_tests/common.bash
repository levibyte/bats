#!/bin/bash

mkdir -p  dir
mkdir -p  not_exisiting_dir
touch not_writable_file -f
chmod 555 not_writable_file -f
mkdir -p  dir
mkdir -p  not_writable_dir
chmod 555 not_writable_dir/ -f

if [ -f .count ]; then
chmod 777 .count
fi

rm -rf .count
#chmod 777 .count -f
touch .count -f
#fix unstabillity
chmod 777 .count -f
echo 0 > .count
chmod 555 .count -f

