# Foreman docker-compose

Docker compose of Foreman in a LB (using haproxy) setup, including basic client (fact uploads), postgres and memcache.

## Requirements

  * Docker Compose **1.6.0+** ([Install from Docker.com](https://docs.docker.com/compose/install/) or via native packaging)
  * Docker Engine **1.10.0+** ([Install from Docker.com](https://docs.docker.com/engine/installation/linux/rhel/) or via native packaging)

## Usage

Clone this Repository to you local environment:

```shell
$ git clone https://github.com/shlomizadok/foreman-docker-compose.git
$ cd foreman-docker-compose
```
In the **bin** directory you will find the **foreman-container** script which includes a few commands to build and run containers.

To build the containers you can on of three commands:

```shell
$ bin/foreman-container build              # Builds both production and development definitions
$ bin/foreman-container build-production   # Builds the production definition only
$ bin/foreman-container build-development  # Builds the development definition only
```

After the containers are built they can be used. In order to start the **development** and **test** container, it is required to mount your local foreman repository as a volume for the container. You can do so by commenting out and adjusting the following in `docker-compose.development.yml`:
```yaml
...
  # volumes:
  #   - $HOME/foreman:/usr/src/foreman-development
...
```

To start the containers you can us the **up** commands:

```shell
$ bin/foreman-container up                       # Starts the production definition only
$ bin/foreman-container up-development           # Starts the development definition only
```

Executing commands inside a container, like `rake` tasks, can be done using the **run** commands following yours:
```shell
$ bin/foreman-container run [...]                # Run commands in a foreman production container
$ bin/foreman-container run-development [...]    # Run commands in a foreman development container
```

Tests can be run in the test container with the **test** command:
```shell
$ bin/foreman-container test                     # Run tests in a foreman
```

Once the environment is built and up (either via `make up` or `make up-development`), you may simply login to `http://localhost` (or `http://localhost:3000` for development). SSL is disabled for this deployment.

**Note on the development definition:** It is only suitable if Docker runs natively on your system or running it in a VM syncing your development folder via NFS. It is also required to set the proper path for the volume to be mounted. If not present the container will `exit`.

## Known issues

### fact uploading

the client container can upload facts, however, you would need to change the following setting:
```
restrict_registered_smart_proxies=false
require_ssl_smart_proxies=false
```


### SELinux Denials

the way haproxy auto configure itself based on scale, is by quering docker itself, this raises a selinux alert, if you want haproxy to autoconfigure currently you need to setenfore=0.

Please note that `docker-compose up -d` binds your localhost:80 to the haproxy container port 80, so once complete you can go to ```http://localhost```


Once completed you may scale your services - e.g. `docker-compose scale foreman=3 client=10`
