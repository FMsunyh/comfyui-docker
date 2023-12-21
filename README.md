# ComfyUI-Docker
ComfyUI-Docker

github官网 [ComfyUI](https://github.com/comfyanonymous/ComfyUI)

应用名称：ComfyUI

## ComfyUI Docker 镜像更新
支持的插件：
- 

### comfyui:100

``` bash
docker pull  registry.cn-shenzhen.aliyuncs.com/ai_base/comfyui:100
```

#### 内容
- 第一个版本
- 内置filebrowser


#### 启动容器
```bash
sudo docker run --gpus all --name comfyui -p 7860:7860 registry.cn-shenzhen.aliyuncs.com/ai_base/comfyui:100
```
