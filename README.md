# ComfyUI-Docker
ComfyUI-Docker

github官网 [ComfyUI](https://github.com/comfyanonymous/ComfyUI)

应用名称：ComfyUI

## SSH配置
用户名： root
密码：l6y#VJWJA4LGr1eI
端口：22

## filebrowser配置
用户名：admin
密码：admin
端口：8080

## ComfyUI Docker 镜像更新
支持的插件：
- 


### comfyui:101

``` bash
docker pull  registry.cn-shenzhen.aliyuncs.com/ai_base/comfyui:101
```

#### 内容
- 插件
  - 升级AnimateDiff v3
  - 添加contorlnet模型 + t2iadapter模型
  - 添加upscale_models 模型
  - 插件管理器
  - 汉化


#### 启动容器
```bash
sudo docker run --gpus all --name comfyui -p 7860:7860 registry.cn-shenzhen.aliyuncs.com/ai_base/comfyui:101
```



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
