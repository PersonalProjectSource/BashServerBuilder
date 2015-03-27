#!/bin/bash
# Déclaration des variables parametrables.
PACKET_MANAGER_NAME=""
LOCALITY=""
FUNCTION_PACKET_MANAGER="serverInstaller"
# SUFFIXE QU'ON UTILISERA POUR UN APPEL DYNAMIQUE DES FONCTIONS
FUNCTION_SUFFIXE=""

# Variable par defaut
DEFAULT_PACKET_MANAGER="yum"
DEFAULT_LOCALITY="Europe/Paris"
PATH_TEMPO_FOLDER="temporary"
VHOST_PATH="/etc/apache2/sites-available"
PATH_PHP_INI="/etc/php5/apache2/php.ini"
ABSOLUTE_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)

function launch {
    # Démarre le script.

	launch_prompt
   
	# TODO sonde pour check la sortie de l'api
	echo $PACKET_MANAGER_NAME
    serverInstaller_${FUNCTION_SUFFIXE}
    apacheInstaller_${FUNCTION_SUFFIXE}

    # TODO mysqlInstaller_${FUNCTION_SUFFIXE} TODO trouver le packet mariadb pour apt
	phpInstaller_${FUNCTION_SUFFIXE}
	vhostEditor
	getGitRepository
	composerInstaller_${FUNCTION_SUFFIXE}
	phpIniEditor
	# ? pearInstaller_${FUNCTION_SUFFIXE}
	deflateFileEditor
	expireFileEditor
	echo "DONE"
	current_prompt

	# FAIRE UN SYSTEME DE LOG POUR VOIR LES ETATS ECHEC OU SUCCESS DES ETAPES
}


function launch_prompt {
	while :
	do
		if [[ $PACKET_MANAGER_NAME == "" ]]; then
			printf "Selectionnez un gestionnaire de packet (YUM/apt/aptitude) : "
			read packet_manager
			FUNCTION_SUFFIXE=$packet_manager
			define_packet_manager $packet_manager
		fi
		if [[ $LOCALITY == "" ]]; then
			printf "Selectionnez la localite (amerique|EUROPE/PARIS) : "
			read input_localite
			define_localite
			break;
		fi
	done
}

function current_prompt {
	while :
	do
		printf '#>> ' 
		read out manager action packet
		
		if [[ $out == "exit" ]]; then
			break
		elif [[ $out == "sudo" ]]; then
			#$out
			$out $manager $action $packet
		else
			dynamic_name=$out$FUNCTION_SUFFIXE 
			eval ${dynamic_name}
		fi
	done
}




function update {
	${PACKET_MANAGER_NAME} update
}


function make_vhost {
	printf "Nom du fichier Vhost  : "
	read vhostname

	printf "ServerAdmin  : "
	read serveradmin

	printf "ServerName  : "
	read servername

	printf "DocumentRoot  : "
	read documentroot

	printf "numero du port  : "
	read port


	Configuration_files/default_vhost.conf coucou toi 
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
		LOCALITY=$DEFAULT_LOCALITY
	elif [[ $1 == "A" ]]; then
		LOCALITY="America"
	elif [[ $1 == "E" ]]; then
		LOCALITY="Europa/Paris"
	else
		LOCALITY=$DEFAULT_LOCALITY
	fi
}


# Appel dynamiquement la methode correspondant au bon gestionnaire de packets.
function serverInstaller_yum {

	yum -y install nano
	yum -y install git
	yum -y install mod_ssl
	#cat /usr/share/zoneinfo/America/Montreal > /etc/localtime # TODO rendre variable la localité du serveur "America"
}

# Appel dynamiquement la methode correspondant au bon gestionnaire de packets.
function serverInstaller_apt {

	echo "INSTALL NANO"
	sudo apt-get install nano
	sudo apt-get install install git
	sudo apt-get install install mod_ssl
	#cat /usr/share/zoneinfo/America/Montreal > /etc/localtime # TODO rendre variable la localité du serveur "America"
}

# INSTALLATION D'APACHE AVEC APT PACKET MANAGER
function apacheInstaller_apt {

	${PACKET_MANAGER_NAME} install apache2
	#${PACKET_MANAGER_NAME} install httpd
	sudo a2enMod rewrite
	service apache2 starts
	
	apachectl configtest
}

# INSTALLATION D'APACHE yum
# function apacheInstaller_yum {

# 	${PACKET_MANAGER_NAME} -y install httpd
# 	systemctl enable httpd.service
# 	systemctl start httpd.service #=> START SERVICE
# 	apachectl configtest #=> TEST CONFIG OK
# }

# INSTALL MYSQL APT
function mysqlInstaller_apt {

	${PACKET_MANAGER_NAME} install mariadb # TODO il faut importer le packet mariadb pour ubuntu
}

# INSTALL MYSQL YUM
function mysqlInstaller_yum {

	${PACKET_MANAGER_NAME} -y install mariadb
}

function phpInstaller_yum {
	
	sudo chmod -777 /var/lib/dpkg/lock
    ${PACKET_MANAGER_NAME} -y install php php-mysql php-gd php-pear
	${PACKET_MANAGER_NAME} -y install php-pgsql
	systemctl restart httpd.service #=> restart service
}

function phpInstaller_apt {
	
	#sudo chmod -777 /var/lib/dpkg/lock ???? n'existe pas dans apt
	${PACKET_MANAGER_NAME} install php5
	${PACKET_MANAGER_NAME} install postgresql

	${PACKET_MANAGER_NAME} install php5-intl
	${PACKET_MANAGER_NAME} install libapache2-mod-php5 # equivalent apt de mstring

	service apache2 restart
}

function vhostEditor {

    printf "Nom du vhost : "
    read nomVhost
    printf "Numero du port : "
    read port
    printf "ServerAdmin : "
    read serveradmin
    printf "ServerName : "
    read servername
    printf "Path du projet : "
    read root

    #vhost_path="/etc/apache2/sites-available"
    
    cd Configuration_files && ./make_vhost $port $serveradmin $servername $root $nomVhost $VHOST_PATH $PATH_TEMPO_FOLDER
}

# Création + recuperation repository git
function getGitRepository {

	mkdir /var/www/bitume
	cd /var/www/bitume/ && git clone https://github.com/NGRP/Total-Bitume.git
}

# Installation composer + intl + mbstring
function composerInstaller_apt {

	cd /var/www/bitume/Total-Bitume/ && curl -s http://getcomposer.org/installer | php # possibilité de faire un script pour mise dans variable d'environnement
}

# Installation composer + intl + mbstring
function composerInstaller_yum {

	curl -s http://getcomposer.org/installer | php
	${PACKET_MANAGER_NAME} -y install php-intl
	${PACKET_MANAGER_NAME} -y install php-mbstring
}

function phpIniEditor {
    echo "phpIniEditor"
    # Edition du fichier php.ini. (Voir pour trouver le bon en fonction de la version de php utilisée).
	# Dans /etc/php.ini => ajouter date.timezone = Europe/Paris
	echo "Path de votre php.ini : $PATH_PHP_INI"
	printf "Si votre path est différent veuillez le saisir : "
	read newPath

	if [[ $newPath != "" ]]; then
		PATH_PHP_INI=$newPath
	fi

	# Copie du php.ini du serveur dans le dossier temporaire /temporary/ini
	cp /etc/php5/apache2/php.ini temporary/ini/
	# parsing du fichier temporaire
	# cp /etc/php5/apache2/php.ini temporary/ini/
	#file="temporary/ini/php.ini"
	file="$ABSOLUTE_PATH/temporary/ini/php.ini"
	echo "test path Absolute ===== $ABSOLUTE_PATH"
 	echo "############# ETAT INITIAL #################"
	while read ligne  
	do  
	  # echo $ligne
	   if [[ $ligne =~ "short_open_tag" ]]; then
	   	echo $ligne
	   	#sed -e "s/Off/On/g" "$file" > "$file".tmp && mv $file".tmp" $file
	   	sed -e "s/$ligne/short_open_tag = Off/g" "$file" > "$file".tmp && mv $file".tmp" $file 
	   fi
	   if [[ $ligne =~ "magic_quotes_gpc" ]]; then
	   	echo $ligne
	   	sed -e "s/$ligne/magic_quotes_gpc = Off/g" "$file" > "$file".tmp && mv $file".tmp" $file 
	   fi
	   if [[ $ligne =~ "register_globals" ]]; then
	   	echo $ligne
	   	sed -e "s/$ligne/register_globals = Off/g" "$file" > "$file".tmp && mv $file".tmp" $file
	   fi
	   if [[ $ligne =~ "session.autostart" ]]; then
	   	echo $ligne
	   	sed -e "s/$ligne/session.autostart = Off/g" "$file" > "$file".tmp && mv $file".tmp" $file
	   fi

	   if [[ $ligne =~ "memory_limit" ]]; then
	   	echo $ligne
	   	sed -e "s/$ligne/memory_limit = 256MB/g" "$file" > "$file".tmp && mv $file".tmp" $file 
	   fi
	   if [[ $ligne =~ "expose_php" ]]; then
	   	echo $ligne
	   	sed -e "s/$ligne/expose_php = Off/g" "$file" > "$file".tmp && mv $file".tmp" $file
	   fi
	   if [[ $ligne =~ "date.timezone" ]]; then
	   	echo $ligne
	   	sed -e "s/$ligne/date.timezone = Europe\/Paris/g" "$file" > "$file".tmp && mv $file".tmp" $file
	   fi
	#sed -e "s/short_open_tag/toto/g" "$file" > "$file".tmp
	#sed -e "s/\/root/\/home/g" fichier > fichier.tmp && mv -f fichier.tmp fichier 
	done < $ABSOLUTE_PATH/temporary/ini/php.ini
	echo "########################################"

	echo "########### ETAT MODIFIÉ ##############"
	pwd
	while read ligne  
	do  
	  # echo $ligne
	   if [[ $ligne =~ "short_open_tag" ]]; then
	   	echo $ligne
	   fi
	   if [[ $ligne =~ "magic_quotes_gpc" ]]; then
	   	echo $ligne
	   fi
	   if [[ $ligne =~ "register_globals" ]]; then
	   	echo $ligne
	   fi
	   if [[ $ligne =~ "session.autostart" ]]; then
	   	echo $ligne
	   fi
	   if [[ $ligne =~ "memory_limit" ]]; then
	   	echo $ligne
	   fi
	   if [[ $ligne =~ "expose_php" ]]; then
	   	echo $ligne
	   fi
	   if [[ $ligne =~ "date.timezone" ]]; then
	   	echo $ligne
	   fi
	   
	#sed -e "s/short_open_tag/toto/g" "$file" > "$file".tmp
	#sed -e "s/\/root/\/home/g" fichier > fichier.tmp && mv -f fichier.tmp fichier 

	done < $ABSOLUTE_PATH/temporary/ini/php.ini
	echo "########################################"
	
	sudo cp $ABSOLUTE_PATH/temporary/ini/php.ini $PATH_PHP_INI
}

function pearInstaller_apt {

    ${PACKET_MANAGER_NAME} install php-pear
	# RSG ${PACKET_MANAGER_NAME} install php-devel
	${PACKET_MANAGER_NAME} install gcc
}

function pearInstaller_yum {

    ${PACKET_MANAGER_NAME} install -y php-pear
	${PACKET_MANAGER_NAME} install -y php-devel
	${PACKET_MANAGER_NAME} install -y gcc
}

function deflateFileEditor {
    echo "deflateFileEditor"

    #cp /Configuration_files/deflat.conf /etc/httpd/conf.d/
    cp $ABSOLUTE_PATH/Configuration_files/deflate.conf ./ # path a définir pour apt faut il creer httpd.
    # # creation /etc/httpd/conf.d/deflate.conf (voir mail)
}

function expireFileEditor {
    echo "expireFileEditor"
    cp $ABSOLUTE_PATH/Configuration_files/expire.conf ./
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
	# ${PACKET_MANAGER_NAME} -y install git
	# ${PACKET_MANAGER_NAME} -y install mod_ssl
	# ${PACKET_MANAGER_NAME} install ntp
}

function purgeapt {
	echo "PURGE NANO"
	sudo apt-get purge nano
	sudo apt-get purge git
	sudo apt-get purge mod_ssl

	sudo apt-get delete nano
	sudo apt-get delete git
	sudo apt-get delete mod_ssl # inconnu pour aptitude TODO rsg


	# ##################################
	${PACKET_MANAGER_NAME} install apache2
	#${PACKET_MANAGER_NAME} install httpd
	sudo a2enMod rewrite
	service apache2 starts
	
	apachectl configtest

	${PACKET_MANAGER_NAME} php5
	${PACKET_MANAGER_NAME} postgresql
	service apache2 restart

	# suppression des repositories + git
}

function helpapt {
	echo "Les commandes sudo sont acceptées : Installation par le gestionnaire de packet apt-get"
	echo "showLog                           : Affiche si toutes les taches ont bien été effectuées"
	echo "update                            : Met a jour les librairies et packets linux"
	echo "purge                             : Supprime tout les packets installés"
	echo "exit                              : Quitte le prompt"
	echo "revert                            : Remet la configuration dans son etat initiale"

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

































