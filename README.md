# Docker builds for iHRIS

### Configuration

The iHRIS apps require hard-coded configurations in the relevant site's config.php including the database connection string. For this reason, it may be preferred to build the container yourself. See the Dockerfile [reference](https://docs.docker.com/engine/reference/builder/#arg). This means that you cannot do run-time customization with these images with regards to the connection string. The default connection string is set in the Dockerfiles which can be overridden as needed.

The connection string is set with ARGs (AKA build-args, build-time only environment variables - different from ENVs). You can choose the defaults already in the Dockerfile or set them in docker-compose or other orchestration framework which will override the defaults.

```sh
# default, set in Dockerfiles
ARG DSN="mysql:user=ihris;pass=ihris;host=localhost;dbname=ihris"
```

Note that Docker networking on Mac and Windows uses a thin VM. Localhost will be resolved as the VM not the host OS. For this reason, the docker-compose examples use 'mysql' as the host, which is linked with the iHRIS container.

To build the container, clone the repo.

```sh
git clone https://github.com/ihris/ihris-docker
```

### iHRIS Manage Blank Site

```
docker-compose -f docker-compose.manage.yml up -d
```

### iHRIS Manage Demo

```
docker-compose -f docker-compose.manage.demo.yml up -d
```

Go to http://localhost/manage-demo or http://localhost/manage Accept the popup app that notes that an install will occur. Reload the page for the installation to start. It can take up to 10 minutes. There will be another popup to click to go to the new site. Login as i2ce_admin with pass 'ihris'

This can be automated once the application and database are up:
```sh
docker ps
docker exec -it <container hash from ps command> bash
cd manage # or cd manage-demo
php index.php --update=1 # run this twice
```

If there are any issues, to troubleshoot, build then: docker run -it <image hash> bash

Todo
- [X] Build arg for DSN
- [x] Fix errors in manage-demo
- [ ] Update when object storage is added to iHRIS
