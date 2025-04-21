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

# UNET_DIR="$BASE_DIR/volumes/$APP/data/models/unet/Kijai"
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
# create_dir_if_not_exists "$UNET_DIR"
create_dir_if_not_exists "$CLIP_DIR"
create_dir_if_not_exists "$VAE_DIR"
create_dir_if_not_exists "$DIFFUSION_MODELS_DIR"
create_dir_if_not_exists "$UPSCALE_MODELS_DIR"
create_dir_if_not_exists "$LORAS_DIR"

# 下载文件列表
# download_if_not_exists "$VAE_DIR"/wan_2.1_vae.safetensors "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors"

# download_if_not_exists "$DIFFUSION_MODELS_DIR"/wan2.1_i2v_480p_14B_fp16.safetensors "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/diffusion_models/wan2.1_i2v_480p_14B_fp16.safetensors"
# download_if_not_exists "$DIFFUSION_MODELS_DIR"/wan2.1_i2v_720p_14B_fp16.safetensors "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/diffusion_models/wan2.1_i2v_720p_14B_fp16.safetensors"
# download_if_not_exists "$DIFFUSION_MODELS_DIR"/wan2.1_t2v_14B_fp16.safetensors "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/diffusion_models/wan2.1_t2v_14B_fp16.safetensors"
# download_if_not_exists "$DIFFUSION_MODELS_DIR"/wan2.1_t2v_1.3B_fp16.safetensors "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Wan2_1-T2V-14B_fp8_e4m3fn.safetensors"

# download_if_not_exists "$CLIP_DIR"/umt5_xxl_fp16.safetensors "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp16.safetensors"
# download_if_not_exists "$CLIP_DIR"/umt5_xxl_fp8_e4m3fn_scaled.safetensors "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors"


download_if_not_exists "$UPSCALE_MODELS_DIR"/4xRealWebPhoto_v4_dat2.safetensors "https://huggingface.co/Phips/4xRealWebPhoto_v4_dat2/resolve/main/4xRealWebPhoto_v4_dat2.safetensors"
download_if_not_exists "$UPSCALE_MODELS_DIR"/4x-UltraSharp.pth "https://huggingface.co/lokCX/4x-Ultrasharp/resolve/main/4x-UltraSharp.pth"
download_if_not_exists "$UPSCALE_MODELS_DIR"/GFPGANv1.4.pth "https://huggingface.co/uwg/upscaler/resolve/main/GFPGAN/GFPGANv1.4.pth"
download_if_not_exists "$UPSCALE_MODELS_DIR"/16xPSNR.pth "https://huggingface.co/uwg/upscaler/resolve/main/ESRGAN/16xPSNR.pth"
download_if_not_exists "$UPSCALE_MODELS_DIR"/8x_NMKD-Typescale_175k.pth "https://huggingface.co/uwg/upscaler/resolve/main/ESRGAN/8x_NMKD-Typescale_175k.pth"
download_if_not_exists "$UPSCALE_MODELS_DIR"/8x_NMKD-Superscale_150000_G.pth "https://huggingface.co/uwg/upscaler/resolve/main/ESRGAN/8x_NMKD-Superscale_150000_G.pth"
download_if_not_exists "$UPSCALE_MODELS_DIR"/4x_NMKD-Superscale-SP_178000_G.pth "https://huggingface.co/uwg/upscaler/resolve/main/ESRGAN/4x_NMKD-Superscale-SP_178000_G.pth"
download_if_not_exists "$UPSCALE_MODELS_DIR"/4x_NMKD-Siax_200k.pth "https://huggingface.co/gemasai/4x_NMKD-Siax_200k/resolve/main/4x_NMKD-Siax_200k.pth"

download_if_not_exists "$LORAS_DIR"/Flux-Dev-4-step.safetensors "https://liblibai-online.liblib.cloud/web/model/84cd9ecbef5b4333afb1125200e50242/c41f8106c9f02c94f89c0fbad50f143409b89d5007916e573cda39b78a3d8a37.safetensors?auth_key=1745231116-305efad2866e4e458f501a0399f8c6fc-0-113ca53dd39d41bbed413f6e324694d4&attname=Flux%20Dev%E6%A8%A1%E5%9E%8B4%E6%AD%A5%E5%87%BA%E5%9B%BElora_Flux%20Dev%E6%A8%A1%E5%9E%8B4%E6%AD%A5%E5%87%BA%E5%9B%BElora_Flux%20Dev%204-step.safetensors"

# 等待所有后台任务完成
wait

echo "所有文件下载完成！"

