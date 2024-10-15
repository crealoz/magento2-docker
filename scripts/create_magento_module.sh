#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <module_directory> <vendor_name> <module_name>"
    exit 1
fi

# Assign arguments to variables
MODULE_DIR=$1
VENDOR=$2
MODULE=$3

# Function to prompt and create directory if needed
create_dir_if_needed() {
    local dir_path=$1
    local dir_name=$2
    read -p "Do you want to create the $dir_name directory? (y/n): " create_dir
    if [ "$create_dir" == "y" ]; then
        mkdir -p $dir_path
        echo "$dir_name directory created."
    fi
}

# Create base directories if they do not exist
mkdir -p $MODULE_DIR/etc

# Prompt for additional directories
create_dir_if_needed "$MODULE_DIR/Api" "Api"
create_dir_if_needed "$MODULE_DIR/Console" "Console"
create_dir_if_needed "$MODULE_DIR/Controller" "Controller"
create_dir_if_needed "$MODULE_DIR/Model" "Model"
create_dir_if_needed "$MODULE_DIR/Observer" "Observer"
create_dir_if_needed "$MODULE_DIR/Setup" "Setup"
create_dir_if_needed "$MODULE_DIR/Ui" "Ui"
create_dir_if_needed "$MODULE_DIR/view" "view"

# Create composer.json
cat <<EOL > $MODULE_DIR/composer.json
{
    "name": "$VENDOR/$MODULE",
    "description": "A Magento 2 module for FAQ",
    "require": {
        "php": "~7.4.0||~8.0.0",
        "magento/framework": "103.0.*"
    },
    "type": "magento2-module",
    "version": "1.0.0",
    "license": [
        "OSL-3.0",
        "AFL-3.0"
    ],
    "autoload": {
        "files": [
            "registration.php"
        ],
        "psr-4": {
            "$VENDOR\\\\$MODULE\\\\": ""
        }
    }
}
EOL

# Create etc/module.xml
cat <<EOL > $MODULE_DIR/etc/module.xml
<?xml version="1.0"?>
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="urn:magento:framework:Module/etc/module.xsd">
    <module name="${VENDOR}_${MODULE}" setup_version="1.0.0"/>
</config>
EOL

# Create registration.php
cat <<EOL > $MODULE_DIR/registration.php
<?php
\Magento\Framework\Component\ComponentRegistrar::register(
    \Magento\Framework\Component\ComponentRegistrar::MODULE,
    '${VENDOR}_${MODULE}',
    __DIR__
);
EOL

echo "Magento 2 module ${VENDOR}_${MODULE} structure created successfully."