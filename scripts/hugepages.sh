#!/bin/bash

mkdir -p /dev/hugepages

echo 1024 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages

mount -t hugetlbfs nodev /dev/hugepages

