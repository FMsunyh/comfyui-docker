#!/bin/bash
# host_setup.sh

for d in volumes/flux volumes/wan2.1 volumes/comfyui volumes/comfyui-dev; do
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


# ==========  创建extra_model_paths.yaml ==========
cat <<EOF > volumes/comfyui/data/extra_model_paths.yaml
flux:
  base_path: /volumes/flux/data/models

  adetailer: adetailer
  blip: blip
  checkpoints: checkpoints
  clip: clip
  clip_vision: clip_vision
  configs: configs
  controlnet: controlnet
  deepdanbooru: deepdanbooru
  diffusers: diffusers
  diffusion_models: diffusion_models
  gligen: gligen
  hypernetworks: hypernetworks
  karlo: karlo
  LLM: LLM
  loras: loras
  LyCORIS: LyCORIS
  midas: midas
  openpose: openpose
  photomaker: photomaker
  pulid: pulid
  style_models: style_models
  text encoders: text encoders
  unet: unet
  upscale_models: upscale_models
  vae: vae
  vae_approx: vae_approx

wan2.1:
  base_path: /volumes/wan2.1/data/models

  adetailer: adetailer
  blip: blip
  checkpoints: checkpoints
  clip: clip
  clip_vision: clip_vision
  configs: configs
  controlnet: controlnet
  deepdanbooru: deepdanbooru
  diffusers: diffusers
  diffusion_models: diffusion_models
  gligen: gligen
  hypernetworks: hypernetworks
  karlo: karlo
  LLM: LLM
  loras: loras
  LyCORIS: LyCORIS
  midas: midas
  openpose: openpose
  photomaker: photomaker
  pulid: pulid
  style_models: style_models
  text encoders: text encoders
  unet: unet
  upscale_models: upscale_models
  vae: vae
  vae_approx: vae_approx
EOF


# ==========  创建extra_model_paths.yaml ==========
cat <<EOF > volumes/comfyui-dev/data/extra_model_paths.yaml
flux:
  base_path: /volumes/flux/data/models

  adetailer: adetailer
  blip: blip
  checkpoints: checkpoints
  clip: clip
  clip_vision: clip_vision
  configs: configs
  controlnet: controlnet
  deepdanbooru: deepdanbooru
  diffusers: diffusers
  diffusion_models: diffusion_models
  gligen: gligen
  hypernetworks: hypernetworks
  karlo: karlo
  LLM: LLM
  loras: loras
  LyCORIS: LyCORIS
  midas: midas
  openpose: openpose
  photomaker: photomaker
  pulid: pulid
  style_models: style_models
  text encoders: text encoders
  unet: unet
  upscale_models: upscale_models
  vae: vae
  vae_approx: vae_approx

wan2.1:
  base_path: /volumes/wan2.1/data/models

  adetailer: adetailer
  blip: blip
  checkpoints: checkpoints
  clip: clip
  clip_vision: clip_vision
  configs: configs
  controlnet: controlnet
  deepdanbooru: deepdanbooru
  diffusers: diffusers
  diffusion_models: diffusion_models
  gligen: gligen
  hypernetworks: hypernetworks
  karlo: karlo
  LLM: LLM
  loras: loras
  LyCORIS: LyCORIS
  midas: midas
  openpose: openpose
  photomaker: photomaker
  pulid: pulid
  style_models: style_models
  text encoders: text encoders
  unet: unet
  upscale_models: upscale_models
  vae: vae
  vae_approx: vae_approx
EOF
