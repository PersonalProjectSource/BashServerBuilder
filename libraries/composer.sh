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