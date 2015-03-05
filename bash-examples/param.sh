#!/bin/bash
echo $#
while getopts "h?vf:a:" opt; do
    case "$opt" in
    h|\?)
        echo "show help"
        exit 0
        ;;
    v)  verbose=1
        echo "set verbose"
        ;;
    f)  output_file=$OPTARG
		echo "set output "$output_file
        ;;
    a)  archive_file=$OPTARG
		echo "set output "$archive_file
        ;;
    esac 
done