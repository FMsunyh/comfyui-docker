#!/bin/bash

###
 # @Author: fmsunyh fmsunyh@gmail.com
 # @Date: 2025-04-15
 # @Description: 部署工作流
###

BASE_DIR="${1:-/work/comfyui-docker/}"
APP="${2:-comfyui}"

cp "$BASE_DIR/workflows/"* "$BASE_DIR/volumes/$APP/data/user/default/workflows"