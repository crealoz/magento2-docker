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

First you need to modify the .env file to set your own values. Copy .env.dist to .env and amend values to have something
fitting. If you do not know what to set, leave it as is. Then you can start the containers with the following command :
    
```bash
docker-compose up -d
```

### Certificates

```bash
openssl req -subj '/CN=dev.magento.com' -x509 -newkey rsa:4096 -nodes -keyout data/certs/cert.key -out data/certs/cert.crt -days 365
```

As you probably adapted the nginx host to  your need in the .env file, you need to change it in this instruction as well.

## Magento installation

### General installation

A script I created is available in bin folder. It will install Magento for you. **Before you run it**, ensure that you have
set the correct values in your .env file. Then you can run it with the following command :

```bash
bin/installmagento
```

What the magic script does :
* Download Magento from official repository using the version set in your .env file
* Extract it in the folder you set in your .env file
* Run composer install
* Run the installation command with the values set in your .env file
* Set the correct permissions on the folders
* Gives some hints on how to set you hosts file

Please have a look at the next section to find useful commands.

If the command to configure hosts file, you need to check your OS documentation to know how to do it. For example, on 
windows, you need to edit the file ```C:\Windows\System32\drivers\etc\hosts```. On linux, you need to edit the file 
```/etc/hosts```. On Mac, you need to edit the file ```/private/etc/hosts``` or ```/etc/hosts```.

### Use Magento Sample Data

This installation does not permit to have sample data with a single command. If you want to install it, you need to do
it manually. You can follow [official documentation](https://experienceleague.adobe.com/docs/commerce-operations/installation-guide/next-steps/sample-data/git-repositories.html?lang=en) on how to install magento then sample data.

Sample data is not mandatory. It's only useful if you want to have some products and categories to play with. It is often
an obstacle when you begin to play around and then you decide that you want to get rid of it.

## Other documentation entries

[Useful tips](docs/useful.md)

[More information about PHP Container](docs/php_container.md)

[More information about MySQL Container](docs/mysql_container.md)

[More information about Elasticsearch Container](docs/elasticsearch_container.md)

[More information about Other Containers](docs/other_containers.md)