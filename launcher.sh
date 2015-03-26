#!/bin/bash

# Déclaration des variables parametrables.
PACKET_MANAGER_NAME=""
FUNCTION_PACKET_MANAGER="serverInstaller"

# Variable par defaut
DEFAULT_PACKET_MANAGER="yum"
DEFAULT_LOCALITY="America"

function launch {
    # Démarre le script.

	launch_prompt

   
	# TODO sonde pour check la sortie de l'api
	echo $PACKET_MANAGER_NAME

 #    serverInstaller
 #    apacheInstaller
 #    mysqlInstaller
	phpInstaller
	# vhostEditor
	# getGitRepository
	# composerInstaller
	# phpIniEditor
	# pearInstaller
	# deflateFileEditor
	# expireFileEditor
	echo "DONE"
	current_prompt
}


function launch_prompt {
	while :
	do
		if [[ $PACKET_MANAGER_NAME == "" ]]; then
			echo "Selectionnez un gestionnaire de packet (YUM/apt/aptitude)"
			read packet_manager
			define_packet_manager $packet_manager
			break
		fi
		if [[ $LOCALITE == "" ]]; then
			echo "Selectionnez la localite (AMERICA/europa)"
			read input_localite
			break
		fi
	done
}

function current_prompt {
	while :
	do
		echo '#####>' 
		read out
		if [[ $out == "exit" ]]; then
			break
		fi
		echo $out
	done
}

function update {
	${PACKET_MANAGER_NAME} update
}
# Initialise le gestionnaire de packet en fonction de la saisie en console (yum par defaut).
function define_packet_manager {

	if [[ $1 == "" ]]; then
		PACKET_MANAGER_NAME=$DEFAULT_PACKET_MANAGER
	elif [[ $1 == "apt" ]]; then
		PACKET_MANAGER_NAME="sudo apt-get"
		apt
	elif [[ $1 == "aptitude" ]]; then
		PACKET_MANAGER_NAME="sudo apt-get"
		aptitude
	else
		PACKET_MANAGER_NAME=$DEFAULT_PACKET_MANAGER
	fi
}

function define_localite {

	if [[ $1 == "" ]]; then
		PACKET_MANAGER_NAME=$DEFAULT_LOCALITY
	elif [[ $1 == "apt" ]]; then
		PACKET_MANAGER_NAME="sudo apt-get"
	elif [[ $1 == "aptitude" ]]; then
		PACKET_MANAGER_NAME="sudo apt-get"
	else
		PACKET_MANAGER_NAME=$DEFAULT_LOCALITY
	fi
}


# Appel dynamiquement la methode correspondant au bon gestionnaire de packets.
function serverInstaller {

	# Appel dynamiquement la fonction selon le gestionnaire de packet définit
	eval ${PACKET_MANAGER_NAME}
	#cat /usr/share/zoneinfo/America/Montreal > /etc/localtime # TODO rendre variable la localité du serveur "America"
}

# INSTALLATION D'APACHE
function apacheInstaller {

	${PACKET_MANAGER_NAME} -y install httpd
	systemctl enable httpd.service
	systemctl start httpd.service => START SERVICE
	apachectl configtest => TEST CONFIG OK
}

# INSTALL MYSQL
function mysqlInstaller {

	${PACKET_MANAGER_NAME} -y install mariadb
}

function phpInstaller {
	
	#sudo chmod -777 /var/lib/dpkg/lock
    ${PACKET_MANAGER_NAME} -y install php php-mysql php-gd php-pear
	${PACKET_MANAGER_NAME} -y install php-pgsql
	#systemctl restart httpd.service => restart service
}

function vhostEditor {
    echo "vhostEditor"
}

# Création + recuperation repository git
function getGitRepository {

	mkdir /var/www/bitume
	git clone https://github.com/NGRP/Total-Bitume.git .
}

# Installation composer + intl + mbstring
function composerInstaller {

	curl -s http://getcomposer.org/installer | php
	${PACKET_MANAGER_NAME} -y install php-intl
	${PACKET_MANAGER_NAME} -y install php-mbstring
}

function phpIniEditor {
    echo "phpIniEditor"
    # Edition du fichier php.ini. (Voir pour trouver le bon en fonction de la version de php utilisée).
	# Dans /etc/php.ini => ajouter date.timezone = Europe/Paris

	# short_open_tag = Off
	# magic_quotes_gpc = Off
	# register_globals = Off
	# session.autostart = Off
	# memory_limit = 256MB
	# expose_php = Off
}

function pearInstaller {

    ${PACKET_MANAGER_NAME} install -y php-pear
	${PACKET_MANAGER_NAME} install -y php-devel
	${PACKET_MANAGER_NAME} install -y gcc
}

function deflateFileEditor {
    echo "deflateFileEditor"
    # # creation /etc/httpd/conf.d/deflate.conf (voir mail)
}

function expireFileEditor {
    echo "expireFileEditor"
    # # Create /etc/httpd/conf.d/expire.conf (voir mail)
}

function apt {
    aptitude
}

# TODO voir pour garder la fonction apt et aptitude.
function yum {
    ${PACKET_MANAGER_NAME} -y install nano
	${PACKET_MANAGER_NAME} -y install git
	${PACKET_MANAGER_NAME} -y install mod_ssl

	${PACKET_MANAGER_NAME} install ntp
}

# TODO no garde la fonction aptitude jusqu'a qu'on soit sur que les commandes apt et yum soient identiques.
function aptitude {
	echo "passage aptitude"
    ${PACKET_MANAGER_NAME} -y install nano
	# ${PACKET_MANAGER_NAME} -y install git
	# ${PACKET_MANAGER_NAME} -y install mod_ssl
	# ${PACKET_MANAGER_NAME} install ntp
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

































