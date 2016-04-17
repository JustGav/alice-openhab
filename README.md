# Docker container for OpenHab

This docker image contains
Java 8
OpenHAB Runtime

Interactive running command
docker run  --net=host --rm -t -i docker-openhab /sbin/my_init -- bash -l

Background running command
docker run --restart=always --name=docker-openhab -v /storage/openhab:/etc/openhab -p 8080:8080 -t -d docker-openhab
