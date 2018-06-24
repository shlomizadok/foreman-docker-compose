FROM fedora:latest

LABEL MAINTAINER="ohadlevy@gmail.com"

#RUN dnf -y update
RUN dnf -y install \
    ruby{,-devel,gems} \
    rubygem-{nokogiri,bundler,unf_ext,rdoc} \
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

#TODO: support local path instead of checkout
RUN git clone --depth=1 ${REPO_URL} .
RUN [ -e 'package.json' ] && npm install || exit 0

ADD database.yml config/database.yml
ADD Gemfile.local.rb bundler.d/Gemfile.local.rb
ADD settings.yaml config/settings.yaml

RUN bundle --without mysql:test:mysql2:development:sqlite:jenkins:openid:libvirt
