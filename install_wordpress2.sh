#!/bin/bash

# Variables
DB_NAME="wordpress_db"
DB_USER="wordpress_user"
DB_PASSWORD="fukinroll"
WP_DIR="/var/www/html/wordpress"
WP_URL="http://192.168.64.20/wordpress"

# Update and install necessary packages
sudo apt-get update
sudo apt-get install -y apache2 mysql-server php libapache2-mod-php php-mysql php-curl php-gd php-intl php-mbstring php-soap php-xml php-zip php-xmlrpc php-cli

# Create WordPress directory
sudo mkdir $WP_DIR
sudo chown -R www-data:www-data $WP_DIR
sudo chmod -R 755 $WP_DIR

# Download and extract WordPress
wget -c http://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz -C /tmp
sudo cp -r /tmp/wordpress/* $WP_DIR

# Create MySQL database and user
sudo mysql -e "CREATE DATABASE $DB_NAME;"
sudo mysql -e "CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';"
sudo mysql -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Configure WordPress
sudo cp $WP_DIR/wp-config-sample.php $WP_DIR/wp-config.php
sudo sed -i "s/database_name_here/$DB_NAME/" $WP_DIR/wp-config.php
sudo sed -i "s/username_here/$DB_USER/" $WP_DIR/wp-config.php
sudo sed -i "s/password_here/$DB_PASSWORD/" $WP_DIR/wp-config.php

# Set WordPress site URL
echo "define('WP_SITEURL',  '$WP_URL');" | sudo tee -a $WP_DIR/wp-config.php
echo "define('WP_HOME', '$WP_URL');" | sudo tee -a $WP_DIR/wp-config.php

# Clean up
rm latest.tar.gz

# Restart Apache
sudo service apache2 restart

echo "WordPress installation completed successfully. Visit $WP_URL to configure your site."


