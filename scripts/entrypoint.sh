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
    --vdev=net_tap0,iface=tap0 \
    --vdev=net_tap1,iface=tap1 2>&1 | tee "$LOG_FILE"  &
DPDK_PID=$!

sleep 2

ip addr add 10.0.0.1/24 dev tap0
ip addr add 10.0.0.2/24 dev tap1

timeout 20s bash -c '
    while true; do
        arping -I tap0 -c 1 -w 10 10.0.0.2 -q >/dev/null 2>&1
        sleep 0.001
    done
' &
TRAFFIC_PID=$!

wait $TRAFFIC_PID 2>/dev/null

kill $DPDK_PID 2>/dev/null