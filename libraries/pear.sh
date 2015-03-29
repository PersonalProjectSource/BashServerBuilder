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