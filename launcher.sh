#!/bin/bash

. libraries/apache.sh
. libraries/php_mysql_installer.sh
. libraries/php_ini_editor.sh
. libraries/composer.sh
. libraries/pear.sh
. libraries/purge.sh
. libraries/serverInstaller.sh
. libraries/vhostEditor.sh

# Déclaration des variables parametrables.
PACKET_MANAGER_NAME=""
LOCALITY=""
FUNCTION_PACKET_MANAGER="serverInstaller"

DEFAULT_PACKET_MANAGER="sudo yum "
DEFAULT_LOCALITY="Europe/Paris"

REFERENCE_PATH=""
PATH_TEMPO_FOLDER="temporary"
PATH_SOURCES_PROJET="/var/www/bitume"
VHOST_PATH="/etc/apache2/sites-available"
PATH_PHP_INI="/etc/php5/apache2/php.ini"
ABSOLUTE_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
# SUFFIXE QU'ON UTILISERA POUR UN APPEL DYNAMIQUE DES FONCTIONS
FUNCTION_SUFFIXE=""

function launch {
    # Démarre le script.
    REFERENCE_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
    echo $REFERENCE_PATH
	launch_prompt
   
	# TODO sonde pour check la sortie de l'api
	echo $PACKET_MANAGER_NAME
	
	apacheInstaller_${FUNCTION_SUFFIXE}
        # TODO mysqlInstaller_${FUNCTION_SUFFIXE} TODO trouver le packet mariadb pour apt
	phpInstaller_${FUNCTIOsN_SUFFIXE}
	vhostEditor
	getGitRepository
	composerInstaller_${FUNCTION_SUFFIXE}
	
	serverInstaller_${FUNCTION_SUFFIXE}
	phpIniEditor
	# ? pearInstaller_${FUNCTION_SUFFIXE}
	deflateFileEditor
	expireFileEditor
	# echo "DONE"
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
			$out $manager $action $packet
		elif [[ $out == "add" ]]; then
			add_action
		elif [[ $out == "start_cmd" ]]; then
			sudo ./command_added.sh
		elif [[ $out == "help" ]]; then
			helpapt
		else
			dynamic_name=$out$FUNCTION_SUFFIXE 
			eval ${dynamic_name}
		fi
	done
}

function update {
	${PACKET_MANAGER_NAME} update
}

function add_action {
	printf "Saisissez la commande a ajouter a la procedure de création du serveur (sudo si admin requis): "
	read commande manager action packet

	echo -e "$commande $manager $action $packet" >> $REFERENCE_PATH/command_added.sh
	cat $REFERENCE_PATH/command_added.sh
	printf "Saisissez une description de la commande pour le fichier d'aide : "
	read  word1 word2 word3 word4 word5 word6 word7 word8 word9 word10 word11 word12 word13
	echo -e "$commande $manager $action $packet : $word1 $word2 $word3 $word4 $word5 $word6 $word7 $word8 $word9 $word10 $word11 $word12 $word13" >> $REFERENCE_PATH/libraries/help_commande.txt
	cat $REFERENCE_PATH/libraries/help_commande.txt
}

# Initialise le gestionnaire de packet en fonction de la saisie en console (yum par defaut).
function define_packet_manager {

	if [[ $1 == "" ]]; then
		PACKET_MANAGER_NAME=$DEFAULT_PACKET_MANAGER
	elif [[ $1 == "apt" ]]; then
		PACKET_MANAGER_NAME="sudo apt-get"
	elif [[ $1 == "aptitude" ]]; then
		PACKET_MANAGER_NAME="sudo apt-get"
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

# Création + recuperation repository git
function getGitRepository {
	echo "-------------------------- git repo installer ----------------------------"
	sudo mkdir $PATH_SOURCES_PROJET
	cd $PATH_SOURCES_PROJET && sudo chmod -R 777 ../ && git clone https://github.com/NGRP/Total-Bitume.git
	echo "----------------------------- FIN CLONE ---------------------------------"
}

function deflateFileEditor {
    #cp /Configuration_files/deflat.conf /etc/httpd/conf.d/
    cp $ABSOLUTE_PATH/Configuration_files/deflate.conf ./ # path a définir pour apt faut il creer httpd.
    # # creation /etc/httpd/conf.d/deflate.conf (voir mail)
}

function expireFileEditor {
    cp $ABSOLUTE_PATH/Configuration_files/expire.conf ./
}

function helpapt {
	pwd
	cat $REFERENCE_PATH/libraries/help_commande.txt
	# echo "Les commandes sudo sont acceptées : Installation par le gestionnaire de packet apt-get"
	# echo "showLog                           : Affiche si toutes les taches ont bien été effectuées"
	# echo "update                            : Met a jour les librairies et packets linux"
	# echo "purge                             : Supprime tout les packets installés"
	# echo "exit                              : Quitte le prompt"
	# echo "revert                            : Remet la configuration dans son etat initiale"
}

# Lancement de l'application
launch
