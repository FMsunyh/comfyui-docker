#!/bin/bash

###
 # @Author: fmsunyh fmsunyh@gmail.com
 # @Date: 2025-04-15
 # @Description: 部署工作流
###

BASE_DIR="${1:-/work/comfyui-docker/}"
APP="${2:-comfyui}"
WORKFLOW_DIR="$BASE_DIR/workflows"
TARGET_DIR="$BASE_DIR/volumes/$APP/data/user/default/workflows"

# 判断 workflow 源目录是否存在并且不为空
if [ -d "$WORKFLOW_DIR" ] && [ "$(ls -A "$WORKFLOW_DIR")" ]; then
    cp "$WORKFLOW_DIR"/* "$TARGET_DIR"
    echo "✅ Workflows copied to $TARGET_DIR"
else
    echo "⚠️ No workflows found in $WORKFLOW_DIR. Skipping copy."
fi
