# ComfyUI-Docker
ComfyUI-Docker

github官网 [ComfyUI](https://github.com/comfyanonymous/ComfyUI)


## 部署步骤
1. 执行host_setup.sh
```bash
bash host_setup.sh
```

2. 启动容器
```
docker-compose --profile flux up -d
```

3. 下载模型
```bash
bash /work/comfyui-docker/setup/setup_flux.sh /work/comfyui-docker/volumes
```

## 相关操作
- 杀掉下载脚本进程

```bash
pkill -f wget
```