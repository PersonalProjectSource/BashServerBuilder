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
	service apache2 start
	
	apachectl configtest
}