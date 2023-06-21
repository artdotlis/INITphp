FROM docker.io/rockylinux:8 AS builder

COPY . /tmp/app

WORKDIR /tmp/app

RUN mkdir -p "${HOME}/.local/bin" && CGO_ENABLED=0 bash ./bin/deploy.sh

FROM docker.io/nginx:alpine3.17

RUN sed -i -e 's/v3\.17/v3.18/g' /etc/apk/repositories

RUN apk --no-cache update && apk add --upgrade apk-tools && apk upgrade --available && \
    apk --no-cache add php82 php82-fpm \
    php82-opcache php82-zip php82-intl \
    php82-bcmath php82-mbstring php82-xml php82-dom\
    php82-pdo php82-mysqlnd php82-pgsql

RUN mkdir -p /run/php-fpm/ && chown nginx:nginx /run/php-fpm

WORKDIR /var/www/

COPY --from=builder /var/www/ ./

COPY --from=builder /tmp/app /tmp/app

COPY --from=builder /docker-entrypoint.d/*  /docker-entrypoint.d/

RUN if grep -e "production:\s*true," "/tmp/app/src/initphp/ts/configs/project.js";then rm -rf /tmp/app; fi

HEALTHCHECK --interval=5m --timeout=3s CMD /health.sh
