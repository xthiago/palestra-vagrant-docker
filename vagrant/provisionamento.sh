#!/usr/bin/env bash
echo ">>> Iniciando o provisionamento"

echo ">>> Criando SWAP"
sudo dd if=/dev/zero of=/swapfile bs=1024 count=512k
sudo mkswap /swapfile
sudo swapon /swapfile
sudo echo "/swapfile       none    swap    sw      0       0 " >> /etc/fstab
sudo chown vagrant:vagrant /swapfile
sudo chmod 0600 /swapfile

# Atualiza lista de pacotes.
sudo apt-get update

# Define diretivas que permitirão instalar MySQL sem ter que digitar a senha.
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'

# Instala PHP + Apache + MySQL
sudo apt-get install -y php5 apache2 libapache2-mod-php5 php5-mysql mysql-server

# Ajusta configurações do PHP
sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini

# Ajusta configurações do MySQL
sudo sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/my.cnf
mysql --password=root -u root --execute="GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION; FLUSH PRIVILEGES;"
sudo service mysql restart

# Ajusta configurações do Apache
sudo sed -i 's/User ${APACHE_RUN_USER}/User vagrant/g' /etc/apache2/apache2.conf
sudo sed -i 's/Group ${APACHE_RUN_GROUP}/Group vagrant/g' /etc/apache2/apache2.conf
sudo service apache2 restart

# Configura diretório da aplicação
sudo rm -rf /var/www/
sudo ln -sf /files /var/www
sudo chown vagrant.vagrant /files -R

# Adiciona arquivo index.php
echo "<?php	 phpinfo(); ?>" > /var/www/index.php

echo ">>> Provisionamento finalizado. Acesse: http://127.0.0.1:2015"
