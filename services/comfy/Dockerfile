FROM pytorch/pytorch:2.5.1-cuda12.4-cudnn9-runtime

ENV DEBIAN_FRONTEND=noninteractive PIP_PREFER_BINARY=1

# 用户参数
ARG UID=1001
ENV USERNAME=aigc
ENV HOME_DIR=/home/${USERNAME}
ENV APP_DIR=${HOME_DIR}/app
ENV PIP_CACHE_DIR=${HOME_DIR}/.cache/pip

# 创建用户
RUN groupadd -g ${UID} ${USERNAME} && \
  useradd -l -u ${UID} -g ${UID} -m -s /bin/bash -N ${USERNAME}

# 安装依赖
RUN apt-get update && apt-get install -y \
  git \
  ffmpeg \
  libsm6 \
  libxext6 \
  openssl \
  gcc \
  g++ \
  rsync \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# 创建目录 + 修正权限
RUN mkdir -p ${HOME_DIR}  ${PIP_CACHE_DIR}  ${APP_DIR} && \
  chown -R ${USERNAME}:${USERNAME} ${HOME_DIR} ${APP_DIR}

# 切换到非 root 用户
USER ${USERNAME}
WORKDIR ${APP_DIR}

# pip 镜像
RUN pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/

# 将 ComfyUI 克隆为中间缓存层（避免频繁变动）
# 注意：尽量提前克隆本地，然后 COPY，否则 clone 无法缓存
RUN git clone https://github.com/comfyanonymous/ComfyUI.git ${APP_DIR}

# 固定版本，避免不必要更新
WORKDIR ${APP_DIR}
RUN git checkout 2f7d8159c32de22c15fbeea7ff9063f2231586bb

# 安装 ComfyUI 依赖（利用 pip 缓存挂载）
RUN --mount=type=cache,target=${PIP_CACHE_DIR} \
  pip install -r requirements.txt

# 拷贝脚本文件到 /docker 目录，确保权限没问题
COPY --link --chown=${USERNAME}:${USERNAME} . /docker/

# 配置启动脚本
RUN chmod u+x /docker/entrypoint.sh && cp /docker/extra_model_paths.yaml ${APP_DIR}

# 安装额外 requirements
RUN --mount=type=cache,target=${PIP_CACHE_DIR} \
  pip install -r /docker/requirements.txt

ENV NVIDIA_VISIBLE_DEVICES=all \
  PYTHONPATH="${PYTHONPATH}:${PWD}" \
  CLI_ARGS=""

EXPOSE 7860

ENTRYPOINT ["/docker/entrypoint.sh"]
CMD ["sh", "-c", "python -u main.py --listen $CLI_ARGS"]
