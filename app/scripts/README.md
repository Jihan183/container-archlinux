## App Scripts

Many of the scripts here are simply for managing the PKGBUILD files of the various xfce components.

* makedeps.sh: This script is used to generate a list of dependencies for each xfce package. It acts as the main driver for the other two (`dups.sed.sh`, and `normalize.awk`)
* build.sh: Builds the container
* start.sh: Runs the built container (if any)
* setup-workdir.sh: Clones each package's repository into the current directory under `xfce/workdir`. Ignores existing packages
