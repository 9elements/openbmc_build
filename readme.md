# Build openbmc

First build the docker image `make build_docker`
run `make` to build openbmc for the e3c246d4i, which is the
default target for now. Use the environment variable `TARGET`
to modify this.

`make clean` removes the build but not the download dir.
