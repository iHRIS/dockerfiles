#!/usr/bin/env bash
set -ex

docker rmi ihris/ihris:4.3-dev_manage-demo_0.1.0 || true

docker build \
--build-arg VER=4.3-dev \
--build-arg MVER=4.3 \
--build-arg SOFT=ihris-manage \
--build-arg TYPE=Demo \
--build-arg SITE=manage-demo \
--build-arg MCONFIG=iHRIS-Manage-Demo.xml \
-t ihris/ihris:4.3-dev_manage-demo_0.1.0 .

docker push ihris/ihris:4.3-dev_manage-demo_0.1.0

docker rmi ihris/ihris:4.3-dev_manage_0.1.0 || true

docker build \
--build-arg VER=4.3-dev \
--build-arg MVER=4.3 \
--build-arg SOFT=ihris-manage \
--build-arg TYPE=blank \
--build-arg SITE=manage \
--build-arg MCONFIG=iHRIS-Manage-BLANK.xml \
-t ihris/ihris:4.3-dev_manage_0.1.0 .

docker push ihris/ihris:4.3-dev_manage_0.1.0
