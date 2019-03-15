FROM fedora:latest

LABEL MAINTAINER="shlomi@ben-hanna.com"

RUN dnf -y update
RUN dnf -y install \
    ruby{,-devel,gems,-irb} \
    rubygem-{nokogiri,bundler,unf_ext,rdoc} \
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

RUN git clone --depth=1 ${REPO_URL} . \
 && mkdir logs
RUN bundle --without bmc:krb5:libvirt:puppet_proxy_legacy:test:windows 

ADD settings.yml config/settings.yml
