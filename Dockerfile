FROM ubuntu:18.10
MAINTAINER juca <juca@juan-carlos.info>

ENV APP_NAME="tendenci" \
    TENDENCI_USER="tendenci" \
    TENDENCI_HOME="/home/tendenci" \
    TENDENCI_LOG_DIR="/var/log/tendenci" \
    TENDENCI_INSTALL_DIR="/home/tendenci/install" \
    TENDENCI_STATIC_DIR="/home/tendenci/static" \
    TENDENCI_PROJECT_ROOT="/home/tendenci/install/tendenci"

RUN mkdir "$TENDENCI_HOME" "$TENDENCI_LOG_DIR" "$TENDENCI_INSTALL_DIR" "$TENDENCI_STATIC_DIR" 

RUN    DEBIAN_FRONTEND=noninteractive apt-get update -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends apt-utils \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y unattended-upgrades update-notifier-common \
    && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure -plow unattended-upgrades  \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y gdal-bin \
        python3 python3-dev python3-pip  \
        libevent-dev libpq-dev \
        libjpeg8 libjpeg-dev \
	libfreetype6 libfreetype6-dev git  \
    && DEBIAN_FRONTEND=noninteractive apt-get clean \
    && DEBIAN_FRONTEND=noninteractive apt-get update 

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y locales && locale-gen en_US.UTF-8  
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

COPY assets/build/ "$TENDENCI_HOME"
COPY assets/runtime/run.sh /runtime/run.sh

RUN bash -x "$TENDENCI_HOME/install.sh"

VOLUME "$TENDENCI_PROJECT_ROOT" "$TENDENCI_LOG_DIR"

WORKDIR "$TENDENCI_INSTALL_DIR"

ENTRYPOINT [ "/bin/bash" ]
CMD [ "/runtime/run.sh" ]
