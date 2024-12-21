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
| Anbernic     | RG28XX          | h700    |  |
| Anbernic     | RG34XX          | h700    |          |
| Anbernic     | RG35XX Original | atm7039 |          |
| Anbernic     | RG35XX Plus     | h700    |          |
| Anbernic     | RG35XX H        | h700    |          |
| Anbernic     | RG35XX 2024     | h700    |          |
| Anbernic     | RG40XX H        | h700    |  |
| Anbernic     | RG40XX V        | h700    |          |
| Anbernic     | AG-Arc-S        | rk3566  |          |
| Anbernic     | RG-CubeXX       | h700    |  |
| Anbernic     | RGXX3           | rk3568  |          |
| Powkiddy     | a12             | rk3128  |          |
| Powkiddy     | a13             | rk3128  |          |
| Powkiddy     | RGB30           | rk3566  |          |
| Powkiddy     | RGB30           | rk3568  |          |
| Powkiddy     | x55             | rk3566  |          |
| Trim UI      | Brick           | a133    |          |
| Trim UI      | Smart Pro       | a133    |          |
| Miyoo        | A30             | r16     |          |
| Retroid      | Pocket 5        | sm8250  |          |
| Retroid      | Pocket Mini     | sm8250  |          |


# File Listing

| File / Location          | Purpose                                             |
|--------------------------|-----------------------------------------------------|
| compose/*.yaml           | Docker compose files for building different targets |
| docker-image-interactive | Docker image file for an interactive environment    | 
| docker-image             | Docker image file for a non-interactive environment |
| compose.sh               | Script that will make a symbolic link to the appropriate compose file in compose/ |
| interactive.sh           | Script that will launch into a docker container in interactive mode.  This can be used on currently running containers. |

# TODO List
- Add support for loading keys into the build
  - This currently requires that you manually load them interactively
- Add support to build other forks and branches
  - This will be done using environment variables
