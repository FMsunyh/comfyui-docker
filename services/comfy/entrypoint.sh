#!/bin/bash

set -Eeuo pipefail

declare -A MOUNTS

PLUGIN_DIR="/data/custom_nodes"

MOUNTS["${APP_DIR}/.cache"]="/data/.cache"
MOUNTS["${APP_DIR}/input"]="/data/input"
MOUNTS["${APP_DIR}/temp"]="/data/temp"
MOUNTS["${APP_DIR}/custom_nodes"]=$PLUGIN_DIR
MOUNTS["${APP_DIR}/models"]="/data/models"
MOUNTS["${APP_DIR}/user/default/workflows"]="/data/user/default/workflows"

MOUNTS["${APP_DIR}/output"]="/output"

echo "[INFO] Setting up mount directories..."

for to_path in "${!MOUNTS[@]}"; do
  from_path="${MOUNTS[$to_path]}"
  parent_dir="$(dirname "$to_path")"

  echo "[INFO] Mount: $from_path -> $to_path"

  # 宿主机目录不存在，则创建（可能是第一次运行）
  if [ ! -d "$from_path" ]; then
    echo "[INFO] Creating host directory: $from_path"
    mkdir -p "$from_path"
    chown "${USERNAME}:${USERNAME}" "$from_path"
  fi

  # 容器目标目录存在，且不是符号链接，说明第一次运行
  if [ -d "$to_path" ] && [ ! -L "$to_path" ]; then
    if [ -z "$(ls -A "$from_path")" ]; then
      echo "[INFO] First time run. Copying contents from container to host: $to_path -> $from_path"
      cp -a "$to_path/." "$from_path/"
      chown -R "${USERNAME}:${USERNAME}" "$from_path"
    fi
    echo "[INFO] Removing original container dir: $to_path"
    rm -rf "$to_path"
  fi

  # 如果 $to_path 已存在但不是正确的软链，删除它
  if [ -e "$to_path" ] || [ -L "$to_path" ]; then
    if [ "$(readlink "$to_path" 2>/dev/null)" != "$from_path" ]; then
      echo "[INFO] Removing existing file or invalid symlink: $to_path"
      rm -rf "$to_path"
    fi
  fi

  # 🛠️ 确保软链接的父目录存在（重点修复）
  mkdir -p "$parent_dir"

  # 创建软链接
  if [ ! -e "$to_path" ]; then
    ln -s "$from_path" "$to_path"
    echo "[INFO] Created symlink: $to_path -> $from_path"
  fi
done

# echo "🔍 Searching for plugin requirements in $PLUGIN_DIR..."

# # 遍历插件目录，寻找 requirements.txt 并安装依赖
# for plugin in "$PLUGIN_DIR"/*; do
#     if [ -d "$plugin" ]; then
#         if [ -f "$plugin/requirements.txt" ]; then
#             echo "📦 Installing requirements for plugin: $(basename "$plugin")"
#             pip install --no-cache-dir -r "$plugin/requirements.txt"
#         else
#             echo "ℹ️ No requirements.txt found in: $(basename "$plugin")"
#         fi
#     fi
# done


# 如果存在自定义启动脚本，运行它
if [ -f "/data/config/comfy/startup.sh" ]; then
  echo "[INFO] Running custom startup script..."
  pushd "$APP_DIR" > /dev/null
  . /data/config/comfy/startup.sh
  popd > /dev/null
fi


echo "✅ All plugin dependencies processed."

echo "[INFO] Entrypoint complete. Executing command: $*"
exec "$@"
