# Docker image for IntelliJ IDEA Community, Go and Go plugin

[![Circle CI](https://circleci.com/gh/dlsniper/docker-intellij.svg?style=svg)](https://circleci.com/gh/dlsniper/docker-intellij)

The image contains the following software:

- [IntelliJ IDEA Community 2016.2](https://www.jetbrains.com/idea/)
- [Go 1.6.3](https://golang.org/)
- [Go plugin (nightly, 0.12.1724)](https://plugins.jetbrains.com/plugin/5047)
- [Markdown plugin (release, 2016.1.20160405)](https://plugins.jetbrains.com/plugin/7793)

## Running


By running the following command you'll be able to start the container

```bash
docker run -tdi \
           --net="host" \
           --privileged=true \
           -e DISPLAY=${DISPLAY} \
           -v /tmp/.X11-unix:/tmp/.X11-unix \
           -v ${HOME}/.IdeaIC2016.1_docker:/home/developer/.IdeaIC2016.1 \
           -v ${GOPATH}:/home/developer/go \
           sebmoule/docker-intellij
```

The command will do the following:

- save the IDE preferences into `<your-HOME-dir>/.IdeaIC2016`
- mounts the GOPATH from your computer to the one in the container. This
assumes you have a single directory. If you have multiple directories in your
GOPATH, then see below how you can customize this to run correctly.

## Customizing the container

You can replace the `${GOPATH}` environment variable to a hardcoded path that
you have in your directory.

You can also choose to save the preferences in another directory.

For an example script to launch this, see below:

```bash
#!/usr/bin/env bash

GOPATH=/path/to/your/GOPATH
PREF_DIR=${HOME}/.IdeaIC2016.1_docker

docker run -tdi \
           --net="host" \
           --privileged=true \
           -e DISPLAY=${DISPLAY} \
           -v /tmp/.X11-unix:/tmp/.X11-unix \
           -v ${PREF_DIR}:/home/developer/.IdeaIC2016.1 \
           -v ${GOPATH}:/home/developer/go \
           sebmoule/docker-intellij
```

## Updating the container

To update the container, simply run:

```shell
docker pull sebmoule/docker-intellij
```

Each of the plugins can be updated individually at any time, and other plugins
can be installed as well.

However, to update IntelliJ IDEA itself, the docker image will need to be
updated.

## License

The MIT License (MIT)

Copyright (c) 2016 Florin Patan

If you want to read the full license text, please see the [LICENSE](https://github.com/dlsniper/docker-intellij/blob/master/LICENSE) file
in this directory.

IntelliJ IDEA and all the other plugins are or may be trademarks of their
respective owners / creators. Please read the individual licenses for them.
