Container utilities
====================

These files are part of the final container, and by default are located in `/container/xfce` within the built container.

File      | Description
--------- | ------------
`etc/`    | files used to configure sudo and pacman
`scripts` | useful scripts for building various internals of the container. See [Dockerfile](Dockerfile)
`pkglist.txt` | List of xfce packages installed. This is used by [`aurutils`](https://github.com/AladW/aurutils) build command to rebuild the package database
