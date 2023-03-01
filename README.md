# Klaxon Docker Artifacts

This repository includes files for building a
[Klaxon](https://github.com/curt/klaxon) image and launching a Klaxon
application and supporting database in [Docker](https://www.docker.com/).

The source code for Klaxon can be found at <https://github.com/curt/klaxon>.

## Usage

__Dockerfile__ is used for building a Docker image of Klaxon. It builds the image
in two stages.

The first stage uses [Git](https://git-scm.com/) to clone the most recent
version of the __main__ branch of the source repository and perform the
compilation.

The second stage uses the products of the first stage to build a lighter final
image that includes a minimal numbers of packages to run the application.

__docker-entrypoint.sh__ gets built into the final image to bootstrap the Klaxon
application when the Docker container starts.

To build the image, after cloning this repository, and assuming you're at the
root level:

```
$ docker build -t "klaxon:main" .
```

__docker-compose.yml__ is used for launching the application. It combines the
image built in the previous step with an official Docker image of PostgreSQL
object-relational database system, running each image in its own container.

```
$ docker compose up
```

The application listens on port 4001, so as not to conflict with a development
version that may be running on port 4000. If you're running the application on
your desktop, you can point a browser to <http://localhost:4001>.

## Road map

Once the Klaxon application has developed more fully, it would be nice to
register the image on [Docker Hub](https://hub.docker.com/).