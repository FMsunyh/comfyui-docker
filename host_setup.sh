#!/bin/bash
# host_setup.sh

for d in flux wan2.1; do
  mkdir -p $d/data
  mkdir -p $d/output
  chown -R aigc:aigc $d
done


