
#!/bin/bash

###
 # @Author: fmsunyh fmsunyh@gmail.com
 # @Date: 2025-04-15
 # @Description: 为comyfui应用 下载插件,如果插件已经存在更新
###

BASE_DIR="${1:-/work/comfyui-docker/}"
APP="${2:-comfyui}"

# 目标目录
TARGET_DIR="$BASE_DIR/volumes/$APP/data/custom_nodes"

# 仓库地址列表（请替换为你真实的10个仓库）
REPOS=(
  "git@github.com:Comfy-Org/ComfyUI-Manager.git"
)

MAX_RETRIES=3

# 确保目标目录存在
mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR" || exit 1

# 开始处理每个仓库
for REPO in "${REPOS[@]}"; do
  REPO_NAME=$(basename "$REPO" .git)
  echo "=============================="
  echo "📦 Processing: $REPO_NAME"

  if [ -d "$REPO_NAME/.git" ]; then
    echo "📁 $REPO_NAME already exists, pulling latest changes..."
    cd "$REPO_NAME" || continue
    git pull
    cd ..
  else
    COUNT=0
    while [ $COUNT -lt $MAX_RETRIES ]; do
      git clone "$REPO" "$REPO_NAME" && break

      COUNT=$((COUNT+1))
      echo "⚠️ Clone failed. Retry #$COUNT in 5 seconds..."
      sleep 5
    done

    if [ $COUNT -eq $MAX_RETRIES ]; then
      echo "❌ Failed to clone $REPO_NAME after $MAX_RETRIES attempts."
    else
      echo "✅ Successfully cloned $REPO_NAME."
    fi
  fi

  echo "=============================="
done