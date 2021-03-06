#!/bin/bash
#####################################################
## Script de Configuração do Servidor LAMP & LEMP  ##
##                 BY: vendettafv                  ##
#####################################################

# Ubuntu 16.04 LTS (Xenial Xerus)
# Apache
# Nginx
# MariaDB 10
# MySQL 5.7
# PHP 7.2
# PHP 5.6
# Memcached
# phpMyAdmin
# SSL
# Composer
# Git

# Constante de Cores
# Black        0;30     Dark Gray     1;30
# Red          0;31     Light Red     1;31
# Green        0;32     Light Green   1;32
# Brown/Orange 0;33     Yellow        1;33
# Blue         0;34     Light Blue    1;34
# Purple       0;35     Light Purple  1;35
# Cyan         0;36     Light Cyan    1;36
# Light Gray   0;37     White         1;37
GREEN="\033[0;32m" # Verde
YELLOW="\033[1;33m" # Laranja
RED="\033[0;31m"   # Vermelho
NORMAL="\033[0m"   # Sem cor (Cor normal)

# Check root
if [[ $EUID -ne 0 ]]; then
   echo "Esse script precisa ser executado como root." 1>&2
   exit 1
fi

# Start
echo -e "${GREEN}Iniciando a Instalação do Servidor.${NORMAL}"

# Ambiente de Instalação
echo -e "${RED}1${NORMAL}) Localhost"
echo -e "${RED}2${NORMAL}) VPS ou Dedicado"
echo -ne "${GREEN}Qual tipo de ambiente você está utilizando?:${NORMAL} "
read TYPE

#Atualizando Sistema
echo -e "${YELLOW}Atualizando lista de pacotes e instalando as atualizações${NORMAL}"
sudo apt-get update && sudo apt-get -y upgrade && sudo apt-get -y dist-upgrade

# Instalando pacotes essenciais
echo -e "${YELLOW}Instalando pacotes essenciais${NORMAL}"
sudo apt-get install -y software-properties-common python-software-properties curl unzip

# Escolha o Web Server
echo -e "${RED}1${NORMAL}) apache2"
echo -e "${RED}2${NORMAL}) nginx"
echo -ne "${GREEN}Escolha o Web Server: ${NORMAL}"
read SERVER
if [ "$SERVER" == "1" ]; then
	# Apache
	echo -e "${YELLOW}Instalando Apache2${NORMAL}"
  sudo apt-get install -y apache2
  # Configurações do Firewall
  sudo ufw enable
  sudo ufw allow "Apache Full"
  sudo ufw allow "OpenSSH"
  # Versão do PHP
  echo -e "${RED}1${NORMAL}) PHP 5.6"
  echo -e "${RED}2${NORMAL}) PHP 7.2"
  echo -ne "${GREEN}Escolha a versão do PHP: ${NORMAL}"
  read PHPV1
  if [ "$PHPV1" == "1" ]; then
    # Instalando PHP 5.6
    echo -e "${YELLOW}Adiconando repositório do PHP 5.6${NORMAL}"
    sudo add-apt-repository -y ppa:ondrej/php && sudo apt-get update
	  echo -e "${YELLOW}Instalando PHP 5.6${NORMAL}"
    sudo apt install -y php5.6 libapache2-mod-php5.6 php5.6-curl php5.6-gd php5.6-mbstring php5.6-mcrypt php5.6-cli php5.6-memcached php5.6-mysql php5.6-xml php5.6-xmlrpc php5.6-intl php5.6-xsl php5.6-zip
    # sudo apt-get install memcached
    # Configurações do PHP
    # sed -i "s@^memory_limit.*@memory_limit = 512M@" /etc/php/5.6/apache2/php.ini
    # sed -i 's@^output_buffering =@output_buffering = On\noutput_buffering =@' /etc/php/5.6/apache2/php.ini
    sed -i 's@^;cgi.fix_pathinfo.*@cgi.fix_pathinfo=0@' /etc/php/5.6/apache2/php.ini
    # sed -i 's@^short_open_tag = Off@short_open_tag = On@' /etc/php/5.6/apache2/php.ini
    # sed -i 's@^expose_php = On@expose_php = Off@' /etc/php/5.6/apache2/php.ini
    # sed -i 's@^request_order.*@request_order = "CGP"@' /etc/php/5.6/apache2/php.ini
    sed -i 's@^;date.timezone.*@date.timezone = America/Sao_Paulo@' /etc/php/5.6/apache2/php.ini
    sed -i 's@^post_max_size.*@post_max_size = 100M@' /etc/php/5.6/apache2/php.ini
    sed -i 's@^upload_max_filesize.*@upload_max_filesize = 100M@' /etc/php/5.6/apache2/php.ini
    sed -i 's@^max_execution_time.*@max_execution_time = 600@' /etc/php/5.6/apache2/php.ini
    # sed -i 's@^;realpath_cache_size.*@realpath_cache_size = 2M@' /etc/php/5.6/apache2/php.ini
    # sed -i 's@^disable_functions.*@disable_functions = passthru,exec,system,chroot,chgrp,chown,shell_exec,proc_open,proc_get_status,ini_alter,ini_restore,dl,openlog,syslog,readlink,symlink,popepassthru,stream_socket_server,fsocket,popen@' /etc/php/5.6/apache2/php.ini
    # [ -ne /usr/sbin/sendmail ] && sed -i 's@^;sendmail_path.*@sendmail_path = /usr/sbin/sendmail -t -i@' /etc/php/5.6/apache2/php.ini
    # sed -i "s@^;curl.cainfo.*@curl.cainfo = ${openssl_install_dir}/cert.pem@" /etc/php/5.6/apache2/php.ini
    # sed -i "s@^;openssl.cafile.*@openssl.cafile = ${openssl_install_dir}/cert.pem@" /etc/php/5.6/apache2/php.ini
    # Restart Apache2
    sudo /etc/init.d/apache2 restart
  elif [ "$PHPV1" == "2" ]; then
    # Instalando PHP 7.2
    echo -e "${YELLOW}Adiconando repositório do PHP 7.2${NORMAL}"
    sudo add-apt-repository -y ppa:ondrej/php && sudo apt-get update
    echo -e "${YELLOW}Instalando PHP 7.2 e alguns pacotes${NORMAL}"
    sudo apt-get install -y php7.2 libapache2-mod-php7.2 php7.2-curl php7.2-gd php7.2-mbstring php7.2-cli php-memcached php7.2-mysql php7.2-xml php7.2-xmlrpc php7.2-sqlite3 php7.2-json php7.2-zip
    # Configurações do PHP
    # sed -i "s@^memory_limit.*@memory_limit = 512M@" /etc/php/7.2/apache2/php.ini
    # sed -i 's@^output_buffering =@output_buffering = On\noutput_buffering =@' /etc/php/7.2/apache2/php.ini
    sed -i 's@^;cgi.fix_pathinfo.*@cgi.fix_pathinfo=0@' /etc/php/7.2/apache2/php.ini
    # sed -i 's@^short_open_tag = Off@short_open_tag = On@' /etc/php/7.2/apache2/php.ini
    # sed -i 's@^expose_php = On@expose_php = Off@' /etc/php/7.2/apache2/php.ini
    # sed -i 's@^request_order.*@request_order = "CGP"@' /etc/php/7.2/apache2/php.ini
    sed -i 's@^;date.timezone.*@date.timezone = America/Sao_Paulo@' /etc/php/7.2/apache2/php.ini
    sed -i 's@^post_max_size.*@post_max_size = 100M@' /etc/php/7.2/apache2/php.ini
    sed -i 's@^upload_max_filesize.*@upload_max_filesize = 100M@' /etc/php/7.2/apache2/php.ini
    sed -i 's@^max_execution_time.*@max_execution_time = 600@' /etc/php/7.2/apache2/php.ini
    # sed -i 's@^;realpath_cache_size.*@realpath_cache_size = 2M@' /etc/php/7.2/apache2/php.ini
    # sed -i 's@^disable_functions.*@disable_functions = passthru,exec,system,chroot,chgrp,chown,shell_exec,proc_open,proc_get_status,ini_alter,ini_restore,dl,openlog,syslog,readlink,symlink,popepassthru,stream_socket_server,fsocket,popen@' /etc/php/7.2/apache2/php.ini
    # [ -ne /usr/sbin/sendmail ] && sed -i 's@^;sendmail_path.*@sendmail_path = /usr/sbin/sendmail -t -i@' /etc/php/7.2/apache2/php.ini
    # sed -i "s@^;curl.cainfo.*@curl.cainfo = ${openssl_install_dir}/cert.pem@" /etc/php/7.2/apache2/php.ini
    # sed -i "s@^;openssl.cafile.*@openssl.cafile = ${openssl_install_dir}/cert.pem@" /etc/php/7.2/apache2/php.ini
    # Restart Apache2
    sudo /etc/init.d/apache2 restart
  fi
elif [ "$SERVER" == "2" ]; then
  # Repositório nginx
  sudo add-apt-repository -y ppa:nginx/stable && sudo apt-get update
  # nginx
	echo -e "${YELLOW}Instalando nginx${NORMAL}"
  sudo apt-get install -y nginx
  # Configurações do Firewall
  sudo ufw enable
  sudo ufw allow "Nginx Full"
  sudo ufw allow "OpenSSH"
  sudo ufw delete allow 'Nginx HTTP'

  # Versão do PHP para nginx
  echo -e "${RED}1${NORMAL}) PHP 5.6 + PHP-FPM"
  echo -e "${RED}2${NORMAL}) PHP 7.2 + PHP-FPM"
  echo -ne "${GREEN}Escolha a versão do PHP: ${NORMAL}"
  read PHPV2
  if [ "$PHPV2" == "1" ]; then
    # Instalando PHP 5.6
    echo -e "${YELLOW}Adiconando repositório do PHP 5.6${NORMAL}"
    sudo add-apt-repository -y ppa:ondrej/php && sudo apt-get update
	  echo -e "${YELLOW}Instalando 5.6 + PHP-FPM${NORMAL}"
    sudo apt-get install -y php5.6 php5.6-fpm php5.6-curl php5.6-gd php5.6-mbstring php5.6-mcrypt php5.6-cli php5.6-memcached php5.6-mysql php5.6-xml php5.6-xmlrpc php5.6-intl php5.6-xsl php5.6-zip
    # sudo apt-get install memcached
    # Configurações do PHP
    # sed -i "s@^memory_limit.*@memory_limit = 512M@" /etc/php/5.6/fpm/php.ini
    # sed -i 's@^output_buffering =@output_buffering = On\noutput_buffering =@' /etc/php/5.6/fpm/php.ini
    sed -i 's@^;cgi.fix_pathinfo.*@cgi.fix_pathinfo=0@' /etc/php/5.6/fpm/php.ini
    # sed -i 's@^short_open_tag = Off@short_open_tag = On@' /etc/php/5.6/fpm/php.ini
    # sed -i 's@^expose_php = On@expose_php = Off@' /etc/php/5.6/fpm/php.ini
    # sed -i 's@^request_order.*@request_order = "CGP"@' /etc/php/5.6/fpm/php.ini
    sed -i 's@^;date.timezone.*@date.timezone = America/Sao_Paulo@' /etc/php/5.6/fpm/php.ini
    sed -i 's@^post_max_size.*@post_max_size = 100M@' /etc/php/5.6/fpm/php.ini
    sed -i 's@^upload_max_filesize.*@upload_max_filesize = 100M@' /etc/php/5.6/fpm/php.ini
    sed -i 's@^max_execution_time.*@max_execution_time = 600@' /etc/php/5.6/fpm/php.ini
    # sed -i 's@^;realpath_cache_size.*@realpath_cache_size = 2M@' /etc/php/5.6/fpm/php.ini
    # sed -i 's@^disable_functions.*@disable_functions = passthru,exec,system,chroot,chgrp,chown,shell_exec,proc_open,proc_get_status,ini_alter,ini_restore,dl,openlog,syslog,readlink,symlink,popepassthru,stream_socket_server,fsocket,popen@' /etc/php/5.6/fpm/php.ini
    # [ -ne /usr/sbin/sendmail ] && sed -i 's@^;sendmail_path.*@sendmail_path = /usr/sbin/sendmail -t -i@' /etc/php/5.6/fpm/php.ini
    # sed -i "s@^;curl.cainfo.*@curl.cainfo = ${openssl_install_dir}/cert.pem@" /etc/php/5.6/fpm/php.ini
    # sed -i "s@^;openssl.cafile.*@openssl.cafile = ${openssl_install_dir}/cert.pem@" /etc/php/5.6/fpm/php.ini
    # Configurações do Nginx
    sudo mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default_config
    # Move o novo arquivo de configurações
    sudo mv /tmp/perfect-server/conf/default_5-6 /etc/nginx/sites-available/default
    # Restart PHP-FPM & Nginx
    sudo systemctl restart php5.6-fpm && sudo systemctl restart nginx
    sudo echo "<?php phpinfo(); ?>" > /var/www/html/info.php
  elif [ "$PHPV2" == "2" ]; then
    # Instalando PHP 7.2
    echo -e "${YELLOW}Adiconando repositório do PHP 7.2${NORMAL}"
    sudo add-apt-repository -y ppa:ondrej/php && sudo apt-get update
	  echo -e "${YELLOW}Instalando PHP 7.2 + PHP-FPM${NORMAL}"
    sudo apt-get install -y php7.2-cli php7.2-fpm php7.2-mysql php7.2-curl php-memcached php7.2-dev php7.2-sqlite3 php7.2-mbstring php7.2-gd php7.2-json php7.2-xmlrpc php7.2-xml php7.2-zip
    # Configurações do PHP
    # sed -i "s@^memory_limit.*@memory_limit = ${Memory_limit}M@" /etc/php/7.2/fpm/php.ini
    # sed -i 's@^output_buffering =@output_buffering = On\noutput_buffering =@' /etc/php/7.2/fpm/php.ini
    sed -i 's@^;cgi.fix_pathinfo.*@cgi.fix_pathinfo=0@' /etc/php/7.2/fpm/php.ini
    # sed -i 's@^short_open_tag = Off@short_open_tag = On@' /etc/php/7.2/fpm/php.ini
    # sed -i 's@^expose_php = On@expose_php = Off@' /etc/php/7.2/fpm/php.ini
    # sed -i 's@^request_order.*@request_order = "CGP"@' /etc/php/7.2/fpm/php.ini
    sed -i 's@^;date.timezone.*@date.timezone = America/Sao_Paulo@' /etc/php/7.2/fpm/php.ini
    sed -i 's@^post_max_size.*@post_max_size = 100M@' /etc/php/7.2/fpm/php.ini
    sed -i 's@^upload_max_filesize.*@upload_max_filesize = 100M@' /etc/php/7.2/fpm/php.ini
    sed -i 's@^max_execution_time.*@max_execution_time = 600@' /etc/php/7.2/fpm/php.ini
    # sed -i 's@^;realpath_cache_size.*@realpath_cache_size = 2M@' /etc/php/7.2/fpm/php.ini
    # sed -i 's@^disable_functions.*@disable_functions = passthru,exec,system,chroot,chgrp,chown,shell_exec,proc_open,proc_get_status,ini_alter,ini_restore,dl,openlog,syslog,readlink,symlink,popepassthru,stream_socket_server,fsocket,popen@' /etc/php/7.2/fpm/php.ini
    # [ -ne /usr/sbin/sendmail ] && sed -i 's@^;sendmail_path.*@sendmail_path = /usr/sbin/sendmail -t -i@' /etc/php/7.2/fpm/php.ini
    # sed -i "s@^;curl.cainfo.*@curl.cainfo = ${openssl_install_dir}/cert.pem@" /etc/php/7.2/fpm/php.ini
    # sed -i "s@^;openssl.cafile.*@openssl.cafile = ${openssl_install_dir}/cert.pem@" /etc/php/7.2/fpm/php.ini
    # Configurações do Nginx
    sudo mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default_config
    # Move o novo arquivo de configurações
    sudo mv /tmp/perfect-server/conf/default_7-2 /etc/nginx/sites-available/default
    # Restart PHP-FPM & Nginx
    sudo systemctl restart php7.2-fpm && sudo systemctl restart nginx
    sudo echo "<?php phpinfo(); ?>" > /var/www/html/info.php
  fi
fi

# Instalação do SGBD
echo -e "${RED}1${NORMAL}) MySQL"
echo -e "${RED}2${NORMAL}) MariaDB"
echo -ne "${GREEN}Escolha o SGBD: ${NORMAL}"
read SQLSERVER
if [ "$SQLSERVER" == "1" ]; then
  # MySQL
  echo -e "${YELLOW}Instalando MySQL${NORMAL}"
  sudo apt-get install -y mysql-server
elif [ "$SQLSERVER" == "2" ]; then
  # MariaDB
  echo -e "${YELLOW}Instalando MariaDB${NORMAL}"
  sudo apt-get install -y mariadb-server mariadb-client
fi

# Instalação segura do MySQL/MariaDB
echo -ne "${GREEN}Realizar instalação segura do MySQL/MariaDB?${NORMAL} [Y/n]: "
read SGBDSECURE
if [[ $SGBDSECURE = [yY] ]]; then
  # Instalação segura
  echo -e "${YELLOW}Realizando instalação segura${NORMAL}"
	sudo mysql_secure_installation
fi

# Instalação do phpMyadmin
echo -ne "${GREEN}Deseja instalar o phpMyAdmin?${NORMAL} [Y/n]: "
read PHPMYADMIN
if [[ $PHPMYADMIN = [yY] ]]; then
  # Repositório phpMyAdmin
  # sudo add-apt-repository -y ppa:nijel/phpmyadmin && sudo apt-get update
  # phpMyAdmin
  echo -e "${YELLOW}Instalando phpMyAdmin${NORMAL}"
  sudo apt-get install -y phpmyadmin
  # Fix phpMyAdmin
  if [ "$PHPV1" == "2" ] || [ "$PHPV2" == "2" ]; then
    # Fix phpMyAdmin PHP 7.2.x
    echo -e "${YELLOW}Realizando ajustes para PHP 7${NORMAL}"
    cd /usr/share
    sudo rm -rf phpmyadmin
    sudo wget -P /usr/share/ "https://files.phpmyadmin.net/phpMyAdmin/4.8.2/phpMyAdmin-4.8.2-all-languages.zip"
    sudo unzip phpMyAdmin-4.8.2-all-languages.zip
    sudo cp -r phpMyAdmin-4.8.2-all-languages phpmyadmin
    sudo rm -rf phpMyAdmin-4.8.2-all-languages
    sudo rm -rf phpMyAdmin-4.8.2-all-languages.zip
    cd /usr/share/phpmyadmin
    sudo rm -rf favicon.ico
    sudo mv /tmp/perfect-server/conf/favicon.ico /usr/share/phpmyadmin/favicon.ico
    sudo mv /tmp/perfect-server/conf/config.inc_new.php /usr/share/phpmyadmin/config.inc.php
    sudo mkdir tmp && sudo chown -R www-data:www-data /usr/share/phpmyadmin/tmp
    sudo mkdir upload && sudo mkdir save
    sudo wget -P /usr/share/phpmyadmin/themes/ "https://files.phpmyadmin.net/themes/metro/2.8/metro-2.8.zip"
    cd /usr/share/phpmyadmin/themes
    sudo unzip metro-2.8.zip
    sudo rm -rf metro-2.8.zip
  fi
  if [ "$SERVER" == "1" ]; then
    # Fix Apache2
    echo -e "${YELLOW}Realizando ajustes para apache2${NORMAL}"
    sudo echo "Include /etc/phpmyadmin/apache.conf" >> /etc/apache2/apache2.conf
    # Restart Apache2
    echo -e "${YELLOW}Reiniciando  Apache${NORMAL}"
    sudo /etc/init.d/apache2 restart
  elif [ "$SERVER" == "2" ]; then
    # Fix nginx
    echo -e "${YELLOW}Realizando ajustes para nginx${NORMAL}"
    sudo ln -s /usr/share/phpmyadmin/ /var/www/html
    # Restart nginx
    echo -e "${YELLOW}Reiniciando nginx${NORMAL}"
    sudo service nginx restart
  fi
fi

# Instalação de Certificado SSL
if [ "$TYPE" == "2" ]; then
  # Iniciando instalação
  echo -ne "${GREEN}Deseja instalar o certificado SSL Let's Encrypt?${NORMAL} [Y/n]: "
  read SITESSL
  if [[ $SITESSL = [yY] ]]; then
    # Certbot
    echo -e "${YELLOW}Instalando SSL${NORMAL}"
    sudo add-apt-repository -y ppa:certbot/certbot && sudo apt-get update
    sudo apt-get install -y python-certbot-nginx
    # Domínio
    # Instalação do SGBD
    echo -e "${RED}1${NORMAL}) Sim"
    echo -e "${RED}2${NORMAL}) Não (Instalação padrão)"
    echo -ne "${GREEN}: ${NORMAL}"
    read SQLSERVER
    echo -ne "${GREEN}Digite o domínio em que deseja instalar o certificado SSL${NORMAL}: "
    read DOMAIN
    sudo letsencrypt certonly -a webroot --webroot-path=/usr/share/nginx/$DOMAIN/ -d $DOMAIN
  fi
fi

# Instalação do Composer
echo -ne "${GREEN}Deseja instalar o Composer?${NORMAL} [Y/n]: "
read COMPOSER
if [[ $COMPOSER = [yY] ]]; then
  # Composer
  echo -e "${YELLOW}Instalando Composer${NORMAL}"
  curl -sS https://getcomposer.org/installer | php
  sudo mv composer.phar /usr/local/bin/composer
fi

# Instalação do Git
echo -ne "${GREEN}Deseja instalar o Git?${NORMAL} [Y/n]: "
read GIT
if [[ $GIT = [yY] ]]; then
  # Git
  echo -e "${YELLOW}Instalando Git${NORMAL}"
  sudo apt-get install -y git
fi

# Configurações finais
sudo apt-get update && sudo apt-get -y upgrade
echo -e "${GREEN}Instalação finalizada com sucesso!${NORMAL}"