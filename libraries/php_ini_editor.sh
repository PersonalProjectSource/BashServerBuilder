function phpIniEditor {
    echo "phpIniEditor"
    # Edition du fichier php.ini. (Voir pour trouver le bon en fonction de la version de php utilisée).
	# Dans /etc/php.ini => ajouter date.timezone = Europe/Paris
	echo "Path de votre php.ini : $PATH_PHP_INI"
	printf "Si votre path est différent veuillez le saisir : "
	read newPath

	if [[ $newPath != "" ]]; then
		PATH_PHP_INI=$newPath
	fi

	# Copie du php.ini du serveur dans le dossier temporaire /temporary/ini
	echo "#############################$ABSOLUTE_PATH"
	pwd
	cp /etc/php5/apache2/php.ini $ABSOLUTE_PATH/temporary/ini/
	cp /etc/php5/apache2/php.ini $ABSOLUTE_PATH/temporary/ini/php_bak.ini

	# parsing du fichier temporaire
	# cp /etc/php5/apache2/php.ini temporary/ini/
	#file="temporary/ini/php.ini"
	file="$ABSOLUTE_PATH/temporary/ini/php.ini"
	echo "test path Absolute ===== $ABSOLUTE_PATH"
 	echo "############# ETAT INITIAL #################"
	while read ligne  
	do  
	   if [[ $ligne =~ "short_open_tag" ]]; then
	   	echo $ligne
	   	sed -e "s/$ligne/short_open_tag = Off/g" "$file" > "$file".tmp && mv $file".tmp" $file 
	   fi
	   if [[ $ligne =~ "magic_quotes_gpc" ]]; then
	   	echo $ligne
	   	sed -e "s/$ligne/magic_quotes_gpc = Off/g" "$file" > "$file".tmp && mv $file".tmp" $file 
	   fi
	   if [[ $ligne =~ "register_globals" ]]; then
	   	echo $ligne
	   	sed -e "s/$ligne/register_globals = Off/g" "$file" > "$file".tmp && mv $file".tmp" $file
	   fi
	   if [[ $ligne =~ "session.autostart" ]]; then
	   	echo $ligne
	   	sed -e "s/$ligne/session.autostart = Off/g" "$file" > "$file".tmp && mv $file".tmp" $file
	   fi

	   if [[ $ligne =~ "memory_limit" ]]; then
	   	echo $ligne
	   	sed -e "s/$ligne/memory_limit = 256MB/g" "$file" > "$file".tmp && mv $file".tmp" $file 
	   fi
	   if [[ $ligne =~ "expose_php" ]]; then
	   	echo $ligne
	   	sed -e "s/$ligne/expose_php = Off/g" "$file" > "$file".tmp && mv $file".tmp" $file
	   fi
	   if [[ $ligne =~ "date.timezone" ]]; then
	   	echo "check ===> "$ligne
	   	sed -e "s/$ligne/date.timezone = Europe\/Paris/g" "$file" > "$file".tmp && mv $file".tmp" $file
	   fi
	done < $ABSOLUTE_PATH/temporary/ini/php.ini
	echo "########################################"

	echo "########### ETAT MODIFIÉ ##############"
	pwd
	while read ligne  
	do  
	  # echo $ligne
	   if [[ $ligne =~ "short_open_tag" ]]; then
	   	echo $ligne
	   fi
	   if [[ $ligne =~ "magic_quotes_gpc" ]]; then
	   	echo $ligne
	   fi
	   if [[ $ligne =~ "register_globals" ]]; then
	   	echo $ligne
	   fi
	   if [[ $ligne =~ "session.autostart" ]]; then
	   	echo $ligne
	   fi
	   if [[ $ligne =~ "memory_limit" ]]; then
	   	echo $ligne
	   fi
	   if [[ $ligne =~ "expose_php" ]]; then
	   	echo $ligne
	   fi
	   if [[ $ligne =~ "date.timezone" ]]; then
	   	echo $ligne
	   fi
	done < $ABSOLUTE_PATH/temporary/ini/php.ini
	echo "########################################"
	
	sudo cp $ABSOLUTE_PATH/temporary/ini/php.ini $PATH_PHP_INI
}