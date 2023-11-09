# Useful tips

## Magento development

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


## CLI

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

