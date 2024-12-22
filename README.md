# Knulli Build
This builds docker images as well as a set of scripts that are used for building knulli.  This also enables building knulli from Windows.

# What is Knulli?
Knulli is an Embedded Linux OS (or custom firmware) for a collection of gaming handheld devices.  See [https://knulli.org/](https://knulli.org/) for more details on knulli.

# Why use this?
Knulli can be built without this, and their build already uses Docker.  This is not necessary to build Knulli. 

There are some differences in how this builds images compared to the standard build in Knulli
- Can be launched using docker compose to build the images with minimal user input.
- Can be launched from Windows
- Uses a volume for the build itself
  - This can be deleted after the build completes or it can be used for iterative builds
- This stores the toolchain in a volume
- This supports an interactive and non-interactive mode

# Buildable Targets

The following table shows various devices and targets so you can see what devices this can compile to.  This was accurate at the time of writing but may be out of date (more devices may be added, some devices may be removed.)

There is no support for any software compiled against this tree as this tree is intended to assist and help developers build knulli.

| Manufacturer | Model           | Target  | Status   |
| ------------ | --------------- | ------- | -------- |
| Anbernic     | RG28XX          | h700    | Compiles |
| Anbernic     | RG34XX          | h700    | Compiles |
| Anbernic     | RG35XX Original | atm7039 | Fails to compile in bluez_utils-5.78 |
| Anbernic     | RG35XX Plus     | h700    | Compiles |
| Anbernic     | RG35XX SP | h700 | Compiles |
| Anbernic     | RG35XX H        | h700    | Compiles |
| Anbernic     | RG35XX 2024     | h700    | Compiles |
| Anbernic     | RG40XX H        | h700    | Compiles |
| Anbernic     | RG40XX V        | h700    | Compiles |
| Anbernic     | AG-Arc-S        | rk3566  | Not produced with RK3566 build |
| Anbernic     | RG-CubeXX       | h700    | Compiles |
| Anbernic     | RGXX3           | rk3568  ||
| Powkiddy     | a12             | rk3128  ||
| Powkiddy     | a13             | rk3128  ||
| Powkiddy     | RGB30           | rk3566  |  |
| Powkiddy     | RGB30           | rk3568  ||
| Powkiddy     | x55             | rk3566  | Compiles |
| Trim UI      | Brick           | a133    |          |
| Trim UI      | Smart Pro       | a133    |          |
| Miyoo        | A30             | r16     |          |
| Retroid      | Pocket 5        | sm8250  |          |
| Retroid      | Pocket Mini     | sm8250  |          |


# File Listing

| File / Location          | Purpose                                                      |
| ------------------------ | ------------------------------------------------------------ |
| compose/*.yaml           | Docker compose files for building different targets          |
| docker-image-interactive | Docker image file for an interactive environment             |
| docker-image             | Docker image file for a non-interactive environment          |
| compose.sh               | Script that will make a symbolic link to the appropriate compose file in compose/ |
| interactive.sh           | Script that will launch into a docker container in interactive mode.  This can be used on currently running containers. |
| keys.txt                 | This is optional.                                            |
| keys.txt.sample          | This is                                                      |

# Volumes and Binds

| Source                     | Type   | Location                         | Description                                                  |
| -------------------------- | ------ | -------------------------------- | ------------------------------------------------------------ |
| knulli_build-<TARGET>      | volume | /home/developer/build            | Knulli is built here                                         |
| knulli_toolchain-<TARGET>  | volume | /home/developer/toolchain        | Cross compilation toolchain is installed here.  This is only needed for building apps outside of the knulli makefile.<br /><br />This will be archived into the ./output folder in case it is preferred to do cross-compilation outside of the docker image. |
| knulli_buildcache-<TARGET> | volume | /home/developer/.buildroot-cache | This is the buildroot compiler cache.  This is stored in a volume so that it is not dropped when the container is dropped. |
| keys.txt                   | bind   | /home/developer/keys.txt         | This file contains various keys used by Emulation Station that cannot be committed into a repository. |
| output                     | bind   | /home/developer/output           | This is used to copy the device images as well as toolchain archives out of the docker image so that they are available on the host operating system. |



## keys.txt

```SCREENSCRAPER_DEV_LOGIN=
SCREENSCRAPER_DEV_LOGIN=
GAMESDB_APIKEY=
CHEEVOS_DEV_LOGIN=
HFS_DEV_LOGIN=
```

| Variable                | Service                                                | Key Example                             |
| ----------------------- | ------------------------------------------------------ | --------------------------------------- |
| SCREENSCRAPER_DEV_LOGIN | [https://screenscraper.fr/](https://screenscraper.fr/) | devid=<username>&devpassword=<password> |
| GAMESDB_APIKEY          | https://thegamesdb.net                                 |                                         |
| CHEEVOS_DEV_LOGIN       | https://retroachievements.org/                         | abcd0123acbd0123                        |
| HFS_DEV_LOGIN           |                                                        |                                         |

# Unattended Build

This will perform a build of the image and the docker container will exit once completed.  See "Buildable Targets" above for a list of applicable targets.

If you are doing iterative development on a package or part of the build system, this is not an efficient way to perform your builds.

**Performing a clean build**

- Delete the knulli_build-<TARGET> to delete intermediate files and cause the source to be re-downloaded from source control
- Delete the knulli_buildroot_cache-<TARGET> to delete the buildroot_cache.

If you would like to do a full build, you may delete the knulli_build-<TARGET> volume and all intermediate files excluding the build

```
$ ./compose.sh <TARGET>
```

# Iterative Development

Coming soon.

# TODO List

- Add support to build other forks and branches
  - This will be done using environment variables
