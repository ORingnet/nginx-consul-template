#!/bin/sh

TEMPLATE=/etc/consul-templates/nginx.ctmpl

echo "upstream app {                 \n\
  least_conn;                            \n\
  {{range service \"$SERVICE\"}}         \n\
  server  {{.Address}}:{{.Port}};        \n\
  {{else}}server 127.0.0.1:65535;{{end}} \n\
}                                        \n\
server {                                 \n\
  listen 80 default_server;              \n\
  location / {                           \n\
    proxy_pass http://app;               \n\
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for; \n\
    proxy_set_header Host $host; \n\
    proxy_set_header X-Real-IP $remote_addr; \n\
  }                                      \n\
}" > $TEMPLATE;

/usr/sbin/nginx -c /etc/nginx/nginx.conf \
& CONSUL_TEMPLATE_LOG=debug consul-template \
  -consul=$CONSUL_SERVER \
  -template "/etc/consul-templates/nginx.ctmpl:/etc/nginx/conf.d/default.conf:/usr/sbin/nginx -s reload";