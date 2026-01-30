#!/bin/bash -xe
sed -i 's/listen       80 default_server;/listen       8085 default_server;/' /etc/nginx/conf.d/default.conf
systemctl reload nginx