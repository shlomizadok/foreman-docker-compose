FROM fedora:latest

LABEL MAINTAINER="ohadlevy@gmail.com"

ARG RUBY_VERSION="2.7"
ARG NODEJS_VERSION="12"
ARG FOREMAN_VERSION="3.0"

RUN echo -e "[nodejs]\nname=nodejs\nstream=${NODEJS_VERSION}\nprofiles=\nstate=enabled\n" \
 > /etc/dnf/modules.d/nodejs.module \
 && echo -e "[ruby]\nname=ruby\nstream=${RUBY_VERSION}\nprofiles=\nstate=enabled\n" \
 > /etc/dnf/modules.d/ruby.module \
 && dnf -y update

RUN dnf -y install \
    ruby{,-devel,gems} \
    rubygem-bundler \
    redhat-rpm-config \
    nodejs \
    npm \
    git \
    libcurl-devel \
    libxml2-devel \
    postgresql-devel \
    systemd-devel \
    gcc-c++ \
    make \
    hostname \
 && dnf clean all

WORKDIR /usr/src/app

ENV RAILS_ENV=production
ENV FOREMAN_APIPIE_LANGS=en
ENV REPO_URL=https://github.com/theforeman/foreman.git

# TODO: support local path instead of checkout
RUN git clone --branch ${FOREMAN_VERSION}-stable --depth=1 ${REPO_URL} .
RUN [ -e 'package.json' ] && npm install || exit 0

ADD database.yml config/database.yml
ADD Gemfile.local.rb bundler.d/Gemfile.local.rb
ADD settings.yaml config/settings.yaml

RUN bundle --without mysql:test:mysql2:development:sqlite:jenkins:openid:libvirt
