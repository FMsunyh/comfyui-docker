FROM alpine/git:2.36.2 as download

COPY clone.sh /clone.sh
RUN . /clone.sh ComfyUI https://github.com/comfyanonymous/ComfyUI.git  a1e1c69f7d555ae281ec46ca7a40c7195f3a249c

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

RUN mkdir -vp ${ROOT}/extensions
COPY --from=download /repositories/ComfyUI ${ROOT}
RUN --mount=type=cache,target=/root/.cache/pip \
  cd ${ROOT} && \
  pip install -r requirements.txt

# RUN rm -rf ${ROOT}/models/
COPY ./data/models ${ROOT}/models

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
