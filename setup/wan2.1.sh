#!/bin/bash
###
 # @Author: fmsunyh fmsunyh@gmail.com
 # @Date: 2025-04-07
 # @Description: 下载脚本，如果文件已存在则跳过下载
###

#!/bin/bash

# ========== 参数设置 ==========
MAX_JOBS=4  # 最多同时运行的下载任务数
CURRENT_JOBS=0

BASE_DIR="${1:-/work/comfyui-docker/}"

# UNET_DIR="$BASE_DIR/volumes/wan2.1/data/models/unet/Kijai"
CLIP_DIR="$BASE_DIR/volumes/wan2.1/data/models/clip/Kijai"
VAE_DIR="$BASE_DIR/volumes/wan2.1/data/models/vae/Kijai"
DIFFUSION_MODELS_DIR="$BASE_DIR/volumes/wan2.1/data/models/diffusion_models/Kijai"

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
    wget --header="Authorization: Bearer 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" --timeout=30 --tries=3 --waitretry=5 -c -O "$output" "$url" &

    ((CURRENT_JOBS++))
    if (( CURRENT_JOBS >= MAX_JOBS )); then
      wait -n  # 等待任意一个任务结束
      ((CURRENT_JOBS--))
    fi
  fi
}

# ========== 创建目录 ==========
# create_dir_if_not_exists "$UNET_DIR"
create_dir_if_not_exists "$CLIP_DIR"
create_dir_if_not_exists "$VAE_DIR"
create_dir_if_not_exists "$DIFFUSION_MODELS_DIR"

# 下载文件列表
download_if_not_exists "$VAE_DIR"/Wan2_1_VAE_bf16.safetensors "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Wan2_1_VAE_bf16.safetensors"
download_if_not_exists "$VAE_DIR"/Wan2_1_VAE_fp32.safetensors "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Wan2_1_VAE_fp32.safetensors"

download_if_not_exists "$DIFFUSION_MODELS_DIR"/Wan2.1-Fun-Control-14B_fp8_e4m3fn.safetensors "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Wan2.1-Fun-Control-14B_fp8_e4m3fn.safetensors"
download_if_not_exists "$DIFFUSION_MODELS_DIR"/Wan2.1-Fun-InP-14B_fp8_e4m3fn.safetensors "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Wan2.1-Fun-InP-14B_fp8_e4m3fn.safetensors"
download_if_not_exists "$DIFFUSION_MODELS_DIR"/Wan2_1-I2V-14B-720P_fp8_e4m3fn.safetensors "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Wan2_1-I2V-14B-720P_fp8_e4m3fn.safetensors"
download_if_not_exists "$DIFFUSION_MODELS_DIR"/Wan2_1-T2V-14B_fp8_e4m3fn.safetensors "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Wan2_1-T2V-14B_fp8_e4m3fn.safetensors"
download_if_not_exists "$DIFFUSION_MODELS_DIR"/Wan2_1_SkyreelsA2_fp8_e4m3fn.safetensors "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Wan2_1_SkyreelsA2_fp8_e4m3fn.safetensors"
download_if_not_exists "$DIFFUSION_MODELS_DIR"/Wan2_1_VACE_1_3B_preview_bf16.safetensors "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Wan2_1_VACE_1_3B_preview_bf16.safetensors"

download_if_not_exists "$CLIP_DIR"/open-clip-xlm-roberta-large-vit-huge-14_visual_fp16.safetensors "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/open-clip-xlm-roberta-large-vit-huge-14_visual_fp16.safetensors"
download_if_not_exists "$CLIP_DIR"/open-clip-xlm-roberta-large-vit-huge-14_visual_fp32.safetensors "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/open-clip-xlm-roberta-large-vit-huge-14_visual_fp32.safetensors"

download_if_not_exists "$CLIP_DIR"/umt5-xxl-enc-bf16.safetensors "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/umt5-xxl-enc-bf16.safetensors"
download_if_not_exists "$CLIP_DIR"/umt5-xxl-enc-fp8_e4m3fn.safetensors "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/umt5-xxl-enc-fp8_e4m3fn.safetensors"

# 等待所有后台任务完成
wait

echo "所有文件下载完成！"

