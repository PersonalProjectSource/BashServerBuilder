# Appel dynamiquement la methode correspondant au bon gestionnaire de packets.
function serverInstaller_yum {

	echo "INSTALL SERVER YUM Manager"
	${PACKET_MANAGER_NAME} -y install nano
	${PACKET_MANAGER_NAME} -y install git
	${PACKET_MANAGER_NAME} -y install mod_ssl
	${PACKET_MANAGER_NAME} install ntp

	${PACKET_MANAGER_NAME} install -y gcc
	${PACKET_MANAGER_NAME} -y install php-process # => normalement déjà installé

	${PACKET_MANAGER_NAME} install pecl
	pecl install apc

	${PACKET_MANAGER_NAME} -y install java-1.7.0-openjdk.x86_64
	
	# TODO voir avec adel mysql -u user -h host -p bdd_name < $PATH_SOURCES_PROJET/bdd_data.sql

	cd $PATH_SOURCES_PROJET/ && php composer.phar install
	cd $PATH_SOURCES_PROJET/ && php app/console assetic:dump —env=prod

	setsebool -P httpd_can_network_connect 1
	#chcon -R -t public_content_rw_t $PATH_SOURCES_PROJET/Total-Bitume/app/cache
	#chcon -R -t public_content_rw_t $PATH_SOURCES_PROJET/Total-Bitume/logs
	#chcon -R -t public_content_rw_t $PATH_SOURCES_PROJET/Total-Bitume/sessions
	chcon -R -t public_content_rw_t $PATH_SOURCES_PROJET/Total-Bitume/web/webservices
	chcon -R -t public_content_rw_t $PATH_SOURCES_PROJET/Total-Bitume/web/excel
	chcon -R -t public_content_rw_t $PATH_SOURCES_PROJET/Total-Bitume/webservices
	setsebool -P allow_httpd_anon_write 1
	#cd $PATH_SOURCES_PROJET/ && chmod -R 0777 app/cache app/logs app/sessions
	
	echo "----------------- Composer install ----------------------------"
	cd $PATH_SOURCES_PROJET/Total-Bitume && php composer.phar self-update
	cd $PATH_SOURCES_PROJET/Total-Bitume && sudo rm composer.lock
	cd $PATH_SOURCES_PROJET/Total-Bitume && php composer.phar install
	cd $PATH_SOURCES_PROJET/Total-Bitume && php app/console assetic:dump —env=prod
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

	# Voir pour trouver l'equivalence APT
	# setsebool -P httpd_can_network_connect 1
	# chcon -R -t public_content_rw_t app/cache
	# chcon -R -t public_content_rw_t app/logs
	# chcon -R -t public_content_rw_t app/sessions
	# chcon -R -t public_content_rw_t web/webservices
	# chcon -R -t public_content_rw_t web/excel
	# chcon -R -t public_content_rw_t webservices
	# setsebool -P allow_httpd_anon_write 1
	cd $PATH_SOURCES_PROJET/ && chmod -R 0777 app/cache app/logs app/sessions

}

