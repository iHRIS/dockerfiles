#!/usr/bin/env bash
set -ex

docker rmi ihris/manage:4.3-demo-0.2.0 || true

docker build \
--build-arg MVER=4.3 \
--build-arg SOFT=ihris-manage \
--build-arg TYPE=Demo \
--build-arg SITE=manage-demo \
--build-arg MCONFIG=iHRIS-Manage-Demo.xml \
-t ihris/manage:4.3-demo-0.2.0 .

docker push ihris/manage:4.3-demo-0.2.0

docker rmi ihris/manage:4.3-0.2.0 || true

docker build \
--build-arg MVER=4.3 \
--build-arg SOFT=ihris-manage \
--build-arg TYPE=blank \
--build-arg SITE=manage \
--build-arg MCONFIG=iHRIS-Manage-BLANK.xml \
-t ihris/manage:4.3-0.2.0 .

docker push ihris/manage:4.3-0.2.0
