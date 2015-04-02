# INSTALLATION D'APACHE AVEC APT PACKET MANAGER
function apacheInstaller_apt {

	${PACKET_MANAGER_NAME} install apache2
	#${PACKET_MANAGER_NAME} install httpd
	sudo a2enMod rewrite
	service apache2 start
	
	apachectl configtest
}

# INSTALLATION D'APACHE AVEC YUM PACKET MANAGER
function apacheInstaller_yum {

	sudo yum -y install httpd
	sudo yum -y install php-pear
	systemctl enable httpd.service

	systemctl start httpd.service # => START SERVICE

	apachectl configtest # => TEST CONFIG OK
}
