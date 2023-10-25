# Docker containers for Magento

## General considerations

Passwords and users are provided as examples, consider changing them for your own security. The main idea is to have an
environment running easily when starting with a new project. The container is not dependant of the source code, so you 
can use it with any project. Said that, it can need some customizations to work.

It works with Magento 2 open source or commerce(enterprise) edition.

### Important

This environment is **not made to be used in production**. It's only made to be used in development environment. It is 
provided as is. I'm not responsible for any issue you can have with it and **I do not promise any support**. I am a
developer, not a devops. I just share my environment because I think it can be useful for others. If you see any improvement
please share and I will be happy to add it.

## Installation

First you need to modify the .env file to set your own values. Then you can start the containers with the following command :
    
```bash
docker-compose up -d
```

### Certificates

```bash
openssl req -subj '/CN=dev.magento.com' -x509 -newkey rsa:4096 -nodes -keyout data/certs/cert.key -out data/certs/cert.crt -days 365
```

As you probably adapted the nginx host to  your need in the .env file, you need to change it in this instruction as well.

## MySQL container

Magento database is normally generated by the proper command on a new installation. But if you want to use an existing one,
you need to import it. There is not yet any script that automatically import it. So you need to do it manually. To have 
your dump accessible from within the container. You need to place your dump in data folder. It is mounted in ```/data/```
folder.

Enter in your container :

```bash
docker exec -it my_magento_mysql bash
```

Once in the container, you can import your dump using the following command :

```bash
mysql -u root -p${MYSQL_ROOT_PASSWORD} ${MYSQL_DATABASE} < /data/<mydump>.sql
```



### Getting database from different environment

If you get database from different environment, you need to change the domain in the database. You can do it with the following command :

```bash
bin/updatecoreconfig
```

This command is made to create a copy of the file update-core-config.sql.template and replace the domain in it. 
Then it injects the sql script in the database. It's handy and permits to run it again if you need to change the domain.
It also sets the correct data for elasticsearch instances and modify some entries regarding development.

If for some reason, this command does not work, you can do it manually with the following commands :

First, you need to enter in your container using the same command as previously stated. Then, you need to execute the following command :

```bash
cp /data/update-core-config.sql.template /data/update-core-config.sql && sed -i "s/{DOMAIN}/${NGINX_HOST}/" /data/update-core-config.sql
```

Then inject your modified sql script in database using :

```bash
mysql -u root -p${MYSQL_ROOT_PASSWORD} ${MYSQL_DATABASE} < /data/update-core-config.sql
```

Database can be accessed in PHP Storm with proper configuration. The host will be 172.28.<your IP section>.5 when user and
password will be the ones that you set. You can also use phpmyadmin (see below).

## PHP Container

Some commands are available in the bin folder. I try to add them from time to time. 

### Use composer

For a while, I could not have composer running using a generic command. So you need to first enter your php container:

```bash
docker exec -it my_magento_php bash
```

Then, you can use composer with the following command :

```bash
composer <command>
```

Pro tips :-) :

Add symfony dumper and Mark Shust's super two-factor auth module :

```bash
composer require-dev symfony/var-dumper
composer require-dev mshust/magento2-two-factor-authentication
```
[Symfony dumper](https://symfony.com/doc/current/components/var_dumper.html) permits to dump large variables in the browser, using :

```php
dump($variable);
//or
dd($variable); //dump and die
```

[Mark Shust's module](https://github.com/markshust/magento2-module-disabletwofactorauth) allows you to activate/deactivate two-factor auth from the command line.

```bash
bin/magento config:set twofactorauth/general/enable 0
```

### CLI

This environment is shipped with a magento cli. You can use it with the following command :

```bash
bin/magento <command>
```

You can use it for all the commands of magento provided the ownership of files is correct. As Magento populates the
generated folder and I flush it quite often. I added a command to clean that folder. And another one to clean the log 
folder.

```bash
bin/cleangenerated
bin/cleanlogs
```

This environment is also shipped with a magerun. You can use it with the following command :

```bash
bin/magerun <command>
```

See [magerun github documentation](https://github.com/netz98/n98-magerun2/wiki) for more information.

## Elasticsearch

Elasticsearch is pretty greedy. For some of my projects, I needed two instances of elasticsearch. So I decided to create
them, but you can remove elasticsearch2 if not needed. If you make this change, don't forget to change the following lines:

```yaml
- discovery.seed_hosts=elasticsearch2
- cluster.initial_master_nodes=elasticsearch,elasticsearch2
```

to 

```yaml
- cluster.initial_master_nodes=elasticsearch
```

### Kibana

Kibana is also available. You can access it with the following url : http://localhost:5601. It will permit you to check 
the health of your elasticsearch instance.

### Troubleshooting

As said, elasticsearch is greedy. So you can have some issues with it. Check for vm.max_map_count on your host. If it's 
not set to 262144, you need to set it with the following command:

```bash
sudo sysctl -w vm.max_map_count=262144
```

## Other containers

### Transactional emails

You can see emails sent using mailhog. You can access it with the following url : http://localhost:8025. It is really not
perfect but it permits to check. There is not any nice display. You will need to consider using a different service if you
can.

### PHPMyAdmin

You can access phpmyadmin with the following url : http://localhost:8080. You can use the credentials you set in your .env
file.