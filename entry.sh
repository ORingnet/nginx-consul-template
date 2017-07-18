#!/bin/sh

sed -ie "s/#service/\"$SERVICE\"/g" /etc/consul-templates/nginx.ctmpl

$/usr/sbin/nginx -c /etc/nginx/nginx.conf -t && \
	/usr/sbin/nginx -c /etc/nginx/nginx.conf -g "daemon on;"

/usr/sbin/nginx -c /etc/nginx/nginx.conf \
& CONSUL_TEMPLATE_LOG=debug consul-template \
  -consul=$CONSUL_SERVER \
  -template "/etc/consul-templates/nginx.ctmpl:/etc/nginx/conf.d/default.conf:/usr/sbin/nginx -s reload";