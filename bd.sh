#/bin/bash

UNAME=$(uname)
function get_cpu_count()
{
    if [ ${UNAME} = "Darwin" ] ; then
        CPU_COUNT=$(sysctl -n hw.ncpu)
    else
        CPU_COUNT=$(grep processor /proc/cpuinfo | wc -l)
    fi
}

get_cpu_count
if [ x$CPU_COUNT = x ] ; then
   CPU_COUNT=4
fi
echo "cpu count:[${CPU_COUNT}]"

build_cmd="make -j$CPU_COUNT > build.out 2>&1"
echo "$build_cmd"
make -j $CPU_COUNT > build.out 2>&1
