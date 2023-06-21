FROM docker.io/nginx:alpine3.17

RUN sed -i -e 's/v3\.17/v3.18/g' /etc/apk/repositories

RUN apk --no-cache update && apk add --upgrade apk-tools && apk upgrade --available && \
    apk --no-cache add php82 php82-fpm \
    php82-opcache php82-zip php82-intl \
    php82-bcmath php82-mbstring php82-xml php82-dom\
    php82-pdo php82-mysqlnd php82-pgsql

RUN mkdir -p /run/php-fpm/ && chown nginx:nginx /run/php-fpm

COPY ./bin/deploy/entry_web.sh /docker-entrypoint.d/99-php-fpm.sh

RUN chmod +x /docker-entrypoint.d/99-php-fpm.sh