# Nginx Consul Template

Docker image with `Nginx` and the `Consul Template` to update its configuration file from consul dynamically.


[Docker Hub Link](https://hub.docker.com/r/oring/nginx-consul-template/)

## Prerequisite

1. [Consul Server](https://github.com/hashicorp/consul)
2. [Registrator](https://github.com/gliderlabs/registrator)

## Environment variable

* `CONSUL_SERVER` : Consul server location, default: `consul:8500`.
* `SERVICE` : Service name, should be equal to target service's SERVICE_NAME.


## docker-compose example

```
version: '2'
services:

  nginx-consul-template:
    image: oring/nginx-consul-template:latest
    ports:
      - 80:80
    environment: 
      - CONSUL_SERVER=consul:8500
      - SERVICE=hello-world

  hello-world-1:
    image: tutum/hello-world
    ports:
      - 80
    environment:
      - SERVICE_NAME=hello-world

  hello-world-2:
    image: tutum/hello-world
    ports:
      - 80
    environment:
      - SERVICE_NAME=hello-world
```