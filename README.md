# Nginx Consul Template

Based on Consul service discovery, it will auto reload nginx when new target service is registered.

## Environment variable

  * `CONSUL_SERVER` : Consul server location.
  * `SERVICE` : Service name, should be equal to service's SERVICE_NAME tag.

## Docker-compose Example

```
version: '2'
services:

  nginx-consul-template:
    image: oring/nginx-consul-template:latest
    ports:
      - 80:80
    depends_on:
      - hello-world
    environment: 
      - CONSUL_SERVER=consul:8500
      - SERVICE=hello-world

  hello-world:
    image: tutum/hello-world
    ports:
      - 80
    environment:
      - SERVICE_NAME=hello-world
```