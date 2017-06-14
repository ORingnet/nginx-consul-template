FROM nginx:stable

RUN apt-get update -qq && apt-get -y install curl unzip

ENV CONSUL_TEMPLATE_VERSION 0.18.5
ENV CONSUL_SERVER consul:8500

ADD https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_SHA256SUMS /tmp/
ADD https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip /tmp/

RUN cd /tmp && \ 
    sha256sum -c consul-template_${CONSUL_TEMPLATE_VERSION}_SHA256SUMS 2>&1 | grep OK && \
    unzip consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip && \ 
    mv consul-template /bin/consul-template && \
    rm -rf /tmp

RUN mkdir /etc/consul-templates
ADD nginx.ctmpl /etc/consul-templates/

CMD /usr/sbin/nginx -c /etc/nginx/nginx.conf \
& CONSUL_TEMPLATE_LOG=debug consul-template \
  -consul=$CONSUL_SERVER \
  -template "/etc/consul-templates/nginx.ctmpl:/etc/nginx/conf.d/default.conf:/usr/sbin/nginx -s reload";