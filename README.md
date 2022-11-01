# df-oss-docker

Docker container para o ambiente DreamFactory 2.14.1 Community Open Source com Ubuntu 20.04, PHP 7.1, NodeJS 16.x, V8 e NGINX.
Adaptação baseada em https://github.com/dreamfactorysoftware/df-docker/releases/tag/2.14.1

## Realizar o build da imagem localmente
`docker build . -t df-oss`

## Iniciar containers pela primeira vez
`docker compose up -d`

## Parar containers
`docker compose stop`

## Reiniciar containers
`docker compose start`

## Parar containers
`docker compose stop`

## Acesso ao DreamFactory
`http://localhost:3000`
    
# Opções de ambiente

|Option|Description| required? |default
|------|-----------|---|---|
|SERVERNAME|Domain for DF|no|dreamfactory.app
|DB_DRIVER|Database Driver (mysql,pgsql,sqlsrv,sqlite)|no|mysql when any DB_HOST supplied. Otherwise sqlite
|DB_HOST|Database Host|no|localhost
|DB_USERNAME|Database User|no|df_admin
|DB_PASSWORD|Database Password|no|df_admin
|DB_DATABASE|Database Name|no|dreamfactory
|DB_PORT|Database Port|no|3306
|CACHE_DRIVER|Cache Driver (file, redis, memcached)|no|*uses file*
|CACHE_HOST|Cache Host|no|*uses file caching*
|CACHE_DATABASE|Redis DB|only if CACHE_DRIVER is set to redis
|CACHE_PORT|Redis/Memcached Port|no|6379
|CACHE_PASSWORD|Redis/Memcached Password|no|*none used*
|CACHE_USERNAME|Memcached username|only if CACHE_DRIVER is set to memcached
|CACHE_WEIGHT|Memcached weight|only if CACHE_DRIVER is set to memcached
|CACHE_PERSISTENT_ID|Memcached persistent_id|only if CACHE_DRIVER is set to memcached
|APP_KEY|Application Key|yes for immutability|*generates a key*
|JWT_TTL|Login Token TTL|no|60
|JWT_REFRESH_TTL|Login Token Refresh TTL|no|20160
|ALLOW_FOREVER_SESSIONS|Allow refresh forever|no|false
|LOG_TO_STDOUT|Forward log to STDOUT|no|*not forwarded*
|SSMTP_mailhub|MX for mailing|yes if DF should mail|*no mailing capabilities*
|SSMTP_XXXX|prefix options with SSMTP_|no|see the [man page](http://manpages.ubuntu.com/manpages/trusty/man5/ssmtp.conf.5.html)
|LICENSE|DreamFactory commercial license (silver, gold). Requires setting up container with volume. See below for details.|no
|ADMIN_EMAIL|First admin user email|no
|ADMIN_PASSWORD|First admin user password|no
|ADMIN_FIRST_NAME|Admin user first name|no
|ADMIN_LAST_NAME|Admin user last name|no
