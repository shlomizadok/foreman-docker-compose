# Foreman docker-compose

Docker compose of Foreman in a LB (using haproxy) setup, including basic client (fact uploads), postgres and memcache.

## Installation

Install `docker-compose` from [docker compose](https://docs.docker.com/compose/install/) (or via native packaging)

cd into this directory and run `docker-compose build`. This will build postgres image and Foreman (develop branch) image.

Once the environment is up, you may simply login to `http://localhost`. SSL is disabled for this deployment.

## Known issues

### fact uploading


Client container to simulate fact uploading.

To use simply execute:
`docker-compose scale client=10` # or any other number of you clients you want
to run concurrently.

TODO: make the client code a bit more robust so it retry if the server is not
available (often happens on first time you run the containers)

### Remote Execution (REX) client


A container that runs SSH, uses similar bits from the Client container above to
register the host (using facts) and keeps SSH daemon running to accept REX
calls.


### SELinux Denials


The way haproxy auto configure itself based on scale, is by querying docker itself, this raises a selinux alert, if you want haproxy to autoconfigure currently you need to setenfore=0.

Please note that `docker-compose up -d` binds your localhost:80 to the haproxy container port 80, so once complete you can go to ```http://localhost```


Once completed you may scale your services - e.g. `docker-compose scale foreman=3 client=10`
