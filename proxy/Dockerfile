FROM fedora:latest

LABEL MAINTAINER="shlomi@ben-hanna.com"

ARG RUBY_VERSION="2.7"
ARG NODEJS_VERSION="12"
ARG FOREMAN_VERSION="3.0"

RUN echo -e "[nodejs]\nname=nodejs\nstream=${NODEJS_VERSION}\nprofiles=\nstate=enabled\n" \
 > /etc/dnf/modules.d/nodejs.module \
 && echo -e "[ruby]\nname=ruby\nstream=${RUBY_VERSION}\nprofiles=\nstate=enabled\n" \
 > /etc/dnf/modules.d/ruby.module \
 && dnf -y update

RUN dnf -y install \
    ruby{,-devel,gems,-irb} \
    rubygem-bundler \
    redhat-rpm-config \
    systemd-devel \
    nodejs \
    postgresql-devel \
    git \
    gcc-c++ \
    make \
    hostname \
 && dnf clean all

WORKDIR /usr/src/app

ENV REPO_URL=https://github.com/theforeman/smart-proxy.git

RUN git clone --branch ${FOREMAN_VERSION}-stable --depth=1 ${REPO_URL} . \
 && mkdir logs
RUN bundle --without bmc:krb5:libvirt:puppet_proxy_legacy:test:windows

ADD settings.yml config/settings.yml
