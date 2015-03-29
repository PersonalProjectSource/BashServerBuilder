function pearInstaller_apt {

    ${PACKET_MANAGER_NAME} install php-pear
	# RSG ${PACKET_MANAGER_NAME} install php-devel
	
}

function pearInstaller_yum {

    ${PACKET_MANAGER_NAME} install -y php-pear
	${PACKET_MANAGER_NAME} install -y php-devel
}