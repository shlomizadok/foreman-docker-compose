# Foreman docker-compose

Docker compose of Foreman in a LB (using haproxy) setup, including basic client (fact uploads), postgres and memcache.

## Installation

Install `docker-compose` from [docker compose](https://docs.docker.com/compose/install/) (or via native packaging)

cd into this directory and run `docker-compose build`. This will build a Foreman (develop branch) image and create web assets (which takes a while).

Afterwards, run `docker-compose up` and log in at `http://localhost`. SSL is disabled for this deployment.

### Change admin password

The admin password is auto-generated and printed out during the build. You can generate a new one as follows:

```bash
$ docker-compose run --rm foreman-init bundle exec rake permissions:reset
```

## Known issues

### fact uploading

The client container can upload facts, however, you would need to change the following setting:

```ini
restrict_registered_smart_proxies=false
require_ssl_smart_proxies=false
```

### SELinux Denials

The way haproxy auto configure itself based on scale, is by quering docker itself, this raises a selinux alert, if you want haproxy to autoconfigure currently you need to setenfore=0.

Please note that `docker-compose up -d` binds your localhost:80 to the haproxy container port 80, so once complete you can go to ```http://localhost```

Once completed you may scale your services - e.g. `docker-compose scale foreman=3 client=10`
