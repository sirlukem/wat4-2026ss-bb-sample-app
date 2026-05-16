#!/bin/sh

docker run --rm -ti -u $(id -u):$(id -g) -v .:/frontend -w /frontend -p 3000:3000 node:lts-alpine $@
