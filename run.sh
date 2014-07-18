#!/bin/sh

cd $(dirname $0)

SOURCE=$(pwd)/android
CONTAINER_HOME=/home/cmbuild
CONTAINER=cyanogenmod
REPOSITORY=stucki/cyanogenmod

# Create a shared folder which will be used as working directory if it 
# does not already exists.
mkdir -p $SOURCE

# Build image if needed
IMAGE_EXISTS=$(docker images -q $REPOSITORY)
if [ $? -ne 0 ]; then
	echo "docker command not found"
	exit $?
elif [[ -z $IMAGE_EXISTS ]]; then
	docker build --no-cache --rm -t $REPOSITORY .
fi

# With the given name $CONTAINER, reconnect to running container, start 
# an existing/stopped container or run a new one if one does not exists.
IS_RUNNING=$(docker inspect -f '{{.State.Running}}' $CONTAINER 2>/dev/null)
if [[ $IS_RUNNING == "true" ]]; then
	docker attach $CONTAINER
elif [[ $IS_RUNNING == "false" ]]; then
	docker start -i $CONTAINER
else
	docker run -v $SOURCE:$CONTAINER_HOME/android -i -t --name $CONTAINER $REPOSITORY sh -c "screen -s /bin/bash";
fi

exit $?
