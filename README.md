# Docker builds for iHRIS

### Configuration

The iHRIS apps require hard-coded configurations in the relevant site's config.php including the database connection string. For this reason, it may be preferred to build the container yourself. See the Dockerfile [reference](https://docs.docker.com/engine/reference/builder/#arg). This means that you cannot do run-time customization with these images with regards to the connection string. The default connection string is set in the Dockerfiles which can be overridden as needed.

The connection string is set with ARGs (AKA build-args, build-time only environment variables - different from ENVs).

```sh
# default, set in Dockerfiles
ARG DSN="mysql:user=ihris;pass=ihris;host=localhost;dbname=ihris"
```

You can choose the default already in the Dockerfile or override them in docker-compose, other orchestration framework, or at build time on CLI.

### Mac

> [Docker networking on Mac](https://docs.docker.com/docker-for-mac/networking/) and Windows uses a thin VM as Docker uses the Linux kernel. Localhost will be resolved as the VM not the host OS. Only on Linux as host OS will localhost  resolve as the host OS.

One solution is to keep all containers on the same virtual bridge. The docker-compose examples use 'mysql' as the host, which launches a mysql container, and is networked with the iHRIS container on the thin VM network bridge.

If you want to run mysql directly on the host OS and ensure that the iHRIS container can see it, then modify the DSN to use 'docker.for.mac.localhost' or 'docker.for.win.localhost' on Windows.

First, set up mysql using Homebrew.
```sh
brew install mysql
brew services start mysql
mysql -u root -p
# homebrew mysql has no root pass set
mysql> create database ihris;
mysql> grant all privileges on ihris.* to ihris@localhost identified by 'ihris';
# set this dynamic parameter for ihris
mysql> SET GLOBAL log_bin_trust_function_creators = 1;
mysql> exit
```

In /usr/local/etc/my.cnf, add the line: sql-mode = "ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION"

Restart mysql.
```sh
brew services restart mysql
```

```sh
git clone https://github.com/ihris/ihris-docker
cd ihris-docker
docker build -f Dockerfile-manage-demo --build-arg DSN="mysql:user=ihris;pass=ihris;host=docker.for.mac.localhost;dbname=ihris" -t ihris-manage-demo .
docker run -d -p 80:80 ihris-manage-demo
```

### iHRIS Manage Blank Site

```
git clone https://github.com/ihris/ihris-docker
docker-compose -f docker-compose.manage.yml up -d
```

### iHRIS Manage Demo

```
git clone https://github.com/ihris/ihris-docker
docker-compose -f docker-compose.manage.demo.yml up -d
```

Go to http://localhost/manage-demo or http://localhost/manage Accept the popup app that notes that an install will occur. Reload the page for the installation to start. It can take up to 10 minutes. There will be another popup to click to go to the new site. Login as i2ce_admin with pass 'ihris'

This can be automated once the application and database are up:

```sh
docker ps
docker exec -it <container hash> bash
cd manage # or cd manage-demo
php index.php --update=1 # run this twice
```

If there are any issues, to troubleshoot, build then: docker run -it <image hash> bash

Todo
- [X] Build arg for DSN
- [x] Fix errors in manage-demo
- [ ] Update when object storage is added to iHRIS
