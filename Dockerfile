FROM alpine/git:2.36.2 as download

COPY clone.sh /clone.sh

# comfyui
RUN . /clone.sh ComfyUI https://github.com/comfyanonymous/ComfyUI.git  a1e1c69f7d555ae281ec46ca7a40c7195f3a249c

# plugin
RUN . /clone.sh ComfyUI-Manager https://github.com/ltdrdata/ComfyUI-Manager.git efc304dd2d09404cf8bd34b0cfb7a0205af2d758
RUN . /clone.sh AIGODLIKE-ComfyUI-Translation https://github.com/AIGODLIKE/AIGODLIKE-ComfyUI-Translation.git db97fed4e8d54d70757911d0b6bb8bdde189d505
RUN . /clone.sh ComfyUI_Custom_Nodes_AlekPet https://github.com/AlekPet/ComfyUI_Custom_Nodes_AlekPet.git 30778102f8629094ebf819aa2ef689a3455d1128
RUN . /clone.sh sdxl_prompt_styler https://github.com/twri/sdxl_prompt_styler.git 95eea10c7024376903cee1185088d50c0965299d
RUN . /clone.sh ComfyUI-Custom-Scripts https://github.com/pythongosssss/ComfyUI-Custom-Scripts.git 27555d4f71bb4e24b87571f89eab2b4a06677bb6
RUN . /clone.sh ComfyUI-AnimateDiff-Evolved https://github.com/Kosinkadink/ComfyUI-AnimateDiff-Evolved.git 27f0d2a8211634edf1bf0c269d92c8b03ba72886

FROM fmsunyh/sd-auto:75

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV ROOT=/ComfyUI
WORKDIR ${ROOT}

RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
RUN --mount=type=cache,target=/var/cache/apt \
  apt-get update && \
  # we need those
  apt-get install -y openssh-server vim  aria2

USER root

RUN echo 'root:l6y#VJWJA4LGr1eI' | chpasswd 

##config ssh
RUN echo 'Port 22' >> /etc/ssh/sshd_config 
RUN echo 'PermitRootLogin yes' >>  /etc/ssh/sshd_config
RUN mkdir /var/run/sshd

# RUN mkdir -vp ${ROOT}/extensions

COPY --from=download /repositories/ComfyUI ${ROOT}
RUN --mount=type=cache,target=/root/.cache/pip \
  cd ${ROOT} && \
  pip install -r requirements.txt

# RUN rm -rf ${ROOT}/models/
COPY ./data/models ${ROOT}/models


# Copy plugin
COPY --from=download /repositories/ComfyUI-Manager ${ROOT}/custom_nodes/ComfyUI-Manager
COPY --from=download /repositories/AIGODLIKE-ComfyUI-Translation ${ROOT}/custom_nodes/AIGODLIKE-ComfyUI-Translation
COPY --from=download /repositories/ComfyUI_Custom_Nodes_AlekPet ${ROOT}/custom_nodes/ComfyUI_Custom_Nodes_AlekPet
COPY --from=download /repositories/sdxl_prompt_styler ${ROOT}/custom_nodes/sdxl_prompt_styler
COPY --from=download /repositories/ComfyUI-Custom-Scripts ${ROOT}/custom_nodes/ComfyUI-Custom-Scripts
COPY --from=download /repositories/ComfyUI-AnimateDiff-Evolved ${ROOT}/custom_nodes/ComfyUI-AnimateDiff-Evolved

COPY ./data/ComfyUI-AnimateDiff-Evolved/models ${ROOT}/custom_nodes/ComfyUI-AnimateDiff-Evolved/models
COPY ./data/ComfyUI-AnimateDiff-Evolved/motion_lora ${ROOT}/custom_nodes/ComfyUI-AnimateDiff-Evolved/motion_lora

# COPY ./cache/huggingface/hub /root/.cache/huggingface/hub 

COPY ./data/filebrowser  /opt/filebrowser
COPY  ./server_app.sh /opt/server_app.sh

ENV NVIDIA_VISIBLE_DEVICES=all
ENV CLI_ARGS=""
EXPOSE 22
EXPOSE 7860
EXPOSE 8080
ENTRYPOINT [""]
STOPSIGNAL SIGINT
ENTRYPOINT ["/bin/bash", "/opt/server_app.sh"]
