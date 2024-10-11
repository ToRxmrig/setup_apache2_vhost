# 10/10/24
# Developer: @ToRxmrig 
# version: v1.0.0
# Time: 1728607580
# nano setup_apache_vhost.sh and paste this script...
# ./setup_apache_vhost.sh domain.com


#!/bin/bash
if [ -z "$1" ]; then
    echo "Usage: $0 <domain>"
    exit 1
fi

DOMAIN="$1"
CONF_FILE="/etc/apache2/sites-available/$DOMAIN.conf"
DOC_ROOT="/var/www/$DOMAIN"

# Check if the configuration file already exists
if [ -f "$CONF_FILE" ]; then
    echo "Disabling and removing the existing configuration for $DOMAIN..."
    sudo a2dissite "$DOMAIN.conf"
    sudo rm "$CONF_FILE"
fi

# Create the document root directory if it doesn't exist
if [ ! -d "$DOC_ROOT" ]; then
    echo "Creating document root directory: $DOC_ROOT"
    mkdir -p "$DOC_ROOT"
    chown -R www-data:www-data "$DOC_ROOT"
    chmod -R 755 "$DOC_ROOT"
else
    echo "Document root directory $DOC_ROOT already exists."
fi

# Create the Apache configuration file
echo "Creating Apache configuration file: $CONF_FILE"
cat <<EOL | sudo tee "$CONF_FILE" > /dev/null
<VirtualHost *:80>
    ServerAdmin solscan@$DOMAIN
    ServerName $DOMAIN
    ServerAlias www.$DOMAIN
    DocumentRoot $DOC_ROOT

    <Directory $DOC_ROOT>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined

    RewriteEngine on
    RewriteCond %{SERVER_NAME} =www.$DOMAIN [OR]
    RewriteCond %{SERVER_NAME} =$DOMAIN
    RewriteRule ^ https://%{SERVER_NAME}%{REQUEST_URI} [END,NE,R=permanent]
</VirtualHost>

<IfModule mod_ssl.c>
<VirtualHost *:443>
    ServerAdmin solscan@$DOMAIN
    ServerName $DOMAIN
    ServerAlias www.$DOMAIN
    DocumentRoot $DOC_ROOT

    <Directory $DOC_ROOT>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined

    Include /etc/letsencrypt/options-ssl-apache.conf
    SSLCertificateFile /etc/letsencrypt/live/$DOMAIN/fullchain.pem
    SSLCertificateKeyFile /etc/letsencrypt/live/$DOMAIN/privkey.pem
</VirtualHost>
</IfModule>
EOL

# Enable the site configuration
echo "Enabling site configuration: $DOMAIN.conf"
sudo a2ensite "$DOMAIN.conf"

# Reload Apache to apply the changes
echo "Reloading Apache to apply changes..."
sudo systemctl reload apache2

echo "Apache virtual host configuration for $DOMAIN has been created and enabled."
echo "Directories and files created:"
echo "Document Root: $DOC_ROOT"
echo "Configuration File: $CONF_FILE"
