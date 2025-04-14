#!/bin/bash

# ========== 参数设置 ==========
BASE_DIR="${1:-/work/comfyui-docker/}"

UNET_DIR="$BASE_DIR/volumes/flux/data/models/unet"
CLIP_DIR="$BASE_DIR/volumes/flux/data/models/clip"
VAE_DIR="$BASE_DIR/volumes/flux/data/models/vae"

# ========== 工具函数 ==========

# 如果目录不存在则创建
create_dir_if_not_exists() {
  local dir="$1"
  if [ ! -d "$dir" ]; then
    echo "📁 创建目录：$dir"
    mkdir -p "$dir"
  else
    echo "📂 目录已存在，跳过：$dir"
  fi
}

# 如果文件不存在则下载
download_if_not_exists() {
  local output="$1"
  local url="$2"

  if [ -f "$output" ]; then
    echo "✅ 文件已存在，跳过下载：$output"
  else
    echo "⬇️ 开始下载：$output"
    wget -c -O "$output" "$url" &
  fi
}

# ========== 创建目录 ==========
create_dir_if_not_exists "$UNET_DIR"
create_dir_if_not_exists "$CLIP_DIR"
create_dir_if_not_exists "$VAE_DIR"

# ========== 下载模型 ==========
download_if_not_exists "$UNET_DIR/flux1-dev.safetensors" \
  "https://huggingface.co/lllyasviel/flux1_dev/resolve/main/flux1-dev-fp8.safetensors?download=true"

download_if_not_exists "$CLIP_DIR/t5xxl_fp16.safetensors" \
  "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp16.safetensors?download=true"

download_if_not_exists "$CLIP_DIR/clip_l.safetensors" \
  "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors?download=true"

download_if_not_exists "$VAE_DIR/ae.safetensors" \
  "https://huggingface.co/black-forest-labs/FLUX.1-schnell/resolve/main/ae.safetensors?download=true"

# ========== 等待所有下载完成 ==========
wait

echo "🎉 所有模型文件已下载完成！"


cp "$BASE_DIR/workflows/flux_dev_example.json" "$BASE_DIR/volumes/flux/data/user/default/workflows"
# bash setup_flux.sh /your/custom/path