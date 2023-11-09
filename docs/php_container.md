
# PHP Container

Some commands are available in the bin folder. I try to add them from time to time.

## Use composer

For a while, I could not have composer running using a generic command. So you need to first enter your php container:

```bash
docker exec -it my_magento_php bash
```

Then, you can use composer with the following command :

```bash
composer <command>
```

