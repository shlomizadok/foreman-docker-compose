# foreman remote execution target container
#
# VERSION               0.0.1

FROM centos:7
MAINTAINER Ivan Nečas <inecas@redhat.com>

RUN rpm -Uvh  "http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm"
RUN yum install -y hostname openssh-server openssh-clients facter
RUN echo UseDNS no >> /etc/ssh/sshd_config

ADD ssh/id_rsa_server /etc/ssh/ssh_host_rsa_key
ADD ssh/id_rsa_server.pub /etc/ssh/ssh_host_rsa_key.pub

CMD mkdir -m 700 /root/.ssh
ADD ssh/id_rsa_foreman_proxy.pub /root/.ssh/authorized_keys
CMD chmod 600 /root/.ssh/authorized_keys

ADD scripts/register-host.sh register-host.sh
ADD scripts/start.sh start.sh
ADD scripts/upload_facts.rb upload_facts.rb

EXPOSE 22
CMD ["./start.sh"]
