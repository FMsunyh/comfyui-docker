#!/bin/bash
###
 # @Author: fmsunyh fmsunyh@gmail.com
 # @Date: 2025-04-15
 # @Description: 为$APP应用，下载模型
###

#!/bin/bash

# ========== 参数设置 ==========
MAX_JOBS=4  # 最多同时运行的下载任务数
CURRENT_JOBS=0

BASE_DIR="${1:-/work/comfyui-docker/}"
APP="${2:-comfyui}"

CHECKPOINTS_DIR="$BASE_DIR/volumes/$APP/data/models/checkpoints"
CLIP_DIR="$BASE_DIR/volumes/$APP/data/models/clip"
VAE_DIR="$BASE_DIR/volumes/$APP/data/models/vae"
DIFFUSION_MODELS_DIR="$BASE_DIR/volumes/$APP/data/models/diffusion_models"
UPSCALE_MODELS_DIR="$BASE_DIR/volumes/$APP/data/models/upscale_models"
LORAS_DIR="$BASE_DIR/volumes/$APP/data/models/loras"

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
create_dir_if_not_exists "$CHECKPOINTS_DIR"
create_dir_if_not_exists "$CLIP_DIR"
create_dir_if_not_exists "$VAE_DIR"
create_dir_if_not_exists "$DIFFUSION_MODELS_DIR"
create_dir_if_not_exists "$UPSCALE_MODELS_DIR"
create_dir_if_not_exists "$LORAS_DIR"

# 下载文件列表
download_if_not_exists "$CHECKPOINTS_DIR"/majicMIX-realistic-麦橘写实_v2威力加强典藏版.safetensors "https://liblibai-online.liblib.cloud/web/model/d7e2ac2f4a1f8853a327e38ec8b8fabc000205d17722ad055d84f2507c84b9ac.safetensors?auth_key=1745292980-b5c5fad68d814a798419e31288c833d1-0-f1e3851672c3120b4e4107e6181cb997&attname=majicMIX%20realistic%20%E9%BA%A6%E6%A9%98%E5%86%99%E5%AE%9E_v2%E5%A8%81%E5%8A%9B%E5%8A%A0%E5%BC%BA%E5%85%B8%E8%97%8F%E7%89%88.safetensors"
download_if_not_exists "$VAE_DIR"/vae-ft-mse-840000-ema-pruned.safetensors "https://huggingface.co/stabilityai/sd-vae-ft-mse-original/resolve/main/vae-ft-mse-840000-ema-pruned.safetensors"
download_if_not_exists "$LORAS_DIR"/场景-飘落的花_v1.0.safetensors "https://liblibai-online.liblib.cloud/web/model/6d7b61cdedae494e9311d971de3ac9d2/7674c2e106bf440a56fbec1db0e1f91643eb944e843c4eeb1a9b2a44c8b226e3.safetensors?auth_key=1745293215-83bbdd57c73340cba0f0b9d4d46b185d-0-af006cfa609205d3f48b41fe52c73574&attname=%E5%9C%BA%E6%99%AF-%E9%A3%98%E8%90%BD%E7%9A%84%E8%8A%B1_v1.0.safetensors"

download_if_not_exists "$LORAS_DIR"/dit_lora.safetensors "https://huggingface.co/bytedance-research/UNO/resolve/main/dit_lora.safetensors"

download_if_not_exists "$LORAS_DIR"/Detailed_Hands-000001.safetensors "https://civitai-delivery-worker-prod.5ac0637cfd0766c97916cefa3764fbdf.r2.cloudflarestorage.com/model/150004/detailedHands000001.5uPQ.safetensors?X-Amz-Expires=86400&response-content-disposition=attachment%3B%20filename%3D%22Detailed_Hands-000001.safetensors%22&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=e01358d793ad6966166af8b3064953ad/20250502/us-east-1/s3/aws4_request&X-Amz-Date=20250502T170821Z&X-Amz-SignedHeaders=host&X-Amz-Signature=6693c7392df619e570205e335d8611ae31746f8446fa4f795e746ae0213fbeac"
download_if_not_exists "$LORAS_DIR"/"Hand v2.safetensors" "https://civitai-delivery-worker-prod.5ac0637cfd0766c97916cefa3764fbdf.r2.cloudflarestorage.com/model/1269491/hand20v2.iTXo.safetensors?X-Amz-Expires=86400&response-content-disposition=attachment%3B%20filename%3D%22Hand%20v2.safetensors%22&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=e01358d793ad6966166af8b3064953ad/20250502/us-east-1/s3/aws4_request&X-Amz-Date=20250502T162258Z&X-Amz-SignedHeaders=host&X-Amz-Signature=b6afeeb7d000b2c4483ca87d86b803a6eb035f51ef21cbaa5b0dfa38d7801a9a"

download_if_not_exists "$CHECKPOINTS_DIR"/sd3.5_large.safetensors "https://huggingface.co/stabilityai/stable-diffusion-3.5-large/resolve/main/sd3.5_large.safetensors"


# 等待所有后台任务完成
wait

echo "所有文件下载完成！"

