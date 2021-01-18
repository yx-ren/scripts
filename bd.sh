#/bin/bash

build_cmd="build.sh > build.out 2>&1"
echo "$build_cmd"
./build.sh > build.out 2>&1
if [ $? != 0 ]; then
    echo "build failed"
fi
