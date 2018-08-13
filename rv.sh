#!/bin/sh
set -x
set -e
# This is running under Ubuntu 16.04
# Install necessary packages. 
sudo apt-get install -y libreadline-dev

VERSION=5.3.4
tar_tests=lua-$VERSION-tests.tar.gz
wget https://www.lua.org/tests/$tar_tests
tar -xzf $tar_tests

json_out=`pwd`/my_errors.json
compiler=kcc
reportflag="CFLAGS=-fissue-report=$json_out"
sudo make -j`nproc` CC=$compiler LD=$compiler $reportflag 
ls -la

../lua -e "print(\"Hello, World!\")"

(
cd lua-$VERSION-tests/
../lua sort.lua
)

ls -la
wc -l my_errors.json

# Generate a HTML report with `rv-html-report` command,
# and output the HTML report to `./report` directory. 
rv-html-report my_errors.json -o report

# Upload your HTML report to RV-Toolkit website with `rv-upload-report` command. 
rv-upload-report `pwd`/report

# Done.