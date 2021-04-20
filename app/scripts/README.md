## App Scripts

Scripts used for house keeping and maintaining a local copy of the container.

File      | Description
--------- | ------------
`build.sh` | use to build the container
`start.sh` | run the built container
`setup-workdir.sh` | useful for an initial setup of a working directory. It clones each package's repository into the current directory under `xfce-workdir`.<br/> Does not delete existing work directories, but will add any non-existing packages
`makedeps.sh`    | This script is used to generate a list of dependencies for each xfce package. It acts as the main driver for the other two (`dups.sed.sh`, and `normalize.awk`)
