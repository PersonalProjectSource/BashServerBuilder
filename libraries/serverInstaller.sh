# Appel dynamiquement la methode correspondant au bon gestionnaire de packets.
function serverInstaller_yum {

	${PACKET_MANAGER_NAME} -y install nano
	${PACKET_MANAGER_NAME} -y install git
	${PACKET_MANAGER_NAME} -y install mod_ssl
	${PACKET_MANAGER_NAME} install ntp

	yum install -y gcc
	yum -y install php-process => normalement déjà installé
	pecl install apc
	yum -y install java-1.7.0-openjdk.x86_64
	php composer.phar install
	mysql -u user -h host -p bdd_name < bdd_data.sql
	php app/console assetic:dump —env=prod

	setsebool -P httpd_can_network_connect 1
	chcon -R -t public_content_rw_t app/cache
	chcon -R -t public_content_rw_t app/logs
	chcon -R -t public_content_rw_t app/sessions
	chcon -R -t public_content_rw_t web/webservices
	chcon -R -t public_content_rw_t web/excel
	chcon -R -t public_content_rw_t webservices
	setsebool -P allow_httpd_anon_write 1
	chmod -R 0777 app/cache app/logs app/sessions

	# yum -y install nano
	# yum -y install git
	# yum -y install mod_ssl
	#cat /usr/share/zoneinfo/America/Montreal > /etc/localtime # TODO rendre variable la localité du serveur "America"
}


# # TODO voir pour garder la fonction apt et aptitude.
# function yum {

#     ${PACKET_MANAGER_NAME} -y install nano
# 	${PACKET_MANAGER_NAME} -y install git
# 	${PACKET_MANAGER_NAME} -y install mod_ssl

# 	${PACKET_MANAGER_NAME} install ntp
# }