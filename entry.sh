#!/bin/sh

TEMPLATE=/etc/consul-templates/nginx.ctmpl

echo "upstream app {                 \n\
  least_conn;                            \n\
  {{range service \"$SERVICE\"}}         \n\
  server  {{.Address}}:{{.Port}};        \n\
  {{else}}server 127.0.0.1:65535;{{end}} \n\
}                                        \n\
" >> $TEMPLATE;

/usr/sbin/nginx -c /etc/nginx/nginx.conf \
& CONSUL_TEMPLATE_LOG=debug consul-template \
  -consul=$CONSUL_SERVER \
  -template "/etc/consul-templates/nginx.ctmpl:/etc/nginx/conf.d/app.conf:sv hup nginx || true";