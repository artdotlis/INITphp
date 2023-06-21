FROM docker.io/rockylinux:8

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG WORK_DIR=/workspace
ENV HOME="/home/${USERNAME}"

COPY . /tmp/app

WORKDIR /tmp/app

RUN bash ./bin/deploy/prep.sh && bash ./bin/deploy/req.sh

WORKDIR /

RUN rm -rf /tmp/app

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m -d $HOME $USERNAME 

RUN mkdir -p $WORK_DIR && \
    chown $USERNAME:$USERNAME -R $WORK_DIR && \
    mkdir -p "${HOME}/.local/bin" && \
    chown $USERNAME:$USERNAME -R $HOME


RUN git config --global --add safe.directory $WORK_DIR

USER $USERNAME

RUN mkdir -p "${WORK_DIR}/public"

ENTRYPOINT ["/bin/sh", "/entry_dev.sh"]