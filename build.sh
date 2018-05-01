#!/usr/bin/env bash
set -ex

# release version blank
docker rmi ihris/manage:4.3.2 || true
docker build --no-cache -f Dockerfile -t ihris/manage:4.3.2 .
docker push ihris/manage:4.3.2

# release version demo
docker rmi ihris/manage:4.3.2-demo || true
docker build --no-cache -f Dockerfile \
--build-arg MVER=4.3 \
--build-arg SOFT=ihris-manage \
--build-arg TYPE=Demo \
--build-arg SITE=manage-demo \
--build-arg MCONFIG=iHRIS-Manage-Demo.xml \
-t ihris/manage:4.3.2-demo .
docker push ihris/manage:4.3.2-demo

# dev version blank
docker rmi ihris/manage:4.3-dev || true
docker build --no-cache -f Dockerfile-dev -t ihris/manage:4.3-dev .
docker push ihris/manage:4.3-dev

# dev version demo
docker rmi ihris/manage:4.3-dev-demo || true
docker build --no-cache -f Dockerfile-dev \
--build-arg MVER=4.3 \
--build-arg SOFT=ihris-manage \
--build-arg TYPE=Demo \
--build-arg SITE=manage-demo \
--build-arg MCONFIG=iHRIS-Manage-Demo.xml \
-t ihris/manage:4.3-dev-demo .
docker push ihris/manage:4.3-dev-demo

# fpm dev version blank
docker rmi ihris/manage:4.3-dev-fpm || true
docker build --no-cache -f Dockerfile-fpm-dev -t ihris/manage:4.3-dev-fpm .
docker push ihris/manage:4.3-dev-fpm

# fpm release version demo
docker rmi ihris/manage:4.3-dev-fpm-demo || true
docker build --no-cache -f Dockerfile-dev \
--build-arg MVER=4.3 \
--build-arg SOFT=ihris-manage \
--build-arg TYPE=Demo \
--build-arg SITE=manage-demo \
--build-arg MCONFIG=iHRIS-Manage-Demo.xml \
-t ihris/manage:4.3-dev-fpm-demo .
docker push ihris/manage:4.3-dev-fpm-demo

# there is no separate release version for fpm