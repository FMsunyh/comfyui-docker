#!/bin/bash

set -Eeuo pipefail

# mkdir -vp /data/custom_nodes

declare -A MOUNTS

MOUNTS["${APP_DIR}/.cache"]="/data/.cache"
MOUNTS["${APP_DIR}/input"]="/data/input"
MOUNTS["${APP_DIR}/output"]="/data/output"
MOUNTS["${APP_DIR}/temp"]="/data/temp"

MOUNTS["${APP_DIR}/custom_nodes"]="/data/custom_nodes"
MOUNTS["${APP_DIR}/models"]="/data/models"

MOUNTS["${APP_DIR}/user/default/workflows"]="/data/user/default/workflows"

for to_path in "${!MOUNTS[@]}"; do
  set -Eeuo pipefail
  from_path="${MOUNTS[${to_path}]}"
  rm -rf "${to_path}"
  if [ ! -f "$from_path" ]; then
    mkdir -vp "$from_path"
  fi
  mkdir -vp "$(dirname "${to_path}")"
  ln -sT "${from_path}" "${to_path}"
  echo Mounted $(basename "${from_path}")
done

if [ -f "/data/config/comfy/startup.sh" ]; then
  pushd ${APP_DIR}
  . /data/config/comfy/startup.sh
  popd
fi

exec "$@"
