#!/bin/bash

mkdir -p /logs

LOG_FILE="/logs/dpdk_test_$(date +%Y%m%d_%H%M%S).log"

if [ -f /scripts/hugepages.sh ]; then
    /scripts/hugepages.sh
fi

stdbuf -o0 -e0 ./build/rxtx_callbacks \
    -l 0 \
    -n 4 \
    --no-pci \
    --vdev=net_af_packet0,iface=eth0 \
    --vdev=net_af_packet1,iface=eth0 2>&1 | tee "$LOG_FILE"  &
DPDK_PID=$!

sleep 2


apt-get update > /dev/null 2>&1 &
APT_PID=$!

wait $APT_PID

kill $DPDK_PID 2>/dev/null
