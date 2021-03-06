FROM php:7.0-apache
# memcache, postfix and eventually apache should run in different containers.

RUN apt-get update &&\
    apt-get install -y wget libpng-dev libtidy-dev libicu-dev &&\
    docker-php-ext-install -j$(nproc) gd tidy intl bcmath pdo_mysql opcache

RUN apt-get install -y uuid-dev &&\
    pecl install uuid apcu &&\
    docker-php-ext-enable uuid apcu

RUN pear install Text_Password

WORKDIR /usr/local/etc/php/conf.d/

RUN echo 'apc.enabled=1\n\
apc.write_lock=1\n\
apc.shm_size=100M\n\
apc.slam_defense=0\n\
apc.enable_cli=1\n'\
>> docker-php-ext-apcu.ini && cat docker-php-ext-apcu.ini

# php-memcached will not install, do this instead
RUN apt-get install -y libmemcached-dev zlib1g-dev \
    && pecl install memcached \
    && docker-php-ext-enable memcached

RUN echo 'opcache.memory_consumption=128M\n\
opcache.interned_strings_buffer=8\n\
opcache.max_accelerated_files=4000\n\
opcache.revalidate_freq=60\n\
opcache.fast_shutdown=1\n\
opcache.enable_cli=1\n'\
>> docker-php-ext-opcache.ini && cat docker-php-ext-opcache.ini

RUN a2enmod rewrite

WORKDIR /etc/apache2

RUN sed -i "s|Options Indexes FollowSymLinks|Options Indexes FollowSymLinks MultiViews|" apache2.conf && cat apache2.conf | grep Options

ARG MVER=4.3
ARG SOFT=ihris-manage
ARG TYPE=blank
ARG SITE=manage
ARG MCONFIG=iHRIS-Manage-BLANK.xml

RUN mkdir -p /var/lib/iHRIS/lib/$MVER

WORKDIR /var/lib/iHRIS/lib/$MVER

RUN wget -q http://launchpad.net/i2ce/4.3/4.3.3/+download/ihris-suite-4.3.3.tar.bz2

RUN tar -xjf ihris-suite-4.3.3.tar.bz2

WORKDIR /var/lib/iHRIS/lib/$MVER/$SOFT/sites/$TYPE/pages

RUN cp htaccess.TEMPLATE .htaccess &&\
    sed -i 's|RewriteBase  /iHRIS|RewriteBase |' .htaccess &&\
    sed -i 's|SetEnv I2CE_Rewritten On|SetEnv I2CE_Rewritten On\n    SetEnv nocheck 1|' .htaccess &&\
    cat .htaccess && [ -d local ] || mkdir local

RUN echo "<?php \n\
\$i2ce_site_i2ce_path = '/var/lib/iHRIS/lib/$MVER/i2ce' ;\n\
\$i2ce_site_dsn = getenv('DSN') ;\n\
\$i2ce_site_module_config = '/var/lib/iHRIS/lib/$MVER/$SOFT/sites/$TYPE/$MCONFIG' ;\n\
\$i2ce_site_user_access_init = null ;" >> local/config.values.php && cat local/config.values.php

WORKDIR /var/lib/iHRIS/lib/$MVER/$SOFT/sites/$TYPE

RUN printf '    <enable name="csd-data-address-type" />\n\
    <enable name="csd_cache" />\n\
    <enable name="csd-data-dow" />\n\
    <enable name="csd-data-gender" />\n\
    <enable name="csd-data-provider-status" />\n\
    <enable name="csd-data-provider-data-model" />\n\
    <enable name="IL-HWR" />\n\
    <enable name="mHero" />\n\
    <enable name="csd-search" />\n\
    <enable name="CSD-data" />\n\
    <enable name="ihris-manage-mcsd-update-supplier" />\n\
    <enable name="PersonAttendance" />\n\
    ' >> enable.txt

RUN sed -i.bak '/<metadata>/r enable.txt' $MCONFIG

WORKDIR /var/www/html

RUN ln -s /var/lib/iHRIS/lib/$MVER/$SOFT/sites/$TYPE/pages $SITE
