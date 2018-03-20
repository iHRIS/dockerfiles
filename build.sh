#!/usr/bin/env bash
set -ex

# release version blank
docker rmi ihris/manage:4.3-0.2.0 || true
docker build -f Dockerfile -t ihris/manage:4.3-0.2.0 .
docker push ihris/manage:4.3-0.2.0

# release version demo
docker rmi ihris/manage:4.3-demo-0.2.0 || true
docker build -f Dockerfile \
--build-arg MVER=4.3 \
--build-arg SOFT=ihris-manage \
--build-arg TYPE=Demo \
--build-arg SITE=manage-demo \
--build-arg MCONFIG=iHRIS-Manage-Demo.xml \
-t ihris/manage:4.3-demo-0.2.0 .
docker push ihris/manage:4.3-demo-0.2.0

# dev version blank
docker rmi ihris/manage:4.3-dev-0.2.0 || true
docker build -f Dockerfile-dev -t ihris/manage:4.3-dev-0.2.0 .
docker push ihris/manage:4.3-dev-0.2.0

# dev version demo
docker rmi ihris/manage:4.3-dev-demo-0.2.0 || true
docker build -f Dockerfile-dev \
--build-arg MVER=4.3 \
--build-arg SOFT=ihris-manage \
--build-arg TYPE=Demo \
--build-arg SITE=manage-demo \
--build-arg MCONFIG=iHRIS-Manage-Demo.xml \
-t ihris/manage:4.3-dev-demo-0.2.0 .
docker push ihris/manage:4.3-dev-demo-0.2.0

# fpm dev version blank
docker rmi ihris/manage:4.3-dev-fpm-0.2.0 || true
docker build -f Dockerfile-fpm-dev -t ihris/manage:4.3-dev-fpm-0.2.0 .
docker push ihris/manage:4.3-dev-fpm-0.2.0

# fpm release version demo
docker rmi ihris/manage:4.3-dev-fpm-demo-0.2.0 || true
docker build -f Dockerfile-dev \
--build-arg MVER=4.3 \
--build-arg SOFT=ihris-manage \
--build-arg TYPE=Demo \
--build-arg SITE=manage-demo \
--build-arg MCONFIG=iHRIS-Manage-Demo.xml \
-t ihris/manage:4.3-dev-fpm-demo-0.2.0 .
docker push ihris/manage:4.3-dev-fpm-demo-0.2.0

# there is no release version for fpm yet, blank or demo