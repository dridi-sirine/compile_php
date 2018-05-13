#!/bin/sh

# Run this script as below
# ./compile_php.sh ~/www_sirine/test_infra/7.2.4 9000

# export /bin to global PATH linux variable
export PATH=$PATH:/bin

# Get parameters
# @TODO Set default value for all parameters
DIR=$1 # Installation directory
VERSION=$2 # PHP version
PORT=$3 # Internal PHP Web Server port

# Change directory to $DIR folder
cd $DIR

# Remove existing php source folder
/bin/rm -rf php-src

# @TODO Clone php-src repository with specific tag /usr/bin/git clone -b 'php-${VERSION}' --single-branch https://github.com/php/php-src.git && cd $(basename $_ .git)
# Clone php source code from github
#/usr/bin/git clone https://github.com/php/php-src.git # @TODO to remove

# Change directory to php source code folder
cd php-src # @TODO to remove

# Change source code to specific tag
git checkout tags/php-$VERSION # @TODO to remove

# Generate configure script for checking compilation dependencies
./buildconf --force

# Generate Makefile for compilation
./configure

# Compile
make

# Install compiled binary php into system folders /usr/bin/local ....
sudo make install

# Get installed php version
/usr/local/bin/php -v

# Create a new php file that display php configuation (php.ini)
echo "<?php phpinfo();" > index.php

# Kill process using ${PORT} if already in use
fuser -k ${PORT}/tcp

# Run built-in php server
/usr/local/bin/php -S localhost:${PORT}

