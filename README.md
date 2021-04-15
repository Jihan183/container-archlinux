# container-archlinux
ArchLinux environment for hacking on xfce-test

## Downloading the lastest image
-
  ```
  docker pull ghcr.io/xfce-test/xfce-test-archlinux:latest
  ```

## Ideal usage
This container is designed in a way that facilitates working on a local copy
of xfce source code, while being able to test your changes in the container.

To achieve this goal, when starting the container
* Mount a folder containing all the xfce-projects you want to work on at `/container/xfce/workdir`
    * Alternatively, use the script in `app/scripts/start.sh` and set the variable `LOCAL_WORKDIR` to point to
    the folder containing those scripts
* Continue working on the projects as you normally would. Commit your changes as you work
* When you want to test, open the container and type `build-packages`, and the changes you made will
be detected and built.
  * (Not recommended, but might help) if the build takes too long, open `/container/xfce/pkglist.txt` and remove all the lines in there except for the name of the package to be built
* You can reinstall the project using this exact command: `yay -S xfce-test --needed`. It will detect any updated packages and prompt you for re-installation
