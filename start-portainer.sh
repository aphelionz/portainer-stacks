#!/bin/bash

docker run -d -p 8000:8000 -p 9443:9443 --name portainer \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_portainer_data:/data \
  --network traefik-swarm \
  -l traefik.enable=true \
  -l traefik.http.routers.portainer.entrypoints=web \
  -l traefik.http.routers.portainer.rule='Host(`portainer`)' \
  -l traefik.http.routers.portainer.service=portainer \
  -l traefik.http.services.portainer.loadbalancer.server.port=9000 \
  cr.portainer.io/portainer/portainer-ee:2.16.2-alpine
