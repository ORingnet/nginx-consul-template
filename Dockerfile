FROM nginx:stable

RUN apt-get update -qq && apt-get -y install curl unzip

ENV CONSUL_TEMPLATE_VERSION 0.18.5
ENV CONSUL_SERVER consul:8500
ENV TEMPLATE /etc/consul-templates/nginx.ctmpl

ADD https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_SHA256SUMS /tmp/
ADD https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip /tmp/

RUN cd /tmp && \ 
    sha256sum -c consul-template_${CONSUL_TEMPLATE_VERSION}_SHA256SUMS 2>&1 | grep OK && \
    unzip consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip && \ 
    mv consul-template /bin/consul-template && \
    rm -rf /tmp

RUN mkdir /etc/consul-templates
RUN echo "upstream app {                 \n\
  least_conn;                            \n\
  {{range service \"$SERVICE\"}}         \n\
  server  {{.Address}}:{{.Port}};        \n\
  {{else}}server 127.0.0.1:65535;{{end}} \n\
}                                        \n\
server {                                 \n\
  listen 80 default_server;              \n\
  location / {                           \n\
    proxy_pass http://app;               \n\
  }                                      \n\
}" > $TEMPLATE;

CMD /usr/sbin/nginx -c /etc/nginx/nginx.conf \
& CONSUL_TEMPLATE_LOG=debug consul-template \
  -consul=$CONSUL_SERVER \
  -template "/etc/consul-templates/nginx.ctmpl:/etc/nginx/conf.d/default.conf:/usr/sbin/nginx -s reload";