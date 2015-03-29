function purgeapt {
	echo "PURGE NANO"
	sudo apt-get purge nano
	sudo apt-get purge git
	sudo apt-get purge mod_ssl

	sudo apt-get delete nano
	sudo apt-get delete git
	sudo apt-get delete mod_ssl # inconnu pour aptitude TODO rsg


	# ##################################
	${PACKET_MANAGER_NAME} install apache2
	#${PACKET_MANAGER_NAME} install httpd
	sudo a2enMod rewrite
	service apache2 starts
	
	apachectl configtest

	${PACKET_MANAGER_NAME} php5
	${PACKET_MANAGER_NAME} postgresql
	service apache2 restart

	# suppression des repositories + git
}