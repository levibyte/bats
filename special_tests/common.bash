#!/bin/bash

mkdir -p  dir
mkdir -p  not_exisiting_dir
touch not_writable_file
chmod 555 not_writable_file
mkdir -p  dir
mkdir -p  not_writable_dir
chmod 555 not_writable_dir/

#fix unstabillity
chmod 777 .count
echo 0 > .count
chmod 555 .count
