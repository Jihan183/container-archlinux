# container-archlinux
ArchLinux environment for hacking on xfce-test

## Ideal usage
This container is designed in such a way facilitates working on a local copy
of xfce source code, while being able to test your changes in the container.

To achieve this goal, we don't bundle the xfce source code into this image. Instead we supply you with a folder (`xfce/db`) containing `PKGBUILD` files. All you have to do is
* Mount this folder in the container as shown `app/scripts/start-xfce-test.sh`
* For whatever project you are working on, you create the git repo in   `xfce/db` and start hacking away.
* Any changes you make should be committed to your local copy, then you just need to use `aurutils` to rebuild the package database
    * `aur build` inside the container at `${XFCE_WORK_DIR}/package_dir/`
* Now you can install the package using the configured `${PACMAN}` command.
