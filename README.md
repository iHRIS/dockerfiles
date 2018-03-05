# Docker builds for iHRIS

> Note: iHRIS is pinned to PHP 7.0 and MySQL 5.5 for the 4.3 release. 4.3-dev includes a fix for it to populate the database with no errors on 5.7.


### Configuration

The iHRIS apps require several configurations. Some are set using for build-time and some during runtime. The database connection string (DSN) is set using an environment variable and can change as needed at runtime.

One Dockerfile can build both blank and demo sites. This is done using build-time variables. See the Dockerfile [reference](https://docs.docker.com/engine/reference/builder/#arg). These variables are only possible to change before build-time and persist.

Both the ARGs and ENVs are set in the example docker-compose files. You can choose the default already in the Dockerfile or override them in docker-compose, other orchestration framework, or at build time on CLI.


### iHRIS Manage Blank Site

```
git clone https://github.com/ihris/dockerfiles
docker-compose -f docker-compose.manage.yml up -d
```

### iHRIS Manage Demo

```
git clone https://github.com/ihris/dockerfiles
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


### Mac using MySQL on localhost

> [Docker networking on Mac](https://docs.docker.com/docker-for-mac/networking/) and Windows uses a thin VM as Docker uses the Linux kernel. Localhost will be resolved as the VM not the host OS. Only on Linux as host OS will localhost  resolve as the host OS.

One solution is to keep all containers on the same virtual bridge. The docker-compose examples use 'mysql' as the host, which launches a mysql container, and is networked with the iHRIS container on the thin VM network bridge.

If you want to run mysql directly on the host OS and ensure that the iHRIS container can see it, then modify the DSN to use 'docker.for.mac.localhost' or 'docker.for.win.localhost' on Windows.

Install mysql using Homebrew.
```sh
brew install mysql
brew services start mysql
mysql -u root -p
# press enter, homebrew mysql has no root pass set
mysql> create database ihris;
mysql> grant all privileges on ihris.* to ihris@localhost identified by 'ihris';
mysql> exit
```

In /usr/local/etc/my.cnf, add the lines:
```
sql-mode = "ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION"
log_bin_trust_function_creators=ON
```

Restart mysql.
```sh
brew services restart mysql
```

Clone the repo, build the image, and run a container.
```sh
git clone https://github.com/ihris/dockerfiles
cd dockerfiles
docker build \
--build-arg MVER=4.3 \
--build-arg SOFT=ihris-manage \
--build-arg TYPE=Demo \
--build-arg SITE=manage-demo \
--build-arg MCONFIG=iHRIS-Manage-Demo.xml \
-t ihris-manage-demo .
docker run -d -p 80:80 --env DSN="mysql:user=ihris;pass=ihris;host=docker.for.mac.localhost;dbname=ihris" ihris-manage-demo
```


### Todo
- [X] Build env/arg for DSN
- [x] Fix errors in manage-demo
- [x] Single Dockerfile
- [ ] Tags builds for Docker hub -- `bzr log -r-1 -q | sed -n 2p | awk '{print ($2)}'`
- [ ] Update when object storage is added to iHRIS
- [ ] Rewrite paths to be simpler
- [ ] Use php-fpm container, preferably alpine

### PHP-FPM (in-progress)

To build the php-fpm container:

* make sure your mysql is running on your localhost
* clone the repo, cd into cloned repo.
then:
```
# build the image
docker build -f Dockerfile-fpm -t ihris-fpm .
# run an instance
# change the DSN to match yours, localhost on linux or docker for mac/win using mac/win
docker run -d -p 9000:9000 --env DSN="mysql:user=ihris;pass=ihris;host=docker.for.mac.host.internal;dbname=ihris" ihris-fpm
# run update script if needed
docker exec -it <image hash> bash
```
