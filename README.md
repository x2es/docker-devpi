Devpi Docker Environment
========================

[Devpi](https://devpi.net/docs/devpi/devpi/stable/%2Bd/index.html) is self-hosted pypi repository.
This setup provides simple Docker environment.
Just clone & go!


## Prerequisites

Docker and docker-compose installed.
See:
 * https://docs.docker.com/engine/install/
 * https://docs.docker.com/compose/install/


## Install & Run

```console
$ git clone git@github.com:x2es/docker-devpi.git
$ cd docker-devpi
$ docker-compose up
```

### Run as service

Swarm doesn't accept `pull_policy` option in `docker-compose.yml` hence it have to be commented.

```console
(once) $ docker swarm init
$ cd docker-devpi
$ docker build . -t devpi
$ bin/start
...
$ bin/stop
```

Unstopped Docker services will start at next boot.

See content of `bin/start` and `bin/stop` scripts for details and `docker service --help`

## Usage

### Publish with poetry

Setup repository "local"

```console
(prj-dir) $ poetry config repositories.local http://localhost:3141/user/private
```

Publish

```console
(prj-dir) $ poetry build
(prj-dir) $ poetry publish -r local -u user -p userpassword
```

### Install with pip

```console
$ pip install -i http://localhost:3141/user/private package-name
```

### Usage cookbook

[Create staging repositories in front of pypi.org](https://stefan.sofa-rockers.org/2017/11/09/getting-started-with-devpi/#package-indexes)


## Configuration

See `docker-compose.yml` as reference.


### Initialization

Container will be initialized on first run:
 * Once `USER_NAME=` and `USER_PASSWORD=` given: user will be created
 * Once `INDEX_NAME=` given: index will be created for `USER_NAME=` or `root`

By default `devpi-init` will initialize `root/pypi` repository and sync index with pypi.org.
You may provide `--no-root-pypi` using `INIT_EXTRA_ARGS=` variable to avoid it.


### Persistance

Provided `docker-compose.yml` persists server data using local volume `devpi_server`.
As alternative you may mount local directory to container's `SERVER_DIR`

It's safe to recreate container once volume used.

In order to reset persisted data

```console
docker volume rm devpi_server
```

## Tools

### `bin/console`

Spawn shell or invoke command in the running container (when started either by `docker-compose up` or swarm)

```console
$ bin/console
$ bin/console devpi_server
$ bin/console devpi_server /usr/bin/env python3
$ bin/console devpi_server pip install foo
```


### `bin/log`

(swarm only)

Check the output logs

```console
$ bin/log
$ bin/log -f
$ bin/log devpi_server
$ bin/log devpi_server -f
```

see bin/log content for details


### Chaining

```console
$ bin/start && bin/wait-container devpi_server && bin/log -f
```


## Troubleshooting

### Swarm: Service won't start

```console
$ docker service ps --no-trunc devpi_server
```

or

```console
$ (Ubuntu) journalctl -u docker.service
```

see https://stackoverflow.com/a/45373282/983232


### Full cleanup

**CAUTION** it will cleanup all data related to `devpi`.

```console
$ ( set -x; docker-compose rm; docker volume rm devpi_server; docker image rm devpi )
```
