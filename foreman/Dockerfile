FROM fedora:latest

MAINTAINER Ohad Levy "ohadlevy@gmail.com"

ARG foreman_version
ARG foreman_mode

ENV FOREMAN_MODE $foreman_mode
ENV FOREMAN_VERSION $foreman_version

ENV RAILS_ENV $FOREMAN_MODE

ENV FOREMAN_APIPIE_LANGS en
ENV FOREMAN_PATH /usr/src/foreman
ENV REPO_URL https://github.com/theforeman/foreman.git
ENV BUNDLE_WITHOUT mysql:test:mysql2:development:sqlite:jenkins:openid:libvirt

RUN mkdir -p $FOREMAN_PATH
WORKDIR /$FOREMAN_PATH

COPY ./support/start.sh /start.sh
COPY ./support/bootstrap.sh /bootstrap.sh
COPY ./support/install-packages.sh /install-packages.sh
RUN /install-packages.sh

RUN git clone $REPO_URL $FOREMAN_PATH

COPY database.yml $FOREMAN_PATH/config/database.yml
COPY Gemfile.local.rb $FOREMAN_PATH/bundler.d/
COPY settings.yaml $FOREMAN_PATH/config/settings.yaml

RUN /start.sh /bootstrap.sh

ENTRYPOINT ["sh", "/start.sh"]
