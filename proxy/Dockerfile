FROM fedora:latest
LABEL MAINTAINER="shlomi@ben-hanna.com"
RUN dnf -y install ruby{,-devel,gems} rubygem-{bundler,rdoc,sqlite3,unf_ext,gssapi} git gcc-c++ make hostname redhat-rpm-config; dnf -y update; dnf clean all
MAINTAINER ohadlevy@gmail.com

ENV REPO_URL=https://github.com/theforeman/smart-proxy.git

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

RUN git clone ${REPO_URL} /usr/src/app
RUN mkdir /usr/src/app/logs
ADD Gemfile.local.rb bundler.d/Gemfile.local.rb
RUN bundle install --clean --retry=100 --jobs=10 --without bmc:development:krb5:libvirt:puppet_proxy_legacy:test:windows
RUN ssh-keygen -t rsa -P '' -f /root/.ssh/id_rsa_foreman_proxy
ADD settings.yml config/settings.yml
ADD settings.d config/settings.d
