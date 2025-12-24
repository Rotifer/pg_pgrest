#!/usr/bin/bash

file2process=$1
sudo cp $file2process /var/www/html/$file2process
sudo chown www-data:www-data /var/www/html/$file2process
sudo chmod 644 /var/www/html/$file2process
