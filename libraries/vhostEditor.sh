
function vhostEditor {

    printf "Nom du vhost : "
    read nomVhost
    printf "Numero du port : "
    read port
    printf "ServerAdmin : "
    read serveradmin
    printf "ServerName : "
    read servername
    printf "Path du projet : "
    read root
    #vhost_path="/etc/apache2/sites-available"
    cd Configuration_files && ./make_vhost $port $serveradmin $servername $root $nomVhost $VHOST_PATH $PATH_TEMPO_FOLDER
}

# function make_vhost {
#     printf "Nom du fichier Vhost  : "
#     read vhostname

#     printf "ServerAdmin  : "
#     read serveradmin

#     printf "ServerName  : "
#     read servername

#     printf "DocumentRoot  : "
#     read documentroot

#     printf "numero du port  : "
#     read port

#     Configuration_files/default_vhost.conf coucou toi 
# }