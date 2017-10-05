# Docker builds for iHRIS

```sh
git clone https://github.com/citizenrich/ihris-docker
```

### iHRIS Manage Blank Site

<more here>

### iHRIS Manage Demo

Build.
```
docker-compose -f docker-compose.manage.demo.yml up -d
```

After its done, go to http://localhost/manage-demo
Accept the popup app that notes that an install will occur.
Reload the page for the installation to start. It can take up to 10 minutes.
