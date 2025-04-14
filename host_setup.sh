#!/bin/bash
# host_setup.sh

for d in flux wan2.1; do
  for subdir in data output; do
    dir="$d/$subdir"
    if [ -d "$dir" ]; then
      echo "Directory $dir already exists, skipping."
    else
      mkdir -p "$dir"
      echo "Created directory $dir"
    fi
  done

  # Set ownership if main folder exists
  if [ -d "$d" ]; then
    chown -R aigc:aigc "$d"
    echo "Set ownership for $d"
  fi
done
