#!/bin/bash

COMMON_PACKAGES="ruby-devel rubygems rubygem-nokogiri rubygem-bundler rubygem-unf_ext
                 rubygem-rdoc redhat-rpm-config nodejs npm git postgresql-devel gcc-c++
                 make hostname"

if [ "$FOREMAN_MODE" = "production" ]; then
  FOREMAN_SYSTEM_GEMS="bundler puma"
else
  FOREMAN_SYSTEM_GEMS="bundler foreman puma"
fi

echo "=> Installing packages for $FOREMAN_MODE"

echo "Common packages: $COMMON_PACKAGES"
dnf -y install $COMMON_PACKAGES

echo "=> Installing RubyGems for $FOREMAN_MODE"
gem install $FOREMAN_SYSTEM_GEMS

echo "=> Updating npm"
npm install -g npm

echo "=> Cleaning up after packages"
dnf clean all
