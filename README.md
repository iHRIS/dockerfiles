# Docker builds for iHRIS

```sh
git clone https://github.com/citizenrich/ihris-docker
```

### iHRIS Manage Blank Site

Build.
```
docker-compose -f docker-compose.manage.yml up -d
```

### iHRIS Manage Demo

Build.
```
docker-compose -f docker-compose.manage.demo.yml up -d
```

Go to http://localhost/manage-demo Accept the popup app that notes that an install will occur.
Reload the page for the installation to start. It can take up to 10 minutes. There will be another popup to click to go to the new site. Login as i2ce_admin with pass 'manage'

This can be automated once the application and database are up:
```sh
cd /var/www/html/manage
php index.php --update=1
```

If there are any issues, to troubleshoot, build then: docker run -it <image hash> bash

Todo
- [ ] One Dockerfile using ARGs and ENVs for manage vs. manage-demo
- [ ] Fix errors in manage-demo
- [ ] Update when object storage is added to iHRIS
