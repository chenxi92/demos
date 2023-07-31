#! /bin/bash

set -eu

for file in $(ls $(pwd)); do
	if [[ -d "$(pwd)/$file" ]]; then
		echo "\ncd $file/"
		cd $file
		sh build.sh
		cd ..
	fi
done