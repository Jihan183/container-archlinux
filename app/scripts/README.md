## App Scripts

Many of the scripts here are simply for managing the PKGBUILD files of the various xfce components.

* makedeps.sh: This script is used to generate a list of dependencies for each xfce package. It acts as the main driver for the other two (`dups.sed.sh`, and `normalize.awk`)
* build-xfce-test.sh: Builds the container
* start-xfce-test.sh: Runs the built container if any
