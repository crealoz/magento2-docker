#!/usr/bin/env sh

echo "Downloading Magento from https://github.com/magento/magento2/archive/refs/tags/$M2_VERSION.tar.gz"

curl -LO "https://github.com/magento/magento2/archive/refs/tags/$M2_VERSION.tar.gz"

echo "Extracting Magento to /var/www/html"

tar -xf "$M2_VERSION.tar.gz" -C /var/www/html --strip-components=1

rm "$M2_VERSION.tar.gz"

echo "Running composer install"

composer install -d /var/www/html

echo "Install Magento with environment variables"

php /var/www/html/bin/magento setup:install \
      --base-url=https://$NGINX_HOST \
      --db-host=mysql \
      --db-name=$MYSQL_DATABASE \
      --db-user=root \
      --db-password=$MYSQL_ROOT_PASSWORD \
      --admin-firstname=$M2_ADMIN_FIRSTNAME \
      --admin-lastname=$M2_ADMIN_LASTNAME \
      --admin-email=$M2_ADMIN_EMAIL \
      --admin-user=$M2_ADMIN_USER \
      --admin-password=$M2_ADMIN_PASSWORD \
      --language=$M2_LANGUAGE \
      --currency=$M2_CURRENCY \
      --timezone=$M2_TIMEZONE \
      --use-rewrites=1 \
      --backend-frontname=$M2_ADMIN_URL \
      --search-engine=opensearch3 \
      --elasticsearch-host=opensearch \
      --elasticsearch-port=9200

echo "Setting ownership to www-data and adjust permissions to magento best practices"
chown -R www-data:www-data /var/www/html
find /var/www/html -type f -exec chmod 644 {} \;
find /var/www/html -type d -exec chmod 755 {} \;

echo -e "\e[1;32mMagento installed successfully\e[0m\n"

echo -e "Please run the following line on your host machine to update /etc/hosts else refer to appropriate documentation for your OS\n"

echo -e "Mac OS/Ubuntu : \e[1;32m sudo -- sh -c -e \"echo '$NGINX_IP $NGINX_HOST' >> /etc/hosts\" \e[0m"