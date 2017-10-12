docker-lineageos
==================

Create a [Docker] based environment to build [LineageOS].

This Dockerfile will create a docker container which is based on Ubuntu 16.04.
It will install the "repo" utility and any other build dependencies which are required to compile LineageOS (formerly known as CyanogenMod).

The main working directory is a shared folder on the host system, so the Docker container can be removed at any time.

**NOTE:** Remember that LineageOS is a huge project. It will consume a large amount of disk space (~80 GB) and it can easily take hours to build.

### How to run/build

**NOTES:**
* You will need to [install Docker][Docker_Installation] to proceed!
* If an image does not exist, ```docker build``` is executed first

```
git clone https://github.com/stucki/docker-lineageos.git
cd docker-lineageos
./run.sh
```

The `run.sh` script accepts the following switches:

* -u|--enable-usb - runs the container in privileged mode (this way you can use adb right from the container)
* -r|--rebuild - force rebuild the image from scratch
* -ws|--with-su - Sets the WITH_SU environment variable to true (your builds will include the su binary)

The container uses "screen" to run the shell. This means that you will be able to open additional shells using [screen keyboard shortcuts][Screen_Shortcuts].

### How to build LineageOS for your device

```
repo init -u git://github.com/lineageos/android.git -b cm-14.1
repo sync -c -j 16
source build/envsetup.sh
breakfast <device codename>   # example: breakfast grouper
brunch <device codename>      # example: brunch grouper
```

### ADB in the container
If you're on Linux and want to use adb from within the container running with `-u` might not be enough. Make sure you have the [Android udev rules](https://github.com/M0Rf30/android-udev-rules/blob/master/51-android.rules) installed on your host system so you can access your device without needing superuser permissions.

### Links

For further information, check the following links:

* [CyanogenMod Building Basics][Cyanogenmod_Building_Basics]
* [Build Instructions for Google Nexus 5][LineageOS_Build_Nexus5] (example device, search the wiki for other devices)

### More information

* [Discussion thread @ XDA developers]

==================

[Docker]:                      https://www.docker.io/
[LineageOS]:                   http://lineageos.org/
[Docker_Installation]:         https://www.docker.io/gettingstarted/
[Screen_Shortcuts]:            http://www.pixelbeat.org/lkdb/screen.html
[CyanogenMod_Building_Basics]: https://web-beta.archive.org/web/20161224192643/http://wiki.cyanogenmod.org/w/Development
[LineageOS_Build_Nexus5]:    https://wiki.lineageos.org/devices/hammerhead/build
[Discussion thread @ XDA developers]: http://forum.xda-developers.com/showthread.php?t=2650345
[dotcloud/docker#2224]:        https://github.com/dotcloud/docker/issues/2224
