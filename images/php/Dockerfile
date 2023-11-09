# Base image on
ARG PHP_VERSION=$PHP_VERSION
FROM php:${PHP_VERSION}-fpm-alpine

# Instal packages and libraries
RUN apk add --no-cache \
        git \
        curl \
        icu-dev \
        icu-libs \
        icu-data-full \
        libxml2-dev \
        libzip-dev \
        freetype \
        freetype-dev \
        libgd \
        libjpeg-turbo \
        libjpeg-turbo-dev \
        libpng \
        libpng-dev \
        libxslt-dev \
        libxslt \
        libgcrypt-dev \
        libwebp-dev \
        linux-headers \
        nodejs \
        npm \
        subversion \
        patch \
        tar \
        gzip \
        mysql-client \
        redis \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-configure zip --with-zip \
    && docker-php-ext-install \
        bcmath \
        mysqli \
        pdo \
        pdo_mysql \
        intl \
        soap \
        sockets \
        zip \
        -j$(nproc) gd \
        xsl \
        simplexml \
        xmlwriter \
        zip

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

# Install magerun
RUN curl -O https://files.magerun.net/n98-magerun2.phar \
    && chmod +x n98-magerun2.phar \
    && mv n98-magerun2.phar /usr/bin/magerun


# Change uid and gid for www-data user
ARG USER_ID=$USER_ID
RUN apk --no-cache add shadow && \
    usermod -u $USER_ID www-data && \
    groupmod -g $USER_ID www-data

#Set SMTP server
ARG SMTP_HOST=$SMTP_HOST
ARG SMTP_PORT=$SMTP_PORT
RUN apk add --no-cache ssmtp
RUN echo "mailhub=$SMTP_HOST:$SMTP_PORT" > /etc/ssmtp/ssmtp.conf
RUN echo "sendmail_path = /usr/sbin/ssmtp -t" >> /usr/local/etc/php/conf.d/sendmail.ini

# Install grunt-cli
RUN npm install -g grunt-cli

CMD ["php-fpm", "-F"]

ARG SRC_PATH_CONTAINER=$SRC_PATH_CONTAINER
WORKDIR ${SRC_PATH_CONTAINER}
