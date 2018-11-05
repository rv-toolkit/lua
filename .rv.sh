#!/bin/sh
set -x # print debug info

json_out=`pwd`/errors.json
report_out=`pwd`/report

# This is running under Ubuntu 16.04
# Install necessary packages. 
sudo apt update
sudo apt install -y libreadline-dev

# Compile and run `lua`.
compiler=kcc
make -j`nproc` CC=$compiler LD=$compiler CFLAGS="-fissue-report=$json_out" 
rm $json_out

`pwd`/lua -e "print(\"Hello, World!\")"

# Generate a HTML report with `rv-html-report` command,
# and output the HTML report to `./report` directory. 
touch $json_out && rv-html-report $json_out -o $report_out

# Upload your HTML report to RV-Toolkit website with `rv-upload-report` command. 
rv-upload-report $report_out

# Done.
