FROM alpine:latest
MAINTAINER juca <juca@juan-carlos.info>

ENV APP_NAME="tendenci" \
    TENDENCI_USER="tendenci" \
    TENDENCI_HOME="/home/tendenci" \
    TENDENCI_LOG_DIR="/var/log/tendenci" \
    TENDENCI_INSTALL_DIR="/home/tendenci/install" \
    TENDENCI_STATIC_DIR="/home/tendenci/static" \
    TENDENCI_PROJECT_ROOT="/home/tendenci/install/tendenci"

RUN mkdir "$TENDENCI_HOME" "$TENDENCI_LOG_DIR" "$TENDENCI_INSTALL_DIR" "$TENDENCI_STATIC_DIR" 

RUN    apk update  \
    && apk add bash 
RUN apk add \
  --no-cache \
  --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
  --repository http://dl-cdn.alpinelinux.org/alpine/edge/main

#    && apk add install  unattended-upgrades update-notifier-common \
#    && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure -plow unattended-upgrades  \
RUN    apk add --no-cache gdal \
        python3 python3-dev python-pip  \
        libevent-dev libpq-dev \
        libjpeg libjpeg-dev \
	libfreetype libfreetype-dev git  \
    && apk cache clean \
    && apk add update 

RUN apk add install -y locales && locale-gen en_US.UTF-8  
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

COPY assets/build/ "$TENDENCI_HOME"
COPY assets/runtime/run.sh /runtime/run.sh

RUN bash -x "$TENDENCI_HOME/install.sh"

VOLUME "$TENDENCI_PROJECT_ROOT" "$TENDENCI_LOG_DIR"

WORKDIR "$TENDENCI_INSTALL_DIR"

ENTRYPOINT [ "/bin/bash" ]
CMD [ "/runtime/run.sh" ]
