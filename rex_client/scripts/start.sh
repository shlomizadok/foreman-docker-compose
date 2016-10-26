#!/usr/bin/env bash

./register-host.sh  2>&1 | tee -a /tmp/registeration_log
/usr/sbin/sshd -D
