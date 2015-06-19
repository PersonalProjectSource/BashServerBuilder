# INSTALL MYSQL APT
function mysqlInstaller_apt {

	${PACKET_MANAGER_NAME} install mariadb # TODO il faut importer le packet mariadb pour ubuntu
}

function phpInstaller_apt {
	
	#sudo chmod -777 /var/lib/dpkg/lock ???? n'existe pas dans apt
	${PACKET_MANAGER_NAME} install php5
	${PACKET_MANAGER_NAME} install postgresql

	${PACKET_MANAGER_NAME} install php5-intl
	${PACKET_MANAGER_NAME} install libapache2-mod-php5 # equivalent apt de mstring

	service apache2 restart
}

# INSTALL MYSQL YUM
function mysqlInstaller_yum {

	${PACKET_MANAGER_NAME} -y install mariadb
}

function phpInstaller_yum {
	
	sudo chmod -777 /var/lib/dpkg/lock
    ${PACKET_MANAGER_NAME} -y install php php-mysql php-gd php-pear
	${PACKET_MANAGER_NAME} -y install php-pgsql
	systemctl restart httpd.service
}

