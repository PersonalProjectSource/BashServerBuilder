# Appel dynamiquement la methode correspondant au bon gestionnaire de packets.
function serverInstaller_yum {

	echo "INSTALL SERVER YUM Manager"

	# echo  "check cmd : "${PACKET_MANAGER_NAME}
	echo "current user is : "
	echo $USER

	${PACKET_MANAGER_NAME} -y install nano
	${PACKET_MANAGER_NAME} -y install git
	${PACKET_MANAGER_NAME} -y install mod_ssl
    ${PACKET_MANAGER_NAME} install ntp
	${PACKET_MANAGER_NAME} install -y gcc
	${PACKET_MANAGER_NAME} -y install php-process # => normalement déjà installé
	#${PACKET_MANAGER_NAME} install pecl
	${PACKET_MANAGER_NAME} install php-intl
	${PACKET_MANAGER_NAME} -y install php-mbstring
	
	pecl install apc
	sudo touch /etc/php.d/apc.ini
	sudo chmod 777 /etc/php.d/apc.ini
	sudo echo "extension=apc.so" >> /etc/php.d/apc.ini
	sudo echo "apc.cache_by_default=0" >> /etc/php.d/apc.ini


###################################################################################
#	           					bloc a reparer
###################################################################################

	#pecl -dmemory_limit=1G install apc # TODO probleme memory limit lors de l'install
	${PACKET_MANAGER_NAME} -y install java-1.7.0-openjdk.x86_64
	mysql -u user -h host -p bdd_name < $PATH_SOURCES_PROJET/bdd-data.sql # TODO ca pete lorsque le fichier SQL n'existe pas.

	#cd $PATH_SOURCES_PROJET/ && php composer.phar install # manque un dossier Total-Bitume dans le path celui-ci est add lor du git clone.
	#cd $PATH_SOURCES_PROJET/ && php app/console assetic:dump —env=prod # idem au dessus.

	sudo setsebool -P httpd_can_network_connect 1
	cd $PATH_SOURCES_PROJET/ && sudo mkdir app/cache 2> /dev/null
	cd $PATH_SOURCES_PROJET/ && sudo chcon -R -t public_content_rw_t app/cache # il faut se trouver a la racine du projet pour les cmd chcon.
	
	cd $PATH_SOURCES_PROJET/ && sudo mkdir app/logs 2> /dev/null
	cd $PATH_SOURCES_PROJET/ && sudo chcon -R -t public_content_rw_t app/logs

	cd $PATH_SOURCES_PROJET/ && sudo mkdir app/sessions 2> /dev/null
	cd $PATH_SOURCES_PROJET/ && sudo chcon -R -t public_content_rw_t app/sessions

	cd $PATH_SOURCES_PROJET/ && sudo mkdir web/webservices 2> /dev/null
	cd $PATH_SOURCES_PROJET/ && sudo chcon -R -t public_content_rw_t web/webservices

	cd $PATH_SOURCES_PROJET/ && sudo mkdir web/excel 2> /dev/null
	cd $PATH_SOURCES_PROJET/ && sudo chcon -R -t public_content_rw_t web/excel

	cd $PATH_SOURCES_PROJET/ && sudo mkdir webservices 2> /dev/null
	cd $PATH_SOURCES_PROJET/ && sudo chcon -R -t public_content_rw_t webservices

	sudo setsebool -P allow_httpd_anon_write 1

	cd $PATH_SOURCES_PROJET/ && sudo chmod -R 0777 app/cache app/logs app/sessions

	addParamsInConfD
}

function addParamsInConfD () {
	echo "Edition du fichier /etc/httpd/conf/httpd.conf"
	sudo echo "ServerSignature Off" >> /etc/httpd/conf/httpd.conf
	sudo echo "ServerTokens Prod" >> /etc/httpd/conf/httpd.conf
	sudo echo "AcceptFilter http none" >> /etc/httpd/conf/httpd.conf
	sudo echo "AcceptFilter https none" >> /etc/httpd/conf/httpd.conf
	sudo echo "ServerName ebitumes.cloudapp.net:443" >> /etc/httpd/conf/httpd.conf
	sudo echo "NameVirtualHost 137.116.216.223:443" >> /etc/httpd/conf/httpd.conf
	echo "Edition terminée"
	# ServerSignature Off
	# ServerTokens Prod
	# AcceptFilter http none
	# AcceptFilter https none
	# ServerName ebitumes.cloudapp.net:443
	# NameVirtualHost 137.116.216.223:443
}

# Appel dynamiquement la methode correspondant au bon gestionnaire de packets.
function serverInstaller_apt {
	
	echo "INSTALL SERVER APT Manager"
	sudo apt-get install nano
	sudo apt-get install install git
	sudo apt-get install install mod_ssl

	${PACKET_MANAGER_NAME} install gcc
	${PACKET_MANAGER_NAME} install php-apc
	sudo service apache2 restart
	cd $PATH_SOURCES_PROJET/ && php composer.phar install
	cd $PATH_SOURCES_PROJET/ && php app/console assetic:dump —env=prod

	# TODO voir avec Adel ce qu'il faut mettre exactement.
	#config java dans parameters.yml : /usr/bin/java      java: /usr/bin/java
	echo"java: /usr/bin/java" >> $PATH_SOURCES_PROJET/app/config/parameters.yml

	cd $PATH_SOURCES_PROJET/ && chmod -R 0777 app/cache app/logs app/sessions
}


# # TODO voir pour garder la fonction apt et aptitude.
# function yum {

#     ${PACKET_MANAGER_NAME} -y install nano
# 	${PACKET_MANAGER_NAME} -y install git
# 	${PACKET_MANAGER_NAME} -y install mod_ssl

# 	${PACKET_MANAGER_NAME} install ntp
# }