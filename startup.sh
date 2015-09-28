#!/bin/sh

# Initialize ccache if needed
if [ ! -f /srv/ccache/CACHEDIR.TAG ]; then
	echo "Initializing ccache in /srv/ccache..."
	CCACHE_DIR=/srv/ccache ccache -M 50G
fi

# Fix permissions. This is needed temporarily to migrate old projects which were still checked out as root.
# It can be removed at some point in the future.
# For performance reasons, only search on the first level.
for i in "/home/cmbuild/android" "/srv/ccache"; do
	if [ $(find $i -maxdepth 1 -user root | wc -l) -gt 0 ]; then
		echo "Fixing permissions on $i..."
		chown -R cmbuild:cmbuild $i
	fi
done

# Fix console permissions as long as https://github.com/docker/docker/issues/9806 is not fixed
usermod --groups tty --append cmbuild
chgrp tty /dev/console
chmod g+rw /dev/console

su -c "cd /home/cmbuild/android; screen -s /bin/bash" cmbuild
