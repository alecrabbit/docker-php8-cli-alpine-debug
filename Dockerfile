FROM dralec/php80-cli-alpine
LABEL Description="Application container"

ENV PHP_XDEBUG_VERSION 3.0.1

# persistent / runtime deps
ENV PHPIZE_DEPS \
    autoconf \
    cmake \
    file \
    g++ \
    gcc \
    libc-dev \
    pcre-dev \
    make \
    pkgconf \
    re2c \
    # for GD
    freetype-dev \
    libpng-dev  \
    libjpeg-turbo-dev \
    libxslt-dev

  ARG COMPOSER_PACKAGES="\
      phpmetrics/phpmetrics \
      phpstan/phpstan \
      phpunit/phpunit \
      edgedesign/phpqa \
      vimeo/psalm \
      sensiolabs/security-checker \
      friendsofphp/php-cs-fixer \
      jakub-onderka/php-parallel-lint \
      jakub-onderka/php-var-dump-check \
      jakub-onderka/php-console-highlighter \
      "

  RUN set -xe \
      && apk add --no-cache --virtual .build-deps \
          $PHPIZE_DEPS \
      && pecl install xdebug-${PHP_XDEBUG_VERSION} \
      && docker-php-ext-enable xdebug \
      && echo 'xdebug.cli_color=1' > /usr/local/etc/php/conf.d/xdebug.ini \
      && apk del .build-deps \
      && composer --no-interaction global --prefer-stable require ${COMPOSER_PACKAGES} \
      && composer clear-cache \
      && rm -rf /tmp/cache



# COPY ./patch/bin/multi-tester /tmp/vendor/bin/multi-tester
# COPY ./patch/src/. /tmp/vendor/kylekatarnls/multi-tester/src/MultiTester/.

WORKDIR /var/www
