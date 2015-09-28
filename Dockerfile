# Build environment for CyanogenMod

FROM ubuntu:14.04
MAINTAINER Michael Stucki <mundaun@gmx.ch>

ENV DEBIAN_FRONTEND noninteractive

RUN sed -i 's/main$/main universe/' /etc/apt/sources.list
RUN apt-get -qq update

RUN apt-get install -y bsdmainutils curl file screen
RUN apt-get install -y android-tools-adb android-tools-fastboot
RUN apt-get install -y bison build-essential flex git gnupg gperf libesd0-dev liblz4-tool libncurses5-dev libsdl1.2-dev libwxgtk2.8-dev libxml2 libxml2-utils lzop openjdk-7-jdk openjdk-7-jre pngcrush schedtool squashfs-tools xsltproc zip zlib1g-dev
RUN apt-get install -y ccache g++-multilib gcc-multilib lib32ncurses5-dev lib32readline-gplv2-dev lib32z1-dev
RUN apt-get install -y tig rsync

# Workaround for apt-get upgrade issue described here: https://github.com/dotcloud/docker/issues/1724
# If you still have problems with upgrading this image, you most likely use an outdated base image
RUN dpkg-divert --local --rename /usr/bin/ischroot && ln -sf /bin/true /usr/bin/ischroot

# Workaround for screen: /usr/bin/screen cannot be installed with setgid "utmp": https://github.com/stucki/docker-cyanogenmod/issues/2
# Install screen with setuid root instead (that's ok on a single-user system)
RUN chmod u+s /usr/bin/screen
RUN chmod 755 /var/run/screen

RUN apt-get -qqy upgrade

RUN mkdir -p /home/cmbuild && useradd --no-create-home cmbuild && rsync -a /etc/skel/ /home/cmbuild/

RUN mkdir /home/cmbuild/bin
RUN curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > /home/cmbuild/bin/repo
RUN chmod a+x /home/cmbuild/bin/repo

# Add sudo permission
RUN echo "cmbuild ALL=NOPASSWD: ALL" > /etc/sudoers.d/cmbuild

# Fix ownership
RUN chown -R cmbuild:cmbuild /home/cmbuild

ADD startup.sh /root/startup.sh
RUN chmod a+x /root/startup.sh

# Set global variables
ADD android-env-vars.sh /etc/android-env-vars.sh
RUN echo "source /etc/android-env-vars.sh" >> /etc/bash.bashrc

VOLUME /home/cmbuild/android
VOLUME /srv/ccache

CMD /root/startup.sh

# This does not work yet, see https://github.com/docker/docker/issues/9806
#USER cmbuild
#WORKDIR /home/cmbuild/android
