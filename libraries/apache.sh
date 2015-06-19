# INSTALLATION D'APACHE AVEC APT PACKET MANAGER
function apacheInstaller_apt {

	${PACKET_MANAGER_NAME} install apache2
	#${PACKET_MANAGER_NAME} install httpd
	sudo a2enMod rewrite
	service apache2 start
	
	apachectl configtest
}


function apacheInstaller_yum {

	${PACKET_MANAGER_NAME} install httpd
	#sudo a2enMod rewrite # TODO lbrau voir comment active le mode rewrite sur Centos
	sudo apachectl restart
	apachectl configtest
}