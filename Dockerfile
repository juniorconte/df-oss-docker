FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && apt-get install -y --no-install-recommends software-properties-common

# Instalar dependencias gerais
RUN apt-get install -y --no-install-recommends \
    git-core curl mcrypt nginx openssl zip unzip ssmtp wget

# Instalar PHP 7.1 com os módulos necessários
RUN LANG=C.UTF-8 add-apt-repository ppa:ondrej/php -y && \
    apt-get update && apt-get install -y --no-install-recommends --allow-unauthenticated \
    php7.1 php7.1-fpm php7.1-cli php7.1-dev php-pear php7.1-gd php7.1-imagick \
    php7.1-zip php7.1-curl php7.1-json php7.1-soap php7.1-bcmath php7.1-mbstring \
    php7.1-common php7.1-xml php7.1-mysql php7.1-pgsql php7.1-sqlite3 php7.1-pgsql \
    php7.1-sybase php7.1-memcached php7.1-redis php7.1-sqlite3 php7.1-ldap php7.1-interbase \
    php7.1-mcrypt php7.1-mysqlnd php7.1-mongodb

# Instalar NodeJS 16.x
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash
RUN apt-get update && apt-get install -y --no-install-recommends --allow-unauthenticated nodejs
# RUN ln -s /usr/bin/nodejs /usr/bin/node

# Configurar sendmail
RUN echo 'sendmail_path = "/usr/sbin/ssmtp -t"' > /etc/php/7.1/cli/conf.d/mail.ini

# Instalar PHP Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
    php -r "unlink('composer-setup.php');"

# Configurar Nginx/php-fpm
RUN rm /etc/nginx/sites-enabled/default
ADD dreamfactory.conf /etc/nginx/sites-available/dreamfactory.conf
RUN ln -s /etc/nginx/sites-available/dreamfactory.conf /etc/nginx/sites-enabled/dreamfactory.conf && \
    sed -i "s/pm.max_children = 5/pm.max_children = 5000/" /etc/php/7.1/fpm/pool.d/www.conf && \
    sed -i "s/pm.start_servers = 2/pm.start_servers = 150/" /etc/php/7.1/fpm/pool.d/www.conf && \
    sed -i "s/pm.min_spare_servers = 1/pm.min_spare_servers = 100/" /etc/php/7.1/fpm/pool.d/www.conf && \
    sed -i "s/pm.max_spare_servers = 3/pm.max_spare_servers = 200/" /etc/php/7.1/fpm/pool.d/www.conf && \
    sed -i "s/pm = dynamic/pm = ondemand/" /etc/php/7.1/fpm/pool.d/www.conf && \
    sed -i "s/worker_connections 768;/worker_connections 2048;/" /etc/nginx/nginx.conf && \
    sed -i "s/keepalive_timeout 65;/keepalive_timeout 10;/" /etc/nginx/nginx.conf

# Obter código do DF a partir do GitHub
RUN git clone https://github.com/dreamfactorysoftware/dreamfactory.git /opt/dreamfactory && \
    git config --global --add safe.directory /opt/dreamfactory

WORKDIR /opt/dreamfactory
RUN git checkout tags/2.14.1

WORKDIR /opt/dreamfactory

# Instalar o DF
RUN rm composer.lock && \
    composer config --no-plugins allow-plugins.kylekatarnls/update-helper true && \
    composer config --no-plugins allow-plugins.dreamfactory/installer true && \
    composer install --no-dev && \
    php artisan df:env --db_connection=sqlite --df_install=Docker && \
    chown -R www-data:www-data /opt/dreamfactory
ADD docker-entrypoint.sh /docker-entrypoint.sh
# set proper permission to docker-entrypoint.sh script and forward error logs to docker log collector
RUN chmod +x /docker-entrypoint.sh && ln -sf /dev/stderr /var/log/nginx/error.log && rm -rf /var/lib/apt/lists/*

EXPOSE 80

CMD ["/docker-entrypoint.sh"]
