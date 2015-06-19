#!/bin/bash

# Déclaration des constantes parametrables.
readonly PACKET_MANAGER_NAME="yum"
FUNCTION_PACKET_MANAGER="serverInstaller"


function launch {
    # Démarre le script.
    serverInstaller
    
    #apacheInstaller
 #    mysqlInstaller
	# phpInstaller
	# vhostEditor
	# getGitRepository
	# composerInstaller
	# phpIniEditor
	# pearInstaller
	# deflateFileEditor
	# expireFileEditor
}

function serverInstaller {

	# Appel dynamiquement la methode correspondant au bon gestionnaire de packets.
	eval ${PACKET_MANAGER_NAME}

	# if [[ $PACKETMANAGER == "yum" ]]; then
	# 	echo "condition YUM"
	# 	# yum -y install nano
	# 	# yum -y install git
	# 	# yum -y install mod_ssl

	# 	#yum install ntp
	# elif [[ $PACKETMANAGER == "apt" ]]; then
	# 	echo "condition apt"
	# 	#statements
	# 	# cat /usr/share/zoneinfo/America/Montreal > /etc/localtime # TODO rendre variable la localité du serveur "America"
	# fi

	# echo "FIN DU IF"
}

function apacheInstaller {
    echo "apache installer"
}

function mysqlInstaller {
    echo "mysqlInstaller"
}

function phpInstaller {
    echo "phpInstaller"
}

function vhostEditor {
    echo "vhostEditor"
}

function getGitRepository {
    echo "getGitRepository"
}

function composerInstaller {
    echo "composerInstaller"
}

function phpIniEditor {
    echo "phpIniEditor"
}

function pearInstaller {
    echo "pearInstaller"
}

function deflateFileEditor {
    echo "deflateFileEditor"
}

function expireFileEditor {
    echo "expireFileEditor"
}

function apt {
    echo "apt"
}

function yum {
    echo "yum"
}

function aptitude {
	echo "aptitude"
}




# Lancement de l'application
launch

# yum -y install nano
# yum -y install git
# yum -y install mod_ssl

# yum install ntp

# cat /usr/share/zoneinfo/America/Montreal > /etc/localtime # TODO rendre variable la localité du serveur "America"

# # INSTALLATION D'APACHE
# yum -y install httpd
# systemctl enable httpd.service

# systemctl start httpd.service => START SERVICE

# apachectl configtest => TEST CONFIG OK

# # INSTALL MYSQL
# yum -y install mariadb

# # INSTALL PHP
# yum -y install php php-mysql php-gd php-pear
# yum -y install php-pgsql
# systemctl restart httpd.service => restart service

# # Appelle au script de creation du Vhost. (voir mail)
# # Faire le script de copie du Vhost dans le path approprié. (/etc/httpd/conf.d/bitume.conf)


# # Création + recuperation repository git
# mkdir /var/www/bitume
# git clone https://github.com/NGRP/Total-Bitume.git .

# # Installation composer + intl + mbstring
# curl -s http://getcomposer.org/installer | php
# yum -y install php-intl
# yum -y install php-mbstring


# # Edition du fichier php.ini. (Voir pour trouver le bon en fonction de la version de php utilisée).
# Dans /etc/php.ini => ajouter date.timezone = Europe/Paris

# short_open_tag = Off
# magic_quotes_gpc = Off
# register_globals = Off
# session.autostart = Off
# memory_limit = 256MB
# expose_php = Off


# # installation du pear (normalement installé, faire la verif)

# yum install -y php-pear
# yum install -y php-devel
# yum install -y gcc

# # creation /etc/httpd/conf.d/deflate.conf (voir mail)

# # Create /etc/httpd/conf.d/expire.conf (voir mail)

































