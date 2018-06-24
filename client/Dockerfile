FROM fedora:latest

LABEL MAINTAINER="ohadlevy@gmail.com"

#RUN dnf -y upgrade
RUN dnf install -y \
    facter \
    hostname \
 && dnf clean all

ADD upload_facts.rb upload_facts.rb

ENV FOREMAN_URL=http://foreman:3000

CMD ["./upload_facts.rb"]
