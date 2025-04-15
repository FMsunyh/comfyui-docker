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
cd comfyui-docker
bash setup/flux.sh "$PWD"
bash setup/wan2.1.sh "$PWD"
bash setup/wan2.1_Comfy-Org.sh "$PWD"
```

## 相关操作
- 杀掉下载脚本进程

```bash
pkill -f wget
```

## 问题解决
- huggingface Username/Password Authentication Failed.
```
https://discuss.huggingface.co/t/private-repo-wget-download-not-working-why/55934

wget --header="Authorization: Bearer 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" --timeout=30 --tries=3 --waitretry=5 -c -O "$output" "$url" &
```
