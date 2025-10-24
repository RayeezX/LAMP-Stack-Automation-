#!/bin/bash
# Script: lamp_stack_setup.sh
# Description: Automates LAMP stack installation and configuration

LOG_FILE="/var/log/lamp_install.log"

echo "LAMP Installation Started at $(date)" | tee -a $LOG_FILE

# Update the system
sudo apt update -y && sudo apt upgrade -y | tee -a $LOG_FILE

# Install Apache
echo "Installing Apache..." | tee -a $LOG_FILE
sudo apt install apache2 -y | tee -a $LOG_FILE
sudo systemctl enable apache2
sudo systemctl start apache2

# Install MySQL
echo "Installing MySQL..." | tee -a $LOG_FILE
sudo apt install mysql-server -y | tee -a $LOG_FILE
sudo systemctl enable mysql
sudo systemctl start mysql

# Secure MySQL (optional)
sudo mysql -e "CREATE DATABASE sampledb;"
sudo mysql -e "CREATE USER 'lampuser'@'localhost' IDENTIFIED BY 'password123';"
sudo mysql -e "GRANT ALL PRIVILEGES ON sampledb.* TO 'lampuser'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Install PHP
echo "Installing PHP..." | tee -a $LOG_FILE
sudo apt install php libapache2-mod-php php-mysql -y | tee -a $LOG_FILE
sudo systemctl restart apache2

# Create a sample PHP page
echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/index.php > /dev/null

# Adjust permissions
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html

# Enable firewall
sudo ufw allow OpenSSH
sudo ufw allow 'Apache Full'
sudo ufw --force enable

echo "LAMP Stack Installed Successfully!" | tee -a $LOG_FILE
echo "Access your server at: http://$(hostname -I | awk '{print $1}')" | tee -a $LOG_FILE
