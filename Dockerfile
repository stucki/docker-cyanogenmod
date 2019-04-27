# Build environment for LineageOS

FROM ubuntu:16.04
MAINTAINER Michael Stucki <michael@stucki.io>


ENV \
# ccache specifics
    CCACHE_SIZE=50G \
    CCACHE_DIR=/srv/ccache \
    USE_CCACHE=1 \
    CCACHE_COMPRESS=1 \
# Extra include PATH, it may not include /usr/local/(s)bin on some systems
    PATH=$PATH:/usr/local/bin/

RUN sed -i 's/main$/main universe/' /etc/apt/sources.list \
 && export DEBIAN_FRONTEND=noninteractive \
 && apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y \
# Install build dependencies (source: https://wiki.cyanogenmod.org/w/Build_for_bullhead)
      bc \
      bison \
      build-essential \
      ccache \
      curl \
      flex \
      g++-multilib \
      gcc-multilib \
      git \
      gnupg \
      gperf \
      imagemagick \
      lib32ncurses5-dev \
      lib32readline-dev \
      lib32z1-dev \
      liblz4-tool \
      libncurses5-dev \
      libsdl1.2-dev \
      libssl-dev \
      libwxgtk3.0-dev \
      libxml2 \
      libxml2-utils \
      lzop \
      pngcrush \
      rsync \
      schedtool \
      squashfs-tools \
      xsltproc \
      zip \
      zlib1g-dev \
# Install Java Development Kit
      openjdk-8-jdk \
# Maven is required for building LineageOS 13
      maven \
# Install additional packages which are useful for building Android
      android-tools-adb \
      android-tools-fastboot \
      bash-completion \
      bsdmainutils \
      file \
      nano \
      screen \
      sudo \
      tig \
      vim \
      wget \
 && rm -rf /var/lib/apt/lists/*

ARG hostuid=1000
ARG hostgid=1000

RUN \
    groupadd --gid $hostgid --force build && \
    useradd --gid $hostgid --uid $hostuid --non-unique build && \
    rsync -a /etc/skel/ /home/build/

RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/local/bin/repo \
 && chmod a+x /usr/local/bin/repo

# Add sudo permission
RUN echo "build ALL=NOPASSWD: ALL" > /etc/sudoers.d/build

ADD startup.sh /home/build/startup.sh
RUN chmod a+x /home/build/startup.sh

# Fix ownership
RUN chown -R build:build /home/build

VOLUME /home/build/android
VOLUME /srv/ccache

USER build
WORKDIR /home/build/android

CMD /home/build/startup.sh
