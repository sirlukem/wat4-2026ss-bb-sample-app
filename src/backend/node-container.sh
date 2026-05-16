#!/bin/sh

docker run --rm -ti -u $(id -u):$(id -g) -v .:/backend -w /backend -p 5000:5000 node:lts-alpine $@
