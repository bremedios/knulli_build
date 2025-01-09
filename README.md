# Knulli Build

This builds docker images as well as a set of scripts that are used for building knulli.  This also enables building knulli from Windows.

# What is Knulli?

Knulli is an Embedded Linux OS (or custom firmware) for a collection of gaming handheld devices.  See [https://knulli.org/](https://knulli.org/) for more details on knulli.

# Why use this?

Knulli can be built without this, and their build already uses Docker.  This is not necessary to build Knulli.

This currently has the following benefits

1. Single step build if knulli is already installed
   
   > ``` $ ./compose.sh <TARGET> ```

2. Uses a series of volumes for the different sections of the build
   
   1. Allows keeping or removing build directories for specific builds

3. Extracts toolchain and images automatically

# Should I Use This For Iterative Development?

At this time, Iterative development when using the make <TARGET>-pkg PKG=<PACKAGE> does not work due to permissions issue when .stamp_built, .stamp_target* and .stamp_staging are deleted.

This issue has been tracked to the use of DIRECT_BUILD=1 and also happens if the standard docker environment is used.

# Docker Resource Notes

The build can be pretty resource intensive from both a system memory and disk usage perspective.

Please ensure that the disk and memory limits are set appropriately for your system prior to starting.

> The non-interactive builds consume more memory because they
> 
> - Install the toolchain to its own volume
> - Export an archive of the toolchain in ./output (host)
> - Copy the device images to ./output (host)
> 
> You can work around this additional storage usage by manually building knulli, skipping the toolchain installation and
> only copying out the device images that matter to you.

### Memory

It has been observed that the build can consume > 11 GB of RAM at its peak, but this limit will likely be reliant on what is being build and how many builds your system can complete in parallel.  The more cores, the more RAM you will likely require.

If your system is running out of RAM, you will notice that your builds will fail with an error that a program has been killed.

### Disk

You may want to set a disk size limit to docker to ensure that it does not grow beyond the desired maximum disk usage in the system.

# TODO

- [ ] Create volume for source downloads

- [ ] Add support for forks and branches

# Buildable Targets

The following table shows various devices and targets so you can see what devices this can compile to.  This was accurate at the time of writing but may be out of date (more devices may be added, some devices may be removed.)

There is no support for any software compiled against this tree as this tree is intended to assist and help developers build knulli.

| Manufacturer | Model           | Target  | Status                                                  |
| ------------ | --------------- | ------- | ------------------------------------------------------- |
| Anbernic     | RG28XX          | h700    | Compiles                                                |
| Anbernic     | RG34XX          | h700    | Compiles                                                |
| Anbernic     | RG35XX Original | atm7039 | Fails to compile in bluez_utils-5.78                    |
| Anbernic     | RG35XX Plus     | h700    | Compiles                                                |
| Anbernic     | RG35XX SP       | h700    | Compiles                                                |
| Anbernic     | RG35XX H        | h700    | Compiles                                                |
| Anbernic     | RG35XX 2024     | h700    | Compiles                                                |
| Anbernic     | RG40XX H        | h700    | Compiles                                                |
| Anbernic     | RG40XX V        | h700    | Compiles                                                |
| Anbernic     | AG-Arc-S        | rk3566  | Not produced with RK3566 build                          |
| Anbernic     | RG-CubeXX       | h700    | Compiles                                                |
| Anbernic     | RGXX3           | rk3568  | Fails to compile due to missing x55 dtb                 |
| Powkiddy     | a12             | rk3128  | Fails to compile in rtl8723ds                           |
| Powkiddy     | a13             | rk3128  | Fails to compile in rtl8723ds                           |
| Powkiddy     | RGB30           | rk3566  | Not produced with RK3566 build                          |
| Powkiddy     | RGB30           | rk3568  | Fails to compile due to missing x55 dtb                 |
| Powkiddy     | x55             | rk3566  | Compiles                                                |
| Trim UI      | Brick           | a133    | Compiles                                                |
| Trim UI      | Smart Pro       | a133    | Compiles                                                |
| Miyoo        | A30             | r16     | Fails to compile due to legacy configuration in .config |
| Retroid      | Pocket 5        | sm8250  | Compiles                                                |
| Retroid      | Pocket Mini     | sm8250  | No Image in sm8250                                      |

# File Listing

| File / Location          | Purpose                                                                                                                 |
| ------------------------ | ----------------------------------------------------------------------------------------------------------------------- |
| compose/*.yaml           | Docker compose files for building different targets                                                                     |
| docker-image-interactive | Docker image file for an interactive environment                                                                        |
| docker-image             | Docker image file for a non-interactive environment                                                                     |
| compose.sh               | Script that will make a symbolic link to the appropriate compose file in compose/                                       |
| interactive.sh           | Script that will launch into a docker container in interactive mode.  This can be used on currently running containers. |
| keys.txt                 | This is optional.                                                                                                       |
| keys.txt.sample          | This is the same sample file that is present in emulation station.                                                      |

# Volumes and Binds

| Source                     | Type   | Location                      | Used in          | Description                                                                                                                                                                                                                                               |
| -------------------------- | ------ | ----------------------------- | ---------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| knulli_build-<TARGET>      | volume | /build                        | Unattended build | Knulli is built here                                                                                                                                                                                                                                      |
| build-<TARGET>             | bind   | /build                        | Bind Build       | Knulli is built here                                                                                                                                                                                                                                      |
| knulli_toolchain-<TARGET>  | volume | /home/ubuntu/toolchain        | Unattended build | Cross compilation toolchain is installed here. This is only needed for building apps outside of the knulli makefile.<br/><br/>This will be archived into the ./output folder in case it is preferred to do cross-compilation outside of the docker image. |
| knulli_buildcache-<TARGET> | volume | /home/ubuntu/.buildroot-cache | Unattended build | Compiler cache                                                                                                                                                                                                                                            |
| keys.txt                   | bind   | /home/ubuntu/keys.txt         | Unattended build | This file contains various keys used by Emulation Station that cannot be committed into a repository.                                                                                                                                                     |
| output                     | bind   | /home/ubuntu/output           | Unattended build | This is used to copy the device images as well as toolchain archives out of the docker image so that they are available on the host operating system.                                                                                                     |

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
| CHEEVOS_DEV_LOGIN       | https://retroachievements.org/                         | z=<username>&y=<password>               |
| HFS_DEV_LOGIN           |                                                        |                                         |

# Unattended Build

This will perform a build of the image and the docker container will exit once completed.  See "Buildable Targets" above for a list of applicable targets.

If you are doing iterative development on a package or part of the build system, this is not a recommended build method as it is not very time efficient.

**Performing a clean build**

- Delete the knulli_build-<TARGET> to delete intermediate files and cause the source to be re-downloaded from source control
- Delete the knulli_buildroot_cache-<TARGET> to delete the buildroot_cache.

```
$ ./compose.sh <TARGET>
```

# Bind Build

This will setup a build environment and drop you into an interactive shell.  The build environment will be bound to ./build-<TARGET> within the path that the interactive build is executed from.

```
$ ./interactive.sh --build-bind <TARGET>
```

# Included Scripts

| Script   | Example                   | Description                                                                                                                     |
| -------- | ------------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| build.sh | ```./build.sh <TARGET>``` | 1. Builds target<br/>2.Installs toolchain<br/>3.Copies device images to ./output<br/>4.Creates tarball of toolchain to ./output |