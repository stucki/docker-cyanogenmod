#!/bin/bash

cd $(dirname $0)

SOURCE=$(pwd)/android
CCACHE=$(pwd)/ccache
CONTAINER_HOME=/home/cmbuild
CONTAINER=cyanogenmod
REPOSITORY=stucki/cyanogenmod
FORCE_BUILD=0

# Create shared folders
mkdir -p $SOURCE
mkdir -p $CCACHE

# Build image if needed
IMAGE_EXISTS=$(docker images -q $REPOSITORY)
if [ $? -ne 0 ]; then
	echo "docker command not found"
	exit $?
elif [[ -z $IMAGE_EXISTS ]] || [[ $FORCE_BUILD = 1 ]]; then
	echo "Building Docker image $REPOSITORY..."
	docker build --no-cache --rm -t $REPOSITORY .
fi

# With the given name $CONTAINER, reconnect to running container, start
# an existing/stopped container or run a new one if one does not exist.
IS_RUNNING=$(docker inspect -f '{{.State.Running}}' $CONTAINER 2>/dev/null)
if [[ $IS_RUNNING == "true" ]]; then
	docker attach $CONTAINER
elif [[ $IS_RUNNING == "false" ]]; then
	docker start -i $CONTAINER
else
	docker run --privileged -v /dev/bus/usb:/dev/bus/usb -v $SOURCE:$CONTAINER_HOME/android -v $CCACHE:/srv/ccache -i -t --name $CONTAINER $REPOSITORY sh -c "screen -s /bin/bash"
fi

exit $?
