# ComfyUI-Docker
ComfyUI-Docker

github官网 [ComfyUI](https://github.com/comfyanonymous/ComfyUI)


## 部署步骤
1. 执行host_setup.sh
    ```bash
    bash host_setup.sh
    ```
2. 启动容器

- 启动 正式环境 comfyui
    端口：62799
    ```
    docker-compose --profile comfyui up -d
    ```

- 启动 flux生图
    端口：62801
    ```
    docker-compose --profile flux up -d
    ```

- 启动 wan2.1生图
    端口：62802
    ```
    docker-compose --profile wan2.1 up -d
    ```

- 启动 默认生图,开发环境 dev-comfyui
    端口：62803
    ```
    docker-compose --profile dev-comfyui up -d
    ```

3. 下载模型

    ```bash
    cd comfyui-docker
    bash setup/flux.sh "$PWD"
    bash setup/wan2.1.sh "$PWD"
    bash setup/wan2.1_Comfy-Org.sh "$PWD"
    bash setup/comfyui.sh "$PWD" "comfyui"
    ```
    
4. 下载插件
    ```bash
    cd comfyui-docker
    bash setup/clone_or_pull_custom_nodes.sh "$PWD" "comfyui"
    ```

5. 部署工作流
    参数一是当前工作目录，参数2是应用名称
    ```bash
    cd comfyui-docker
    bash setup/copy_workflows.sh "$PWD" "comfyui"
    ```

6. 下载常用的模型
    
    ```bash
    cd comfyui-docker
    bash setup/download_models.sh "$PWD" "comfyui-dev"

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
